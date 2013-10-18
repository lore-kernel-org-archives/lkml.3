Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3JRV4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:56:20 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:65462 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3JRV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:56:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <cjb@laptop.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        Daniel Mack <daniel@caiaq.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Doug Anderson <dianders@chromium.org>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-omap@vger.kernel.org,
        Kevin Liu <kliu5@marvell.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Johan Rudholm <jrudholm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH v3 0/3] Prevent races when doing read-modify-write of INTMASK
Date: Fri, 18 Oct 2013 14:55:59 -0700
Message-Id: <1382133362-31747-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382126905-14654-1-git-send-email-dianders@chromium.org>
References: <1382126905-14654-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bing Zhao at Marvell discovered a race in the way that dw_mmc was
doing a read-modify-write of the INTMASK register.  This 2-patch
series attempts to fix the problem using a simple spinlock.  In order
to do so cleanly, we include a patch to tidy up the way that we
disable low power mode when using SDIO interrupts.

This patch series was not tested on ToT Linux other than basic
compiling and booting, since we don't have the whole Marvell SDIO
stack up and running in mainline yet.  This series is based on
mmc-next (e76b855 mmc: sdhci-esdhc-imx: set actual_clock in clock
setting) merged atop mainlinx Linux.

Changes in v3:
- Add fixup to pandora_wl1251_init_card().

Changes in v2:
- Core patch new for this version.
- Fixed "|" to "&".
- intmask_lock renamed to irq_lock

Doug Anderson (3):
  mmc: core: Support the optional init_card() callback for MMC and SD
  mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO interrupts
  mmc: dw_mmc: Protect read-modify-write of INTMASK with a lock

 arch/arm/mach-omap2/board-omap3pandora.c | 14 +++---
 drivers/mmc/core/mmc.c                   |  6 +++
 drivers/mmc/core/sd.c                    |  7 ++-
 drivers/mmc/host/dw_mmc.c                | 79 +++++++++++++++++++-------------
 drivers/mmc/host/dw_mmc.h                |  1 +
 include/linux/mmc/dw_mmc.h               |  6 +++
 6 files changed, 74 insertions(+), 39 deletions(-)

-- 
1.8.4

