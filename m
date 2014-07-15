Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbaGOLTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:19:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13644 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaGOLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:19:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d6-53c50e5308c4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Subject: Re: [PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences
Date: Tue, 15 Jul 2014 13:19:29 +0200
Message-id: <2740751.gTMSlJs48H@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53C3A8E8.4090009@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403697175-13476-1-git-send-email-t.figa@samsung.com>
 <53C3A8E8.4090009@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQd1gvqPBBj/381qs+atk0bvgKpvF
	psfXWC0u75rDZjHj/D4mi7VH7rJbrJ/xmsVi1a4/jA4cHjtn3WX32Lyk3qNvyypGj8+b5AJY
	orhsUlJzMstSi/TtErgy9n5YwVawTKLi2M+H7A2MH4W6GDk5JARMJH4+e8AKYYtJXLi3ng3E
	FhKYzigxdZNyFyMXkN3CJPHh2EwWkASbgJXExPZVjCC2iIC6xLcp/ewgRcwCk5kkTjydxQ6S
	EBZwldj7YjZYEYuAqkTjy1lgU3kFNCV2da0A2yYq4CmxY/tKoDgHBydQ/Pe0WojFsxgl3nTY
	QpQLSvyYfA9sL7OAvMS+/VNZIWwdif2t09gmMAIVI5TNQlI2C0nZAkbmVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBAf5MagfjygaLQ4wCHIxKPLwS7w4HC7EmlhVX5h5ilOBgVhLhrf93
	JFiINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDY8/zLzN6
	DswR8tLe3DR1KrPWgkuftm4v/2Czvfym4fJ5tUc03W5o+It5HKpZ3LNsuZL5ITZON9/Af72S
	85uk9588PnHrJ2kuTU2XOc9blu8+9PSiUxuPlMFxsZ9OKefYM5Xfr/t2wGnfdY2QyyyVK/f9
	ZBBbd+vTBVvVzoUXt0m93L/j+Jrtiy8qsRRnJBpqMRcVJwIAYOXwgWwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, July 14, 2014 11:54:48 AM Tomasz Figa wrote:
> Hi Kukjin,
> 
> On 25.06.2014 13:52, Tomasz Figa wrote:
> > Due to recent consolidation of Exynos suspend and cpuidle code, some
> > parts of suspend and resume sequences are executed two times, once from
> > exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
> > breaks suspend, at least on Exynos4-based boards.
> > 
> > This patch fixes the issue by removing exynos_pm_syscore_ops completely
> > and making the code rely only on CPU PM notifier.
> > 
> > Tested on Exynos4210-based Trats board.
> > 
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  arch/arm/mach-exynos/pm.c | 23 ++++-------------------
> >  1 file changed, 4 insertions(+), 19 deletions(-)
> > 
> > Changes since v1:
> >  - rebased onto Kukjin's fixes branch.
> > 
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index 202ca73..f23cc77 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -364,11 +364,6 @@ early_wakeup:
> >  	return;
> >  }
> >  
> > -static struct syscore_ops exynos_pm_syscore_ops = {
> > -	.suspend	= exynos_pm_suspend,
> > -	.resume		= exynos_pm_resume,
> > -};
> > -
> >  /*
> >   * Suspend Ops
> >   */
> > @@ -438,22 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
> >  
> >  	switch (cmd) {
> >  	case CPU_PM_ENTER:
> > -		if (cpu == 0) {
> > -			exynos_pm_central_suspend();
> > -			if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
> > -				exynos_cpu_save_register();
> > -		}
> > +		if (cpu == 0)
> > +			exynos_pm_suspend();
> >  		break;
> >  
> >  	case CPU_PM_EXIT:
> > -		if (cpu == 0) {
> > -			if (read_cpuid_part_number() ==
> > -					ARM_CPU_PART_CORTEX_A9) {
> > -				scu_enable(S5P_VA_SCU);
> > -				exynos_cpu_restore_register();
> > -			}
> > -			exynos_pm_central_resume();
> > -		}
> > +		if (cpu == 0)
> > +			exynos_pm_resume();
> >  		break;
> >  	}
> >  
> > @@ -478,6 +464,5 @@ void __init exynos_pm_init(void)
> >  	tmp |= ((0xFF << 8) | (0x1F << 1));
> >  	__raw_writel(tmp, S5P_WAKEUP_MASK);
> >  
> > -	register_syscore_ops(&exynos_pm_syscore_ops);
> >  	suspend_set_ops(&exynos_suspend_ops);
> >  }
> > 
> 
> Please consider this patch for next fixes pull request. Without it
> suspend/resume is broken for Exynos4 and probably other SoCs. This patch
> just restores the sequence from before the patch moving things to PM
> notifier, so I don't think it should need any special treatment.

Your patch fixes the regression and is a step in the good direction but it
seems that it needs a bit more work:

Your patch adds to cpuidle AFTR code path restoring of exynos_core_save and
exynos5_sys_save registers without saving them first (restoring is done
through exynos_pm_resume() which is used by both suspend and cpuidle while
saving is done through exynos_pm_prepare() which is used only by suspend). 

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

