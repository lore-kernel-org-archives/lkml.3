Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3LCDp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:45:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45175 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3LCDoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 15/15] mfd: menelaus: Use devm_request_threaded_irq()
Date: Mon, 2 Dec 2013 21:43:08 -0600
Message-ID: <1386042188-12246-15-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by using devm_request_threaded_irq() we can
drop a few extra lines of code and rely on
device managed resources layer to free our
IRQ for us.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index bffe978..b87c2bd 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1271,8 +1271,8 @@ static int menelaus_probe(struct i2c_client *client,
 	/* Set output buffer strengths */
 	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
 
-	err = request_threaded_irq(client->irq, NULL, menelaus_irq,
-			IRQF_ONESHOT, DRIVER_NAME, m);
+	err = devm_request_threaded_irq(&client->dev, client->irq,
+			NULL, menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
 	if (err) {
 		dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 				client->irq, err);
@@ -1283,7 +1283,7 @@ static int menelaus_probe(struct i2c_client *client,
 
 	val = menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);
 	if (val < 0)
-		goto fail_free_irq;
+		goto fail_free_descs;
 	if (val & (1 << 7))
 		m->vcore_hw_mode = 1;
 	else
@@ -1292,14 +1292,12 @@ static int menelaus_probe(struct i2c_client *client,
 	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
 		err = menelaus_pdata->late_init(&client->dev);
 		if (err < 0)
-			goto fail_free_irq;
+			goto fail_free_descs;
 	}
 
 	menelaus_rtc_init(m);
 
 	return 0;
-fail_free_irq:
-	free_irq(client->irq, m);
 
 fail_free_descs:
 	irq_free_descs(irq_base, MENELAUS_NR_IRQS);
@@ -1311,7 +1309,6 @@ static int menelaus_remove(struct i2c_client *client)
 {
 	struct menelaus_chip	*m = i2c_get_clientdata(client);
 
-	free_irq(client->irq, m);
 	irq_free_descs(m->irq_base, MENELAUS_NR_IRQS);
 	the_menelaus = NULL;
 	return 0;
-- 
1.8.4.GIT

