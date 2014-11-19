Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbaKSVwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:52:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510AbaKSVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 3.14 062/122] power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle
Date: Wed, 19 Nov 2014 12:51:52 -0800
Message-Id: <20141119205210.860073560@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 0eaf437aa14949d2230aeab7364f4ab47901304a upstream.

The power_supply_get_by_phandle() on error returns ENODEV or NULL.
The driver later expects obtained pointer to power supply to be
valid or NULL. If it is not NULL then it dereferences it in
bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
pointer.

Properly handle the power_supply_get_by_phandle() error case by
replacing error value with NULL. This indicates that usb charger
detection won't be used.

Fix also memory leak of 'name' if power_supply_get_by_phandle() fails
with NULL and probe should defer.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
[small fix regarding the missing ti,usb-charger-detection info message]
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq2415x_charger.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1579,8 +1579,15 @@ static int bq2415x_probe(struct i2c_clie
 	if (np) {
 		bq->notify_psy = power_supply_get_by_phandle(np, "ti,usb-charger-detection");
 
-		if (!bq->notify_psy)
-			return -EPROBE_DEFER;
+		if (IS_ERR(bq->notify_psy)) {
+			dev_info(&client->dev,
+				"no 'ti,usb-charger-detection' property (err=%ld)\n",
+				PTR_ERR(bq->notify_psy));
+			bq->notify_psy = NULL;
+		} else if (!bq->notify_psy) {
+			ret = -EPROBE_DEFER;
+			goto error_2;
+		}
 	}
 	else if (pdata->notify_device)
 		bq->notify_psy = power_supply_get_by_name(pdata->notify_device);


