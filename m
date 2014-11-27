Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaK0Qvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:51:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12492 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaK0Qvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:51:40 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-70-5477569a65ff
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 0/2] cpuidle: exynos: add coupled cpuidle support for
 Exynos4210
Date: Thu, 27 Nov 2014 17:51:23 +0100
Message-id: <1417107085-26159-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd1ZYeUhBrtW8ltsnLGe1WLBjHZm
	i3mfZS1evzC06F1wlc3ibNMbdov3h54xW1zeNYfN4nPvEUaLGef3MVms2vWH0YHbY+esu+we
	CzaVety5tofN4/a/x8wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfGxcy1bwSrRinNzelgb
	GL8JdDFyckgImEjMmHyGGcIWk7hwbz1bFyMXh5DAIkaJyV9nMkE4XUwSBzd0gFWxCVhJTGxf
	xQhiiwioSfQs3soIUsQs8JZJYvurR0wgCWGBUInGX4fZQWwWAVWJ+es2gzXwCnhIHL8znw1i
	naJE97MJbBMYuRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA6qZ9I7GFc1WBxiFOBg
	VOLhtThQFiLEmlhWXJl7iFGCg1lJhLfJtjxEiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+Nm7kh
	QgLpiSWp2ampBalFMFkmDk6pBsbyr5Ns/BNrN01cyD+zZMuLx7quF5q5L0jf8TDayfFRQenO
	Da9JT81+GtuHe1/ZqJNcvKdCUtSFOaHqi4ey6MW5s7dPkYnflKtQwFj9x8ji13TFVauzEv3Y
	RTNfPRXtP/Dk2Y7ua+uzWa05mY/Nn7/25VWTVq6erddstuv28fYu+zK/crHU9c9KLMUZiYZa
	zEXFiQC2tZf5JgIAAA==
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
- for-next branch (760a7d4763c8) of linux-samsung.git kernel tree

v2:
- rebased on top of for-next branch (commit: 760a7d4763c8) of
  linux-samsung.git kernel tree (the patchset also applies fine
  to next-20141126 branch of linux-next kernel tree but needs
  CPUIDLE_FLAG_TIME_VALID flag usage removed to fix build)
- added Signed-off-by from Daniel Lezcano to patch #2
- added separate struct cpuidle_driver exynos_coupled_idle_driver

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
 drivers/cpuidle/cpuidle-exynos.c             |  77 +++++++++++++++-
 include/linux/platform_data/cpuidle-exynos.h |  20 ++++
 8 files changed, 235 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/platform_data/cpuidle-exynos.h

-- 
1.8.2.3

