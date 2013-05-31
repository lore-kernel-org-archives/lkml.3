Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3EaRz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:55:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3EaRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:55:48 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 13:55:48 EDT
Date: Fri, 31 May 2013 10:45:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
Message-ID: <20130531174526.GD599@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments have been light for this round so I think we're about
ready to merge. John/Thomas, can you pick up these patches or
shall I route them through arm-soc or something else?

On 05/13, Stephen Boyd wrote:
> In light of Mark Rutland's recent work on divorcing the ARM architected
> timers from the ARM local timer API and introducing a generic arch hook for
> broadcast it seems that we should remove the local timer API entirely.
> Doing so will reduce the architecture dependencies of our timer drivers,
> reduce code in ARM core, and simplify timer drivers because they no longer
> go through an architecture layer that is essentially a hotplug notifier.
> 
> Previous attempts have been made[1] unsuccessfully. I'm hoping this can
> be accepted now so that we can clean up the timer drivers that are
> used in both UP and SMP situations. Right now these drivers have to ignore
> the timer setup callback on the boot CPU to avoid registering clockevents
> twice. This is not very symmetric and causes convuluted code that does
> the same thing in two places.
> 
> Patches based on next-20130418
> 
> I'm still looking for Acks/Tested-by on EXYNOS and PRIMA2.
> 
> [1] http://article.gmane.org/gmane.linux.ports.arm.kernel/145705
> 
> Note: A hotplug notifier is used by both x86 for the apb_timer (see 
> apbt_cpuhp_notify) and by metag (see arch_timer_cpu_notify in
> metag_generic.c) so this is not new.
> 
> Changes since v5:
>  * Rebased onto v3.10-rc1
>  * Rebase caused minor updates to mct patch
> 
> Changes since v4:
>  * Rebased onto next-20130418
>  * Rebase caused minor updates to mct patch and twd Kconfig
> 
> Changes since v3:
>  * New patch to fix SMP with dummy timers registered after a global timer
>  * Push this_cpu_ptr lower to avoid preemptible false positive warnings
>  * Collected acks/tested-bys
> 
> Changes since v2:
>  * Bug fixes in smp_twd from Tony Lindgren's testing
>  * Move smp_twd to use late_time_init hook
>  * Collected Acks
> 
> Changes since v1:
>  * Picked up Mark's generic dummy timer driver
>  * Split out omap changes into new patch
> 
> Mark Rutland (1):
>   clocksource: add generic dummy timer driver
> 
> Stephen Boyd (10):
>   clockevents: Prefer CPU local devices over global devices
>   ARM: smp: Remove duplicate dummy timer implementation
>   ARM: smp_twd: Divorce smp_twd from local timer API
>   ARM: OMAP2+: Divorce from local timer API
>   ARM: EXYNOS4: Divorce mct from local timer API
>   ARM: PRIMA2: Divorce timer-marco from local timer API
>   ARM: msm: Divorce msm_timer from local timer API
>   clocksource: time-armada-370-xp: Fix sparse warning
>   clocksource: time-armada-370-xp: Divorce from local timer API
>   ARM: smp: Remove local timer API
> 
>  arch/arm/Kconfig                         |  12 +--
>  arch/arm/include/asm/localtimer.h        |  34 ---------
>  arch/arm/kernel/smp.c                    |  87 ---------------------
>  arch/arm/kernel/smp_twd.c                |  64 ++++++++++------
>  arch/arm/mach-highbank/Kconfig           |   2 +-
>  arch/arm/mach-imx/Kconfig                |   2 +-
>  arch/arm/mach-msm/timer.c                | 126 +++++++++++++++++--------------
>  arch/arm/mach-omap2/Kconfig              |   3 +-
>  arch/arm/mach-omap2/timer.c              |   7 --
>  arch/arm/mach-realview/Kconfig           |   8 +-
>  arch/arm/mach-spear/Kconfig              |   2 +-
>  arch/arm/mach-tegra/Kconfig              |   2 +-
>  arch/arm/mach-ux500/Kconfig              |   2 +-
>  arch/arm/mach-vexpress/Kconfig           |   2 +-
>  arch/arm/mach-zynq/Kconfig               |   2 +-
>  drivers/clocksource/Makefile             |   1 +
>  drivers/clocksource/dummy_timer.c        |  69 +++++++++++++++++
>  drivers/clocksource/exynos_mct.c         |  60 ++++++++++-----
>  drivers/clocksource/time-armada-370-xp.c |  92 +++++++++++-----------
>  drivers/clocksource/timer-marco.c        | 100 +++++++++++++-----------
>  include/linux/time-armada-370-xp.h       |   4 +-
>  kernel/time/tick-common.c                |   5 +-
>  22 files changed, 340 insertions(+), 346 deletions(-)
>  delete mode 100644 arch/arm/include/asm/localtimer.h
>  create mode 100644 drivers/clocksource/dummy_timer.c
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
