Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbaFKRXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:20 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37394 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaFKRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:16 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/22] staging: rtl8188eu: Remove function _rtw_write_port_cancel()
Date: Wed, 11 Jun 2014 22:51:30 +0530
Message-Id: <1402507301-3722-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_write_port_cancel() is a wrapper function, being used to call
usb_write_port_cancel().
Call usb_write_port_cancel() directly and drop _rtw_write_port_cancel().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c       |   12 ------------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h    |    5 +----
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |    2 +-
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index a0a395c..182074f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -126,18 +126,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-void _rtw_write_port_cancel(struct adapter *adapter)
-{
-	void (*_write_port_cancel)(struct adapter *pintfhdl);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct intf_hdl *pintfhdl = &(pio_priv->intf);
-
-	_write_port_cancel = pintfhdl->io_ops._write_port_cancel;
-
-	if (_write_port_cancel)
-		_write_port_cancel(adapter);
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 02ab541..cfba5d6 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -672,5 +672,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
-	pops->_write_port_cancel = &usb_write_port_cancel;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 4f24092..9c34328 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -50,7 +50,6 @@ struct _io_ops {
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
-	void (*_write_port_cancel)(struct adapter *pintfhdl);
 };
 
 struct io_req {
@@ -94,7 +93,7 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
 int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
 u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void _rtw_write_port_cancel(struct adapter *adapter);
+void usb_write_port_cancel(struct adapter *adapter);
 
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
@@ -106,8 +105,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write16((adapter), (addr), (val))
 #define  rtw_write32(adapter, addr, val)				\
 	_rtw_write32((adapter), (addr), (val))
-#define rtw_write_port_cancel(adapter) _rtw_write_port_cancel((adapter))
-
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 25a931a..491d8e5 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -194,7 +194,7 @@ static void usb_intf_stop(struct adapter *padapter)
 	rtw_hal_inirp_deinit(padapter);
 
 	/* cancel out irp */
-	rtw_write_port_cancel(padapter);
+	usb_write_port_cancel(padapter);
 
 	/* todo:cancel other irps */
 
-- 
1.7.10.4

