Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbaGOMQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:16:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51852 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705AbaGOMQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:16:11 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-31-53c51b7b32da
Message-id: <53C51B57.9040404@samsung.com>
Date: Tue, 15 Jul 2014 14:15:19 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403697175-13476-1-git-send-email-t.figa@samsung.com>
 <53C3A8E8.4090009@gmail.com> <2740751.gTMSlJs48H@amdc1032>
In-reply-to: <2740751.gTMSlJs48H@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xK7rV0keDDQ5P17fYOGM9q8WqDUtY
	LNb8VbLoXXCVzWLT42usFpd3zWGzmHF+H5PF2iN32S1W7frD6MDpsXPWXXaPzUvqPfq2rGL0
	+LxJLoAlissmJTUnsyy1SN8ugSvj49l/rAVbZSsO3HvC2MB4XLyLkYNDQsBEYvou1i5GTiBT
	TOLCvfVsXYxcHEICSxkl5rfdYoJwPjNKnLp8B6yKV0BL4t7252A2i4CqxJtFe8FsNgE1ic8N
	j9hAbH6gmjVN11lAFogKREg8viAE0Soo8WPyPRYQW0QgXuLc649gy5gFZjFJPNuygRkkISzg
	KrH3xWxGiMU7GCUalsxlB0lwAg3d8fg7mM0soCOxv3UaG4QtL7F5zVvmCYyCs5AsmYWkbBaS
	sgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQqLg6w7GpcesDjEKcDAq8fDemHYkWIg1
	say4MvcQowQHs5IIb/0/oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGlb9ta1gNHk9esHSh7o6b
	GmkPGrrfCFguqDrGuzP73J7bFnHPpM63Zdxmti7Qv1EmeDcz4JpYyf2p5q7/mDQPhncsX8fM
	5FipalxVtsLolPjX+z/6lBW3czwRXs95MKjqTdti5Y0LHZxK8ntadd+W3e3/+7rVydX/t9jf
	c2naJhobbq+RDhRVYinOSDTUYi4qTgQAjSMOd2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2014 13:19, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday, July 14, 2014 11:54:48 AM Tomasz Figa wrote:
>> Hi Kukjin,
>>
>> On 25.06.2014 13:52, Tomasz Figa wrote:
>>> Due to recent consolidation of Exynos suspend and cpuidle code, some
>>> parts of suspend and resume sequences are executed two times, once from
>>> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
>>> breaks suspend, at least on Exynos4-based boards.
>>>
>>> This patch fixes the issue by removing exynos_pm_syscore_ops completely
>>> and making the code rely only on CPU PM notifier.
>>>
>>> Tested on Exynos4210-based Trats board.
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/pm.c | 23 ++++-------------------
>>>  1 file changed, 4 insertions(+), 19 deletions(-)
>>>
>>> Changes since v1:
>>>  - rebased onto Kukjin's fixes branch.
>>>
>>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>>> index 202ca73..f23cc77 100644
>>> --- a/arch/arm/mach-exynos/pm.c
>>> +++ b/arch/arm/mach-exynos/pm.c
>>> @@ -364,11 +364,6 @@ early_wakeup:
>>>  	return;
>>>  }
>>>  
>>> -static struct syscore_ops exynos_pm_syscore_ops = {
>>> -	.suspend	= exynos_pm_suspend,
>>> -	.resume		= exynos_pm_resume,
>>> -};
>>> -
>>>  /*
>>>   * Suspend Ops
>>>   */
>>> @@ -438,22 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>>>  
>>>  	switch (cmd) {
>>>  	case CPU_PM_ENTER:
>>> -		if (cpu == 0) {
>>> -			exynos_pm_central_suspend();
>>> -			if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
>>> -				exynos_cpu_save_register();
>>> -		}
>>> +		if (cpu == 0)
>>> +			exynos_pm_suspend();
>>>  		break;
>>>  
>>>  	case CPU_PM_EXIT:
>>> -		if (cpu == 0) {
>>> -			if (read_cpuid_part_number() ==
>>> -					ARM_CPU_PART_CORTEX_A9) {
>>> -				scu_enable(S5P_VA_SCU);
>>> -				exynos_cpu_restore_register();
>>> -			}
>>> -			exynos_pm_central_resume();
>>> -		}
>>> +		if (cpu == 0)
>>> +			exynos_pm_resume();
>>>  		break;
>>>  	}
>>>  
>>> @@ -478,6 +464,5 @@ void __init exynos_pm_init(void)
>>>  	tmp |= ((0xFF << 8) | (0x1F << 1));
>>>  	__raw_writel(tmp, S5P_WAKEUP_MASK);
>>>  
>>> -	register_syscore_ops(&exynos_pm_syscore_ops);
>>>  	suspend_set_ops(&exynos_suspend_ops);
>>>  }
>>>
>>
>> Please consider this patch for next fixes pull request. Without it
>> suspend/resume is broken for Exynos4 and probably other SoCs. This patch
>> just restores the sequence from before the patch moving things to PM
>> notifier, so I don't think it should need any special treatment.
> 
> Your patch fixes the regression and is a step in the good direction but it
> seems that it needs a bit more work:
> 
> Your patch adds to cpuidle AFTR code path restoring of exynos_core_save and
> exynos5_sys_save registers without saving them first (restoring is done
> through exynos_pm_resume() which is used by both suspend and cpuidle while
> saving is done through exynos_pm_prepare() which is used only by suspend). 

That's right, unfortunately. Interestingly enough AFTR worked fine on
Exynos4210 with this patch, but still this needs to be fixed.

Now, in fact, I recall that Chander had some objections to this patch as
well and we decided that he will send another patch to replace mine [1],
but I haven't heard from him since that.

Chander, do you have any progress with this? Keep in mind that we need
this as an rc fix and we already have rc5, so not much time left. If you
don't have time to work on this I can take care of this, proceeding as
we discussed in [1].

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085/focus=33975

Best regards,
Tomasz
