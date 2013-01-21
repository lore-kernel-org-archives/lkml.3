Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3AUKKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3AUKKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:42 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 31/33] w1: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:24 +0100
Message-Id: <1358762966-20791-32-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:Z+EWecp5se57R/On/tOjP0YjUh6rB0/imQl3jxJPkc4
 F/y2q7+67CFcXn3yB0JJZ3rzsbw53bbVHa4pebOmtWcm8oRRmZ
 XbAtAMFqMU7zZswJgjNRa8Wpz3seVXSp8Yz1lsyAZyYCmmeAmM
 MB2s1KmgKAffMTkMNQjwkEmzaZWXXt1KLLY4B6yX8Aw/cslumM
 cmwEkjRK0ACCvkHe1sqAIZ9OJ2rpngR3gq4nHlHtbGts1AJtWY
 4dH6Dk/c6Q47hHk3uRbdmzjiiP2YTe5KaKC4vQQMlbxHYyqzSP
 eQstuk2v7yYXmbDFBSbdIt3rkGEeD647U2ugdBqO1Qr3wkmVsX
 lL/86BLy/EnHfvR1OO/6V5e222aI2fKlFAa/AF2BwIA18M1JDx
 7GLrsPtH2gVzw0q/OumyPp/31Q4zJjoLe24/Ogc3Ctd1HLG7j0
 6ZQXj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/omap_hdq.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 184dbce..db2390a 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -560,11 +560,9 @@ static int omap_hdq_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	hdq_data->hdq_base = devm_request_and_ioremap(dev, res);
-	if (!hdq_data->hdq_base) {
-		dev_dbg(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
+	hdq_data->hdq_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hdq_data->hdq_base))
+		return PTR_ERR(hdq_data->hdq_base);
 
 	hdq_data->hdq_usecount = 0;
 	mutex_init(&hdq_data->hdq_mutex);
-- 
1.8.1.1

