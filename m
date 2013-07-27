Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3G0UiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 16:38:08 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:52195 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3G0UiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 16:38:06 -0400
From: Samuel Williams <sam8641@gmail.com>
To: mlindner@marvell.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Williams <sam8641@gmail.com>
Subject: [PATCH] sky2: detect and prevent kernel panic from a possible faulty hardware
Date: Sat, 27 Jul 2013 15:35:54 -0500
Message-Id: <1374957354-10142-1-git-send-email-sam8641@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A possible faulty hardware might interrupt with a status of 0xffffffff which
may kernel panic if sky2 driver tries to handle it. Detecting this problem
may avoid kernel panic.

Signed-off-by: Samuel Williams <sam8641@gmail.com>
---
 drivers/net/ethernet/marvell/sky2.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e09a8c6..43fe2f3 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3049,8 +3049,17 @@ static int sky2_poll(struct napi_struct *napi, int work_limit)
 	int work_done = 0;
 	u16 idx;
 
-	if (unlikely(status & Y2_IS_ERROR))
+	if (unlikely(status & Y2_IS_ERROR)) {
+		if (status == 0xFFFFFFFF) {
+			dev_err(&hw->pdev->dev,
+				"fatal hardware inturrupt error\n");
+			napi_complete(napi);
+			napi_disable(&hw->napi);
+			return 0;
+		}
 		sky2_err_intr(hw, status);
+	}
+
 
 	if (status & Y2_IS_IRQ_PHY1)
 		sky2_phy_intr(hw, 0);
-- 
1.7.10.4

