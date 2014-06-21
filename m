Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbaFUMvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:51:11 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64998 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934914AbaFUMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:51:07 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 6/7] staging: rtl8188eu: Remove continual_urb_error from struct dvobj_priv
Date: Sat, 21 Jun 2014 18:19:36 +0530
Message-Id: <1403354977-23644-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
References: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_inc_and_chk_continual_urb_error() was only user of continual_urb_error,
which has been removed.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h    |    2 --
 drivers/staging/rtl8188eu/include/usb_ops.h      |    8 --------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |    2 --
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    3 ---
 4 files changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 6750135..097fcc9 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -174,8 +174,6 @@ struct dvobj_priv {
 
 	struct usb_interface *pusbintf;
 	struct usb_device *pusbdev;
-
-	atomic_t continual_urb_error;
 };
 
 static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index eb934bf..ea23b459 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -34,14 +34,6 @@
 
 #include <usb_ops_linux.h>
 
-/*
-* Set the continual_urb_error of this @param dvobjprive to 0
-*/
-static inline void rtw_reset_continual_urb_error(struct dvobj_priv *dvobj)
-{
-	atomic_set(&dvobj->continual_urb_error, 0);
-}
-
 #define USB_HIGH_SPEED_BULK_SIZE	512
 #define USB_FULL_SPEED_BULK_SIZE	64
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index c4a4880..4af2c95 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -121,8 +121,6 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	if (!pdvobjpriv->usb_vendor_req_buf)
 		goto free_dvobj;
 
-	rtw_reset_continual_urb_error(pdvobjpriv);
-
 	usb_get_dev(pusbd);
 
 	status = _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 9f9bb06..ad7c48e 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -276,7 +276,6 @@ static int usbctrl_vendorreq(struct adapter *adapt, u8 request, u16 value, u16 i
 		status = usb_control_msg(udev, pipe, request, reqtype, value, index, pIo_buf, len, RTW_USB_CONTROL_MSG_TIMEOUT);
 
 		if (status == len) {   /*  Success this control transfer. */
-			rtw_reset_continual_urb_error(dvobjpriv);
 			if (requesttype == 0x01)
 				memcpy(pdata, pIo_buf,  len);
 		} else { /*  error cases */
@@ -408,8 +407,6 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 			usb_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 			DBG_88E("%s()-%d: RX Warning!\n", __func__, __LINE__);
 		} else {
-			rtw_reset_continual_urb_error(adapter_to_dvobj(adapt));
-
 			skb_put(precvbuf->pskb, purb->actual_length);
 			skb_queue_tail(&precvpriv->rx_skb_queue, precvbuf->pskb);
 
-- 
1.7.10.4

