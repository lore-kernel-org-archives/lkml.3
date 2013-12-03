Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3LCDpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:45:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3LCDop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 14/15] mfd: menelaus: IRQ is a requirement
Date: Mon, 2 Dec 2013 21:43:07 -0600
Message-ID: <1386042188-12246-14-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this driver needs IRQ to work, if client->irq
isn't set properly, we won't work. Remove
check around request_threaded_irq().

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

