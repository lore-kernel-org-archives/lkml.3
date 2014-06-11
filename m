Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbaFKRXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60104 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFKRXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/22] staging: rtl8188eu: Remove function _rtw_read_port_cancel()
Date: Wed, 11 Jun 2014 22:51:28 +0530
Message-Id: <1402507301-3722-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_read_port_cancel() is a wrapper function, being used to call
usb_read_port_cancel().
Call usb_read_port_cancel() directly and drop _rtw_read_port_cancel().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c       |   12 ------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c   |    2 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h    |    4 +---
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 4a3cd3d..627a852 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -126,18 +126,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-void _rtw_read_port_cancel(struct adapter *adapter)
-{
-	void (*_read_port_cancel)(struct adapter *pintfhdl);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct intf_hdl *pintfhdl = &(pio_priv->intf);
-
-	_read_port_cancel = pintfhdl->io_ops._read_port_cancel;
-
-	if (_read_port_cancel)
-		_read_port_cancel(adapter);
-}
-
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
 	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 0118b9d..88dbc95 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1071,7 +1071,7 @@ static unsigned int rtl8188eu_inirp_deinit(struct adapter *Adapter)
 {
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("\n ===> usb_rx_deinit\n"));
 
-	rtw_read_port_cancel(Adapter);
+	usb_read_port_cancel(Adapter);
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("\n <=== usb_rx_deinit\n"));
 
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index c41085c..95f6c10 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -673,6 +673,5 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
 	pops->_write_port = &usb_write_port;
-	pops->_read_port_cancel = &usb_read_port_cancel;
 	pops->_write_port_cancel = &usb_write_port_cancel;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index e68b40c..0ca46e8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -52,7 +52,6 @@ struct _io_ops {
 	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
 	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
-	void (*_read_port_cancel)(struct adapter *pintfhdl);
 	void (*_write_port_cancel)(struct adapter *pintfhdl);
 };
 
@@ -89,7 +88,7 @@ u8 _rtw_read8(struct adapter *adapter, u32 addr);
 u16 _rtw_read16(struct adapter *adapter, u32 addr);
 u32 _rtw_read32(struct adapter *adapter, u32 addr);
 u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void _rtw_read_port_cancel(struct adapter *adapter);
+void usb_read_port_cancel(struct adapter *adapter);
 
 int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
 int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
@@ -102,7 +101,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
 #define rtw_read32(adapter, addr) _rtw_read32((adapter), (addr))
-#define rtw_read_port_cancel(adapter) _rtw_read_port_cancel((adapter))
 
 #define  rtw_write8(adapter, addr, val)					\
 	_rtw_write8((adapter), (addr), (val))
-- 
1.7.10.4

