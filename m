Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaKGSBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:01:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27539 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKGSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:01:19 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-95-545d08ec52e0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 0/2] cpuidle: exynos: add coupled cpuidle support for Exynos4210
Date: Fri, 07 Nov 2014 19:00:49 +0100
Message-id: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t9jQd03HLEhBoe+WVhsnLGe1WLBjHZm
	i3mfZS1evzC06F1wlc3ibNMbdov3h54xW1zeNYfN4nPvEUaLGef3MVms2vWH0YHbY+esu+we
	CzaVety5tofN4/a/x8wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlTFpwmzmgndCFXMOnWJv
	YHzL18XIySEhYCJxZ/ZDVghbTOLCvfVsILaQwHRGiUWPSiDsLiaJGxdUQWw2ASuJie2rGEFs
	EQE1iZ7FW4FsLg5mgbdMEttfPWLqYuTgEBYIkGjoEgOpYRFQlWi8fYMJxOYV8JB4sPoWE8Qu
	RYnuZxPYJjByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHE7PpHcwrmqwOMQowMGo
	xMN7gzcmRIg1say4MvcQowQHs5IIrzlrbIgQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFC
	AumJJanZqakFqUUwWSYOTqkGRvYNFowFDuUff9q2ybFaN9ioLlWZ/uZ849nV8+s/SmfUcTDH
	f/RtWxiba27692ql58pP3QnTp1n/zlB6e2bVrZvRGbt0RSZU6/ZOaRHLsGDqsLZkSew4ZfT9
	81OeDjsBnna/JbPtJEu/t+09HvX2Uu+tzfYdick3lXbcN7gvmrc/evL5LbP2KbEUZyQaajEX
	FScCABxfBesjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset adds coupled cpuidle support for Exynos4210
to an existing cpuidle-exynos driver.  As a result it enables AFTR
mode to be used by default on Exynos4210 without the need to hot
unplug CPU1 first.

This work is heavily based on earlier cpuidle-exynos4210 driver from
Daniel Lezcano:

http://www.spinics.net/lists/linux-samsung-soc/msg28134.html

Changes from Daniel's code include:
- porting code to current kernels
- fixing it to work on my setup (by using S5P_INFORM register
  instead of S5P_VA_SYSRAM one on Revison 1.1 and retrying poking
  CPU1 out of the BOOT ROM if necessary)
- fixing rare lockup caused by waiting for CPU1 to get stuck in
  the BOOT ROM (CPU hotplug code in arch/arm/mach-exynos/platsmp.c
  doesn't require this and works fine)
- moving Exynos specific code to arch/arm/mach-exynos/pm.c
- using cpu_boot_reg_base() helper instead of BOOT_VECTOR macro
- using exynos_cpu_*() helpers instead of accessing registers
  directly
- using arch_send_wakeup_ipi_mask() instead of dsb_sev()
  (this matches CPU hotplug code in arch/arm/mach-exynos/platsmp.c)
- integrating separate exynos4210-cpuidle driver into existing
  exynos-cpuidle one

patch #1 is a fix for Exynos platform PM code preparing it for
coupled cpuidle support

patch #2 adds coupled cpuidle AFTR mode for Exynos4210

The patchset depends on:
- 'next-20141031' branch of linux-next kernel tree (it also applies
  fine to for-next branch of linux-samsung.git tree from today)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (2):
  ARM: EXYNOS: apply S5P_CENTRAL_SEQ_OPTION fix only when necessary
  cpuidle: exynos: add coupled cpuidle support for Exynos4210

 arch/arm/mach-exynos/common.h                |   4 +
 arch/arm/mach-exynos/exynos.c                |   4 +
 arch/arm/mach-exynos/platsmp.c               |   2 +-
 arch/arm/mach-exynos/pm.c                    | 133 ++++++++++++++++++++++++++-
 arch/arm/mach-exynos/suspend.c               |   4 +
 drivers/cpuidle/Kconfig.arm                  |   1 +
 drivers/cpuidle/cpuidle-exynos.c             |  62 ++++++++++++-
 include/linux/platform_data/cpuidle-exynos.h |  20 ++++
 8 files changed, 220 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/platform_data/cpuidle-exynos.h

-- 
1.8.2.3

