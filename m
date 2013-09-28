Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3I1BWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 21:22:32 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:48016 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3I1BW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 21:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <5245A73F.9030207@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
	<CA+b37P2McAMq80jppqoD58QjhrJ7f2cEX4JJdivVfuRH1-69VQ@mail.gmail.com>
	<5245A73F.9030207@gmail.com>
Date: Sat, 28 Sep 2013 06:52:27 +0530
Message-ID: <CA+b37P0MCg4dW+0jZ7gDJsGGKZa8bwC+yyyxumSuVNtsqEUXjw@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel and
 module code
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2013 21:11, Jiang Liu <liuj97@gmail.com> wrote:
> On 09/25/2013 10:35 PM, Sandeepa Prabhu wrote:
>> On 25 September 2013 16:14, Jiang Liu <liuj97@gmail.com> wrote:
>>> From: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> Introduce aarch64_insn_patch_text() and __aarch64_insn_patch_text()
>>> to patch kernel and module code.
>>>
>>> Function aarch64_insn_patch_text() is a heavy version which may use
>>> stop_machine() to serialize all online CPUs, and function
>>> __aarch64_insn_patch_text() is light version without explicitly
>>> serialization.
>> Hi Jiang,
>>
>> I have written kprobes support for aarch64, and need both the
>> functionality (lightweight and stop_machine() versions).
>> I would like to rebase these API in kprobes, however slight changes
>> would require in case of stop_machine version, which I explained
>> below.
>> [Though kprobes cannot share Instruction encode support of jump labels
>> as, decoding & simulation quite different for kprobes/uprobes and
>> based around single stepping]
>>
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> Cc: Jiang Liu <liuj97@gmail.com>
>>> ---
>>>  arch/arm64/include/asm/insn.h |  2 ++
>>>  arch/arm64/kernel/insn.c      | 64 +++++++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 66 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
>>> index e7d1bc8..0ea7193 100644
>>> --- a/arch/arm64/include/asm/insn.h
>>> +++ b/arch/arm64/include/asm/insn.h
>>> @@ -49,5 +49,7 @@ __AARCH64_INSN_FUNCS(nop,     0xFFFFFFFF, 0xD503201F)
>>>  enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
>>>
>>>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>>> +int aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
>>> +int __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
>>>
>>>  #endif /* _ASM_ARM64_INSN_H */
>>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>>> index 8541c3a..50facfc 100644
>>> --- a/arch/arm64/kernel/insn.c
>>> +++ b/arch/arm64/kernel/insn.c
>>> @@ -15,6 +15,8 @@
>>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>   */
>>>  #include <linux/kernel.h>
>>> +#include <linux/stop_machine.h>
>>> +#include <asm/cacheflush.h>
>>>  #include <asm/insn.h>
>>>
>>>  static int aarch64_insn_cls[] = {
>>> @@ -69,3 +71,65 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>>>         return __aarch64_insn_hotpatch_safe(old_insn) &&
>>>                __aarch64_insn_hotpatch_safe(new_insn);
>>>  }
>>> +
>>> +struct aarch64_insn_patch {
>>> +       void    *text_addr;
>>> +       u32     *new_insns;
>>> +       int     insn_cnt;
>>> +};
>>> +
>>> +int __kprobes __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
>>> +{
>>> +       int i;
>>> +       u32 *tp = addr;
>>> +
>>> +       /* instructions must be word aligned */
>>> +       if (cnt <= 0 || ((uintptr_t)addr & 0x3))
>>> +               return -EINVAL;
>>> +
>>> +       for (i = 0; i < cnt; i++)
>>> +               tp[i] = insns[i];
>>> +
>>> +       flush_icache_range((uintptr_t)tp, (uintptr_t)tp + cnt * sizeof(u32));
>>> +
>>> +       return 0;
>>> +}
>> Looks fine, but do you need to check for CPU big endian mode here? (I
>> think swab32() needed if EL1 is in big-endian mode)
> Hi Sandeepa,
>         Thanks for reminder, we do need to take care of data access endian
> issue here, will fix it in next version.
>
>>
>>> +
>>> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
>>> +{
>>> +       struct aarch64_insn_patch *pp = arg;
>>> +
>>> +       return __aarch64_insn_patch_text(pp->text_addr, pp->new_insns,
>>> +                                        pp->insn_cnt);
>>> +}
>>> +
>>> +int __kprobes aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
>>> +{
>>> +       int ret;
>>> +       bool safe = false;
>>> +
>>> +       /* instructions must be word aligned */
>>> +       if (cnt <= 0 || ((uintptr_t)addr & 0x3))
>>> +               return -EINVAL;
>>> +
>>> +       if (cnt == 1)
>>> +               safe = aarch64_insn_hotpatch_safe(*(u32 *)addr, insns[0]);
>>> +
>>> +       if (safe) {
>>> +               ret = __aarch64_insn_patch_text(addr, insns, cnt);
>>> +       } else {
>>
>> Can you move the code below this into separate API that just apply
>> patch with stop_machine? And then a wrapper function for jump label
>> specific handling that checks for aarch64_insn_hotpatch_safe() ?
>> Also, it will be good to move the patching code out of insn.c to
>> patch.c (refer to arch/arm/kernel/patch.c).
>>
>> Please refer to attached file (my current implementation) to make
>> sense of exactly what kprobes would need (ignore the big-endian part
>> for now). I think splitting the code should be straight-forward and we
>> can avoid two different implementations. Please let me know if this
>> can be done, I will rebase my patches above your next version.
>
> After reading the attached file, I feel current implementation of
> aarch64_insn_patch_text() should satisfy kprobe's requirements too.
>
> The extra optimization of aarch64_insn_hotpatch_safe() should work
> for kprobe too. For example, if we install a kprobe on a function call
> instruction(BL), we need to replace "BL offset1" with "BRK" or "BL
> offset2". In such cases, we could directly patch the code without
> stop_machine(). Is there any special requirement that we must use
> stop_machine() for kprobe here?
Kprobes will have it's own checks before placing a break-point so
additional check is not required. Though it might work, that's not the
point, it does not need extra check while kprobes logic would have
already validated before calling patching API.

And stop_machine is needed to apply code patch in sync with all cpus,
kprobes on most other platforms use stop_machine to update code
section.

Thanks,
Sandeepa
>
> Thanks!
> Gerry
>
>>
>> Thanks,
>> Sandeepa
>>> +               struct aarch64_insn_patch patch = {
>>> +                       .text_addr = addr,
>>> +                       .new_insns = insns,
>>> +                       .insn_cnt = cnt,
>>> +               };
>>> +
>>> +               /*
>>> +                * Execute __aarch64_insn_patch_text() on every online CPU,
>>> +                * which ensure serialization among all online CPUs.
>>> +                */
>>> +               ret = stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
>>> +       }
>>> +
>>> +       return ret;
>>> +}
>>> --
>>> 1.8.1.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
