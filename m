Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3CDDu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:50:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189Ab3CDDol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:41 -0500
Message-Id: <20130304033711.428402106@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 039/153] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 957f4aca5fa0db69635271bc4621cc0b65b2d590 upstream.

When the new_id entry in /sysfs is used for a foreign USB device, rtlwifi
BUGS with a NULL pointer dereference because the per-driver configuration
data is not available. The probe function has been restructured as
suggested by Ben Hutchings <bhutchings@solarflare.com>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    8 +++++++-
 drivers/net/wireless/rtlwifi/usb.c          |    5 +++--
 drivers/net/wireless/rtlwifi/usb.h          |    3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -372,9 +372,15 @@ static struct usb_device_id rtl8192c_usb
 
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
 
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -894,7 +894,8 @@ static struct rtl_intf_ops rtl_usb_ops =
 };
 
 int __devinit rtl_usb_probe(struct usb_interface *intf,
-			const struct usb_device_id *id)
+			    const struct usb_device_id *id,
+			    struct rtl_hal_cfg *rtl_hal_cfg)
 {
 	int err;
 	struct ieee80211_hw *hw = NULL;
@@ -928,7 +929,7 @@ int __devinit rtl_usb_probe(struct usb_i
 	usb_set_intfdata(intf, hw);
 	/* init cfg & intf_ops */
 	rtlpriv->rtlhal.interface = INTF_USB;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_info);
+	rtlpriv->cfg = rtl_hal_cfg;
 	rtlpriv->intf_ops = &rtl_usb_ops;
 	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -158,7 +158,8 @@ struct rtl_usb_priv {
 
 
 int __devinit rtl_usb_probe(struct usb_interface *intf,
-			    const struct usb_device_id *id);
+			    const struct usb_device_id *id,
+			    struct rtl_hal_cfg *rtl92cu_hal_cfg);
 void rtl_usb_disconnect(struct usb_interface *intf);
 int rtl_usb_suspend(struct usb_interface *pusb_intf, pm_message_t message);
 int rtl_usb_resume(struct usb_interface *pusb_intf);


