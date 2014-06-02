Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaFBMJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:09:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22071 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaFBMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:09:07 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-a1-538c695984a1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 6/7] ARM: EXYNOS: PM: fix register setup on EXYNOS4x12 for
 AFTR mode code
Date: Mon, 02 Jun 2014 14:08:29 +0200
Message-id: <2762097.QhkViWyNLQ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5375D44F.7000505@linaro.org>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
 <1399287439-31376-7-git-send-email-b.zolnierkie@samsung.com>
 <5375D44F.7000505@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jAd3IzJ5gg22HzS3mfZa16F1wlc3i
	bNMbdov3h54xW2x6fI3V4vKuOWwWn3uPMFrMOL+PyeLM6UusFif/9DJarJ/xmsVi41cPBx6P
	O9f2sHlsXlLvcfvfY2aPLVfbWTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY+bsCywFbfwV
	rxfuY2tgbOHpYuTkkBAwkVj98zk7hC0mceHeerYuRi4OIYFFjBKLfx1lgXBamCTOtp5hA6li
	E7CSmNi+ihHEFhHQk2h838YEYjMLzGSWuP9LBMQWFoiX2HFzEVicRUBVYs6LxSwgNq+ApsT8
	k3vAbFEBT4kd21eCzeQU0JL49rYBatlyRolrHROZIBoEJX5MvscCsUBeYt/+qawQtrrEpHmL
	mCcwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTHxzOpHYwrGywO
	MQpwMCrx8P5U7wkWYk0sK67MPcQowcGsJMK71AIoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdA
	q3WgkEB6YklqdmpqQWoRTJaJg1OqgdHjhWlKh+61T/usFTqOO/PvujTtjxJ3vRxD5Uatp3yG
	19Pemhtfe9l79FfIjMsT7sX9KVh4JO/K2XJPufZlrVaXr0nFaV7dY9r4IeHhzubCUr5VRZs3
	HVTIj3t0d/7jY9EqHAuVpWX2GS5rk1jquX/ZX/6obqlF53YeP7XL7KH25DUqhr6X5z1XYinO
	SDTUYi4qTgQAZrBYjYsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, May 16, 2014 11:03:11 AM Daniel Lezcano wrote:
> On 05/05/2014 12:57 PM, Bartlomiej Zolnierkiewicz wrote:
> > Add S5P_CENTRAL_SEQ_OPTION register setup for EXYNOS4x12 to AFTR
> > mode code.  Without this setup AFTR mode doesn't show any benefit
> > over WFI one.  When this setup is applied AFTR mode reduces power
> > consumption by ~12% (as measured on Trats2 board).
> >
> > This change is a preparation for adding secure firmware support to
> > EXYNOS cpuidle driver.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >   arch/arm/mach-exynos/pm.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index 18f6bf8..3922968 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -391,6 +391,10 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
> >   	case CPU_PM_ENTER:
> >   		if (cpu == 0) {
> >   			exynos_pm_central_suspend();
> > +			if (soc_is_exynos4212() || soc_is_exynos4412())
> > +				__raw_writel(S5P_USE_STANDBY_WFI0 |
> > +					     S5P_USE_STANDBY_WFE0,
> > +					     S5P_CENTRAL_SEQ_OPTION);
> 
> Why not put this code in the exynos_enter_aftr() ?

I would prefer to keep this code close to exynos_pm_central_suspend()
because exynos_pm_suspend() (which calls exynos_pm_central_suspend()
too) also contains S5P_USE_STANDBY_WF[I,E]0 setting code (done for all
SoCs).  If possible I would like to make this code common for AFTR &
suspend in the future (once it is tested on Exynos4210 and Exynos5250)
by moving S5P_USE_STANDBY_WF[I,E]0 setting to exynos_pm_central_suspend()
and doing it for all SoCs.  Are you okay with this?

> >   			exynos_cpu_save_register();
> >   		}
> >   		break;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

