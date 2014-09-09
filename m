Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaIIM1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:27:10 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59210 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIIM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:27:08 -0400
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: tgih.jun@samsung.com, ulf.hansson@linaro.org, chris@printf.net,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC cards
Date: Tue,  9 Sep 2014 14:26:54 +0200
Message-Id: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on a i.MX6 board, with Sandisk SDIN5D1-2G.
Without this patch, I/O errors occur.
This eMMC seems to have a different Manufacturer ID as it reads 0x45
and not 0x2 as specified in datasheet.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/mmc/core/mmc_ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index f51b5ba..91babaa 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -458,6 +458,15 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	if (!use_busy_signal)
 		return 0;
 
+	/* WORKAROUND: for Sandisk eMMC cards, it might need certain delay
+	 * before sending CMD13 after CMD6
+	 * On SDIN5D1-2G MANFID is 0x45 and not 0x2 as specified in datasheet
+	 */
+	if (card->cid.manfid == CID_MANFID_SANDISK ||
+		card->cid.manfid == 0x45) {
+		msleep(1);
+	}
+
 	/*
 	 * CRC errors shall only be ignored in cases were CMD13 is used to poll
 	 * to detect busy completion.
-- 
2.0.4

