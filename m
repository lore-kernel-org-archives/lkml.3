Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaFKRWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:44 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62656 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFKRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/22] staging: rtl8188eu: Instead of intf_hdl pass adapter in read & write functions
Date: Wed, 11 Jun 2014 22:51:25 +0530
Message-Id: <1402507301-3722-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intf_hdl is passed in usb_[read,write][8,16,32]() functions, which
is then passed to vender_request() there it's used to get adapter pointer,
so instead of passing intf_hdl we can directly pass adapter.

This change will also help in removing rtw_[read,write][8,16,32]() wrapper
functions being used to call usb_[read,write][8,16,32]() functions.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c           |   44 ++++++++++-----------
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    4 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |   34 ++++++++--------
 drivers/staging/rtl8188eu/include/rtw_io.h        |   22 +++++------
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |    6 +--
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    9 ++---
 6 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index a0a31e6..85306bf 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -57,10 +57,10 @@ u8 _rtw_read8(struct adapter *adapter, u32 addr)
 	u8 r_val;
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl *pintfhdl = &(pio_priv->intf);
-	u8 (*_read8)(struct intf_hdl *pintfhdl, u32 addr);
+	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
 
 	_read8 = pintfhdl->io_ops._read8;
-	r_val = _read8(pintfhdl, addr);
+	r_val = _read8(adapter, addr);
 	return r_val;
 }
 
@@ -69,10 +69,10 @@ u16 _rtw_read16(struct adapter *adapter, u32 addr)
 	u16 r_val;
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	u16 (*_read16)(struct intf_hdl *pintfhdl, u32 addr);
+	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
 	_read16 = pintfhdl->io_ops._read16;
 
-	r_val = _read16(pintfhdl, addr);
+	r_val = _read16(adapter, addr);
 	return r_val;
 }
 
@@ -81,10 +81,10 @@ u32 _rtw_read32(struct adapter *adapter, u32 addr)
 	u32 r_val;
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	u32	(*_read32)(struct intf_hdl *pintfhdl, u32 addr);
+	u32	(*_read32)(struct adapter *pintfhdl, u32 addr);
 	_read32 = pintfhdl->io_ops._read32;
 
-	r_val = _read32(pintfhdl, addr);
+	r_val = _read32(adapter, addr);
 	return r_val;
 }
 
@@ -92,11 +92,11 @@ int _rtw_write8(struct adapter *adapter, u32 addr, u8 val)
 {
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write8)(struct intf_hdl *pintfhdl, u32 addr, u8 val);
+	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int ret;
 	_write8 = pintfhdl->io_ops._write8;
 
-	ret = _write8(pintfhdl, addr, val);
+	ret = _write8(adapter, addr, val);
 
 	return RTW_STATUS_CODE(ret);
 }
@@ -105,11 +105,11 @@ int _rtw_write16(struct adapter *adapter, u32 addr, u16 val)
 {
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write16)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
+	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 	int ret;
 	_write16 = pintfhdl->io_ops._write16;
 
-	ret = _write16(pintfhdl, addr, val);
+	ret = _write16(adapter, addr, val);
 
 	return RTW_STATUS_CODE(ret);
 }
@@ -117,11 +117,11 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
 {
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write32)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
+	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
 	int ret;
 	_write32 = pintfhdl->io_ops._write32;
 
-	ret = _write32(pintfhdl, addr, val);
+	ret = _write32(adapter, addr, val);
 
 	return RTW_STATUS_CODE(ret);
 }
@@ -130,18 +130,18 @@ int _rtw_writeN(struct adapter *adapter, u32 addr , u32 length , u8 *pdata)
 {
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl *pintfhdl = (struct intf_hdl *)(&(pio_priv->intf));
-	int (*_writeN)(struct intf_hdl *pintfhdl, u32 addr, u32 length, u8 *pdata);
+	int (*_writeN)(struct adapter *pintfhdl, u32 addr, u32 length, u8 *pdata);
 	int ret;
 	_writeN = pintfhdl->io_ops._writeN;
 
-	ret = _writeN(pintfhdl, addr, length, pdata);
+	ret = _writeN(adapter, addr, length, pdata);
 
 	return RTW_STATUS_CODE(ret);
 }
 
 void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
-	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
+	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
 
@@ -155,25 +155,25 @@ void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 
 	_read_port = pintfhdl->io_ops._read_port;
 
