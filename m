Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3KDPNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:13:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56872 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3KDPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <527671E9.8040704@gmail.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
	<1382109602-27432-3-git-send-email-liuj97@gmail.com>
	<20131030001245.GB25346@mudshark.cambridge.arm.com>
	<527671E9.8040704@gmail.com>
Date: Mon, 4 Nov 2013 23:12:56 +0800
Message-ID: <CA+b37P2WU74NU7wG_H+KfmL6Y-fdhipsuOruU-z=wv=8ENwrfQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel and
 module code
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2013 23:55, Jiang Liu <liuj97@gmail.com> wrote:
> On 10/30/2013 08:12 AM, Will Deacon wrote:
>> Hi Jinag Liu,
>>
>> Sorry for the delayed review, I've been travelling.
>>
>> On Fri, Oct 18, 2013 at 04:19:56PM +0100, Jiang Liu wrote:
>>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> If I try and email you at your Huawei address, I get a bounce from the mail
>> server. Is that expected? If so, it's not very helpful from a commit log
>> perspective if you use that address as the author on your patches.
>>
> Hi Will,
>         Sorry for the inconvenience. I have left Huawei recently and
> have had a vacation last two weeks. I will use my gmail account next
> time.
>
>>> Introduce three interfaces to patch kernel and module code:
>>> aarch64_insn_patch_text_nosync():
>>>      patch code without synchronization, it's caller's responsibility
>>>      to synchronize all CPUs if needed.
>>> aarch64_insn_patch_text_sync():
>>>      patch code and always synchronize with stop_machine()
>>> aarch64_insn_patch_text():
>>>      patch code and synchronize with stop_machine() if needed
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> Cc: Jiang Liu <liuj97@gmail.com>
>>> ---
>>>  arch/arm64/include/asm/insn.h | 19 ++++++++-
>>>  arch/arm64/kernel/insn.c      | 91 +++++++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 109 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
>>> index 7499490..7a69491 100644
>>> --- a/arch/arm64/include/asm/insn.h
>>> +++ b/arch/arm64/include/asm/insn.h
>>> @@ -71,8 +71,25 @@ enum aarch64_insn_hint_op {
>>>
>>>  bool aarch64_insn_is_nop(u32 insn);
>>>
>>> -enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
>>> +/*
>>> + * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
>>> + * little-endian.
>>> + */
>>> +static __always_inline u32 aarch64_insn_read(void *addr)
>>> +{
>>> +    return le32_to_cpu(*(u32 *)addr);
>>> +}
>>>
>>> +static __always_inline void aarch64_insn_write(void *addr, u32 insn)
>>> +{
>>> +    *(u32 *)addr = cpu_to_le32(insn);
>>> +}
>>
>> I wouldn't bother with these helpers. You should probably be using
>> probe_kernel_address or similar, then doing the endianness swabbing on the
>> return value in-line.
> How about keeping and refining aarch64_insn_read/write interfaces
> by using probe_kernel_address()? I think they may be used in other
> places when supporting big endian ARM64 kernel.
>
>>
>>> +enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
>>>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>>>
>>> +int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
>>> +int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
>>> +int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
>>> +
>>>  #endif      /* __ASM_INSN_H */
>>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>>> index f5b779f..3879db4 100644
>>> --- a/arch/arm64/kernel/insn.c
>>> +++ b/arch/arm64/kernel/insn.c
>>> @@ -16,6 +16,9 @@
>>>   */
>>>  #include <linux/compiler.h>
>>>  #include <linux/kernel.h>
>>> +#include <linux/smp.h>
>>> +#include <linux/stop_machine.h>
>>> +#include <asm/cacheflush.h>
>>>  #include <asm/insn.h>
>>>
>>>  static int aarch64_insn_encoding_class[] = {
>>> @@ -88,3 +91,91 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>>>      return __aarch64_insn_hotpatch_safe(old_insn) &&
>>>             __aarch64_insn_hotpatch_safe(new_insn);
>>>  }
>>> +
>>> +int __kprobes aarch64_insn_patch_text_nosync(void *addr, u32 insn)
>>> +{
>>> +    u32 *tp = addr;
>>> +
>>> +    /* A64 instructions must be word aligned */
>>> +    if ((uintptr_t)tp & 0x3)
>>> +            return -EINVAL;
>>> +
>>> +    aarch64_insn_write(tp, insn);
>>> +    flush_icache_range((uintptr_t)tp, (uintptr_t)tp + sizeof(u32));
>>
>> sizeof(insn) is clearer here.
>>
> Will make this change in next version.
>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +struct aarch64_insn_patch {
>>> +    void    **text_addrs;
>>> +    u32     *new_insns;
>>> +    int     insn_cnt;
>>> +};
>>> +
>>> +static DEFINE_MUTEX(text_patch_lock);
>>> +static atomic_t text_patch_id;
>>> +
>>> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
>>> +{
>>> +    int i, ret = 0;
>>> +    struct aarch64_insn_patch *pp = arg;
>>> +
>>> +    if (atomic_read(&text_patch_id) == smp_processor_id()) {
>>
>> You could actually pass in the test_patch_id as zero-initialised parameter
>> to this function (i.e. it points to something on the stack of the guy
>> issuing the stop_machine). Then you do an inc_return here. If you see zero,
>> you go ahead and do the patching.
> Good suggestion!
> Function stop_machine() already has a mutex to serialize all callers,
> so we don't need explicitly serialization here. Will simplify the
> code in next version.
>
>>
>>> +            for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
>>> +                    ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
>>> +                                                         pp->new_insns[i]);
>>> +            /* Let other CPU continue */
>>> +            atomic_set(&text_patch_id, -1);
>>
>> You're relying on the barrier in flush_icache_range to order this
>> atomic_set. I think you should add a comment describing that, because it's
>> very subtle.
> How about an explicitly smp_wmb() here? That would be more
> maintainable.
>
>>
>>> +    } else {
>>> +            while (atomic_read(&text_patch_id) != -1)
>>> +                    cpu_relax();
>>> +            isb();
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>
>> I don't think you need the isb -- the exception return should do the trick
>> (but again, a comment would be useful).
> stop_machine() is implemented by thread scheduling instead of cross CPU
> function call(IPI), so there may be no "eret" after returning from
> this callback function. So used an "isb" here.
>
>>
>>> +
>>> +int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
>>> +{
>>> +    int ret;
>>> +    struct aarch64_insn_patch patch = {
>>> +            .text_addrs = addrs,
>>> +            .new_insns = insns,
>>> +            .insn_cnt = cnt,
>>> +    };
>>> +
>>> +    if (cnt <= 0)
>>> +            return -EINVAL;
>>> +
>>> +    mutex_lock(&text_patch_lock);
>>
>> Again, if you use a loacl variable, I don't think you need the mutex. What
>> do you think?
> Sure, will make the change.
>
>>
>>> +    atomic_set(&text_patch_id, smp_processor_id());
>>> +    ret = stop_machine(aarch64_insn_patch_text_cb, &patch, cpu_online_mask);
>>
>> Instead of doing this, why not instead call aarch64_insn_patch_text_nosync
>> inline, then call kick_all_cpus_sync immediately afterwards, without the
>> need to stop_machine.
> Sandeepa, who is working on kprobe for ARM64, needs the stop_machine()
> mechanism to synchronize all online CPUs, so it's a preparation for
> kprobe.
Hi Gerry,

I had published kprobes patches for ARM64:
http://lwn.net/Articles/570648/  and using your patcset (v3) for
patching support, it works so far.
I CCed you on my RFC but unfortunately to your huawei email not the gmail.

I can give a try with kick_all_cpus_sync but wanted to understand this
a bit  detail on hows different from stop_machine and how this work.

Thanks,
Sandeepa

>
> Thanks!
> Gerry
>>
>> Will
>>
>
