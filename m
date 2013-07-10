Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3GJPmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:42:18 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:44565 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3GJPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:42:15 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] mmc: dw_mmc: Invalidate cache of current_speed after suspend/resume
Date: Wed, 10 Jul 2013 08:42:02 -0700
Message-Id: <1373470926-19314-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373470926-19314-1-git-send-email-dianders@chromium.org>
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_mmc driver keeps a cache of the current slot->clock in order to
avoid doing a whole lot of work every time set_ios() is called.
However, after suspend/resume the register values are bogus so we need
to ensure that the cached value is invalidated.

In many cases we got by without this since the core mmc code fiddles
with the clock a lot.  If we've got a card present we're probably
running it at something like 50MHz and the core will temporarily
switch us to 400kHz after resume.  One case that didn't work (for me)
is the case of having no card in the slot.  The slot is initted to
400kHz at boot time.  After suspend/resume the slot thinks it's still
at 400kHz (due to the cache) so doesn't adjust timing.  When it tries
to send the command at probe time it just times out and gets left in a
bad state.

Invalidating the current_speed also means that we don't need to call:
  dw_mci_setup_bus(slot, true);
...to force an update of the clock in the case when the slot was left
powered.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3: None
Changes in v2:
- Fix typo (some -> come)
- Use ~0 instead of 0xFFFFFFFF; add comment about value

 drivers/mmc/host/dw_mmc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bc3a1bc..7a5ce6a 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2488,13 +2488,19 @@ int dw_mci_resume(struct dw_mci *host)
 		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
 	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE);
 
+	/*
+	 * Invalidate the 'current_speed' value since CLKDIV has come up in
+	 * default state and our cache is incorrect; set to something we know
+	 * slot->clock won't be.
+	 */
+	host->current_speed = ~0;
+
 	for (i = 0; i < host->num_slots; i++) {
 		struct dw_mci_slot *slot = host->slot[i];
 		if (!slot)
 			continue;
 		if (slot->mmc->pm_flags & MMC_PM_KEEP_POWER) {
 			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
-			dw_mci_setup_bus(slot, true);
 		}
 
 		ret = mmc_resume_host(host->slot[i]->mmc);
-- 
1.8.3