-	_read_port(pintfhdl, addr, cnt, pmem);
+	_read_port(adapter, addr, cnt, pmem);
 
 }
 
 void _rtw_read_port_cancel(struct adapter *adapter)
 {
-	void (*_read_port_cancel)(struct intf_hdl *pintfhdl);
+	void (*_read_port_cancel)(struct adapter *pintfhdl);
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct intf_hdl *pintfhdl = &(pio_priv->intf);
 
 	_read_port_cancel = pintfhdl->io_ops._read_port_cancel;
 
 	if (_read_port_cancel)
-		_read_port_cancel(pintfhdl);
+		_read_port_cancel(adapter);
 }
 
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
-	u32 (*_write_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
+	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
 	u32 ret = _SUCCESS;
@@ -181,7 +181,7 @@ u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 
 	_write_port = pintfhdl->io_ops._write_port;
 
-	ret = _write_port(pintfhdl, addr, cnt, pmem);
+	ret = _write_port(adapter, addr, cnt, pmem);
 
 
 	return ret;
@@ -189,14 +189,14 @@ u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 
 void _rtw_write_port_cancel(struct adapter *adapter)
 {
-	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
+	void (*_write_port_cancel)(struct adapter *pintfhdl);
 	struct io_priv *pio_priv = &adapter->iopriv;
 	struct intf_hdl *pintfhdl = &(pio_priv->intf);
 
 	_write_port_cancel = pintfhdl->io_ops._write_port_cancel;
 
 	if (_write_port_cancel)
-		_write_port_cancel(pintfhdl);
+		_write_port_cancel(adapter);
 }
 
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 316c821..fdbc53a 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1039,7 +1039,7 @@ static unsigned int rtl8188eu_inirp_init(struct adapter *Adapter)
 	uint	status;
 	struct intf_hdl *pintfhdl = &Adapter->iopriv.intf;
 	struct recv_priv *precvpriv = &(Adapter->recvpriv);
-	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
+	u32 (*_read_port)(struct adapter *padapter, u32 addr, u32 cnt, u8 *pmem);
 
 
 	_read_port = pintfhdl->io_ops._read_port;
@@ -1054,7 +1054,7 @@ static unsigned int rtl8188eu_inirp_init(struct adapter *Adapter)
 	/* issue Rx irp to receive data */
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		if (_read_port(pintfhdl, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf) == false) {
+		if (_read_port(Adapter, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf) == false) {
 			RT_TRACE(_module_hci_hal_init_c_, _drv_err_, ("usb_rx_init: usb_read_port error\n"));
 			status = _FAIL;
 			goto exit;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 6a1be6e..d1f00db 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -26,9 +26,8 @@
 #include <recv_osdep.h>
 #include <rtl8188e_hal.h>
 
-static int usbctrl_vendorreq(struct intf_hdl *pintfhdl, u8 request, u16 value, u16 index, void *pdata, u16 len, u8 requesttype)
+static int usbctrl_vendorreq(struct adapter *adapt, u8 request, u16 value, u16 index, void *pdata, u16 len, u8 requesttype)
 {
-	struct adapter	*adapt = pintfhdl->padapter;
 	struct dvobj_priv  *dvobjpriv = adapter_to_dvobj(adapt);
 	struct usb_device *udev = dvobjpriv->pusbdev;
 	unsigned int pipe;
@@ -116,7 +115,7 @@ exit:
 	return status;
 }
 
-static u8 usb_read8(struct intf_hdl *pintfhdl, u32 addr)
+static u8 usb_read8(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -133,14 +132,14 @@ static u8 usb_read8(struct intf_hdl *pintfhdl, u32 addr)
 	wvalue = (u16)(addr&0x0000ffff);
 	len = 1;
 
-	usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 
 
 	return data;
 
 }
 
-static u16 usb_read16(struct intf_hdl *pintfhdl, u32 addr)
+static u16 usb_read16(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -154,12 +153,12 @@ static u16 usb_read16(struct intf_hdl *pintfhdl, u32 addr)
 	index = 0;/* n/a */
 	wvalue = (u16)(addr&0x0000ffff);
 	len = 2;
-	usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 
 	return (u16)(le32_to_cpu(data)&0xffff);
 }
 
-static u32 usb_read32(struct intf_hdl *pintfhdl, u32 addr)
+static u32 usb_read32(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -176,13 +175,13 @@ static u32 usb_read32(struct intf_hdl *pintfhdl, u32 addr)
 	wvalue = (u16)(addr&0x0000ffff);
 	len = 4;
 
-	usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 
 
 	return le32_to_cpu(data);
 }
 
-static int usb_write8(struct intf_hdl *pintfhdl, u32 addr, u8 val)
+static int usb_write8(struct adapter *adapter, u32 addr, u8 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -198,11 +197,11 @@ static int usb_write8(struct intf_hdl *pintfhdl, u32 addr, u8 val)
 	wvalue = (u16)(addr&0x0000ffff);
 	len = 1;
 	data = val;
-	ret = usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	ret = usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 	return ret;
 }
 
-static int usb_write16(struct intf_hdl *pintfhdl, u32 addr, u16 val)
+static int usb_write16(struct adapter *adapter, u32 addr, u16 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -222,13 +221,13 @@ static int usb_write16(struct intf_hdl *pintfhdl, u32 addr, u16 val)
 
 	data = cpu_to_le32(val & 0x0000ffff);
 
-	ret = usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	ret = usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 
 
 	return ret;
 }
 
-static int usb_write32(struct intf_hdl *pintfhdl, u32 addr, u32 val)
+static int usb_write32(struct adapter *adapter, u32 addr, u32 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -247,13 +246,13 @@ static int usb_write32(struct intf_hdl *pintfhdl, u32 addr, u32 val)
 	len = 4;
 	data = cpu_to_le32(val);
 
-	ret = usbctrl_vendorreq(pintfhdl, request, wvalue, index, &data, len, requesttype);
+	ret = usbctrl_vendorreq(adapter, request, wvalue, index, &data, len, requesttype);
 
 
 	return ret;
 }
 
-static int usb_writeN(struct intf_hdl *pintfhdl, u32 addr, u32 length, u8 *pdata)
+static int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata)
 {
 	u8 request;
 	u8 requesttype;
@@ -272,7 +271,7 @@ static int usb_writeN(struct intf_hdl *pintfhdl, u32 addr, u32 length, u8 *pdata
 	len = length;
 	 memcpy(buf, pdata, len);
 
-	ret = usbctrl_vendorreq(pintfhdl, request, wvalue, index, buf, len, requesttype);
+	ret = usbctrl_vendorreq(adapter, request, wvalue, index, buf, len, requesttype);
 
 
 	return ret;
@@ -565,11 +564,10 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 	}
 }
 
-static u32 usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
+static u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *rmem)
 {
 	struct urb *purb = NULL;
 	struct recv_buf	*precvbuf = (struct recv_buf *)rmem;
-	struct adapter		*adapter = pintfhdl->padapter;
 	struct dvobj_priv	*pdvobj = adapter_to_dvobj(adapter);
 	struct recv_priv	*precvpriv = &adapter->recvpriv;
 	struct usb_device	*pusbd = pdvobj->pusbdev;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 5c76815..f5a40b6 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -44,20 +44,20 @@ struct intf_priv;
 struct intf_hdl;
 
 struct _io_ops {
-	u8 (*_read8)(struct intf_hdl *pintfhdl, u32 addr);
-	u16 (*_read16)(struct intf_hdl *pintfhdl, u32 addr);
-	u32 (*_read32)(struct intf_hdl *pintfhdl, u32 addr);
-	int (*_write8)(struct intf_hdl *pintfhdl, u32 addr, u8 val);
-	int (*_write16)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
-	int (*_write32)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
-	int (*_writeN)(struct intf_hdl *pintfhdl, u32 addr, u32 length,
+	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
+	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
+	u32 (*_read32)(struct adapter *pintfhdl, u32 addr);
+	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
+	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
+	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
+	int (*_writeN)(struct adapter *pintfhdl, u32 addr, u32 length,
 		       u8 *pdata);
-	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
+	u32 (*_read_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
 			  u8 *pmem);
-	u32 (*_write_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
+	u32 (*_write_port)(struct adapter *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
-	void (*_read_port_cancel)(struct intf_hdl *pintfhdl);
-	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
+	void (*_read_port_cancel)(struct adapter *pintfhdl);
+	void (*_write_port_cancel)(struct adapter *pintfhdl);
 };
 
 struct io_req {
diff --git a/drivers/staging/rtl8188eu/include/usb_ops_linux.h b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
index e5b758a..e722c45 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops_linux.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
@@ -47,9 +47,9 @@ unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr);
 void usb_read_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem);
 void usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem);
 
-void usb_read_port_cancel(struct intf_hdl *pintfhdl);
+void usb_read_port_cancel(struct adapter *padapter);
 
-u32 usb_write_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem);
-void usb_write_port_cancel(struct intf_hdl *pintfhdl);
+u32 usb_write_port(struct adapter *padapter, u32 addr, u32 cnt, u8 *wmem);
+void usb_write_port_cancel(struct adapter *padapter);
 
 #endif
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 5bac414..92c42e4 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -39,11 +39,10 @@ unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr)
 	return pipe;
 }
 
