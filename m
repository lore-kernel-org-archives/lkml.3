Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3CMSSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:18:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51999 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938Ab3CMSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:17:59 -0400
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="29169505"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv3 00/10] Remove ARM local timer API
Date: Wed, 13 Mar 2013 11:17:46 -0700
Message-Id: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In light of Mark Rutland's recent work on divorcing the ARM architected
timers from the ARM local timer API and introducing a generic arch hook for
broadcast it seems that we should remove the local timer API entirely.
Doing so will reduce the architecture dependencies of our timer drivers,
reduce code in ARM core, and simplify timer drivers because they no longer
go through an architecture layer that is essentially a hotplug notifier.

Previous attempts have been made[1] unsuccessfully. I'm hoping this can
be accepted now so that we can clean up the timer drivers that are
used in both UP and SMP situations. Right now these drivers have to ignore
the timer setup callback on the boot CPU to avoid registering clockevents
twice. This is not very symmetric and causes convuluted code that does
the same thing in two places.

Patches based on v3.9-rc2. I'm still looking for Acks/Tested-by
on EXYNOS and PRIMA2.

[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/145705

Note: A hotplug notifier is used by both x86 for the apb_timer (see 
apbt_cpuhp_notify) and by metag (see arch_timer_cpu_notify in
metag_generic.c) so this is not new.

Changes since v2:
 * Bug fixes in smp_twd from Tony Lindgren's testing
 * Move smp_twd to use late_time_init hook
 * Collected Acks

Changes since v1:
 * Picked up Mark's generic dummy timer driver
 * Split out omap changes into new patch

Mark Rutland (1):
  clocksource: add generic dummy timer driver

Stephen Boyd (9):
  ARM: smp: Remove duplicate dummy timer implementation
  ARM: smp_twd: Divorce smp_twd from local timer API
  ARM: OMAP2+: Divorce from local timer API
  ARM: EXYNOS4: Divorce mct from local timer API
  ARM: PRIMA2: Divorce timer-marco from local timer API
  ARM: msm: Divorce msm_timer from local timer API
  clocksource: time-armada-370-xp: Fix sparse warning
  clocksource: time-armada-370-xp: Divorce from local timer API
  ARM: smp: Remove local timer API

 arch/arm/Kconfig                         |  12 +--
 arch/arm/include/asm/localtimer.h        |  34 ---------
 arch/arm/kernel/smp.c                    |  87 ---------------------
 arch/arm/kernel/smp_twd.c                |  64 ++++++++++------
 arch/arm/mach-exynos/mct.c               |  53 +++++++++----
 arch/arm/mach-msm/timer.c                | 125 +++++++++++++++++--------------
 arch/arm/mach-omap2/Kconfig              |   1 -
 arch/arm/mach-omap2/timer.c              |   7 --
 arch/arm/mach-prima2/timer-marco.c       |  98 ++++++++++++------------
 drivers/clocksource/Makefile             |   1 +
 drivers/clocksource/dummy_timer.c        |  67 +++++++++++++++++
 drivers/clocksource/time-armada-370-xp.c |  88 ++++++++++------------
 include/linux/time-armada-370-xp.h       |   4 +-
 13 files changed, 309 insertions(+), 332 deletions(-)
 delete mode 100644 arch/arm/include/asm/localtimer.h
 create mode 100644 drivers/clocksource/dummy_timer.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

