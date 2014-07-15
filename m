Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaGORbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:31:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48113 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaGORbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:31:44 -0400
MIME-Version: 1.0
In-Reply-To: <53C51B57.9040404@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
	<1403697175-13476-1-git-send-email-t.figa@samsung.com>
	<53C3A8E8.4090009@gmail.com>
	<2740751.gTMSlJs48H@amdc1032>
	<53C51B57.9040404@samsung.com>
Date: Tue, 15 Jul 2014 23:01:43 +0530
X-Google-Sender-Auth: 1lGkzcg8S9GUUyjc2B464m2MoGM
Message-ID: <CADWw7OgQpJh+5V10QfKQyeUk3kV+AiKJ8yk_+jqW9QywgHAqFA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences
From: Chander Kashyap <k.chander@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:45 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On 15.07.2014 13:19, Bartlomiej Zolnierkiewicz wrote:
>>
>> Hi,
>>
>> On Monday, July 14, 2014 11:54:48 AM Tomasz Figa wrote:
>>> Hi Kukjin,
>>>
>>> On 25.06.2014 13:52, Tomasz Figa wrote:
>>>> Due to recent consolidation of Exynos suspend and cpuidle code, some
>>>> parts of suspend and resume sequences are executed two times, once from
>>>> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
>>>> breaks suspend, at least on Exynos4-based boards.
>>>>
>>>> This patch fixes the issue by removing exynos_pm_syscore_ops completely
>>>> and making the code rely only on CPU PM notifier.
>>>>
>>>> Tested on Exynos4210-based Trats board.
>>>>
>>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>>> ---
>>>>  arch/arm/mach-exynos/pm.c | 23 ++++-------------------
>>>>  1 file changed, 4 insertions(+), 19 deletions(-)
>>>>
>>>> Changes since v1:
>>>>  - rebased onto Kukjin's fixes branch.
>>>>
>>>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>>>> index 202ca73..f23cc77 100644
>>>> --- a/arch/arm/mach-exynos/pm.c
>>>> +++ b/arch/arm/mach-exynos/pm.c
>>>> @@ -364,11 +364,6 @@ early_wakeup:
>>>>     return;
>>>>  }
>>>>
>>>> -static struct syscore_ops exynos_pm_syscore_ops = {
>>>> -   .suspend        = exynos_pm_suspend,
>>>> -   .resume         = exynos_pm_resume,
>>>> -};
>>>> -
>>>>  /*
>>>>   * Suspend Ops
>>>>   */
>>>> @@ -438,22 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>>>>
>>>>     switch (cmd) {
>>>>     case CPU_PM_ENTER:
>>>> -           if (cpu == 0) {
>>>> -                   exynos_pm_central_suspend();
>>>> -                   if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
>>>> -                           exynos_cpu_save_register();
>>>> -           }
>>>> +           if (cpu == 0)
>>>> +                   exynos_pm_suspend();
>>>>             break;
>>>>
>>>>     case CPU_PM_EXIT:
>>>> -           if (cpu == 0) {
>>>> -                   if (read_cpuid_part_number() ==
>>>> -                                   ARM_CPU_PART_CORTEX_A9) {
>>>> -                           scu_enable(S5P_VA_SCU);
>>>> -                           exynos_cpu_restore_register();
>>>> -                   }
>>>> -                   exynos_pm_central_resume();
>>>> -           }
>>>> +           if (cpu == 0)
>>>> +                   exynos_pm_resume();
>>>>             break;
>>>>     }
>>>>
>>>> @@ -478,6 +464,5 @@ void __init exynos_pm_init(void)
>>>>     tmp |= ((0xFF << 8) | (0x1F << 1));
>>>>     __raw_writel(tmp, S5P_WAKEUP_MASK);
>>>>
>>>> -   register_syscore_ops(&exynos_pm_syscore_ops);
>>>>     suspend_set_ops(&exynos_suspend_ops);
>>>>  }
>>>>
>>>
>>> Please consider this patch for next fixes pull request. Without it
>>> suspend/resume is broken for Exynos4 and probably other SoCs. This patch
>>> just restores the sequence from before the patch moving things to PM
>>> notifier, so I don't think it should need any special treatment.
>>
>> Your patch fixes the regression and is a step in the good direction but it
>> seems that it needs a bit more work:
>>
>> Your patch adds to cpuidle AFTR code path restoring of exynos_core_save and
>> exynos5_sys_save registers without saving them first (restoring is done
>> through exynos_pm_resume() which is used by both suspend and cpuidle while
>> saving is done through exynos_pm_prepare() which is used only by suspend).
>
> That's right, unfortunately. Interestingly enough AFTR worked fine on
> Exynos4210 with this patch, but still this needs to be fixed.
>
> Now, in fact, I recall that Chander had some objections to this patch as
> well and we decided that he will send another patch to replace mine [1],
> but I haven't heard from him since that.

Patch for the same has been already posted.
Below is the link for the same
http://www.spinics.net/lists/arm-kernel/msg343402.html

This patch has conflict with Russel's patch, so i will rebase on his
tree and resend

This patch can be ignored in that case.

>
> Chander, do you have any progress with this? Keep in mind that we need
> this as an rc fix and we already have rc5, so not much time left. If you
> don't have time to work on this I can take care of this, proceeding as
> we discussed in [1].
>
> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085/focus=33975
>
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
