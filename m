Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3EAO1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:27:00 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52283 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3EAO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:26:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, per.forlin@stericsson.com, rabin@rab.in
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] dmaengine: ste_dma40: Rectify incorrect configuration validation checking
Date: Wed,  1 May 2013 15:26:38 +0100
Message-Id: <1367418399-30591-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we compare an event's group (dev_type / 16) with STEDMA40_DEV_DST_MEMORY
(-1), the only way we'd obtain a positive result is if we passed -16 as a
device type, which is unfeasible. Instead, it would be much more sane to
compare STEDMA40_DEV_DST_MEMORY against the raw dev_type in order to expect
the expected result.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3b83dee..c79853f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1771,19 +1771,19 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	}
 
 	if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
-	    dst_event_group == STEDMA40_DEV_DST_MEMORY) {
+	    conf->dst_dev_type == STEDMA40_DEV_DST_MEMORY) {
 		chan_err(d40c, "Invalid dst\n");
 		res = -EINVAL;
 	}
 
 	if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
-	    src_event_group == STEDMA40_DEV_SRC_MEMORY) {
+	    conf->src_dev_type == STEDMA40_DEV_SRC_MEMORY) {
 		chan_err(d40c, "Invalid src\n");
 		res = -EINVAL;
 	}
 
-	if (src_event_group == STEDMA40_DEV_SRC_MEMORY &&
-	    dst_event_group == STEDMA40_DEV_DST_MEMORY && is_log) {
+	if (conf->src_dev_type == STEDMA40_DEV_SRC_MEMORY &&
+	    conf->dst_dev_type == STEDMA40_DEV_DST_MEMORY && is_log) {
 		chan_err(d40c, "No event line\n");
 		res = -EINVAL;
 	}
-- 
1.7.10.4

