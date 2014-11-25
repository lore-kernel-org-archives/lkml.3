Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaKYKmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaKYKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sebastian Reichel <sre@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 154/254] power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle
Date: Tue, 25 Nov 2014 10:38:24 +0000
Message-Id: <1416912004-5928-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/power/bq2415x_charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index e384844a1ae1..260795c6901a 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1579,8 +1579,15 @@ static int bq2415x_probe(struct i2c_client *client,
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
-- 
2.1.0

