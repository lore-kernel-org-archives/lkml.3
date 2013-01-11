Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3AKNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:26 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33468 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AKNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Robert Marklund <robert.marklund@stericsson.com>
Subject: [PATCH 01/18] power: ab8500_charger: Rename the power_loss function
Date: Fri, 11 Jan 2013 13:12:49 +0000
Message-Id: <1357909986-9262-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>

Rename the ab8500_power_loss_handling function to a more
descriptive name ab8500_enable_disable_sw_fallback

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
Reviewed-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
Tested-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
---
 drivers/power/ab8500_charger.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 2ddface..d6e1792 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -270,20 +270,19 @@ static enum power_supply_property ab8500_charger_usb_props[] = {
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 };
 
-/**
- * ab8500_power_loss_handling - set how we handle powerloss.
- * @di:		pointer to the ab8500_charger structure
- *
- * Magic nummbers are from STE HW department.
+/*
+ * Function for enabling and disabling sw fallback mode
+ * should always be disabled when no charger is connected.
  */
-static void ab8500_power_loss_handling(struct ab8500_charger *di)
+static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
+		bool fallback)
 {
 	u8 reg;
 	int ret;
 
-	dev_dbg(di->dev, "Autopower : %d\n", di->autopower);
+	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
-	/* read the autopower register */
+	/* read the register containing fallback bit */
 	ret = abx500_get_register_interruptible(di->dev, 0x15, 0x00, &reg);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
@@ -297,12 +296,12 @@ static void ab8500_power_loss_handling(struct ab8500_charger *di)
 		return;
 	}
 
-	if (di->autopower)
+	if (fallback)
 		reg |= 0x8;
 	else
 		reg &= ~0x8;
 
-	/* write back the changed value to autopower reg */
+	/* write back the changed fallback bit value to register */
 	ret = abx500_set_register_interruptible(di->dev, 0x15, 0x00, reg);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
@@ -332,12 +331,12 @@ static void ab8500_power_supply_changed(struct ab8500_charger *di,
 		    !di->ac.charger_connected &&
 		    di->autopower) {
 			di->autopower = false;
-			ab8500_power_loss_handling(di);
+			ab8500_enable_disable_sw_fallback(di, false);
 		} else if (!di->autopower &&
 			   (di->ac.charger_connected ||
 			    di->usb.charger_connected)) {
 			di->autopower = true;
-			ab8500_power_loss_handling(di);
+			ab8500_enable_disable_sw_fallback(di, true);
 		}
 	}
 	power_supply_changed(psy);
-- 
1.7.9.5

