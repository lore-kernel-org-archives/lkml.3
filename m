Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707Ab3DCIvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:51:06 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33849 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3DCIrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:47:10 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 04/12] usb: phy: ab8500-usb: fix eye diagram for ab8500 v2.0
Date: Wed,  3 Apr 2013 10:45:05 +0200
Message-Id: <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>

AB8500 v2.0 has eye diagram issues when drawing more than 100mA from
VBUS.  Force charging current to 100mA in case of standard host.

Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 5b92a59..1fd0780 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -485,6 +485,18 @@ static void ab8500_usb_phy_disable_work(struct work_struct *work)
 		ab8500_usb_peri_phy_dis(ab);
 }
 
+static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab, unsigned mA)
+{
+	/* AB8500 V2 has eye diagram issues when drawing more than 100mA from
+	 * VBUS.  Set charging current to 100mA in case of standard host
+	 */
+	if (is_ab8500_2p0_or_earlier(ab->ab8500))
+		if (mA > 100)
+			mA = 100;
+
+	return mA;
+}
+
 static int ab8500_usb_set_power(struct usb_phy *phy, unsigned mA)
 {
 	struct ab8500_usb *ab;
@@ -494,6 +506,8 @@ static int ab8500_usb_set_power(struct usb_phy *phy, unsigned mA)
 
 	ab = phy_to_ab(phy);
 
+	mA = ab8500_eyediagram_workaroud(ab, mA);
+
 	ab->vbus_draw = mA;
 
 	if (mA)
-- 
1.8.1.3

