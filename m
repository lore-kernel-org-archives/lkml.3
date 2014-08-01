Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaHAKDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:03:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42506 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbaHAKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:03:50 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] dma: at_hdmac: fix invalid remaining bytes detection
Date: Fri,  1 Aug 2014 12:03:26 +0200
Message-Id: <1406887406-10567-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch:
drivers/dma/at_hdmac.c:299 atc_get_bytes_left() warn: unsigned
'atchan->remain_desc' is never less than zero.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/dma/at_hdmac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c13a3bb0f594..9ec84ee2fa25 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -294,14 +294,16 @@ static int atc_get_bytes_left(struct dma_chan *chan)
 			ret = -EINVAL;
 			goto out;
 		}
-		atchan->remain_desc -= (desc_cur->lli.ctrla & ATC_BTSIZE_MAX)
-						<< (desc_first->tx_width);
-		if (atchan->remain_desc < 0) {
+
+		count = (desc_cur->lli.ctrla & ATC_BTSIZE_MAX)
+			<< (desc_first->tx_width);
+		if (atchan->remain_desc < count) {
 			ret = -EINVAL;
 			goto out;
-		} else {
-			ret = atchan->remain_desc;
 		}
+
+		atchan->remain_desc -= count;
+		ret = atchan->remain_desc;
 	} else {
 		/*
 		 * Get residual bytes when current
-- 
1.9.1

