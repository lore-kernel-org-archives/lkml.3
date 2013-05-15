Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3EOMEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:38 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44566 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3EOMEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:36 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 04/10] usb: phy: ab8500-usb: restart phy during probe
Date: Wed, 15 May 2013 14:03:27 +0200
Message-Id: <1368619413-24647-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>

Add an ab8500_usb_restart_phy() function called during probe to ensure
that the AB8500 USB phy is initialized properly even when a cable is
connected at probe time.

Without this fix subsequent host reconnections are not detected
properly.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index cc0d7e5..bbe51cc 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -668,6 +668,33 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static void ab8500_usb_restart_phy(struct ab8500_usb *ab)
+{
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			AB8500_BIT_PHY_CTRL_DEVICE_EN,
+			AB8500_BIT_PHY_CTRL_DEVICE_EN);
+
+	udelay(100);
+
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			AB8500_BIT_PHY_CTRL_DEVICE_EN,
+			0);
+
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			AB8500_BIT_PHY_CTRL_HOST_EN,
+			AB8500_BIT_PHY_CTRL_HOST_EN);
+
+	udelay(100);
+
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			AB8500_BIT_PHY_CTRL_HOST_EN,
+			0);
+}
+
 static int ab8500_usb_regulator_get(struct ab8500_usb *ab)
 {
 	int err;
@@ -887,6 +914,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
 
+	/*
+	 * This is required for usb-link-status to work properly when a
+	 * cable is connected at boot time.
+	 */
+	ab8500_usb_restart_phy(ab);
+
 	abx500_usb_link_status_update(ab);
 
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
-- 
1.8.2

