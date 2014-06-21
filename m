Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912AbaFUMuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:50:54 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45542 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbaFUMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:50:51 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/7] staging: rtl8188eu: Remove inline function rtw_inc_and_chk_continual_urb_error()
Date: Sat, 21 Jun 2014 18:19:35 +0530
Message-Id: <1403354977-23644-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
References: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_inc_and_chk_continual_urb_error() is used to check if device is
removed unexpectedly, to do that we can just check status of urb in
usb_read_port_complete() and usbctrl_vendorreq() doed that by checking
return value of usb_control_msg().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_ops.h      |   19 -------------------
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |   10 +---------
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index 79d206e..eb934bf 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -35,25 +35,6 @@
 #include <usb_ops_linux.h>
 
 /*
- * Increase and check if the continual_urb_error of this @param dvobjprivei
- * is larger than MAX_CONTINUAL_URB_ERR
- * @return true:
- * @return false:
- */
-static inline int rtw_inc_and_chk_continual_urb_error(struct dvobj_priv *dvobj)
-{
-	int ret = false;
-	int value;
-	value = atomic_inc_return(&dvobj->continual_urb_error);
-	if (value > MAX_CONTINUAL_URB_ERR) {
-		DBG_88E("[dvobj:%p][ERROR] continual_urb_error:%d > %d\n",
-			dvobj, value, MAX_CONTINUAL_URB_ERR);
-		ret = true;
-	}
-	return ret;
-}
-
-/*
 * Set the continual_urb_error of this @param dvobjprive to 0
 */
 static inline void rtw_reset_continual_urb_error(struct dvobj_priv *dvobj)
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 363f7f5..9f9bb06 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -300,11 +300,6 @@ static int usbctrl_vendorreq(struct adapter *adapt, u8 request, u16 value, u16 i
 				}
 			}
 
-			if (rtw_inc_and_chk_continual_urb_error(dvobjpriv)) {
-				adapt->bSurpriseRemoved = true;
-				break;
-			}
-
 		}
 
 		/*  firmware download is checksumed, don't retry */
@@ -432,15 +427,12 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 		skb_put(precvbuf->pskb, purb->actual_length);
 		precvbuf->pskb = NULL;
 
-		if (rtw_inc_and_chk_continual_urb_error(adapter_to_dvobj(adapt)))
-			adapt->bSurpriseRemoved = true;
-
 		switch (purb->status) {
 		case -EINVAL:
 		case -EPIPE:
 		case -ENODEV:
 		case -ESHUTDOWN:
-			RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("usb_read_port_complete:bSurpriseRemoved=true\n"));
+			adapt->bSurpriseRemoved = true;
 		case -ENOENT:
 			adapt->bDriverStopped = true;
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("usb_read_port_complete:bDriverStopped=true\n"));
-- 
1.7.10.4

