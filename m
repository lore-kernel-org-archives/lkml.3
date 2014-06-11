Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaFKRXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:13 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46502 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaFKRXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/22] staging: rtl8188eu: Remove function _rtw_write_port()
Date: Wed, 11 Jun 2014 22:51:29 +0530
Message-Id: <1402507301-3722-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_write_port() is a wrapper function, being used to call usb_write_port().
Call usb_write_port() directly and drop _rtw_write_port().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c        |   16 ----------------
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c |    4 ++--
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c  |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h     |    6 +-----
 4 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 627a852..a0a395c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -126,22 +126,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
-{
-	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	u32 ret = _SUCCESS;
-
-
-	_write_port = pintfhdl->io_ops._write_port;
-
-	ret = _write_port(adapter, addr, cnt, pmem);
-
-
-	return ret;
-}
-
 void _rtw_write_port_cancel(struct adapter *adapter)
 {
 	void (*_write_port_cancel)(struct adapter *pintfhdl);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 3476f88..4bc2ce0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -397,7 +397,7 @@ static s32 rtw_dump_xframe(struct adapter *adapt, struct xmit_frame *pxmitframe)
 		}
 		ff_hwaddr = rtw_get_ff_hwaddr(pxmitframe);
 
-		inner_ret = rtw_write_port(adapt, ff_hwaddr, w_sz, (unsigned char *)pxmitbuf);
+		inner_ret = usb_write_port(adapt, ff_hwaddr, w_sz, (unsigned char *)pxmitbuf);
 
 		rtw_count_tx_stats(adapt, pxmitframe, sz);
 
@@ -608,7 +608,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 
 	/* 3 4. write xmit buffer to USB FIFO */
 	ff_hwaddr = rtw_get_ff_hwaddr(pfirstframe);
-	rtw_write_port(adapt, ff_hwaddr, pbuf_tail, (u8 *)pxmitbuf);
+	usb_write_port(adapt, ff_hwaddr, pbuf_tail, (u8 *)pxmitbuf);
 
 	/* 3 5. update statisitc */
 	pbuf_tail -= (pfirstframe->agg_num * TXDESC_SIZE);
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 95f6c10..02ab541 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -672,6 +672,5 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
-	pops->_write_port = &usb_write_port;
 	pops->_write_port_cancel = &usb_write_port_cancel;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 0ca46e8..4f24092 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -50,8 +50,6 @@ struct _io_ops {
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
-	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
-			   u8 *pmem);
 	void (*_write_port_cancel)(struct adapter *pintfhdl);
 };
 
@@ -95,7 +93,7 @@ int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
 int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
 int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
-u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
+u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void _rtw_write_port_cancel(struct adapter *adapter);
 
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
@@ -108,8 +106,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write16((adapter), (addr), (val))
 #define  rtw_write32(adapter, addr, val)				\
 	_rtw_write32((adapter), (addr), (val))
-#define rtw_write_port(adapter, addr, cnt, mem)				\
-	_rtw_write_port((adapter), (addr), (cnt), (mem))
 #define rtw_write_port_cancel(adapter) _rtw_write_port_cancel((adapter))
 
 
-- 
1.7.10.4

