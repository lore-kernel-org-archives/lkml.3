Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3BVH12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:27:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37814 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3BVH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="26425012"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/8] Remove ARM local timer API
Date: Thu, 21 Feb 2013 23:27:11 -0800
Message-Id: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
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

Patches based on linux-next-20130221. Mostly compile tested as I don't
have access to the hardware.

[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/145705

Note: A hotplug notifier is used by both x86 for the apb_timer (see 
apbt_cpuhp_notify) and by metag (see arch_timer_cpu_notify in
metag_generic.c) so this is not new.

Stephen Boyd (8):
  ARM: smp: Lower rating of dummy broadcast device
  ARM: smp_twd: Divorce smp_twd from local timer API
  ARM: EXYNOS4: Divorce mct from local timer API
  ARM: PRIMA2: Divorce timer-marco from local timer API
  ARM: MSM: Divorce msm_timer from local timer API
  clocksource: time-armada-370-xp: Fix sparse warning
  clocksource: time-armada-370-xp: Divorce from local timer API
  ARM: smp: Remove local timer API

 arch/arm/Kconfig                         |  12 +--
 arch/arm/include/asm/localtimer.h        |  34 ---------
 arch/arm/kernel/smp.c                    |  69 +++--------------
 arch/arm/kernel/smp_twd.c                |  48 ++++++++----
 arch/arm/mach-exynos/mct.c               |  53 +++++++++----
 arch/arm/mach-msm/timer.c                | 125 +++++++++++++++++--------------
 arch/arm/mach-omap2/Kconfig              |   1 -
 arch/arm/mach-omap2/timer.c              |   7 --
 arch/arm/mach-prima2/timer-marco.c       |  98 ++++++++++++------------
 drivers/clocksource/time-armada-370-xp.c |  88 ++++++++++------------
 include/linux/time-armada-370-xp.h       |   4 +-
 11 files changed, 241 insertions(+), 298 deletions(-)
 delete mode 100644 arch/arm/include/asm/localtimer.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

