Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3CZWn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3CZWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geir Haatveit <nospam@haatveit.nu>,
        Greg Suarez <gsuarez@smithmicro.com>,
        Alexey Orishko <alexey.orishko@stericsson.com>,
        Tommi Kyntola <kynde@ts.ray.fi>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 17/98] net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility
Date: Tue, 26 Mar 2013 15:42:06 -0700
Message-Id: <20130326224244.271246407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 1e8bbe6cd02fc300c88bd48244ce61ad9c7d1776 ]

commit bd329e1 ("net: cdc_ncm: do not bind to NCM compatible MBIM devices")
introduced a new policy, preferring MBIM for dual NCM/MBIM functions if
the cdc_mbim driver was enabled.  This caused a regression for users
wanting to use NCM.

Devices implementing NCM backwards compatibility according to section
3.2 of the MBIM v1.0 specification allow either NCM or MBIM on a single
USB function, using different altsettings.  The cdc_ncm and cdc_mbim
drivers will both probe such functions, and must agree on a common
policy for selecting either MBIM or NCM.  Until now, this policy has
been set at build time based on CONFIG_USB_NET_CDC_MBIM.

Use a module parameter to set the system policy at runtime, allowing the
user to prefer NCM on systems with the cdc_mbim driver.

Reported-by: Geir Haatveit <nospam@haatveit.nu>
Cc: Greg Suarez <gsuarez@smithmicro.com>
Cc: Alexey Orishko <alexey.orishko@stericsson.com>
Reported-by: Tommi Kyntola <kynde@ts.ray.fi>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=54791
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_mbim.c  |   11 ---------
 drivers/net/usb/cdc_ncm.c   |   49 ++++++++++++++++++++++++++++----------------
 include/linux/usb/cdc_ncm.h |    1 
 3 files changed, 34 insertions(+), 27 deletions(-)

--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -68,18 +68,9 @@ static int cdc_mbim_bind(struct usbnet *
 	struct cdc_ncm_ctx *ctx;
 	struct usb_driver *subdriver = ERR_PTR(-ENODEV);
 	int ret = -ENODEV;
-	u8 data_altsetting = CDC_NCM_DATA_ALTSETTING_NCM;
+	u8 data_altsetting = cdc_ncm_select_altsetting(dev, intf);
 	struct cdc_mbim_state *info = (void *)&dev->data;
 
-	/* see if interface supports MBIM alternate setting */
-	if (intf->num_altsetting == 2) {
-		if (!cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
-			usb_set_interface(dev->udev,
-					  intf->cur_altsetting->desc.bInterfaceNumber,
-					  CDC_NCM_COMM_ALTSETTING_MBIM);
-		data_altsetting = CDC_NCM_DATA_ALTSETTING_MBIM;
-	}
-
 	/* Probably NCM, defer for cdc_ncm_bind */
 	if (!cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
 		goto err;
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -55,6 +55,14 @@
 
 #define	DRIVER_VERSION				"14-Mar-2012"
 
+#if IS_ENABLED(CONFIG_USB_NET_CDC_MBIM)
+static bool prefer_mbim = true;
+#else
+static bool prefer_mbim;
+#endif
+module_param(prefer_mbim, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(prefer_mbim, "Prefer MBIM setting on dual NCM/MBIM functions");
+
 static void cdc_ncm_txpath_bh(unsigned long param);
 static void cdc_ncm_tx_timeout_start(struct cdc_ncm_ctx *ctx);
 static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *hr_timer);
@@ -550,9 +558,12 @@ void cdc_ncm_unbind(struct usbnet *dev,
 }
 EXPORT_SYMBOL_GPL(cdc_ncm_unbind);
 
-static int cdc_ncm_bind(struct usbnet *dev, struct usb_interface *intf)
+/* Select the MBIM altsetting iff it is preferred and available,
+ * returning the number of the corresponding data interface altsetting
+ */
+u8 cdc_ncm_select_altsetting(struct usbnet *dev, struct usb_interface *intf)
 {
-	int ret;
+	struct usb_host_interface *alt;
 
 	/* The MBIM spec defines a NCM compatible default altsetting,
 	 * which we may have matched:
@@ -568,23 +579,27 @@ static int cdc_ncm_bind(struct usbnet *d
 	 *   endpoint descriptors, shall be constructed according to
 	 *   the rules given in section 6 (USB Device Model) of this
 	 *   specification."
-	 *
-	 * Do not bind to such interfaces, allowing cdc_mbim to handle
-	 * them
 	 */
-#if IS_ENABLED(CONFIG_USB_NET_CDC_MBIM)
-	if ((intf->num_altsetting == 2) &&
-	    !usb_set_interface(dev->udev,
-			       intf->cur_altsetting->desc.bInterfaceNumber,
-			       CDC_NCM_COMM_ALTSETTING_MBIM)) {
-		if (cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
-			return -ENODEV;
-		else
-			usb_set_interface(dev->udev,
-					  intf->cur_altsetting->desc.bInterfaceNumber,
-					  CDC_NCM_COMM_ALTSETTING_NCM);
+	if (prefer_mbim && intf->num_altsetting == 2) {
+		alt = usb_altnum_to_altsetting(intf, CDC_NCM_COMM_ALTSETTING_MBIM);
+		if (alt && cdc_ncm_comm_intf_is_mbim(alt) &&
+		    !usb_set_interface(dev->udev,
+				       intf->cur_altsetting->desc.bInterfaceNumber,
+				       CDC_NCM_COMM_ALTSETTING_MBIM))
+			return CDC_NCM_DATA_ALTSETTING_MBIM;
 	}
-#endif
+	return CDC_NCM_DATA_ALTSETTING_NCM;
+}
+EXPORT_SYMBOL_GPL(cdc_ncm_select_altsetting);
+
+static int cdc_ncm_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int ret;
+
+	/* MBIM backwards compatible function? */
+	cdc_ncm_select_altsetting(dev, intf);
+	if (cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
+		return -ENODEV;
 
 	/* NCM data altsetting is always 1 */
 	ret = cdc_ncm_bind_common(dev, intf, 1);
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -127,6 +127,7 @@ struct cdc_ncm_ctx {
 	u16 connected;
 };
 
+extern u8 cdc_ncm_select_altsetting(struct usbnet *dev, struct usb_interface *intf);
 extern int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_altsetting);
 extern void cdc_ncm_unbind(struct usbnet *dev, struct usb_interface *intf);
 extern struct sk_buff *cdc_ncm_fill_tx_frame(struct cdc_ncm_ctx *ctx, struct sk_buff *skb, __le32 sign);


