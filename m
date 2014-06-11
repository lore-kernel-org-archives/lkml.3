Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaFKRYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:05 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56046 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbaFKRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/22] staging: rtl8188eu: Remove function _rtw_read16()
Date: Wed, 11 Jun 2014 22:51:35 +0530
Message-Id: <1402507301-3722-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_read16() is a wrapper function, being used to call usb_read16().
Call usb_read16() directly and drop _rtw_read16().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_io.c           |   12 ------------
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    8 ++++----
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c   |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |   10 +++++-----
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |    3 +--
 drivers/staging/rtl8188eu/include/rtw_io.h        |    4 +---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   12 ++++++------
 10 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index 615a090..bf39b64 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -101,7 +101,7 @@ int proc_get_read_reg(char *page, char **start,
 		len += snprintf(page + len, count - len, "rtw_read8(0x%x)=0x%x\n", proc_get_read_addr, rtw_read8(padapter, proc_get_read_addr));
 		break;
 	case 2:
-		len += snprintf(page + len, count - len, "rtw_read16(0x%x)=0x%x\n", proc_get_read_addr, rtw_read16(padapter, proc_get_read_addr));
+		len += snprintf(page + len, count - len, "usb_read16(0x%x)=0x%x\n", proc_get_read_addr, usb_read16(padapter, proc_get_read_addr));
 		break;
 	case 4:
 		len += snprintf(page + len, count - len, "usb_read32(0x%x)=0x%x\n", proc_get_read_addr, usb_read32(padapter, proc_get_read_addr));
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 9266d8f..3ce1134 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -64,18 +64,6 @@ u8 _rtw_read8(struct adapter *adapter, u32 addr)
 	return r_val;
 }
 
