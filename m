Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3LQAJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:09:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40993 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3LQAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:09:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/10] mfd: menelaus: IRQ is a requirement
Date: Mon, 16 Dec 2013 18:08:24 -0600
Message-ID: <1387238904-7843-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1387238904-7843-1-git-send-email-balbi@ti.com>
References: <20131216153936.GQ18769@lee--X1>
 <1387238904-7843-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver needs IRQ to work, if client->irq isn't set properly, we
won't work. Remove check around request_threaded_irq().

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 5d106e4..b01588e 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1271,14 +1271,12 @@ static int menelaus_probe(struct i2c_client *client,
 	/* Set output buffer strengths */
 	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
 
-	if (client->irq > 0) {
-		err = devm_request_threaded_irq(&client->dev, client->irq, NULL,
-				menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
-		if (err) {
-			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
-					client->irq, err);
-			goto fail;
-		}
+	err = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+			menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
+	if (err) {
+		dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
+				client->irq, err);
+		goto fail;
 	}
 
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
-- 
1.8.4.GIT

