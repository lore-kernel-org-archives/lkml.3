Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770AbaKNW33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:29:29 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58494 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaKNW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:29:28 -0500
Date: Fri, 14 Nov 2014 14:29:25 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Clement Perrochaud <clement.perrochaud@nxp.com>,
        Arron Wang <arron.wang@intel.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: pn544: i2c: fix error handling of irq_of_parse_and_map
Message-ID: <20141114222925.GA334@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual code inspection.

 drivers/nfc/pn544/i2c.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 440291a..cfb3f0b 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -918,13 +918,12 @@ static int pn544_hci_i2c_of_request_resources(struct i2c_client *client)
 	}
 
 	/* IRQ */
-	ret = irq_of_parse_and_map(pp, 0);
-	if (ret < 0) {
-		nfc_err(&client->dev,
-			"Unable to get irq, error: %d\n", ret);
+	client->irq = irq_of_parse_and_map(pp, 0);
+	if (!client->irq) {
+		nfc_err(&client->dev, "Unable to get irq\n");
+		ret = -EINVAL;
 		goto err_gpio_fw;
 	}
-	client->irq = ret;
 
 	return 0;
 
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
