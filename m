Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab3LIQ0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:26:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56414 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933912Ab3LIQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:22:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 14/15] mfd: menelaus: IRQ is a requirement
Date: Mon, 9 Dec 2013 10:21:24 -0600
Message-ID: <1386606085-26838-14-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386606085-26838-1-git-send-email-balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
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
index c0219b7..bffe978 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1271,14 +1271,12 @@ static int menelaus_probe(struct i2c_client *client,
 	/* Set output buffer strengths */
 	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
 
-	if (client->irq > 0) {
-		err = request_threaded_irq(client->irq, NULL, menelaus_irq,
-				IRQF_ONESHOT, DRIVER_NAME, m);
-		if (err) {
-			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
-					client->irq, err);
-			goto fail_free_descs;
-		}
+	err = request_threaded_irq(client->irq, NULL, menelaus_irq,
+			IRQF_ONESHOT, DRIVER_NAME, m);
+	if (err) {
+		dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
+				client->irq, err);
+		goto fail_free_descs;
 	}
 
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
-- 
1.8.4.GIT

