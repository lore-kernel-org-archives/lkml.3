Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab3B1PQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:16:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab3B1OrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 035/139] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
Date: Thu, 28 Feb 2013 14:43:05 +0000
Message-Id: <1362062689-2567-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 957f4aca5fa0db69635271bc4621cc0b65b2d590 upstream.

When the new_id entry in /sysfs is used for a foreign USB device, rtlwifi
BUGS with a NULL pointer dereference because the per-driver configuration
data is not available. The probe function has been restructured as
suggested by Ben Hutchings <bhutchings@solarflare.com>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 8 +++++++-
 drivers/net/wireless/rtlwifi/usb.c          | 5 +++--
 drivers/net/wireless/rtlwifi/usb.h          | 3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index b7e6607..6f4f9aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -363,9 +363,15 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 
 MODULE_DEVICE_TABLE(usb, rtl8192c_usb_ids);
 
+static int rtl8192cu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtl_usb_probe(intf, id, &rtl92cu_hal_cfg);
+}
+
 static struct usb_driver rtl8192cu_driver = {
 	.name = "rtl8192cu",
-	.probe = rtl_usb_probe,
+	.probe = rtl8192cu_probe,
 	.disconnect = rtl_usb_disconnect,
 	.id_table = rtl8192c_usb_ids,
 
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 17cd028..c03a018 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -935,7 +935,8 @@ static struct rtl_intf_ops rtl_usb_ops = {
 };
 
 int __devinit rtl_usb_probe(struct usb_interface *intf,
-			const struct usb_device_id *id)
+			    const struct usb_device_id *id,
+			    struct rtl_hal_cfg *rtl_hal_cfg)
 {
 	int err;
 	struct ieee80211_hw *hw = NULL;
@@ -970,7 +971,7 @@ int __devinit rtl_usb_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, hw);
 	/* init cfg & intf_ops */
 	rtlpriv->rtlhal.interface = INTF_USB;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_info);
+	rtlpriv->cfg = rtl_hal_cfg;
 	rtlpriv->intf_ops = &rtl_usb_ops;
 	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/rtlwifi/usb.h
index 43846b3..b1a9cb2 100644
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -157,7 +157,8 @@ struct rtl_usb_priv {
 
 
 int __devinit rtl_usb_probe(struct usb_interface *intf,
-			    const struct usb_device_id *id);
+			    const struct usb_device_id *id,
+			    struct rtl_hal_cfg *rtl92cu_hal_cfg);
 void rtl_usb_disconnect(struct usb_interface *intf);
 int rtl_usb_suspend(struct usb_interface *pusb_intf, pm_message_t message);
 int rtl_usb_resume(struct usb_interface *pusb_intf);
-- 
1.8.1.2

