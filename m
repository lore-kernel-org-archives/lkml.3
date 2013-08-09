Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968153Ab3HIQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:39:20 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:63683 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968111Ab3HIQjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:39:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/4] mmc: dw_mmc: Invalidate cache of current_speed after suspend/resume
Date: Fri,  9 Aug 2013 09:33:17 -0700
Message-Id: <1376066000-5495-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1376066000-5495-1-git-send-email-dianders@chromium.org>
References: <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1376066000-5495-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_mmc driver keeps a cache of the current slot->clock in order to
avoid doing a whole lot of work every time set_ios() is called.
However, after suspend/resume the register values are bogus so we need
to ensure that the cached value is invalidated.

Specifically I saw problems with the SD Card slot, which doesn't have
MMC_KEEP_POWER.  Problems showed up when no card was inserted across
suspend/resume.  In other words:

1. At boot time, slot is all setup and configured to 400kHz.
2. Suspend
3. Resume; clock registers are reset (by suspend/resume) and not
   restored since dw_mmc still thinks slot is configured for 400kHz
   due to host->current_speed cache.
4. Insert card.
5. No code sees any need to change the clock for detecting the card,
   since everyone thinks it's at 400kHz.  ...but it's not.

Invalidating the current_speed also means that we don't need to call:
  dw_mci_setup_bus(slot, true);
...to force an update of the clock in the case when the slot was left
powered.

Before this patch, many scenarios worked fine across suspend/resume
since the core mmc code ends up adjusting the clock quite a bit
during/suspend resume (and this ended up invalidating the cache for
us).

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes in v5:
- Remove force_clkinit as per Jaehoon
- Update commit message to (hopefully) be clearer

Changes in v4: None
Changes in v3: None
Changes in v2:
- Fix typo (some -> come)
- Use ~0 instead of 0xFFFFFFFF; add comment about value

 drivers/mmc/host/dw_mmc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ee5f167..e614b03 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -629,13 +629,13 @@ static void mci_send_cmd(struct dw_mci_slot *slot, u32 cmd, u32 arg)
 		cmd, arg, cmd_status);
 }
 
-static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
+static void dw_mci_setup_bus(struct dw_mci_slot *slot)
 {
 	struct dw_mci *host = slot->host;
 	u32 div;
 	u32 clk_en_a;
 
-	if (slot->clock != host->current_speed || force_clkinit) {
+	if (slot->clock != host->current_speed) {
 		div = host->bus_hz / slot->clock;
 		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
 			/*
@@ -819,7 +819,7 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		drv_data->set_ios(slot->host, ios);
 
 	/* Slot specific timing and width adjustment */
-	dw_mci_setup_bus(slot, false);
+	dw_mci_setup_bus(slot);
 
 	switch (ios->power_mode) {
 	case MMC_POWER_UP:
@@ -2511,13 +2511,19 @@ int dw_mci_resume(struct dw_mci *host)
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

