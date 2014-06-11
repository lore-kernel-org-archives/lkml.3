Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaFKR0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:26:05 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37979 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334AbaFKRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/22] staging: rtl8188eu: Remove function _rtw_read8()
Date: Wed, 11 Jun 2014 22:51:36 +0530
Message-Id: <1402507301-3722-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_read8() is a wrapper function, being used to call usb_read8().
Call usb_read8() directly and drop _rtw_read8().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   24 +++---
 drivers/staging/rtl8188eu/core/rtw_io.c           |   13 ---
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    6 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    2 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c    |    6 +-
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c      |    4 +-
 drivers/staging/rtl8188eu/hal/hal_com.c           |    8 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c      |   10 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c       |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   42 +++++-----
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c   |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c     |    6 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |   90 ++++++++++-----------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |    3 +-
 drivers/staging/rtl8188eu/include/rtw_io.h        |    4 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   22 ++---
 17 files changed, 116 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index bf39b64..acd6d45 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -98,7 +98,7 @@ int proc_get_read_reg(char *page, char **start,
 
 	switch (proc_get_read_len) {
 	case 1:
-		len += snprintf(page + len, count - len, "rtw_read8(0x%x)=0x%x\n", proc_get_read_addr, rtw_read8(padapter, proc_get_read_addr));
+		len += snprintf(page + len, count - len, "usb_read8(0x%x)=0x%x\n", proc_get_read_addr, usb_read8(padapter, proc_get_read_addr));
 		break;
 	case 2:
 		len += snprintf(page + len, count - len, "usb_read16(0x%x)=0x%x\n", proc_get_read_addr, usb_read16(padapter, proc_get_read_addr));
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 2a1b179..1da9d1e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -182,11 +182,11 @@ ReadEFuseByte(
 
 	/* Write Address */
 	usb_write8(Adapter, EFUSE_CTRL+1, (_offset & 0xff));
-	readbyte = rtw_read8(Adapter, EFUSE_CTRL+2);
+	readbyte = usb_read8(Adapter, EFUSE_CTRL+2);
 	usb_write8(Adapter, EFUSE_CTRL+2, ((_offset >> 8) & 0x03) | (readbyte & 0xfc));
 
 	/* Write bit 32 0 */
-	readbyte = rtw_read8(Adapter, EFUSE_CTRL+3);
+	readbyte = usb_read8(Adapter, EFUSE_CTRL+3);
 	usb_write8(Adapter, EFUSE_CTRL+3, (readbyte & 0x7f));
 
 	/* Check bit 32 read-ready */
@@ -264,27 +264,27 @@ u8 EFUSE_Read1Byte(struct adapter *Adapter, u16 Address)
 		/* Write E-fuse Register address bit0~7 */
 		temp = Address & 0xFF;
 		usb_write8(Adapter, EFUSE_CTRL+1, temp);
-		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+2);
+		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+2);
 		/* Write E-fuse Register address bit8~9 */
 		temp = ((Address >> 8) & 0x03) | (Bytetemp & 0xFC);
 		usb_write8(Adapter, EFUSE_CTRL+2, temp);
 
 		/* Write 0x30[31]= 0 */
-		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+3);
+		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
 		temp = Bytetemp & 0x7F;
 		usb_write8(Adapter, EFUSE_CTRL+3, temp);
 
 		/* Wait Write-ready (0x30[31]= 1) */
-		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+3);
+		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
 		while (!(Bytetemp & 0x80)) {
-			Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+3);
+			Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
 			k++;
 			if (k == 1000) {
 				k = 0;
 				break;
 			}
 		}
-		data = rtw_read8(Adapter, EFUSE_CTRL);
+		data = usb_read8(Adapter, EFUSE_CTRL);
 		return data;
 	} else {
 		return 0xFF;
@@ -306,14 +306,14 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data, bool pseudo)
 	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr & 0xff));
 	usb_write8(pAdapter, EFUSE_CTRL+2, ((u8)((addr>>8) & 0x03)) |
-		   (rtw_read8(pAdapter, EFUSE_CTRL+2) & 0xFC));
+		   (usb_read8(pAdapter, EFUSE_CTRL+2) & 0xFC));
 
 	usb_write8(pAdapter, EFUSE_CTRL+3,  0x72);/* read cmd */
 
