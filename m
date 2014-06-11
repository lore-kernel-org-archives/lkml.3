Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaFKRYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:14 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47818 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaFKRYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:09 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/22] staging: rtl8188eu: Remove functions initialize rtw_[read,write] wrapper
Date: Wed, 11 Jun 2014 22:51:37 +0530
Message-Id: <1402507301-3722-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have removed all rtw_[read,write]() function calls,
so no need to initialize structures used to build rtw_[read,write]
abstraction.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c       |   16 ----------------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    4 ----
 drivers/staging/rtl8188eu/include/rtw_io.h    |    4 ----
 drivers/staging/rtl8188eu/include/usb_ops.h   |    2 --
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |    3 ---
 5 files changed, 29 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 25b0a87..dd56896 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -51,19 +51,3 @@ jackson@realtek.com.tw
 #define rtw_cpu_to_le16(val)		cpu_to_le16(val)
 #define rtw_cpu_to_le32(val)		cpu_to_le32(val)
 
-int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
-{
-	struct io_priv	*piopriv = &padapter->iopriv;
-	struct intf_hdl *pintf = &piopriv->intf;
-
-	if (set_intf_ops == NULL)
-		return _FAIL;
-
-	piopriv->padapter = padapter;
-	pintf->padapter = padapter;
-	pintf->pintf_dev = adapter_to_dvobj(padapter);
-
-	set_intf_ops(&pintf->io_ops);
-
-	return _SUCCESS;
-}
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d0c82dc..1002ff0 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -663,7 +663,3 @@ void rtl8188eu_xmit_tasklet(void *priv)
 	}
 }
 
-void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
-{
-	_rtw_memset((u8 *)pops, 0, sizeof(struct _io_ops));
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index ef865da..86431b8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -89,8 +89,4 @@ int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_write_port_cancel(struct adapter *adapter);
 
-
-int rtw_init_io_priv(struct adapter *padapter,
-		     void (*set_intf_ops)(struct _io_ops *pops));
-
 #endif	/* _RTL8711_IO_H_ */
diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index a290e0f..ff730f4 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -63,8 +63,6 @@ enum{
 #include <usb_ops_linux.h>
 
 void rtl8188eu_set_hw_type(struct adapter *padapter);
-void rtl8188eu_set_intf_ops(struct _io_ops *pops);
-#define usb_set_intf_ops rtl8188eu_set_intf_ops
 
 /*
  * Increase and check if the continual_urb_error of this @param dvobjprivei
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 491d8e5..c4a4880 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -396,9 +396,6 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	padapter->intf_start = &usb_intf_start;
 	padapter->intf_stop = &usb_intf_stop;
 
-	/* step init_io_priv */
-	rtw_init_io_priv(padapter, usb_set_intf_ops);
-
 	/* step read_chip_version */
 	rtw_hal_read_chip_version(padapter);
 
-- 
1.7.10.4

