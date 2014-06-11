Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaFKRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:58 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62457 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFKRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/22] staging: rtl8188eu: Remove function _rtw_read_port()
Date: Wed, 11 Jun 2014 22:51:27 +0530
Message-Id: <1402507301-3722-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_read_port() is a wrapper function, being used to call usb_read_port().
use usb_read_port() directly and drop _rtw_read_port().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c       |   20 --------------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c   |    7 +------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    9 ++++-----
 drivers/staging/rtl8188eu/include/rtw_io.h    |    6 +-----
 drivers/staging/rtl8188eu/os_dep/recv_linux.c |    2 +-
 5 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index ee1fade..4a3cd3d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -126,26 +126,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
-{
-	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-
-
-	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
-			 ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
-			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
-	     return;
-	}
-
-	_read_port = pintfhdl->io_ops._read_port;
-
-	_read_port(adapter, addr, cnt, pmem);
-
-}
-
 void _rtw_read_port_cancel(struct adapter *adapter)
 {
 	void (*_read_port_cancel)(struct adapter *pintfhdl);
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index fdbc53a..0118b9d 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1037,12 +1037,7 @@ static unsigned int rtl8188eu_inirp_init(struct adapter *Adapter)
 	u8 i;
 	struct recv_buf *precvbuf;
 	uint	status;
-	struct intf_hdl *pintfhdl = &Adapter->iopriv.intf;
 	struct recv_priv *precvpriv = &(Adapter->recvpriv);
-	u32 (*_read_port)(struct adapter *padapter, u32 addr, u32 cnt, u8 *pmem);
-
-
-	_read_port = pintfhdl->io_ops._read_port;
 
 	status = _SUCCESS;
 
@@ -1054,7 +1049,7 @@ static unsigned int rtl8188eu_inirp_init(struct adapter *Adapter)
 	/* issue Rx irp to receive data */
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		if (_read_port(Adapter, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf) == false) {
+		if (usb_read_port(Adapter, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf) == false) {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_err_, ("usb_rx_init: usb_read_port error\n"));
 			status = _FAIL;
 			goto exit;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 24b347b..c41085c 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -511,7 +511,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 			RT_TRACE(_module_hci_ops_os_c_, _drv_err_,
 				 ("usb_read_port_complete: (purb->actual_length > MAX_RECVBUF_SZ) || (purb->actual_length < RXDESC_SIZE)\n"));
 			precvbuf->reuse = true;
-			rtw_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
+			usb_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 			DBG_88E("%s()-%d: RX Warning!\n", __func__, __LINE__);
 		} else {
 			rtw_reset_continual_urb_error(adapter_to_dvobj(adapt));
@@ -524,7 +524,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 
 			precvbuf->pskb = NULL;
 			precvbuf->reuse = false;
-			rtw_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
+			usb_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 		}
 	} else {
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("usb_read_port_complete : purb->status(%d) != 0\n", purb->status));
@@ -553,7 +553,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 				haldata->srestpriv.Wifi_Error_Status = USB_READ_PORT_FAIL;
 			}
 			precvbuf->reuse = true;
-			rtw_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
+			usb_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 			break;
 		case -EINPROGRESS:
 			DBG_88E("ERROR: URB IS IN PROGRESS!\n");
@@ -564,7 +564,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 	}
 }
 
-static u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *rmem)
+u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *rmem)
 {
 	struct urb *purb = NULL;
 	struct recv_buf	*precvbuf = (struct recv_buf *)rmem;
@@ -669,7 +669,6 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read8 = &usb_read8;
 	pops->_read16 = &usb_read16;
 	pops->_read32 = &usb_read32;
-	pops->_read_port = &usb_read_port;
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 77193b5..e68b40c 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -50,8 +50,6 @@ struct _io_ops {
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
-	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
-			  u8 *pmem);
 	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
 	void (*_read_port_cancel)(struct adapter *pintfhdl);
@@ -90,7 +88,7 @@ struct io_priv {
 u8 _rtw_read8(struct adapter *adapter, u32 addr);
 u16 _rtw_read16(struct adapter *adapter, u32 addr);
 u32 _rtw_read32(struct adapter *adapter, u32 addr);
-void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
+u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void _rtw_read_port_cancel(struct adapter *adapter);
 
 int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
@@ -104,8 +102,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
 #define rtw_read32(adapter, addr) _rtw_read32((adapter), (addr))
-#define rtw_read_port(adapter, addr, cnt, mem)				\
-	_rtw_read_port((adapter), (addr), (cnt), (mem))
 #define rtw_read_port_cancel(adapter) _rtw_read_port_cancel((adapter))
 
 #define  rtw_write8(adapter, addr, val)					\
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index c0fa8fd..64dfc02 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -199,7 +199,7 @@ void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf)
 	dev_kfree_skb_any(precvbuf->pskb);
 	precvbuf->pskb = NULL;
 	precvbuf->reuse = false;
-	rtw_read_port(padapter, precvpriv->ff_hwaddr, 0,
+	usb_read_port(padapter, precvpriv->ff_hwaddr, 0,
 			(unsigned char *)precvbuf);
 }
 
-- 
1.7.10.4