-	while (!(0x80 & rtw_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
+	while (!(0x80 & usb_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
 		tmpidx++;
 	if (tmpidx < 100) {
-		*data = rtw_read8(pAdapter, EFUSE_CTRL);
+		*data = usb_read8(pAdapter, EFUSE_CTRL);
 		result = true;
 	} else {
 		*data = 0xff;
@@ -337,13 +337,13 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr&0xff));
 	usb_write8(pAdapter, EFUSE_CTRL+2,
-		   (rtw_read8(pAdapter, EFUSE_CTRL+2) & 0xFC) |
+		   (usb_read8(pAdapter, EFUSE_CTRL+2) & 0xFC) |
 		   (u8)((addr>>8) & 0x03));
 	usb_write8(pAdapter, EFUSE_CTRL, data);/* data */
 
 	usb_write8(pAdapter, EFUSE_CTRL+3, 0xF2);/* write cmd */
 
-	while ((0x80 &  rtw_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
+	while ((0x80 &  usb_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
 		tmpidx++;
 
 	if (tmpidx < 100)
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 3ce1134..25b0a87 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -51,19 +51,6 @@ jackson@realtek.com.tw
 #define rtw_cpu_to_le16(val)		cpu_to_le16(val)
 #define rtw_cpu_to_le32(val)		cpu_to_le32(val)
 
-
-u8 _rtw_read8(struct adapter *adapter, u32 addr)
-{
-	u8 r_val;
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl *pintfhdl = &(pio_priv->intf);
-	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
-
-	_read8 = pintfhdl->io_ops._read8;
-	r_val = _read8(adapter, addr);
-	return r_val;
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 2f3d0ab..fa8704d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -30,7 +30,7 @@ u32 read_macreg(struct adapter *padapter, u32 addr, u32 sz)
 
 	switch (sz) {
 	case 1:
-		val = rtw_read8(padapter, addr);
+		val = usb_read8(padapter, addr);
 		break;
 	case 2:
 		val = usb_read16(padapter, addr);
@@ -302,7 +302,7 @@ static void disable_dm(struct adapter *padapter)
 
 	/* 3 1. disable firmware dynamic mechanism */
 	/*  disable Power Training, Rate Adaptive */
-	v8 = rtw_read8(padapter, REG_BCN_CTRL);
+	v8 = usb_read8(padapter, REG_BCN_CTRL);
 	v8 &= ~EN_BCN_FUNCTION;
 	usb_write8(padapter, REG_BCN_CTRL, v8);
 
@@ -421,7 +421,7 @@ end_of_mp_start_test:
 
 	if (res == _SUCCESS) {
 		/*  set MSR to WIFI_FW_ADHOC_STATE */
-		val8 = rtw_read8(padapter, MSR) & 0xFC; /*  0x0102 */
+		val8 = usb_read8(padapter, MSR) & 0xFC; /*  0x0102 */
 		val8 |= WIFI_FW_ADHOC_STATE;
 		usb_write8(padapter, MSR, val8); /*  Link in ad hoc network */
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index 4f6e7e8..c06cd82 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -801,7 +801,7 @@ int rtl8188eu_oid_rt_pro_read_register_hdl(struct oid_par_priv *poid_par_priv)
 
 	switch (width) {
 	case 1:
-		RegRWStruct->value = rtw_read8(Adapter, offset);
+		RegRWStruct->value = usb_read8(Adapter, offset);
 		break;
 	case 2:
 		RegRWStruct->value = usb_read16(Adapter, offset);
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index c4ee978..3a7d35d 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -819,7 +819,7 @@ static void _PHY_SaveMACRegisters(
 	struct odm_dm_struct *dm_odm = &pHalData->odmpriv;
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Save MAC parameters.\n"));
 	for (i = 0; i < (IQK_MAC_REG_NUM - 1); i++) {
-		MACBackup[i] = rtw_read8(adapt, MACReg[i]);
+		MACBackup[i] = usb_read8(adapt, MACReg[i]);
 	}
 	MACBackup[i] = usb_read32(adapt, MACReg[i]);
 }
@@ -1205,7 +1205,7 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 	u32 RF_Amode = 0, RF_Bmode = 0, LC_Cal;
 
 	/* Check continuous TX and Packet TX */
-	tmpreg = rtw_read8(adapt, 0xd03);
+	tmpreg = usb_read8(adapt, 0xd03);
 
 	if ((tmpreg&0x70) != 0)			/* Deal with contisuous TX case */
 		usb_write8(adapt, 0xd03, tmpreg&0x8F);	/* disable all continuous TX */
@@ -1446,7 +1446,7 @@ static void phy_setrfpathswitch_8188e(struct adapter *adapt, bool main, bool is2
 {
 	if (!adapt->hw_init_completed) {
 		u8 u1btmp;
-		u1btmp = rtw_read8(adapt, REG_LEDCFG2) | BIT7;
+		u1btmp = usb_read8(adapt, REG_LEDCFG2) | BIT7;
 		usb_write8(adapt, REG_LEDCFG2, u1btmp);
 		PHY_SetBBReg(adapt, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 	}
diff --git a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
index d90c544..1808d35 100644
--- a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
+++ b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
@@ -80,7 +80,7 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
 
 				/*  Read the value from system register */
-				value = rtw_read8(padapter, offset);
+				value = usb_read8(padapter, offset);
 
 				value &= ~(GET_PWR_CFG_MASK(pwrcfgcmd));
 				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) & GET_PWR_CFG_MASK(pwrcfgcmd));
@@ -94,7 +94,7 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 				poll_bit = false;
 				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
 				do {
-						value = rtw_read8(padapter, offset);
+						value = usb_read8(padapter, offset);
 
 					value &= GET_PWR_CFG_MASK(pwrcfgcmd);
 					if (value == (GET_PWR_CFG_VALUE(pwrcfgcmd) & GET_PWR_CFG_MASK(pwrcfgcmd)))
diff --git a/drivers/staging/rtl8188eu/hal/hal_com.c b/drivers/staging/rtl8188eu/hal/hal_com.c
index f69dbf9..429de69 100644
--- a/drivers/staging/rtl8188eu/hal/hal_com.c
+++ b/drivers/staging/rtl8188eu/hal/hal_com.c
@@ -341,7 +341,7 @@ s32 c2h_evt_read(struct adapter *adapter, u8 *buf)
 	if (buf == NULL)
 		goto exit;
 
-	trigger = rtw_read8(adapter, REG_C2HEVT_CLEAR);
+	trigger = usb_read8(adapter, REG_C2HEVT_CLEAR);
 
 	if (trigger == C2H_EVT_HOST_CLOSE)
 		goto exit; /* Not ready */
@@ -352,15 +352,15 @@ s32 c2h_evt_read(struct adapter *adapter, u8 *buf)
 
 	_rtw_memset(c2h_evt, 0, 16);
 
-	*buf = rtw_read8(adapter, REG_C2HEVT_MSG_NORMAL);
-	*(buf+1) = rtw_read8(adapter, REG_C2HEVT_MSG_NORMAL + 1);
+	*buf = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL);
+	*(buf+1) = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL + 1);
 
 	RT_PRINT_DATA(_module_hal_init_c_, _drv_info_, "c2h_evt_read(): ",
 		      &c2h_evt , sizeof(c2h_evt));
 
 	/* Read the content */
 	for (i = 0; i < c2h_evt->plen; i++)
-		c2h_evt->payload[i] = rtw_read8(adapter, REG_C2HEVT_MSG_NORMAL +
+		c2h_evt->payload[i] = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL +
 						sizeof(*c2h_evt) + i);
 
 	RT_PRINT_DATA(_module_hal_init_c_, _drv_info_,
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 17ab11b..5c9d64e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -41,7 +41,7 @@ static u8 _is_fw_read_cmd_down(struct adapter *adapt, u8 msgbox_num)
 	u8 valid;
 
 	do {
-		valid = rtw_read8(adapt, REG_HMETFR) & BIT(msgbox_num);
+		valid = usb_read8(adapt, REG_HMETFR) & BIT(msgbox_num);
 		if (0 == valid)
 			read_down = true;
 	} while ((!read_down) && (retry_cnts--));
@@ -625,8 +625,8 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		/*  Disable Hw protection for a time which revserd for Hw sending beacon. */
 		/*  Fix download reserved page packet fail that access collision with the protection time. */
 		/*  2010.05.11. Added by tynli. */
-		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(3)));
-		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(4));
+		usb_write8(adapt, REG_BCN_CTRL, usb_read8(adapt, REG_BCN_CTRL)&(~BIT(3)));
+		usb_write8(adapt, REG_BCN_CTRL, usb_read8(adapt, REG_BCN_CTRL)|BIT(4));
 
 		if (haldata->RegFwHwTxQCtrl&BIT6) {
 			DBG_88E("HalDownloadRSVDPage(): There is an Adapter is sending beacon.\n");
@@ -668,8 +668,8 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		/*  */
 
 		/*  Enable Bcn */
-		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(3));
-		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(4)));
+		usb_write8(adapt, REG_BCN_CTRL, usb_read8(adapt, REG_BCN_CTRL)|BIT(3));
+		usb_write8(adapt, REG_BCN_CTRL, usb_read8(adapt, REG_BCN_CTRL)&(~BIT(4)));
 
 		/*  To make sure that if there exists an adapter which would like to send beacon. */
 		/*  If exists, the origianl value of 0x422[6] will be 1, we should check this to */
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index 65cf139..917c60e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -36,7 +36,7 @@ static void dm_InitGPIOSetting(struct adapter *Adapter)
 {
 	u8	tmp1byte;
 
-	tmp1byte = rtw_read8(Adapter, REG_GPIO_MUXCFG);
+	tmp1byte = usb_read8(Adapter, REG_GPIO_MUXCFG);
 	tmp1byte &= (GPIOSEL_GPIO | ~GPIOSEL_ENBT);
 
 	usb_write8(Adapter, REG_GPIO_MUXCFG, tmp1byte);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index bcce688..58426ac 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -36,7 +36,7 @@ static void iol_mode_enable(struct adapter *padapter, u8 enable)
 
 	if (enable) {
 		/* Enable initial offload */
-		reg_0xf0 = rtw_read8(padapter, REG_SYS_CFG);
+		reg_0xf0 = usb_read8(padapter, REG_SYS_CFG);
 		usb_write8(padapter, REG_SYS_CFG, reg_0xf0|SW_OFFLOAD_EN);
 
 		if (!padapter->bFWReady) {
@@ -46,7 +46,7 @@ static void iol_mode_enable(struct adapter *padapter, u8 enable)
 
 	} else {
 		/* disable initial offload */
-		reg_0xf0 = rtw_read8(padapter, REG_SYS_CFG);
+		reg_0xf0 = usb_read8(padapter, REG_SYS_CFG);
 		usb_write8(padapter, REG_SYS_CFG, reg_0xf0 & ~SW_OFFLOAD_EN);
 	}
 }
@@ -58,16 +58,16 @@ static s32 iol_execute(struct adapter *padapter, u8 control)
 	u32 start = 0, passing_time = 0;
 
 	control = control&0x0f;
-	reg_0x88 = rtw_read8(padapter, REG_HMEBOX_E0);
+	reg_0x88 = usb_read8(padapter, REG_HMEBOX_E0);
 	usb_write8(padapter, REG_HMEBOX_E0,  reg_0x88|control);
 
 	start = jiffies;
-	while ((reg_0x88 = rtw_read8(padapter, REG_HMEBOX_E0)) & control &&
+	while ((reg_0x88 = usb_read8(padapter, REG_HMEBOX_E0)) & control &&
 	       (passing_time = rtw_get_passing_time_ms(start)) < 1000) {
 		;
 	}
 
-	reg_0x88 = rtw_read8(padapter, REG_HMEBOX_E0);
+	reg_0x88 = usb_read8(padapter, REG_HMEBOX_E0);
 	status = (reg_0x88 & control) ? _FAIL : _SUCCESS;
 	if (reg_0x88 & control<<4)
 		status = _FAIL;
@@ -227,7 +227,7 @@ static void efuse_read_phymap_from_txpktbuf(
 	u8 *pos = content;
 
 	if (bcnhead < 0) /* if not valid */
-		bcnhead = rtw_read8(adapter, REG_TDECTRL+1);
+		bcnhead = usb_read8(adapter, REG_TDECTRL+1);
 
 	DBG_88E("%s bcnhead:%d\n", __func__, bcnhead);
 
@@ -240,9 +240,9 @@ static void efuse_read_phymap_from_txpktbuf(
 
 		usb_write8(adapter, REG_TXPKTBUF_DBG, 0);
 		start = jiffies;
-		while (!(reg_0x143 = rtw_read8(adapter, REG_TXPKTBUF_DBG)) &&
+		while (!(reg_0x143 = usb_read8(adapter, REG_TXPKTBUF_DBG)) &&
 		       (passing_time = rtw_get_passing_time_ms(start)) < 1000) {
-			DBG_88E("%s polling reg_0x143:0x%02x, reg_0x106:0x%02x\n", __func__, reg_0x143, rtw_read8(adapter, 0x106));
+			DBG_88E("%s polling reg_0x143:0x%02x, reg_0x106:0x%02x\n", __func__, reg_0x143, usb_read8(adapter, 0x106));
 			msleep(1);
 		}
 
@@ -253,8 +253,8 @@ static void efuse_read_phymap_from_txpktbuf(
 			u8 lenc[2];
 			u16 lenbak, aaabak;
 			u16 aaa;
-			lenc[0] = rtw_read8(adapter, REG_PKTBUF_DBG_DATA_L);
-			lenc[1] = rtw_read8(adapter, REG_PKTBUF_DBG_DATA_L+1);
+			lenc[0] = usb_read8(adapter, REG_PKTBUF_DBG_DATA_L);
+			lenc[1] = usb_read8(adapter, REG_PKTBUF_DBG_DATA_L+1);
 
 			aaabak = le16_to_cpup((__le16 *)lenc);
 			lenbak = le16_to_cpu(*((__le16 *)lenc));
@@ -399,15 +399,15 @@ static void _FWDownloadEnable(struct adapter *padapter, bool enable)
 
 	if (enable) {
 		/*  MCU firmware download enable. */
-		tmp = rtw_read8(padapter, REG_MCUFWDL);
+		tmp = usb_read8(padapter, REG_MCUFWDL);
 		usb_write8(padapter, REG_MCUFWDL, tmp | 0x01);
 
 		/*  8051 reset */
-		tmp = rtw_read8(padapter, REG_MCUFWDL+2);
+		tmp = usb_read8(padapter, REG_MCUFWDL+2);
 		usb_write8(padapter, REG_MCUFWDL+2, tmp&0xf7);
 	} else {
 		/*  MCU firmware download disable. */
-		tmp = rtw_read8(padapter, REG_MCUFWDL);
+		tmp = usb_read8(padapter, REG_MCUFWDL);
 		usb_write8(padapter, REG_MCUFWDL, tmp&0xfe);
 
 		/*  Reserved for fw extension. */
@@ -494,7 +494,7 @@ static int _PageWrite(struct adapter *padapter, u32 page, void *buffer, u32 size
 	u8 value8;
 	u8 u8Page = (u8)(page & 0x07);
 
-	value8 = (rtw_read8(padapter, REG_MCUFWDL+2) & 0xF8) | u8Page;
+	value8 = (usb_read8(padapter, REG_MCUFWDL+2) & 0xF8) | u8Page;
 	usb_write8(padapter, REG_MCUFWDL+2, value8);
 
 	return _BlockWrite(padapter, buffer, size);
@@ -536,7 +536,7 @@ void _8051Reset88E(struct adapter *padapter)
 {
 	u8 u1bTmp;
 
-	u1bTmp = rtw_read8(padapter, REG_SYS_FUNC_EN+1);
+	u1bTmp = usb_read8(padapter, REG_SYS_FUNC_EN+1);
 	usb_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp&(~BIT2));
 	usb_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp|(BIT2));
 	DBG_88E("=====> _8051Reset88E(): 8051 reset success .\n");
@@ -666,7 +666,7 @@ s32 rtl8188e_FirmwareDownload(struct adapter *padapter)
 
 	/*  Suggested by Filen. If 8051 is running in RAM code, driver should inform Fw to reset by itself, */
 	/*  or it will cause download Fw fail. 2010.02.01. by tynli. */
-	if (rtw_read8(padapter, REG_MCUFWDL) & RAM_DL_SEL) { /* 8051 RAM code */
+	if (usb_read8(padapter, REG_MCUFWDL) & RAM_DL_SEL) { /* 8051 RAM code */
 		usb_write8(padapter, REG_MCUFWDL, 0x00);
 		_8051Reset88E(padapter);
 	}
@@ -675,7 +675,7 @@ s32 rtl8188e_FirmwareDownload(struct adapter *padapter)
 	fwdl_start_time = jiffies;
 	while (1) {
 		/* reset the FWDL chksum */
-		usb_write8(padapter, REG_MCUFWDL, rtw_read8(padapter, REG_MCUFWDL) | FWDL_ChkSum_rpt);
+		usb_write8(padapter, REG_MCUFWDL, usb_read8(padapter, REG_MCUFWDL) | FWDL_ChkSum_rpt);
 
 		rtStatus = _WriteFW(padapter, pFirmwareBuf, FirmwareLen);
 
@@ -784,7 +784,7 @@ hal_EfusePowerSwitch_RTL8188E(
 
 		if (bWrite) {
 			/*  Enable LDO 2.5V before read/write action */
-			tempval = rtw_read8(pAdapter, EFUSE_TEST+3);
+			tempval = usb_read8(pAdapter, EFUSE_TEST+3);
 			tempval &= 0x0F;
 			tempval |= (VOLTAGE_V25 << 4);
 			usb_write8(pAdapter, EFUSE_TEST+3, (tempval | 0x80));
@@ -794,7 +794,7 @@ hal_EfusePowerSwitch_RTL8188E(
 
 		if (bWrite) {
 			/*  Disable LDO 2.5V after read/write action */
-			tempval = rtw_read8(pAdapter, EFUSE_TEST+3);
+			tempval = usb_read8(pAdapter, EFUSE_TEST+3);
 			usb_write8(pAdapter, EFUSE_TEST+3, (tempval & 0x7F));
 		}
 	}
@@ -1827,10 +1827,10 @@ static void hal_notch_filter_8188e(struct adapter *adapter, bool enable)
 {
 	if (enable) {
 		DBG_88E("Enable notch filter\n");
-		usb_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) | BIT1);
+		usb_write8(adapter, rOFDM0_RxDSP+1, usb_read8(adapter, rOFDM0_RxDSP+1) | BIT1);
 	} else {
 		DBG_88E("Disable notch filter\n");
-		usb_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) & ~BIT1);
+		usb_write8(adapter, rOFDM0_RxDSP+1, usb_read8(adapter, rOFDM0_RxDSP+1) & ~BIT1);
 	}
 }
 void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 868fa68..9f016a5 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -792,8 +792,8 @@ _PHY_SetBWMode92C(
 	/* 3<1>Set MAC register */
 	/* 3 */
 
-	regBwOpMode = rtw_read8(Adapter, REG_BWOPMODE);
-	regRRSR_RSC = rtw_read8(Adapter, REG_RRSR+2);
+	regBwOpMode = usb_read8(Adapter, REG_BWOPMODE);
+	regRRSR_RSC = usb_read8(Adapter, REG_RRSR+2);
 
 	switch (pHalData->CurrentChannelBW) {
 	case HT_CHANNEL_WIDTH_20:
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index 3971b70..ab07a6c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -34,7 +34,7 @@ void SwLedOn(struct adapter *padapter, struct LED_871x *pLed)
 
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped)
 		return;
-	LedCfg = rtw_read8(padapter, REG_LEDCFG2);
+	LedCfg = usb_read8(padapter, REG_LEDCFG2);
 	usb_write8(padapter, REG_LEDCFG2, (LedCfg&0xf0)|BIT5|BIT6); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
@@ -49,13 +49,13 @@ void SwLedOff(struct adapter *padapter, struct LED_871x *pLed)
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped)
 		goto exit;
 
-	LedCfg = rtw_read8(padapter, REG_LEDCFG2);/* 0x4E */
+	LedCfg = usb_read8(padapter, REG_LEDCFG2);/* 0x4E */
 
 	if (pHalData->bLedOpenDrain) {
 			/*  Open-drain arrangement for controlling the LED) */
 		LedCfg &= 0x90; /*  Set to software control. */
 		usb_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3));
-		LedCfg = rtw_read8(padapter, REG_MAC_PINMUX_CFG);
+		LedCfg = usb_read8(padapter, REG_MAC_PINMUX_CFG);
 		LedCfg &= 0xFE;
 		usb_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
 	} else {
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 4f4bf7f..03701ca 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -152,7 +152,7 @@ static void _InitInterrupt(struct adapter *Adapter)
 	/*  REG_USB_SPECIAL_OPTION - BIT(4) */
 	/*  0; Use interrupt endpoint to upload interrupt pkt */
 	/*  1; Use bulk endpoint to upload interrupt pkt, */
-	usb_opt = rtw_read8(Adapter, REG_USB_SPECIAL_OPTION);
+	usb_opt = usb_read8(Adapter, REG_USB_SPECIAL_OPTION);
 
 	if (!adapter_to_dvobj(Adapter)->ishighspeed)
 		usb_opt = usb_opt & (~INT_BULK_SEL);
@@ -437,7 +437,7 @@ static void _InitRetryFunction(struct adapter *Adapter)
 {
 	u8 value8;
 
-	value8 = rtw_read8(Adapter, REG_FWHW_TXQ_CTRL);
+	value8 = usb_read8(Adapter, REG_FWHW_TXQ_CTRL);
 	value8 |= EN_AMPDU_RTY_NEW;
 	usb_write8(Adapter, REG_FWHW_TXQ_CTRL, value8);
 
@@ -501,8 +501,8 @@ usb_AggSettingRxUpdate(
 	u8 valueDMA;
 	u8 valueUSB;
 
-	valueDMA = rtw_read8(Adapter, REG_TRXDMA_CTRL);
-	valueUSB = rtw_read8(Adapter, REG_USB_SPECIAL_OPTION);
+	valueDMA = usb_read8(Adapter, REG_TRXDMA_CTRL);
+	valueUSB = usb_read8(Adapter, REG_USB_SPECIAL_OPTION);
 
 	switch (haldata->UsbRxAggMode) {
 	case USB_RX_AGG_DMA:
@@ -598,11 +598,11 @@ static void _InitBeaconParameters(struct adapter *Adapter)
 	/*  beacause test chip does not contension before sending beacon. by tynli. 2009.11.03 */
 	usb_write16(Adapter, REG_BCNTCFG, 0x660F);
 
-	haldata->RegBcnCtrlVal = rtw_read8(Adapter, REG_BCN_CTRL);
-	haldata->RegTxPause = rtw_read8(Adapter, REG_TXPAUSE);
-	haldata->RegFwHwTxQCtrl = rtw_read8(Adapter, REG_FWHW_TXQ_CTRL+2);
-	haldata->RegReg542 = rtw_read8(Adapter, REG_TBTT_PROHIBIT+2);
-	haldata->RegCR_1 = rtw_read8(Adapter, REG_CR+1);
+	haldata->RegBcnCtrlVal = usb_read8(Adapter, REG_BCN_CTRL);
+	haldata->RegTxPause = usb_read8(Adapter, REG_TXPAUSE);
+	haldata->RegFwHwTxQCtrl = usb_read8(Adapter, REG_FWHW_TXQ_CTRL+2);
+	haldata->RegReg542 = usb_read8(Adapter, REG_TBTT_PROHIBIT+2);
+	haldata->RegCR_1 = usb_read8(Adapter, REG_CR+1);
 }
 
 static void _BeaconFunctionEnable(struct adapter *Adapter,
@@ -664,12 +664,12 @@ enum rt_rf_power_state RfOnOffDetect(struct adapter *adapt)
 	enum rt_rf_power_state rfpowerstate = rf_off;
 
 	if (adapt->pwrctrlpriv.bHWPowerdown) {
-		val8 = rtw_read8(adapt, REG_HSISR);
+		val8 = usb_read8(adapt, REG_HSISR);
 		DBG_88E("pwrdown, 0x5c(BIT7)=%02x\n", val8);
 		rfpowerstate = (val8 & BIT7) ? rf_off : rf_on;
 	} else { /*  rf on/off */
-		usb_write8(adapt, REG_MAC_PINMUX_CFG, rtw_read8(adapt, REG_MAC_PINMUX_CFG)&~(BIT3));
-		val8 = rtw_read8(adapt, REG_GPIO_IO_SEL);
+		usb_write8(adapt, REG_MAC_PINMUX_CFG, usb_read8(adapt, REG_MAC_PINMUX_CFG)&~(BIT3));
+		val8 = usb_read8(adapt, REG_GPIO_IO_SEL);
 		DBG_88E("GPIO_IN=%02x\n", val8);
 		rfpowerstate = (val8 & BIT3) ? rf_on : rf_off;
 	}
@@ -832,7 +832,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 
 	/* Enable TX Report */
 	/* Enable Tx Report Timer */
-	value8 = rtw_read8(Adapter, REG_TX_RPT_CTRL);
+	value8 = usb_read8(Adapter, REG_TX_RPT_CTRL);
 	usb_write8(Adapter,  REG_TX_RPT_CTRL, (value8|BIT1|BIT0));
 	/* Set MAX RPT MACID */
 	usb_write8(Adapter,  REG_TX_RPT_CTRL+1, 2);/* FOR sta mode ,0: bc/mc ,1:AP */
@@ -950,7 +950,7 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 	RT_TRACE(_module_hci_hal_init_c_, _drv_info_, ("CardDisableRTL8188EU\n"));
 
 	/* Stop Tx Report Timer. 0x4EC[Bit1]=b'0 */
-	val8 = rtw_read8(Adapter, REG_TX_RPT_CTRL);
+	val8 = usb_read8(Adapter, REG_TX_RPT_CTRL);
 	usb_write8(Adapter, REG_TX_RPT_CTRL, val8&(~BIT1));
 
 	/*  stop rx */
@@ -961,10 +961,10 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 
 	/*  2. 0x1F[7:0] = 0		turn off RF */
 
-	val8 = rtw_read8(Adapter, REG_MCUFWDL);
+	val8 = usb_read8(Adapter, REG_MCUFWDL);
 	if ((val8 & RAM_DL_SEL) && Adapter->bFWReady) { /* 8051 RAM code */
 		/*  Reset MCU 0x2[10]=0. */
-		val8 = rtw_read8(Adapter, REG_SYS_FUNC_EN+1);
+		val8 = usb_read8(Adapter, REG_SYS_FUNC_EN+1);
 		val8 &= ~BIT(2);	/*  0x2[10], FEN_CPUEN */
 		usb_write8(Adapter, REG_SYS_FUNC_EN+1, val8);
 	}
@@ -974,26 +974,26 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 
 	/* YJ,add,111212 */
 	/* Disable 32k */
-	val8 = rtw_read8(Adapter, REG_32K_CTRL);
+	val8 = usb_read8(Adapter, REG_32K_CTRL);
 	usb_write8(Adapter, REG_32K_CTRL, val8&(~BIT0));
 
 	/*  Card disable power action flow */
 	HalPwrSeqCmdParsing(Adapter, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_DISABLE_FLOW);
 
 	/*  Reset MCU IO Wrapper */
-	val8 = rtw_read8(Adapter, REG_RSV_CTRL+1);
+	val8 = usb_read8(Adapter, REG_RSV_CTRL+1);
 	usb_write8(Adapter, REG_RSV_CTRL+1, (val8&(~BIT3)));
-	val8 = rtw_read8(Adapter, REG_RSV_CTRL+1);
+	val8 = usb_read8(Adapter, REG_RSV_CTRL+1);
 	usb_write8(Adapter, REG_RSV_CTRL+1, val8|BIT3);
 
 	/* YJ,test add, 111207. For Power Consumption. */
-	val8 = rtw_read8(Adapter, GPIO_IN);
+	val8 = usb_read8(Adapter, GPIO_IN);
 	usb_write8(Adapter, GPIO_OUT, val8);
 	usb_write8(Adapter, GPIO_IO_SEL, 0xFF);/* Reg0x46 */
 
-	val8 = rtw_read8(Adapter, REG_GPIO_IO_SEL);
+	val8 = usb_read8(Adapter, REG_GPIO_IO_SEL);
 	usb_write8(Adapter, REG_GPIO_IO_SEL, (val8<<4));
-	val8 = rtw_read8(Adapter, REG_GPIO_IO_SEL+1);
+	val8 = usb_read8(Adapter, REG_GPIO_IO_SEL+1);
 	usb_write8(Adapter, REG_GPIO_IO_SEL+1, val8|0x0F);/* Reg0x43 */
 	usb_write32(Adapter, REG_BB_PAD_CTRL, 0x00080808);/* set LNA ,TRSW,EX_PA Pin to output mode */
 	haldata->bMacPwrCtrlOn = false;
@@ -1164,7 +1164,7 @@ static void _ReadPROMContent(
 	u8 eeValue;
 
 	/* check system boot selection */
-	eeValue = rtw_read8(Adapter, REG_9346CR);
+	eeValue = usb_read8(Adapter, REG_9346CR);
 	eeprom->EepromOrEfuse		= (eeValue & BOOT_FROM_EEPROM) ? true : false;
 	eeprom->bautoload_fail_flag	= (eeValue & EEPROM_EN) ? false : true;
 
@@ -1235,10 +1235,10 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 	u8 mode = *((u8 *)val);
 
 	/*  disable Port0 TSF update */
-	usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+	usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 
 	/*  set net_type */
-	val8 = rtw_read8(Adapter, MSR)&0x0c;
+	val8 = usb_read8(Adapter, MSR)&0x0c;
 	val8 |= mode;
 	usb_write8(Adapter, MSR, val8);
 
@@ -1275,14 +1275,14 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 		usb_write8(Adapter, REG_DUAL_TSF_RST, BIT(0));
 
 		/* BIT3 - If set 0, hw will clr bcnq when tx becon ok/fail or port 0 */
-		usb_write8(Adapter, REG_MBID_NUM, rtw_read8(Adapter, REG_MBID_NUM) | BIT(3) | BIT(4));
+		usb_write8(Adapter, REG_MBID_NUM, usb_read8(Adapter, REG_MBID_NUM) | BIT(3) | BIT(4));
 
 		/* enable BCN0 Function for if1 */
 		/* don't enable update TSF0 for if1 (due to TSF update when beacon/probe rsp are received) */
 		usb_write8(Adapter, REG_BCN_CTRL, (DIS_TSF_UDT0_NORMAL_CHIP|EN_BCN_FUNCTION | BIT(1)));
 
 		/* dis BCN1 ATIM  WND if if2 is station */
-		usb_write8(Adapter, REG_BCN_CTRL_1, rtw_read8(Adapter, REG_BCN_CTRL_1) | BIT(0));
+		usb_write8(Adapter, REG_BCN_CTRL_1, usb_read8(Adapter, REG_BCN_CTRL_1) | BIT(0));
 	}
 }
 
@@ -1317,7 +1317,7 @@ static void hw_var_set_bcn_func(struct adapter *Adapter, u8 variable, u8 *val)
 	if (*((u8 *)val))
 		usb_write8(Adapter, bcn_ctrl_reg, (EN_BCN_FUNCTION | EN_TXBCN_RPT));
 	else
-		usb_write8(Adapter, bcn_ctrl_reg, rtw_read8(Adapter, bcn_ctrl_reg)&(~(EN_BCN_FUNCTION | EN_TXBCN_RPT)));
+		usb_write8(Adapter, bcn_ctrl_reg, usb_read8(Adapter, bcn_ctrl_reg)&(~(EN_BCN_FUNCTION | EN_TXBCN_RPT)));
 }
 
 static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
@@ -1331,7 +1331,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		{
 			u8 val8;
 
-			val8 = rtw_read8(Adapter, MSR)&0x0c;
+			val8 = usb_read8(Adapter, MSR)&0x0c;
 			val8 |= *((u8 *)val);
 			usb_write8(Adapter, MSR, val8);
 		}
@@ -1340,7 +1340,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		{
 			u8 val8;
 
-			val8 = rtw_read8(Adapter, MSR) & 0x03;
+			val8 = usb_read8(Adapter, MSR) & 0x03;
 			val8 |= *((u8 *)val) << 2;
 			usb_write8(Adapter, MSR, val8);
 		}
@@ -1378,7 +1378,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			/*  Set RRSR rate table. */
 			usb_write8(Adapter, REG_RRSR, BrateCfg & 0xff);
 			usb_write8(Adapter, REG_RRSR+1, (BrateCfg >> 8) & 0xff);
-			usb_write8(Adapter, REG_RRSR+2, rtw_read8(Adapter, REG_RRSR+2)&0xf0);
+			usb_write8(Adapter, REG_RRSR+2, usb_read8(Adapter, REG_RRSR+2)&0xf0);
 
 			/*  Set RTS initial rate */
 			while (BrateCfg > 0x1) {
@@ -1407,13 +1407,13 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				StopTxBeacon(Adapter);
 
 			/* disable related TSF function */
-			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(3)));
+			usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)&(~BIT(3)));
 
 			usb_write32(Adapter, REG_TSFTR, tsf);
 			usb_write32(Adapter, REG_TSFTR+4, tsf>>32);
 
 			/* enable related TSF function */
-			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(3));
+			usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)|BIT(3));
 
 			if (((pmlmeinfo->state&0x03) == WIFI_FW_ADHOC_STATE) || ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE))
 				ResumeTxBeacon(Adapter);
@@ -1441,7 +1441,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		usb_write8(Adapter, REG_DUAL_TSF_RST, (BIT(0)|BIT(1)));
 
 		/* disable update TSF */
-		usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+		usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 		break;
 	case HW_VAR_MLME_SITESURVEY:
 		if (*((u8 *)val)) { /* under sitesurvey */
@@ -1453,7 +1453,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
 			/* disable update TSF */
-			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+			usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 		} else { /* sitesurvey done */
 			struct mlme_ext_priv	*pmlmeext = &Adapter->mlmeextpriv;
 			struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
@@ -1464,11 +1464,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 
 				/* enable update TSF */
-				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			} else if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 				/* enable update TSF */
-				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			}
 			if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 				usb_write32(Adapter, REG_RCR, usb_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
@@ -1511,7 +1511,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			} else if (type == 2) {
 				/* sta add event call back */
 				/* enable update TSF */
-				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, usb_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 
 				if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE|WIFI_ADHOC_MASTER_STATE))
 					RetryLimit = 0x7;
@@ -1641,7 +1641,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 	case HW_VAR_ACM_CTRL:
 		{
 			u8 acm_ctrl = *((u8 *)val);
-			u8 AcmCtrl = rtw_read8(Adapter, REG_ACMHWCTRL);
+			u8 AcmCtrl = usb_read8(Adapter, REG_ACMHWCTRL);
 
 			if (acm_ctrl > 1)
 				AcmCtrl = AcmCtrl | 0x1;
@@ -1689,7 +1689,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				}
 				if (MinSpacingToSet < SecMinSpace)
 					MinSpacingToSet = SecMinSpace;
-				usb_write8(Adapter, REG_AMPDU_MIN_SPACE, (rtw_read8(Adapter, REG_AMPDU_MIN_SPACE) & 0xf8) | MinSpacingToSet);
+				usb_write8(Adapter, REG_AMPDU_MIN_SPACE, (usb_read8(Adapter, REG_AMPDU_MIN_SPACE) & 0xf8) | MinSpacingToSet);
 			}
 		}
 		break;
@@ -1838,7 +1838,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		break;
 	case HW_VAR_BCN_VALID:
 		/* BCN_VALID, BIT16 of REG_TDECTRL = BIT0 of REG_TDECTRL+2, write 1 to clear, Clear by sw */
-		usb_write8(Adapter, REG_TDECTRL+2, rtw_read8(Adapter, REG_TDECTRL+2) | BIT0);
+		usb_write8(Adapter, REG_TDECTRL+2, usb_read8(Adapter, REG_TDECTRL+2) | BIT0);
 		break;
 	default:
 		break;
@@ -1854,11 +1854,11 @@ static void GetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 	case HW_VAR_BASIC_RATE:
 		*((u16 *)(val)) = haldata->BasicRateSet;
 	case HW_VAR_TXPAUSE:
-		val[0] = rtw_read8(Adapter, REG_TXPAUSE);
+		val[0] = usb_read8(Adapter, REG_TXPAUSE);
 		break;
 	case HW_VAR_BCN_VALID:
 		/* BCN_VALID, BIT16 of REG_TDECTRL = BIT0 of REG_TDECTRL+2 */
-		val[0] = (BIT0 & rtw_read8(Adapter, REG_TDECTRL+2)) ? true : false;
+		val[0] = (BIT0 & usb_read8(Adapter, REG_TDECTRL+2)) ? true : false;
 		break;
 	case HW_VAR_DM_FLAG:
 		val[0] = podmpriv->SupportAbility;
@@ -2032,7 +2032,7 @@ static u8 SetHalDefVar8188EUsb(struct adapter *Adapter, enum hal_def_variable eV
 			} else if (dm_func == 6) {/* turn on all dynamic func */
 				if (!(podmpriv->SupportAbility  & DYNAMIC_BB_DIG)) {
 					struct rtw_dig *pDigTable = &podmpriv->DM_DigTable;
-					pDigTable->CurIGValue = rtw_read8(Adapter, 0xc50);
+					pDigTable->CurIGValue = usb_read8(Adapter, 0xc50);
 				}
 				podmpriv->SupportAbility = DYNAMIC_ALL_FUNC_ENABLE;
 				DBG_88E("==> Turn on all dynamic function...\n");
@@ -2184,7 +2184,7 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 
 	ResumeTxBeacon(adapt);
 
-	usb_write8(adapt, bcn_ctrl_reg, rtw_read8(adapt, bcn_ctrl_reg)|BIT(1));
+	usb_write8(adapt, bcn_ctrl_reg, usb_read8(adapt, bcn_ctrl_reg)|BIT(1));
 }
 
 static void rtl8188eu_init_default_value(struct adapter *adapt)
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d5d9288..d0c82dc 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -115,7 +115,7 @@ exit:
 	return status;
 }
 
-static u8 usb_read8(struct adapter *adapter, u32 addr)
+u8 usb_read8(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -666,5 +666,4 @@ void rtl8188eu_xmit_tasklet(void *priv)
 void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 {
 	_rtw_memset((u8 *)pops, 0, sizeof(struct _io_ops));
-	pops->_read8 = &usb_read8;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 63b1ff0..ef865da 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -44,7 +44,6 @@ struct intf_priv;
 struct intf_hdl;
 
 struct _io_ops {
-	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
 };
 
 struct io_req {
@@ -76,7 +75,7 @@ struct io_priv {
 	struct intf_hdl intf;
 };
 
-u8 _rtw_read8(struct adapter *adapter, u32 addr);
+u8 usb_read8(struct adapter *adapter, u32 addr);
 u16 usb_read16(struct adapter *adapter, u32 addr);
 u32 usb_read32(struct adapter *adapter, u32 addr);
 u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
@@ -90,7 +89,6 @@ int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_write_port_cancel(struct adapter *adapter);
 
-#define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index fd888cb..11b71ec 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2179,7 +2179,7 @@ static int rtw_wx_read32(struct net_device *dev,
 
 	switch (bytes) {
 	case 1:
-		data32 = rtw_read8(padapter, addr);
+		data32 = usb_read8(padapter, addr);
 		sprintf(extra, "0x%02X", data32);
 		break;
 	case 2:
@@ -2353,7 +2353,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 		RegRWStruct = (struct mp_rw_reg *)pdata;
 		switch (RegRWStruct->width) {
 		case 1:
-			RegRWStruct->value = rtw_read8(padapter, RegRWStruct->offset);
+			RegRWStruct->value = usb_read8(padapter, RegRWStruct->offset);
 			break;
 		case 2:
 			RegRWStruct->value = usb_read16(padapter, RegRWStruct->offset);
@@ -4109,7 +4109,7 @@ static int rtw_dbg_port(struct net_device *dev,
 	case 0x70:/* read_reg */
 		switch (minor_cmd) {
 		case 1:
-			DBG_88E("rtw_read8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
+			DBG_88E("usb_read8(0x%x) = 0x%02x\n", arg, usb_read8(padapter, arg));
 			break;
 		case 2:
 			DBG_88E("usb_read16(0x%x) = 0x%04x\n", arg, usb_read16(padapter, arg));
@@ -4123,7 +4123,7 @@ static int rtw_dbg_port(struct net_device *dev,
 		switch (minor_cmd) {
 		case 1:
 			usb_write8(padapter, arg, extra_arg);
-			DBG_88E("usb_write8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
+			DBG_88E("usb_write8(0x%x) = 0x%02x\n", arg, usb_read8(padapter, arg));
 			break;
 		case 2:
 			usb_write16(padapter, arg, extra_arg);
@@ -4227,7 +4227,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			if (_SUCCESS != rtw_IOL_exec_cmds_sync(padapter, xmit_frame, 5000, 0))
 				ret = -EPERM;
 
-			final = rtw_read8(padapter, reg);
+			final = usb_read8(padapter, reg);
 			if (start_value+write_num-1 == final)
 				DBG_88E("continuous IOL_CMD_WB_REG to 0x%x %u times Success, start:%u, final:%u\n", reg, write_num, start_value, final);
 			else
@@ -4577,13 +4577,13 @@ static int rtw_dbg_port(struct net_device *dev,
 
 		case 0xfd:
 			usb_write8(padapter, 0xc50, arg);
-			DBG_88E("wr(0xc50) = 0x%x\n", rtw_read8(padapter, 0xc50));
+			DBG_88E("wr(0xc50) = 0x%x\n", usb_read8(padapter, 0xc50));
 			usb_write8(padapter, 0xc58, arg);
-			DBG_88E("wr(0xc58) = 0x%x\n", rtw_read8(padapter, 0xc58));
+			DBG_88E("wr(0xc58) = 0x%x\n", usb_read8(padapter, 0xc58));
 			break;
 		case 0xfe:
-			DBG_88E("rd(0xc50) = 0x%x\n", rtw_read8(padapter, 0xc50));
-			DBG_88E("rd(0xc58) = 0x%x\n", rtw_read8(padapter, 0xc58));
+			DBG_88E("rd(0xc50) = 0x%x\n", usb_read8(padapter, 0xc50));
+			DBG_88E("rd(0xc58) = 0x%x\n", usb_read8(padapter, 0xc58));
 			break;
 		case 0xff:
 			DBG_88E("dbg(0x210) = 0x%x\n", usb_read32(padapter, 0x210));
@@ -6494,7 +6494,7 @@ static int rtw_mp_read_reg(struct net_device *dev,
 	switch (width) {
 	case 'b':
 		/*  1 byte */
-		sprintf(extra, "%d\n",  rtw_read8(padapter, addr));
+		sprintf(extra, "%d\n",  usb_read8(padapter, addr));
 		wrqu->length = strlen(extra);
 		break;
 	case 'w':
@@ -7078,7 +7078,7 @@ static int rtw_mp_arx(struct net_device *dev,
 		OFDM_FA = read_bbreg(padapter, 0xda4, 0x0000FFFF);
 		OFDM_FA = read_bbreg(padapter, 0xda4, 0xFFFF0000);
 		OFDM_FA = read_bbreg(padapter, 0xda8, 0x0000FFFF);
-		CCK_FA = (rtw_read8(padapter, 0xa5b)<<8) | (rtw_read8(padapter, 0xa5c));
+		CCK_FA = (usb_read8(padapter, 0xa5b)<<8) | (usb_read8(padapter, 0xa5c));
 
 		sprintf(extra, "Phy Received packet OK:%d CRC error:%d FA Counter: %d", cckok+ofdmok+htok, cckcrc+ofdmcrc+htcrc, OFDM_FA+CCK_FA);
 	}
-- 
1.7.10.4

