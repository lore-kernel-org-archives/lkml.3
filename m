Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3IZCvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:51:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36284 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZCvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <5243074C.5000507@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
	<CA+b37P2McAMq80jppqoD58QjhrJ7f2cEX4JJdivVfuRH1-69VQ@mail.gmail.com>
	<5243074C.5000507@gmail.com>
Date: Thu, 26 Sep 2013 08:21:16 +0530
Message-ID: <CA+b37P31XGEVMuOwMvMuGpyvC2qjqxXSTQhZ8AXvavdAHGfE=Q@mail.gmail.com>
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

On 25 September 2013 21:24, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Sandeepa,
>         Great to know that you are working on kprobe for ARM64.
> I have done some investigation, found it's an huge work for me
> then gave up:(
>         I will try refine the implementation based on your requirement.
>         Thanks!
Hi Jiang,
Thanks. please CC me when you post next version of this patch, then I
can rebase my code and verify it.

Thanks,
Sandeepa

>
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