-u16 _rtw_read16(struct adapter *adapter, u32 addr)
-{
-	u16 r_val;
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
-	_read16 = pintfhdl->io_ops._read16;
-
-	r_val = _read16(adapter, addr);
-	return r_val;
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 77134bc..2f3d0ab 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -33,7 +33,7 @@ u32 read_macreg(struct adapter *padapter, u32 addr, u32 sz)
 		val = rtw_read8(padapter, addr);
 		break;
 	case 2:
-		val = rtw_read16(padapter, addr);
+		val = usb_read16(padapter, addr);
 		break;
 	case 4:
 		val = usb_read32(padapter, addr);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index 2ba92e6..4f6e7e8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -804,7 +804,7 @@ int rtl8188eu_oid_rt_pro_read_register_hdl(struct oid_par_priv *poid_par_priv)
 		RegRWStruct->value = rtw_read8(Adapter, offset);
 		break;
 	case 2:
-		RegRWStruct->value = rtw_read16(Adapter, offset);
+		RegRWStruct->value = usb_read16(Adapter, offset);
 		break;
 	default:
 		width = 4;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7a7d704..bcce688 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -763,20 +763,20 @@ hal_EfusePowerSwitch_RTL8188E(
 		usb_write8(pAdapter, REG_EFUSE_ACCESS, EFUSE_ACCESS_ON);
 
 		/*  1.2V Power: From VDDON with Power Cut(0x0000h[15]), defualt valid */
-		tmpV16 = rtw_read16(pAdapter, REG_SYS_ISO_CTRL);
+		tmpV16 = usb_read16(pAdapter, REG_SYS_ISO_CTRL);
 		if (!(tmpV16 & PWC_EV12V)) {
 			tmpV16 |= PWC_EV12V;
 			 usb_write16(pAdapter, REG_SYS_ISO_CTRL, tmpV16);
 		}
 		/*  Reset: 0x0000h[28], default valid */
-		tmpV16 =  rtw_read16(pAdapter, REG_SYS_FUNC_EN);
+		tmpV16 =  usb_read16(pAdapter, REG_SYS_FUNC_EN);
 		if (!(tmpV16 & FEN_ELDR)) {
 			tmpV16 |= FEN_ELDR;
 			usb_write16(pAdapter, REG_SYS_FUNC_EN, tmpV16);
 		}
 
 		/*  Clock: Gated(0x0008h[5]) 8M(0x0008h[1]) clock from ANA, default valid */
-		tmpV16 = rtw_read16(pAdapter, REG_SYS_CLKR);
+		tmpV16 = usb_read16(pAdapter, REG_SYS_CLKR);
 		if ((!(tmpV16 & LOADER_CLK_EN))  || (!(tmpV16 & ANA8M))) {
 			tmpV16 |= (LOADER_CLK_EN | ANA8M);
 			usb_write16(pAdapter, REG_SYS_CLKR, tmpV16);
@@ -1882,7 +1882,7 @@ u8 GetEEPROMSize8188E(struct adapter *padapter)
 	u8 size = 0;
 	u32	cr;
 
-	cr = rtw_read16(padapter, REG_9346CR);
+	cr = usb_read16(padapter, REG_9346CR);
 	/*  6: EEPROM used is 93C46, 4: boot from E-Fuse. */
 	size = (cr & BOOT_FROM_EEPROM) ? 6 : 4;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 2f53da8..868fa68 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -603,7 +603,7 @@ PHY_BBConfig8188E(
 
 
 	/*  Enable BB and RF */
-	RegVal = rtw_read16(Adapter, REG_SYS_FUNC_EN);
+	RegVal = usb_read16(Adapter, REG_SYS_FUNC_EN);
 	usb_write16(Adapter, REG_SYS_FUNC_EN, (u16)(RegVal|BIT13|BIT0|BIT1));
 
 	/*  20090923 Joseph: Advised by Steven and Jenyu. Power sequence before init RF. */
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 80600bd..4f4bf7f 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -120,7 +120,7 @@ static u32 rtl8188eu_InitPowerOn(struct adapter *adapt)
 	usb_write16(adapt, REG_CR, 0x00);  /* suggseted by zhouzhou, by page, 20111230 */
 
 		/*  Enable MAC DMA/WMAC/SCHEDULE/SEC block */
-	value16 = rtw_read16(adapt, REG_CR);
+	value16 = usb_read16(adapt, REG_CR);
 	value16 |= (HCI_TXDMA_EN | HCI_RXDMA_EN | TXDMA_EN | RXDMA_EN
 				| PROTOCOL_EN | SCHEDULE_EN | ENSEC | CALTMR_EN);
 	/*  for SDIO - Set CR bit10 to enable 32k calibration. Suggested by SD1 Gimmy. Added by tynli. 2011.08.31. */
@@ -221,7 +221,7 @@ static void _InitNormalChipRegPriority(struct adapter *Adapter, u16 beQ,
 				       u16 bkQ, u16 viQ, u16 voQ, u16 mgtQ,
 				       u16 hiQ)
 {
-	u16 value16	= (rtw_read16(Adapter, REG_TRXDMA_CTRL) & 0x7);
+	u16 value16	= (usb_read16(Adapter, REG_TRXDMA_CTRL) & 0x7);
 
 	value16 |= _TXDMA_BEQ_MAP(beQ)	| _TXDMA_BKQ_MAP(bkQ) |
 		   _TXDMA_VIQ_MAP(viQ)	| _TXDMA_VOQ_MAP(voQ) |
@@ -823,7 +823,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	/*  Init CR MACTXEN, MACRXEN after setting RxFF boundary REG_TRXFF_BNDY to patch */
 	/*  Hw bug which Hw initials RxFF boundary size to a value which is larger than the real Rx buffer size in 88E. */
 	/*  Enable MACTXEN/MACRXEN block */
-	value16 = rtw_read16(Adapter, REG_CR);
+	value16 = usb_read16(Adapter, REG_CR);
 	value16 |= (MACTXEN | MACRXEN);
 	usb_write8(Adapter, REG_CR, value16);
 
@@ -905,7 +905,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_HAL_DM);
 		usb_write16(Adapter, REG_TX_RPT_TIME, 0x3DF0);
 
 		/* enable tx DMA to drop the redundate data of packet */
-		usb_write16(Adapter, REG_TXDMA_OFFSET_CHK, (rtw_read16(Adapter, REG_TXDMA_OFFSET_CHK) | DROP_DATA_EN));
+		usb_write16(Adapter, REG_TXDMA_OFFSET_CHK, (usb_read16(Adapter, REG_TXDMA_OFFSET_CHK) | DROP_DATA_EN));
 
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_IQK);
 		/*  2010/08/26 MH Merge from 8192CE. */
@@ -1801,7 +1801,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			usb_write8(Adapter, REG_TXPAUSE, 0xff);
 
 			/* keep sn */
-			Adapter->xmitpriv.nqos_ssn = rtw_read16(Adapter, REG_NQOS_SEQ);
+			Adapter->xmitpriv.nqos_ssn = usb_read16(Adapter, REG_NQOS_SEQ);
 
 			if (!pwrpriv->bkeepfwalive) {
 				/* RX DMA stop */
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 9fd1c66..d5d9288 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -139,7 +139,7 @@ static u8 usb_read8(struct adapter *adapter, u32 addr)
 
 }
 
-static u16 usb_read16(struct adapter *adapter, u32 addr)
+u16 usb_read16(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -667,5 +667,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 {
 	_rtw_memset((u8 *)pops, 0, sizeof(struct _io_ops));
 	pops->_read8 = &usb_read8;
-	pops->_read16 = &usb_read16;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index a48c5f4..63b1ff0 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -45,7 +45,6 @@ struct intf_hdl;
 
 struct _io_ops {
 	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
-	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
 };
 
 struct io_req {
@@ -78,7 +77,7 @@ struct io_priv {
 };
 
 u8 _rtw_read8(struct adapter *adapter, u32 addr);
-u16 _rtw_read16(struct adapter *adapter, u32 addr);
+u16 usb_read16(struct adapter *adapter, u32 addr);
 u32 usb_read32(struct adapter *adapter, u32 addr);
 u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_read_port_cancel(struct adapter *adapter);
@@ -92,7 +91,6 @@ u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_write_port_cancel(struct adapter *adapter);
 
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
-#define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 5119da3..fd888cb 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2183,7 +2183,7 @@ static int rtw_wx_read32(struct net_device *dev,
 		sprintf(extra, "0x%02X", data32);
 		break;
 	case 2:
-		data32 = rtw_read16(padapter, addr);
+		data32 = usb_read16(padapter, addr);
 		sprintf(extra, "0x%04X", data32);
 		break;
 	case 4:
@@ -2356,7 +2356,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 			RegRWStruct->value = rtw_read8(padapter, RegRWStruct->offset);
 			break;
 		case 2:
-			RegRWStruct->value = rtw_read16(padapter, RegRWStruct->offset);
+			RegRWStruct->value = usb_read16(padapter, RegRWStruct->offset);
 			break;
 		case 4:
 			RegRWStruct->value = usb_read32(padapter, RegRWStruct->offset);
@@ -4112,7 +4112,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			DBG_88E("rtw_read8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
 			break;
 		case 2:
-			DBG_88E("rtw_read16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
+			DBG_88E("usb_read16(0x%x) = 0x%04x\n", arg, usb_read16(padapter, arg));
 			break;
 		case 4:
 			DBG_88E("usb_read32(0x%x) = 0x%08x\n", arg, usb_read32(padapter, arg));
@@ -4127,7 +4127,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			break;
 		case 2:
 			usb_write16(padapter, arg, extra_arg);
-			DBG_88E("usb_write16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
+			DBG_88E("usb_write16(0x%x) = 0x%04x\n", arg, usb_read16(padapter, arg));
 			break;
 		case 4:
 			usb_write32(padapter, arg, extra_arg);
@@ -4256,7 +4256,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			if (_SUCCESS != rtw_IOL_exec_cmds_sync(padapter, xmit_frame, 5000, 0))
 				ret = -EPERM;
 
-			final = rtw_read16(padapter, reg);
+			final = usb_read16(padapter, reg);
 			if (start_value+write_num-1 == final)
 				DBG_88E("continuous IOL_CMD_WW_REG to 0x%x %u times Success, start:%u, final:%u\n", reg, write_num, start_value, final);
 			else
@@ -6499,7 +6499,7 @@ static int rtw_mp_read_reg(struct net_device *dev,
 		break;
 	case 'w':
 		/*  2 bytes */
-		sprintf(data, "%04x\n", rtw_read16(padapter, addr));
+		sprintf(data, "%04x\n", usb_read16(padapter, addr));
 		for (i = 0; i <= strlen(data); i++) {
 			if (i%2 == 0) {
 				tmp[j] = ' ';
-- 
1.7.10.4

