Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab3ECOdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61634 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3ECOdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/63] dmaengine: ste_dma40: Rectify incorrect configuration validation checking
Date: Fri,  3 May 2013 15:31:55 +0100
Message-Id: <1367591569-32197-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
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

