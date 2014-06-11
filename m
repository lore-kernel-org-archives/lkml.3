Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbaFKRWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:50 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38714 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFKRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/22] staging: rtl8188eu: Remove function _rtw_writeN()
Date: Wed, 11 Jun 2014 22:51:26 +0530
Message-Id: <1402507301-3722-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_writeN() is a wrapper function, being used to call usb_writeN().
Call usb_writeN() directly and drop _rtw_writeN().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c           |   13 -------------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    4 ++--
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |    5 ++---
 drivers/staging/rtl8188eu/include/rtw_io.h        |    6 +-----
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 85306bf..ee1fade 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -126,19 +126,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-int _rtw_writeN(struct adapter *adapter, u32 addr , u32 length , u8 *pdata)
-{
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl *pintfhdl = (struct intf_hdl *)(&(pio_priv->intf));
-	int (*_writeN)(struct adapter *pintfhdl, u32 addr, u32 length, u8 *pdata);
-	int ret;
-	_writeN = pintfhdl->io_ops._writeN;
-
-	ret = _writeN(adapter, addr, length, pdata);
-
-	return RTW_STATUS_CODE(ret);
-}
-
 void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
 	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 208b373..1a53a16 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -441,7 +441,7 @@ static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
 	}
 
 	for (i = 0; i < blockCount_p1; i++) {
-		ret = rtw_writeN(padapter, (FW_8188E_START_ADDRESS + i * blockSize_p1), blockSize_p1, (bufferPtr + i * blockSize_p1));
+		ret = usb_writeN(padapter, (FW_8188E_START_ADDRESS + i * blockSize_p1), blockSize_p1, (bufferPtr + i * blockSize_p1));
 		if (ret == _FAIL)
 			goto exit;
 	}
@@ -460,7 +460,7 @@ static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
 		}
 
 		for (i = 0; i < blockCount_p2; i++) {
-			ret = rtw_writeN(padapter, (FW_8188E_START_ADDRESS + offset + i*blockSize_p2), blockSize_p2, (bufferPtr + offset + i*blockSize_p2));
+			ret = usb_writeN(padapter, (FW_8188E_START_ADDRESS + offset + i*blockSize_p2), blockSize_p2, (bufferPtr + offset + i*blockSize_p2));
 
 			if (ret == _FAIL)
 				goto exit;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d1f00db..24b347b 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -252,7 +252,7 @@ static int usb_write32(struct adapter *adapter, u32 addr, u32 val)
 	return ret;
 }
 
-static int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata)
+int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata)
 {
 	u8 request;
 	u8 requesttype;
@@ -274,7 +274,7 @@ static int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata)
 	ret = usbctrl_vendorreq(adapter, request, wvalue, index, buf, len, requesttype);
 
 
-	return ret;
+	return RTW_STATUS_CODE(ret);
 }
 
 static void interrupt_handler_8188eu(struct adapter *adapt, u16 pkt_len, u8 *pbuf)
@@ -673,7 +673,6 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
-	pops->_writeN = &usb_writeN;
 	pops->_write_port = &usb_write_port;
 	pops->_read_port_cancel = &usb_read_port_cancel;
 	pops->_write_port_cancel = &usb_write_port_cancel;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index f5a40b6..77193b5 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -50,8 +50,6 @@ struct _io_ops {
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
-	int (*_writeN)(struct adapter *pintfhdl, u32 addr, u32 length,
-		       u8 *pdata);
 	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
 			  u8 *pmem);
 	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
@@ -98,7 +96,7 @@ void _rtw_read_port_cancel(struct adapter *adapter);
 int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
 int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
 int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
-int _rtw_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
+int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void _rtw_write_port_cancel(struct adapter *adapter);
@@ -116,8 +114,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write16((adapter), (addr), (val))
 #define  rtw_write32(adapter, addr, val)				\
 	_rtw_write32((adapter), (addr), (val))
-#define  rtw_writeN(adapter, addr, length, data)			\
-	_rtw_writeN((adapter), (addr), (length), (data))
 #define rtw_write_port(adapter, addr, cnt, mem)				\
 	_rtw_write_port((adapter), (addr), (cnt), (mem))
 #define rtw_write_port_cancel(adapter) _rtw_write_port_cancel((adapter))
-- 
1.7.10.4

