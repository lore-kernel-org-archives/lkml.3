Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3AUMFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:05:09 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52422 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3AUMFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:05:01 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/24] ab8500-charger: Do not touch VBUSOVV bits
Date: Mon, 21 Jan 2013 12:03:57 +0000
Message-Id: <1358769840-4763-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Do not touch the VBUSOVV in USBCHTRL2 when running on AB8505.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Tested-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
---
 drivers/power/ab8500_charger.c    |   22 ++++++++++++++++------
 include/linux/mfd/abx500/ab8500.h |   19 +++++++++++++++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a632b94..871bf5a 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2671,13 +2671,23 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	/* VBUS OVV set to 6.3V and enable automatic current limitiation */
-	ret = abx500_set_register_interruptible(di->dev,
-		AB8500_CHARGER,
-		AB8500_USBCH_CTRL2_REG,
-		VBUS_OVV_SELECT_6P3V | VBUS_AUTO_IN_CURR_LIM_ENA);
+	if (is_ab9540_2p0(di->parent) || is_ab8505_2p0(di->parent))
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER,
+			AB8500_USBCH_CTRL2_REG,
+			VBUS_AUTO_IN_CURR_LIM_ENA,
+			VBUS_AUTO_IN_CURR_LIM_ENA);
+	else
+		/*
+		 * VBUS OVV set to 6.3V and enable automatic current limitation
+		 */
+		ret = abx500_set_register_interruptible(di->dev,
+			AB8500_CHARGER,
+			AB8500_USBCH_CTRL2_REG,
+			VBUS_OVV_SELECT_6P3V | VBUS_AUTO_IN_CURR_LIM_ENA);
 	if (ret) {
-		dev_err(di->dev, "failed to set VBUS OVV\n");
+		dev_err(di->dev,
+			"failed to set automatic current limitation\n");
 		goto out;
 	}
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 9dd9b99..b9a6a84 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -346,4 +346,23 @@ static inline int is_ab8500_2p0(struct ab8500 *ab)
 	return (is_ab8500(ab) && (ab->chip_id == AB8500_CUT2P0));
 }
 
+static inline int is_ab8505_1p0_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8505(ab) && (ab->chip_id <= AB8500_CUT1P0));
+}
+
+static inline int is_ab8505_2p0(struct ab8500 *ab)
+{
+	return (is_ab8505(ab) && (ab->chip_id == AB8500_CUT2P0));
+}
+
+static inline int is_ab9540_1p0_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab9540(ab) && (ab->chip_id <= AB8500_CUT1P0));
+}
+
+static inline int is_ab9540_2p0(struct ab8500 *ab)
+{
+	return (is_ab9540(ab) && (ab->chip_id == AB8500_CUT2P0));
+}
 #endif /* MFD_AB8500_H */
-- 
1.7.9.5

