Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbaLBXnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:43:06 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54397 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbaLBXnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:43:02 -0500
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, linux@arm.linux.org.uk,
        hsweeten@visionengravers.com, tony@atomide.com, s.hauer@pengutronix.de,
        wsa@the-dreams.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris@printf.net, gsoutade@neotion.com,
        joe@perches.com, axel.lin@ingics.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
Date: Tue,  2 Dec 2014 15:42:43 -0800
Message-Id: <1417563767-32181-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bing Zhao at Marvell found a problem with dw_mmc where interrupts
weren't firing sometimes.  He tracked it down to a read-modify-write
problem with the INTMASK.  These patches fix the problem.

Note: I've picked up a > 1-year old series here to make another
attempt at landing it upstream.  These patches have been in shipping
Chromebooks for the last year.  Note that v3 to v4 has no changes
other than a rebase and a small commit message update.

The first two patches extend the "init_card()" mechanism of MMC core
to actually be called for all card types, not just SDIO.  That could
be applied any time and should fix at least one longstanding bug
(untested).

The third patch is a cleanup patch to use init_card() to move things
around a bit so we don't need to handle SDIO cards in such a strange
place.  On earlier versions of this patch Seungwon brought up a few
points which I have _not_ addressed.  See
<https://patchwork.kernel.org/patch/3049071/>.  Other than talk of
cards with out of band interrupts maybe being able to gate their
clocks, he wanted to use MMC_QUIRK_BROKEN_CLK_GATING.  I didn't do
that because of the ordering of init_card() and when the quirks are
set.  Some users of init_card() like pandora_wl1251_init_card() rely
on it being called very early in the process.
pandora_wl1251_init_card() hardcodes a vendor and device and thus need
to be called super early.  On the other hand the code that adds quirks
_reads_ the vendor and device.  It can't possibly move before
init_card().  If folks are willing to take an additional host op of
init_card_late() I can certainly go that way, though.

The fourth patch is (I think) reviewed and ready to go assuming the
other two land.

Changes in v5:
- Split fixup to pandora_wl1251_init_card() into its own patch.

Changes in v3:
- Add fixup to pandora_wl1251_init_card().

Changes in v2:
- mmc core change new for this version.
- Fixed "|" to "&".
- intmask_lock renamed to irq_lock

Doug Anderson (4):
  ARM: OMAP2+: Make sure pandora_wl1251_init_card() applies to SDIO only
  mmc: core: Support the optional init_card() callback for MMC and SD
  mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO interrupts
  mmc: dw_mmc: Protect read-modify-write of INTMASK with a lock

 arch/arm/mach-omap2/board-omap3pandora.c | 14 +++---
 drivers/mmc/core/mmc.c                   |  6 +++
 drivers/mmc/core/sd.c                    |  7 ++-
 drivers/mmc/host/dw_mmc.c                | 80 +++++++++++++++++++-------------
 drivers/mmc/host/dw_mmc.h                |  1 +
 include/linux/mmc/dw_mmc.h               |  6 +++
 6 files changed, 74 insertions(+), 40 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