-void usb_read_port_cancel(struct intf_hdl *pintfhdl)
+void usb_read_port_cancel(struct adapter *padapter)
 {
 	int i;
 	struct recv_buf *precvbuf;
-	struct adapter	*padapter = pintfhdl->padapter;
 	precvbuf = (struct recv_buf *)padapter->recvpriv.precv_buf;
 
 	DBG_88E("%s\n", __func__);
@@ -137,14 +136,13 @@ check_completion:
 	tasklet_hi_schedule(&pxmitpriv->xmit_tasklet);
 }
 
-u32 usb_write_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
+u32 usb_write_port(struct adapter *padapter, u32 addr, u32 cnt, u8 *wmem)
 {
 	unsigned long irqL;
 	unsigned int pipe;
 	int status;
 	u32 ret = _FAIL;
 	struct urb *purb = NULL;
-	struct adapter *padapter = (struct adapter *)pintfhdl->padapter;
 	struct dvobj_priv	*pdvobj = adapter_to_dvobj(padapter);
 	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
 	struct xmit_buf *pxmitbuf = (struct xmit_buf *)wmem;
@@ -230,10 +228,9 @@ exit:
 	return ret;
 }
 
-void usb_write_port_cancel(struct intf_hdl *pintfhdl)
+void usb_write_port_cancel(struct adapter *padapter)
 {
 	int i, j;
-	struct adapter	*padapter = pintfhdl->padapter;
 	struct xmit_buf *pxmitbuf = (struct xmit_buf *)padapter->xmitpriv.pxmitbuf;
 
 	DBG_88E("%s\n", __func__);
-- 
1.7.10.4

