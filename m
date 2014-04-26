Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaDZQod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:44:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41781 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaDZQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:44:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH] staging: rtl8188eu: Use USB subsystem functions to check endpoint type
Date: Sat, 26 Apr 2014 22:13:55 +0530
Message-Id: <1398530635-3813-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use inline functions provided by USB subsystem to check endpoint type,
instead of macros implemented by driver to do the same.

Unnecessary debugging messages are also removed.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   92 ++++-----------------------
 1 file changed, 14 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 49a4ce4..2960602 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -80,46 +80,6 @@ static struct rtw_usb_drv rtl8188e_usb_drv = {
 
 static struct rtw_usb_drv *usb_drv = &rtl8188e_usb_drv;
 
-static inline int RT_usb_endpoint_dir_in(const struct usb_endpoint_descriptor *epd)
-{
-	return (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN;
-}
-
-static inline int RT_usb_endpoint_dir_out(const struct usb_endpoint_descriptor *epd)
-{
-	return (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT;
-}
-
-static inline int RT_usb_endpoint_xfer_int(const struct usb_endpoint_descriptor *epd)
-{
-	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT;
-}
-
-static inline int RT_usb_endpoint_xfer_bulk(const struct usb_endpoint_descriptor *epd)
-{
-	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK;
-}
-
-static inline int RT_usb_endpoint_is_bulk_in(const struct usb_endpoint_descriptor *epd)
-{
-	return RT_usb_endpoint_xfer_bulk(epd) && RT_usb_endpoint_dir_in(epd);
-}
-
-static inline int RT_usb_endpoint_is_bulk_out(const struct usb_endpoint_descriptor *epd)
-{
-	return RT_usb_endpoint_xfer_bulk(epd) && RT_usb_endpoint_dir_out(epd);
-}
-
-static inline int usb_endpoint_is_int(const struct usb_endpoint_descriptor *epd)
-{
-	return RT_usb_endpoint_xfer_int(epd) && RT_usb_endpoint_dir_in(epd);
-}
-
-static inline int RT_usb_endpoint_num(const struct usb_endpoint_descriptor *epd)
-{
-	return epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-}
-
 static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 {
 	u8 rst = _SUCCESS;
@@ -183,60 +143,36 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 
 	for (i = 0; i < pdvobjpriv->nr_endpoint; i++) {
+
+		int ep_num;
 		phost_endp = phost_iface->endpoint + i;
+
 		if (phost_endp) {
 			pendp_desc = &phost_endp->desc;
+			ep_num = usb_endpoint_num(pendp_desc);
 
-			DBG_88E("\nusb_endpoint_descriptor(%d):\n", i);
-			DBG_88E("bLength=%x\n", pendp_desc->bLength);
-			DBG_88E("bDescriptorType=%x\n",
-				pendp_desc->bDescriptorType);
-			DBG_88E("bEndpointAddress=%x\n",
-				pendp_desc->bEndpointAddress);
-			DBG_88E("wMaxPacketSize=%d\n",
-				le16_to_cpu(pendp_desc->wMaxPacketSize));
-			DBG_88E("bInterval=%x\n", pendp_desc->bInterval);
-
-			if (RT_usb_endpoint_is_bulk_in(pendp_desc)) {
-				DBG_88E("RT_usb_endpoint_is_bulk_in = %x\n",
-					RT_usb_endpoint_num(pendp_desc));
-				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
+			if (usb_endpoint_is_bulk_in(pendp_desc)) {
+				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = ep_num;
 				pdvobjpriv->RtNumInPipes++;
-			} else if (usb_endpoint_is_int(pendp_desc)) {
-				DBG_88E("usb_endpoint_is_int = %x, Interval = %x\n",
-					RT_usb_endpoint_num(pendp_desc),
-					pendp_desc->bInterval);
-				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
+			} else if (usb_endpoint_is_int_in(pendp_desc)) {
+				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = ep_num;
 				pdvobjpriv->RtNumInPipes++;
-			} else if (RT_usb_endpoint_is_bulk_out(pendp_desc)) {
-				DBG_88E("RT_usb_endpoint_is_bulk_out = %x\n",
-					RT_usb_endpoint_num(pendp_desc));
-				pdvobjpriv->RtOutPipe[pdvobjpriv->RtNumOutPipes] = RT_usb_endpoint_num(pendp_desc);
+			} else if (usb_endpoint_is_bulk_out(pendp_desc)) {
+				pdvobjpriv->RtOutPipe[pdvobjpriv->RtNumOutPipes] = ep_num;
 				pdvobjpriv->RtNumOutPipes++;
 			}
-			pdvobjpriv->ep_num[i] = RT_usb_endpoint_num(pendp_desc);
+			pdvobjpriv->ep_num[i] = ep_num;
 		}
 	}
 
-	DBG_88E("nr_endpoint=%d, in_num=%d, out_num=%d\n\n",
-		pdvobjpriv->nr_endpoint, pdvobjpriv->RtNumInPipes,
-		pdvobjpriv->RtNumOutPipes);
-
-	if (pusbd->speed == USB_SPEED_HIGH) {
+	if (pusbd->speed == USB_SPEED_HIGH)
 		pdvobjpriv->ishighspeed = true;
-		DBG_88E("USB_SPEED_HIGH\n");
-	} else {
+	else
 		pdvobjpriv->ishighspeed = false;
-		DBG_88E("NON USB_SPEED_HIGH\n");
-	}
 
-	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL) {
-		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't INIT rtw_init_intf_priv\n"));
+	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL)
 		goto free_dvobj;
-	}
 
-	/* 3 misc */
 	sema_init(&(pdvobjpriv->usb_suspend_sema), 0);
 	rtw_reset_continual_urb_error(pdvobjpriv);
 
-- 
1.7.9.5

