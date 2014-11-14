Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbaKNWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:32:29 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34490 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbaKNWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:32:27 -0500
Date: Fri, 14 Nov 2014 14:32:24 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: st21nfca: fix error handling of irq_of_parse_and_map
Message-ID: <20141114223224.GA1448@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Also report error returned by devm_gpio_request_one instead of
clobbering it with -ENODEV.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/nfc/st21nfca/i2c.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 0ea756b..6d6d282 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -531,20 +531,19 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 				  "clf_enable");
 	if (r) {
 		nfc_err(&client->dev, "Failed to request enable pin\n");
-		return -ENODEV;
+		return r;
 	}
 
 	phy->gpio_ena = gpio;
 
 	/* IRQ */
-	r = irq_of_parse_and_map(pp, 0);
-	if (r < 0) {
-		nfc_err(&client->dev, "Unable to get irq, error: %d\n", r);
-		return r;
+	client->irq = irq_of_parse_and_map(pp, 0);
+	if (!client->irq) {
+		nfc_err(&client->dev, "Unable to get irq\n");
+		return -EINVAL;
 	}
 
 	phy->irq_polarity = irq_get_trigger_type(r);
-	client->irq = r;
 
 	return 0;
 }
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
