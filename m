Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaD2BZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:25:46 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49786 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaD2BZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:25:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/2] staging: rtl8188eu: Use USB subsystem functions to check endpoint type
Date: Tue, 29 Apr 2014 06:55:13 +0530
Message-Id: <1398734713-4367-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398734713-4367-1-git-send-email-navin.patidar@gmail.com>
References: <1398734713-4367-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use inline functions provided by USB subsystem to check endpoint type,
instead of inline functions implemented by driver to do the same.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   57 +++++----------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 8a52829..8ed2ac8 100644
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
@@ -183,21 +143,24 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 
 	for (i = 0; i < pdvobjpriv->nr_endpoint; i++) {
+		int ep_num;
 		phost_endp = phost_iface->endpoint + i;
+
 		if (phost_endp) {
 			pendp_desc = &phost_endp->desc;
+			ep_num = usb_endpoint_num(pendp_desc);
 
-			if (RT_usb_endpoint_is_bulk_in(pendp_desc)) {
-				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
+			if (usb_endpoint_is_bulk_in(pendp_desc)) {
+				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = ep_num;
 				pdvobjpriv->RtNumInPipes++;
-			} else if (usb_endpoint_is_int(pendp_desc)) {
-				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
+			} else if (usb_endpoint_is_int_in(pendp_desc)) {
+				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = ep_num;
 				pdvobjpriv->RtNumInPipes++;
-			} else if (RT_usb_endpoint_is_bulk_out(pendp_desc)) {
-				pdvobjpriv->RtOutPipe[pdvobjpriv->RtNumOutPipes] = RT_usb_endpoint_num(pendp_desc);
+			} else if (usb_endpoint_is_bulk_out(pendp_desc)) {
+				pdvobjpriv->RtOutPipe[pdvobjpriv->RtNumOutPipes] = ep_num;
 				pdvobjpriv->RtNumOutPipes++;
 			}
-			pdvobjpriv->ep_num[i] = RT_usb_endpoint_num(pendp_desc);
+			pdvobjpriv->ep_num[i] = ep_num;
 		}
 	}
 
-- 
1.7.10.4

