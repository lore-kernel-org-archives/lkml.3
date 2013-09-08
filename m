Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3IHIvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 04:51:32 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49813 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3IHIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 04:51:29 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/4] power: isp1704_charger: Add callback function set_current
Date: Sun,  8 Sep 2013 10:50:38 +0200
Message-Id: <1378630239-10006-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add callback function set_current to platform data.
Driver will call this function when isp1704 change current
and board provided this callback funtion in platform data.

This patch is needed for Nokia RX-51 to tell bq2415x charging
chip about connected wallcharger events.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/isp1704_charger.c       |   16 ++++++++++++++++
 include/linux/power/isp1704_charger.h |    1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index f726cb6..4f20a1a 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -91,6 +91,18 @@ static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 }
 
 /*
+ * Set charger current from isp1704 if a function for it
+ * has been provided with platform data.
+ */
+static void isp1704_charger_set_current(struct isp1704_charger *isp, int mA)
+{
+	struct isp1704_charger_data *board = isp->dev->platform_data;
+
+	if (board && board->set_current)
+		board->set_current(mA);
+}
+
+/*
  * Determine is the charging port DCP (dedicated charger) or CDP (Host/HUB
  * chargers).
  *
@@ -257,6 +269,7 @@ static void isp1704_charger_work(struct work_struct *data)
 			if (isp1704_charger_detect_dcp(isp)) {
 				isp->psy.type = POWER_SUPPLY_TYPE_USB_DCP;
 				isp->current_max = 1800;
+				isp1704_charger_set_current(isp, 1800);
 			} else {
 				isp->psy.type = POWER_SUPPLY_TYPE_USB;
 				isp->current_max = 500;
@@ -277,6 +290,8 @@ static void isp1704_charger_work(struct work_struct *data)
 
 			if (isp->current_max > 100)
 				isp->psy.type = POWER_SUPPLY_TYPE_USB_CDP;
+
+			isp1704_charger_set_current(isp, isp->current_max);
 		}
 		break;
 	case USB_EVENT_NONE:
@@ -297,6 +312,7 @@ static void isp1704_charger_work(struct work_struct *data)
 			usb_gadget_disconnect(isp->phy->otg->gadget);
 
 		isp1704_charger_set_power(isp, 0);
+		isp1704_charger_set_current(isp, 0);
 		break;
 	default:
 		goto out;
diff --git a/include/linux/power/isp1704_charger.h b/include/linux/power/isp1704_charger.h
index 68096a6..d154b02 100644
--- a/include/linux/power/isp1704_charger.h
+++ b/include/linux/power/isp1704_charger.h
@@ -24,6 +24,7 @@
 
 struct isp1704_charger_data {
 	void		(*set_power)(bool on);
+	void		(*set_current)(int mA);
 };
 
 #endif
-- 
1.7.10.4

