Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaFKRXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:48 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57741 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaFKRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/22] staging: rtl8188eu: Remove function _rtw_write8()
Date: Wed, 11 Jun 2014 22:51:33 +0530
Message-Id: <1402507301-3722-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_write8() is a wrapper function, being used to call usb_write8().
Call usb_write8() directly and drop _rtw_write8().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c         |    2 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |   26 +--
 drivers/staging/rtl8188eu/core/rtw_io.c            |   13 --
 drivers/staging/rtl8188eu/core/rtw_mp.c            |    6 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      |    2 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   18 +-
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c       |    2 +-
 drivers/staging/rtl8188eu/hal/hal_com.c            |    2 +-
 drivers/staging/rtl8188eu/hal/odm.c                |    2 +-
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |   28 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |   58 +++---
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c        |   32 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   10 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c      |    8 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |  216 ++++++++++----------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |    3 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         |    6 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   14 +-
 21 files changed, 218 insertions(+), 236 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index d13eed3..d204537 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -63,7 +63,7 @@ int proc_set_write_reg(struct file *file, const char __user *buffer,
 		}
 		switch (len) {
 		case 1:
-			rtw_write8(padapter, addr, (u8)val);
+			usb_write8(padapter, addr, (u8)val);
 			break;
 		case 2:
 			usb_write16(padapter, addr, (u16)val);
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 40afe48..513e9c6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -181,13 +181,13 @@ ReadEFuseByte(
 	}
 
 	/* Write Address */
-	rtw_write8(Adapter, EFUSE_CTRL+1, (_offset & 0xff));
+	usb_write8(Adapter, EFUSE_CTRL+1, (_offset & 0xff));
 	readbyte = rtw_read8(Adapter, EFUSE_CTRL+2);
-	rtw_write8(Adapter, EFUSE_CTRL+2, ((_offset >> 8) & 0x03) | (readbyte & 0xfc));
+	usb_write8(Adapter, EFUSE_CTRL+2, ((_offset >> 8) & 0x03) | (readbyte & 0xfc));
 
 	/* Write bit 32 0 */
 	readbyte = rtw_read8(Adapter, EFUSE_CTRL+3);
-	rtw_write8(Adapter, EFUSE_CTRL+3, (readbyte & 0x7f));
+	usb_write8(Adapter, EFUSE_CTRL+3, (readbyte & 0x7f));
 
 	/* Check bit 32 read-ready */
 	retry = 0;
@@ -263,16 +263,16 @@ u8 EFUSE_Read1Byte(struct adapter *Adapter, u16 Address)
 	if (Address < contentLen) {	/* E-fuse 512Byte */
 		/* Write E-fuse Register address bit0~7 */
 		temp = Address & 0xFF;
-		rtw_write8(Adapter, EFUSE_CTRL+1, temp);
+		usb_write8(Adapter, EFUSE_CTRL+1, temp);
 		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+2);
 		/* Write E-fuse Register address bit8~9 */
 		temp = ((Address >> 8) & 0x03) | (Bytetemp & 0xFC);
-		rtw_write8(Adapter, EFUSE_CTRL+2, temp);
+		usb_write8(Adapter, EFUSE_CTRL+2, temp);
 
 		/* Write 0x30[31]= 0 */
 		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+3);
 		temp = Bytetemp & 0x7F;
-		rtw_write8(Adapter, EFUSE_CTRL+3, temp);
+		usb_write8(Adapter, EFUSE_CTRL+3, temp);
 
 		/* Wait Write-ready (0x30[31]= 1) */
 		Bytetemp = rtw_read8(Adapter, EFUSE_CTRL+3);
@@ -304,11 +304,11 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data, bool pseudo)
 	}
 	/*  -----------------e-fuse reg ctrl --------------------------------- */
 	/* address */
-	rtw_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr & 0xff));
-	rtw_write8(pAdapter, EFUSE_CTRL+2, ((u8)((addr>>8) & 0x03)) |
+	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr & 0xff));
+	usb_write8(pAdapter, EFUSE_CTRL+2, ((u8)((addr>>8) & 0x03)) |
 		   (rtw_read8(pAdapter, EFUSE_CTRL+2) & 0xFC));
 
-	rtw_write8(pAdapter, EFUSE_CTRL+3,  0x72);/* read cmd */
+	usb_write8(pAdapter, EFUSE_CTRL+3,  0x72);/* read cmd */
 
 	while (!(0x80 & rtw_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
 		tmpidx++;
@@ -335,13 +335,13 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 
 	/*  -----------------e-fuse reg ctrl --------------------------------- */
 	/* address */
-	rtw_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr&0xff));
-	rtw_write8(pAdapter, EFUSE_CTRL+2,
+	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr&0xff));
+	usb_write8(pAdapter, EFUSE_CTRL+2,
 		   (rtw_read8(pAdapter, EFUSE_CTRL+2) & 0xFC) |
 		   (u8)((addr>>8) & 0x03));
-	rtw_write8(pAdapter, EFUSE_CTRL, data);/* data */
+	usb_write8(pAdapter, EFUSE_CTRL, data);/* data */
 
-	rtw_write8(pAdapter, EFUSE_CTRL+3, 0xF2);/* write cmd */
+	usb_write8(pAdapter, EFUSE_CTRL+3, 0xF2);/* write cmd */
 
 	while ((0x80 &  rtw_read8(pAdapter, EFUSE_CTRL+3)) && (tmpidx < 100))
 		tmpidx++;
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 8b11ac2..1da0936 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -88,19 +88,6 @@ u32 _rtw_read32(struct adapter *adapter, u32 addr)
 	return r_val;
 }
 
-int _rtw_write8(struct adapter *adapter, u32 addr, u8 val)
-{
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
-	int ret;
-	_write8 = pintfhdl->io_ops._write8;
-
-	ret = _write8(adapter, addr, val);
-
-	return RTW_STATUS_CODE(ret);
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 5c5e206..c199268 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -50,7 +50,7 @@ void write_macreg(struct adapter *padapter, u32 addr, u32 val, u32 sz)
 {
 	switch (sz) {
 	case 1:
-		rtw_write8(padapter, addr, (u8)val);
+		usb_write8(padapter, addr, (u8)val);
 		break;
 	case 2:
 		usb_write16(padapter, addr, (u16)val);
@@ -304,7 +304,7 @@ static void disable_dm(struct adapter *padapter)
 	/*  disable Power Training, Rate Adaptive */
 	v8 = rtw_read8(padapter, REG_BCN_CTRL);
 	v8 &= ~EN_BCN_FUNCTION;
-	rtw_write8(padapter, REG_BCN_CTRL, v8);
+	usb_write8(padapter, REG_BCN_CTRL, v8);
 
 	/* 3 2. disable driver dynamic mechanism */
 	/*  disable Dynamic Initial Gain */
@@ -423,7 +423,7 @@ end_of_mp_start_test:
 		/*  set MSR to WIFI_FW_ADHOC_STATE */
 		val8 = rtw_read8(padapter, MSR) & 0xFC; /*  0x0102 */
 		val8 |= WIFI_FW_ADHOC_STATE;
-		rtw_write8(padapter, MSR, val8); /*  Link in ad hoc network */
+		usb_write8(padapter, MSR, val8); /*  Link in ad hoc network */
 	}
 	return res;
 }
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index 8aac515..ebb97e8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -853,7 +853,7 @@ int rtl8188eu_oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 			status = NDIS_STATUS_NOT_ACCEPTED;
 			break;
 		}
-		rtw_write8(padapter, offset, (u8)value);
+		usb_write8(padapter, offset, (u8)value);
 		break;
 	case 2:
 		if (value > 0xFFFF) {
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 59bd949..514d325 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -848,7 +848,7 @@ _PHY_ReloadMACRegisters(
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("Reload MAC parameters !\n"));
 	for (i = 0; i < (IQK_MAC_REG_NUM - 1); i++) {
-		rtw_write8(adapt, MACReg[i], (u8)MACBackup[i]);
+		usb_write8(adapt, MACReg[i], (u8)MACBackup[i]);
 	}
 	usb_write32(adapt, MACReg[i], MACBackup[i]);
 }
@@ -892,12 +892,12 @@ _PHY_MACSettingCalibration(
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("MAC settings for Calibration.\n"));
 
-	rtw_write8(adapt, MACReg[i], 0x3F);
+	usb_write8(adapt, MACReg[i], 0x3F);
 
 	for (i = 1; i < (IQK_MAC_REG_NUM - 1); i++) {
-		rtw_write8(adapt, MACReg[i], (u8)(MACBackup[i]&(~BIT3)));
+		usb_write8(adapt, MACReg[i], (u8)(MACBackup[i]&(~BIT3)));
 	}
-	rtw_write8(adapt, MACReg[i], (u8)(MACBackup[i]&(~BIT5)));
+	usb_write8(adapt, MACReg[i], (u8)(MACBackup[i]&(~BIT5)));
 }
 
 void
@@ -1208,9 +1208,9 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 	tmpreg = rtw_read8(adapt, 0xd03);
 
 	if ((tmpreg&0x70) != 0)			/* Deal with contisuous TX case */
-		rtw_write8(adapt, 0xd03, tmpreg&0x8F);	/* disable all continuous TX */
+		usb_write8(adapt, 0xd03, tmpreg&0x8F);	/* disable all continuous TX */
 	else							/*  Deal with Packet TX case */
-		rtw_write8(adapt, REG_TXPAUSE, 0xFF);			/*  block all queues */
+		usb_write8(adapt, REG_TXPAUSE, 0xFF);			/*  block all queues */
 
 	if ((tmpreg&0x70) != 0) {
 		/* 1. Read original RF mode */
@@ -1242,7 +1242,7 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 	if ((tmpreg&0x70) != 0) {
 		/* Deal with continuous TX case */
 		/* Path-A */
-		rtw_write8(adapt, 0xd03, tmpreg);
+		usb_write8(adapt, 0xd03, tmpreg);
 		PHY_SetRFReg(adapt, RF_PATH_A, RF_AC, bMask12Bits, RF_Amode);
 
 		/* Path-B */
@@ -1250,7 +1250,7 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 			PHY_SetRFReg(adapt, RF_PATH_B, RF_AC, bMask12Bits, RF_Bmode);
 	} else {
 		/*  Deal with Packet TX case */
-		rtw_write8(adapt, REG_TXPAUSE, 0x00);
+		usb_write8(adapt, REG_TXPAUSE, 0x00);
 	}
 }
 
@@ -1447,7 +1447,7 @@ static void phy_setrfpathswitch_8188e(struct adapter *adapt, bool main, bool is2
 	if (!adapt->hw_init_completed) {
 		u8 u1btmp;
 		u1btmp = rtw_read8(adapt, REG_LEDCFG2) | BIT7;
-		rtw_write8(adapt, REG_LEDCFG2, u1btmp);
+		usb_write8(adapt, REG_LEDCFG2, u1btmp);
 		PHY_SetBBReg(adapt, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 	}
 
diff --git a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
index 50f9513..d90c544 100644
--- a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
+++ b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
@@ -86,7 +86,7 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) & GET_PWR_CFG_MASK(pwrcfgcmd));
 
 				/*  Write the value back to system register */
-				rtw_write8(padapter, offset, value);
+				usb_write8(padapter, offset, value);
 				break;
 			case PWR_CMD_POLLING:
 				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_POLLING\n"));
diff --git a/drivers/staging/rtl8188eu/hal/hal_com.c b/drivers/staging/rtl8188eu/hal/hal_com.c
index 829b900..f69dbf9 100644
--- a/drivers/staging/rtl8188eu/hal/hal_com.c
+++ b/drivers/staging/rtl8188eu/hal/hal_com.c
@@ -328,7 +328,7 @@ void hal_init_macaddr(struct adapter *adapter)
 
 void c2h_evt_clear(struct adapter *adapter)
 {
-	rtw_write8(adapter, REG_C2HEVT_CLEAR, C2H_EVT_HOST_CLOSE);
+	usb_write8(adapter, REG_C2HEVT_CLEAR, C2H_EVT_HOST_CLOSE);
 }
 
 s32 c2h_evt_read(struct adapter *adapter, u8 *buf)
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index dfab77e..11101f3 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -833,7 +833,7 @@ void ODM_Write_CCK_CCA_Thres(struct odm_dm_struct *pDM_Odm, u8 CurCCK_CCAThres)
 	struct adapter *adapt = pDM_Odm->Adapter;
 
 	if (pDM_DigTable->CurCCK_CCAThres != CurCCK_CCAThres)		/* modify by Guo.Mingzhi 2012-01-03 */
-		rtw_write8(adapt, ODM_REG_CCK_CCA_11N, CurCCK_CCAThres);
+		usb_write8(adapt, ODM_REG_CCK_CCA_11N, CurCCK_CCAThres);
 	pDM_DigTable->PreCCK_CCAThres = pDM_DigTable->CurCCK_CCAThres;
 	pDM_DigTable->CurCCK_CCAThres = CurCCK_CCAThres;
 }
diff --git a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
index a988612..4d4978b 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
@@ -68,7 +68,7 @@ void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data)
 {
 	struct adapter *adapt = pDM_Odm->Adapter;
 
-	rtw_write8(adapt, Addr, Data);
+	usb_write8(adapt, Addr, Data);
 	ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE, ("===> ODM_ConfigMACWithHeaderFile: [MAC_REG] %08X %08X\n", Addr, Data));
 }
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 73277b9..17ab11b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -106,13 +106,13 @@ static s32 FillH2CCmd_88E(struct adapter *adapt, u8 ElementID, u32 CmdLen, u8 *p
 			/* Write Ext command */
 			msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * RTL88E_EX_MESSAGE_BOX_SIZE);
 			for (cmd_idx = 0; cmd_idx < ext_cmd_len; cmd_idx++) {
-				rtw_write8(adapt, msgbox_ex_addr+cmd_idx, *((u8 *)(&h2c_cmd_ex)+cmd_idx));
+				usb_write8(adapt, msgbox_ex_addr+cmd_idx, *((u8 *)(&h2c_cmd_ex)+cmd_idx));
 			}
 		}
 		/*  Write command */
 		msgbox_addr = REG_HMEBOX_0 + (h2c_box_num * RTL88E_MESSAGE_BOX_SIZE);
 		for (cmd_idx = 0; cmd_idx < RTL88E_MESSAGE_BOX_SIZE; cmd_idx++) {
-			rtw_write8(adapt, msgbox_addr+cmd_idx, *((u8 *)(&h2c_cmd)+cmd_idx));
+			usb_write8(adapt, msgbox_addr+cmd_idx, *((u8 *)(&h2c_cmd)+cmd_idx));
 		}
 		bcmd_down = true;
 
@@ -620,13 +620,13 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 
 		/* Set REG_CR bit 8. DMA beacon by SW. */
 		haldata->RegCR_1 |= BIT0;
-		rtw_write8(adapt,  REG_CR+1, haldata->RegCR_1);
+		usb_write8(adapt,  REG_CR+1, haldata->RegCR_1);
 
 		/*  Disable Hw protection for a time which revserd for Hw sending beacon. */
 		/*  Fix download reserved page packet fail that access collision with the protection time. */
 		/*  2010.05.11. Added by tynli. */
-		rtw_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(3)));
-		rtw_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(4));
+		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(3)));
+		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(4));
 
 		if (haldata->RegFwHwTxQCtrl&BIT6) {
 			DBG_88E("HalDownloadRSVDPage(): There is an Adapter is sending beacon.\n");
@@ -634,7 +634,7 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		}
 
 		/*  Set FWHW_TXQ_CTRL 0x422[6]=0 to tell Hw the packet is not a real beacon frame. */
-		rtw_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl&(~BIT6)));
+		usb_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl&(~BIT6)));
 		haldata->RegFwHwTxQCtrl &= (~BIT6);
 
 		/*  Clear beacon valid check bit. */
@@ -668,8 +668,8 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		/*  */
 
 		/*  Enable Bcn */
-		rtw_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(3));
-		rtw_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(4)));
+		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)|BIT(3));
+		usb_write8(adapt, REG_BCN_CTRL, rtw_read8(adapt, REG_BCN_CTRL)&(~BIT(4)));
 
 		/*  To make sure that if there exists an adapter which would like to send beacon. */
 		/*  If exists, the origianl value of 0x422[6] will be 1, we should check this to */
@@ -677,7 +677,7 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		/*  the beacon cannot be sent by HW. */
 		/*  2010.06.23. Added by tynli. */
 		if (bSendBeacon) {
-			rtw_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl|BIT6));
+			usb_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl|BIT6));
 			haldata->RegFwHwTxQCtrl |= BIT6;
 		}
 
@@ -690,7 +690,7 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		/*  Do not enable HW DMA BCN or it will cause Pcie interface hang by timing issue. 2011.11.24. by tynli. */
 		/*  Clear CR[8] or beacon packet will not be send to TxBuf anymore. */
 		haldata->RegCR_1 &= (~BIT0);
-		rtw_write8(adapt,  REG_CR+1, haldata->RegCR_1);
+		usb_write8(adapt,  REG_CR+1, haldata->RegCR_1);
 	}
 }
 
@@ -713,13 +713,13 @@ void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state)
 		/*  update CTWindow value. */
 		if (pwdinfo->ctwindow > 0) {
 			p2p_ps_offload->CTWindow_En = 1;
-			rtw_write8(adapt, REG_P2P_CTWIN, pwdinfo->ctwindow);
+			usb_write8(adapt, REG_P2P_CTWIN, pwdinfo->ctwindow);
 		}
 
 		/*  hw only support 2 set of NoA */
 		for (i = 0; i < pwdinfo->noa_num; i++) {
 			/*  To control the register setting for which NOA */
-			rtw_write8(adapt, REG_NOA_DESC_SEL, (i << 4));
+			usb_write8(adapt, REG_NOA_DESC_SEL, (i << 4));
 			if (i == 0)
 				p2p_ps_offload->NoA0_En = 1;
 			else
@@ -729,12 +729,12 @@ void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state)
 			usb_write32(adapt, REG_NOA_DESC_DURATION, pwdinfo->noa_duration[i]);
 			usb_write32(adapt, REG_NOA_DESC_INTERVAL, pwdinfo->noa_interval[i]);
 			usb_write32(adapt, REG_NOA_DESC_START, pwdinfo->noa_start_time[i]);
-			rtw_write8(adapt, REG_NOA_DESC_COUNT, pwdinfo->noa_count[i]);
+			usb_write8(adapt, REG_NOA_DESC_COUNT, pwdinfo->noa_count[i]);
 		}
 
 		if ((pwdinfo->opp_ps == 1) || (pwdinfo->noa_num > 0)) {
 			/*  rst p2p circuit */
-			rtw_write8(adapt, REG_DUAL_TSF_RST, BIT(4));
+			usb_write8(adapt, REG_DUAL_TSF_RST, BIT(4));
 
 			p2p_ps_offload->Offload_En = 1;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index d5cd30b..65cf139 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -39,7 +39,7 @@ static void dm_InitGPIOSetting(struct adapter *Adapter)
 	tmp1byte = rtw_read8(Adapter, REG_GPIO_MUXCFG);
 	tmp1byte &= (GPIOSEL_GPIO | ~GPIOSEL_ENBT);
 
-	rtw_write8(Adapter, REG_GPIO_MUXCFG, tmp1byte);
+	usb_write8(Adapter, REG_GPIO_MUXCFG, tmp1byte);
 }
 
 /*  */
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 5b627d1..71a2417 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -37,7 +37,7 @@ static void iol_mode_enable(struct adapter *padapter, u8 enable)
 	if (enable) {
 		/* Enable initial offload */
 		reg_0xf0 = rtw_read8(padapter, REG_SYS_CFG);
-		rtw_write8(padapter, REG_SYS_CFG, reg_0xf0|SW_OFFLOAD_EN);
+		usb_write8(padapter, REG_SYS_CFG, reg_0xf0|SW_OFFLOAD_EN);
 
 		if (!padapter->bFWReady) {
 			DBG_88E("bFWReady == false call reset 8051...\n");
@@ -47,7 +47,7 @@ static void iol_mode_enable(struct adapter *padapter, u8 enable)
 	} else {
 		/* disable initial offload */
 		reg_0xf0 = rtw_read8(padapter, REG_SYS_CFG);
-		rtw_write8(padapter, REG_SYS_CFG, reg_0xf0 & ~SW_OFFLOAD_EN);
+		usb_write8(padapter, REG_SYS_CFG, reg_0xf0 & ~SW_OFFLOAD_EN);
 	}
 }
 
@@ -59,7 +59,7 @@ static s32 iol_execute(struct adapter *padapter, u8 control)
 
 	control = control&0x0f;
 	reg_0x88 = rtw_read8(padapter, REG_HMEBOX_E0);
-	rtw_write8(padapter, REG_HMEBOX_E0,  reg_0x88|control);
+	usb_write8(padapter, REG_HMEBOX_E0,  reg_0x88|control);
 
 	start = jiffies;
 	while ((reg_0x88 = rtw_read8(padapter, REG_HMEBOX_E0)) & control &&
@@ -78,7 +78,7 @@ static s32 iol_InitLLTTable(struct adapter *padapter, u8 txpktbuf_bndy)
 {
 	s32 rst = _SUCCESS;
 	iol_mode_enable(padapter, 1);
-	rtw_write8(padapter, REG_TDECTRL+1, txpktbuf_bndy);
+	usb_write8(padapter, REG_TDECTRL+1, txpktbuf_bndy);
 	rst = iol_execute(padapter, CMD_INIT_LLT);
 	iol_mode_enable(padapter, 0);
 	return rst;
@@ -231,14 +231,14 @@ static void efuse_read_phymap_from_txpktbuf(
 
 	DBG_88E("%s bcnhead:%d\n", __func__, bcnhead);
 
-	rtw_write8(adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
+	usb_write8(adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
 
 	dbg_addr = bcnhead*128/8; /* 8-bytes addressing */
 
 	while (1) {
 		usb_write16(adapter, REG_PKTBUF_DBG_ADDR, dbg_addr+i);
 
-		rtw_write8(adapter, REG_TXPKTBUF_DBG, 0);
+		usb_write8(adapter, REG_TXPKTBUF_DBG, 0);
 		start = jiffies;
 		while (!(reg_0x143 = rtw_read8(adapter, REG_TXPKTBUF_DBG)) &&
 		       (passing_time = rtw_get_passing_time_ms(start)) < 1000) {
@@ -285,7 +285,7 @@ static void efuse_read_phymap_from_txpktbuf(
 			break;
 		i++;
 	}
-	rtw_write8(adapter, REG_PKT_BUFF_ACCESS_CTRL, DISABLE_TRXPKT_BUF_ACCESS);
+	usb_write8(adapter, REG_PKT_BUFF_ACCESS_CTRL, DISABLE_TRXPKT_BUF_ACCESS);
 	DBG_88E("%s read count:%u\n", __func__, count);
 	*size = count;
 }
@@ -296,9 +296,9 @@ static s32 iol_read_efuse(struct adapter *padapter, u8 txpktbuf_bndy, u16 offset
 	u8 physical_map[512];
 	u16 size = 512;
 
-	rtw_write8(padapter, REG_TDECTRL+1, txpktbuf_bndy);
+	usb_write8(padapter, REG_TDECTRL+1, txpktbuf_bndy);
 	_rtw_memset(physical_map, 0xFF, 512);
-	rtw_write8(padapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
+	usb_write8(padapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
 	status = iol_execute(padapter, CMD_READ_EFUSE_MAP);
 	if (status == _SUCCESS)
 		efuse_read_phymap_from_txpktbuf(padapter, txpktbuf_bndy, physical_map, &size);
@@ -326,7 +326,7 @@ static s32 iol_ioconfig(struct adapter *padapter, u8 iocfg_bndy)
 {
 	s32 rst = _SUCCESS;
 
-	rtw_write8(padapter, REG_TDECTRL+1, iocfg_bndy);
+	usb_write8(padapter, REG_TDECTRL+1, iocfg_bndy);
 	rst = iol_execute(padapter, CMD_IOCONFIG);
 	return rst;
 }
@@ -357,7 +357,7 @@ static int rtl8188e_IOL_exec_cmds_sync(struct adapter *adapter, struct xmit_fram
 	iol_mode_enable(adapter, 0);
 exit:
 	/* restore BCN_HEAD */
-	rtw_write8(adapter, REG_TDECTRL+1, 0);
+	usb_write8(adapter, REG_TDECTRL+1, 0);
 	return ret;
 }
 
@@ -369,7 +369,7 @@ void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter *Adapter, int data_len)
 	u8 *pbuf = vzalloc(data_len+10);
 	DBG_88E("###### %s ######\n", __func__);
 
-	rtw_write8(Adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
+	usb_write8(Adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
 	if (pbuf) {
 		for (addr = 0; addr < data_cnts; addr++) {
 			usb_write32(Adapter, 0x140, addr);
@@ -400,18 +400,18 @@ static void _FWDownloadEnable(struct adapter *padapter, bool enable)
 	if (enable) {
 		/*  MCU firmware download enable. */
 		tmp = rtw_read8(padapter, REG_MCUFWDL);
-		rtw_write8(padapter, REG_MCUFWDL, tmp | 0x01);
+		usb_write8(padapter, REG_MCUFWDL, tmp | 0x01);
 
 		/*  8051 reset */
 		tmp = rtw_read8(padapter, REG_MCUFWDL+2);
-		rtw_write8(padapter, REG_MCUFWDL+2, tmp&0xf7);
+		usb_write8(padapter, REG_MCUFWDL+2, tmp&0xf7);
 	} else {
 		/*  MCU firmware download disable. */
 		tmp = rtw_read8(padapter, REG_MCUFWDL);
-		rtw_write8(padapter, REG_MCUFWDL, tmp&0xfe);
+		usb_write8(padapter, REG_MCUFWDL, tmp&0xfe);
 
 		/*  Reserved for fw extension. */
-		rtw_write8(padapter, REG_MCUFWDL+1, 0x00);
+		usb_write8(padapter, REG_MCUFWDL+1, 0x00);
 	}
 }
 
@@ -478,7 +478,7 @@ static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
 			 (buffSize-offset), blockSize_p3, blockCount_p3));
 
 		for (i = 0; i < blockCount_p3; i++) {
-			ret = rtw_write8(padapter, (FW_8188E_START_ADDRESS + offset + i), *(bufferPtr + offset + i));
+			ret = usb_write8(padapter, (FW_8188E_START_ADDRESS + offset + i), *(bufferPtr + offset + i));
 
 			if (ret == _FAIL)
 				goto exit;
@@ -495,7 +495,7 @@ static int _PageWrite(struct adapter *padapter, u32 page, void *buffer, u32 size
 	u8 u8Page = (u8)(page & 0x07);
 
 	value8 = (rtw_read8(padapter, REG_MCUFWDL+2) & 0xF8) | u8Page;
-	rtw_write8(padapter, REG_MCUFWDL+2, value8);
+	usb_write8(padapter, REG_MCUFWDL+2, value8);
 
 	return _BlockWrite(padapter, buffer, size);
 }
@@ -537,8 +537,8 @@ void _8051Reset88E(struct adapter *padapter)
 	u8 u1bTmp;
 
 	u1bTmp = rtw_read8(padapter, REG_SYS_FUNC_EN+1);
-	rtw_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp&(~BIT2));
-	rtw_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp|(BIT2));
+	usb_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp&(~BIT2));
+	usb_write8(padapter, REG_SYS_FUNC_EN+1, u1bTmp|(BIT2));
 	DBG_88E("=====> _8051Reset88E(): 8051 reset success .\n");
 }
 
@@ -667,7 +667,7 @@ s32 rtl8188e_FirmwareDownload(struct adapter *padapter)
 	/*  Suggested by Filen. If 8051 is running in RAM code, driver should inform Fw to reset by itself, */
 	/*  or it will cause download Fw fail. 2010.02.01. by tynli. */
 	if (rtw_read8(padapter, REG_MCUFWDL) & RAM_DL_SEL) { /* 8051 RAM code */
-		rtw_write8(padapter, REG_MCUFWDL, 0x00);
+		usb_write8(padapter, REG_MCUFWDL, 0x00);
 		_8051Reset88E(padapter);
 	}
 
@@ -675,7 +675,7 @@ s32 rtl8188e_FirmwareDownload(struct adapter *padapter)
 	fwdl_start_time = jiffies;
 	while (1) {
 		/* reset the FWDL chksum */
-		rtw_write8(padapter, REG_MCUFWDL, rtw_read8(padapter, REG_MCUFWDL) | FWDL_ChkSum_rpt);
+		usb_write8(padapter, REG_MCUFWDL, rtw_read8(padapter, REG_MCUFWDL) | FWDL_ChkSum_rpt);
 
 		rtStatus = _WriteFW(padapter, pFirmwareBuf, FirmwareLen);
 
@@ -760,7 +760,7 @@ hal_EfusePowerSwitch_RTL8188E(
 	u16	tmpV16;
 
 	if (PwrState) {
-		rtw_write8(pAdapter, REG_EFUSE_ACCESS, EFUSE_ACCESS_ON);
+		usb_write8(pAdapter, REG_EFUSE_ACCESS, EFUSE_ACCESS_ON);
 
 		/*  1.2V Power: From VDDON with Power Cut(0x0000h[15]), defualt valid */
 		tmpV16 = rtw_read16(pAdapter, REG_SYS_ISO_CTRL);
@@ -787,15 +787,15 @@ hal_EfusePowerSwitch_RTL8188E(
 			tempval = rtw_read8(pAdapter, EFUSE_TEST+3);
 			tempval &= 0x0F;
 			tempval |= (VOLTAGE_V25 << 4);
-			rtw_write8(pAdapter, EFUSE_TEST+3, (tempval | 0x80));
+			usb_write8(pAdapter, EFUSE_TEST+3, (tempval | 0x80));
 		}
 	} else {
-		rtw_write8(pAdapter, REG_EFUSE_ACCESS, EFUSE_ACCESS_OFF);
+		usb_write8(pAdapter, REG_EFUSE_ACCESS, EFUSE_ACCESS_OFF);
 
 		if (bWrite) {
 			/*  Disable LDO 2.5V after read/write action */
 			tempval = rtw_read8(pAdapter, EFUSE_TEST+3);
-			rtw_write8(pAdapter, EFUSE_TEST+3, (tempval & 0x7F));
+			usb_write8(pAdapter, EFUSE_TEST+3, (tempval & 0x7F));
 		}
 	}
 }
@@ -1827,10 +1827,10 @@ static void hal_notch_filter_8188e(struct adapter *adapter, bool enable)
 {
 	if (enable) {
 		DBG_88E("Enable notch filter\n");
-		rtw_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) | BIT1);
+		usb_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) | BIT1);
 	} else {
 		DBG_88E("Disable notch filter\n");
-		rtw_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) & ~BIT1);
+		usb_write8(adapter, rOFDM0_RxDSP+1, rtw_read8(adapter, rOFDM0_RxDSP+1) & ~BIT1);
 	}
 }
 void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
@@ -2379,5 +2379,5 @@ void SetBcnCtrlReg(struct adapter *padapter, u8 SetBits, u8 ClearBits)
 	pHalData->RegBcnCtrlVal |= SetBits;
 	pHalData->RegBcnCtrlVal &= ~ClearBits;
 
-	rtw_write8(padapter, REG_BCN_CTRL, (u8)pHalData->RegBcnCtrlVal);
+	usb_write8(padapter, REG_BCN_CTRL, (u8)pHalData->RegBcnCtrlVal);
 }
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_mp.c b/drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
index a4d057c..1e94250 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
@@ -201,23 +201,23 @@ void Hal_MPT_CCKTxPowerAdjustbyIndex(struct adapter *pAdapter, bool beven)
 			CCK_index = 32;
 		/* Adjust CCK according to gain index */
 		if (!pDM_Odm->RFCalibrateInfo.bCCKinCH14) {
-			rtw_write8(pAdapter, 0xa22, CCKSwingTable_Ch1_Ch13[CCK_index][0]);
-			rtw_write8(pAdapter, 0xa23, CCKSwingTable_Ch1_Ch13[CCK_index][1]);
-			rtw_write8(pAdapter, 0xa24, CCKSwingTable_Ch1_Ch13[CCK_index][2]);
-			rtw_write8(pAdapter, 0xa25, CCKSwingTable_Ch1_Ch13[CCK_index][3]);
-			rtw_write8(pAdapter, 0xa26, CCKSwingTable_Ch1_Ch13[CCK_index][4]);
-			rtw_write8(pAdapter, 0xa27, CCKSwingTable_Ch1_Ch13[CCK_index][5]);
-			rtw_write8(pAdapter, 0xa28, CCKSwingTable_Ch1_Ch13[CCK_index][6]);
-			rtw_write8(pAdapter, 0xa29, CCKSwingTable_Ch1_Ch13[CCK_index][7]);
+			usb_write8(pAdapter, 0xa22, CCKSwingTable_Ch1_Ch13[CCK_index][0]);
+			usb_write8(pAdapter, 0xa23, CCKSwingTable_Ch1_Ch13[CCK_index][1]);
+			usb_write8(pAdapter, 0xa24, CCKSwingTable_Ch1_Ch13[CCK_index][2]);
+			usb_write8(pAdapter, 0xa25, CCKSwingTable_Ch1_Ch13[CCK_index][3]);
+			usb_write8(pAdapter, 0xa26, CCKSwingTable_Ch1_Ch13[CCK_index][4]);
+			usb_write8(pAdapter, 0xa27, CCKSwingTable_Ch1_Ch13[CCK_index][5]);
+			usb_write8(pAdapter, 0xa28, CCKSwingTable_Ch1_Ch13[CCK_index][6]);
+			usb_write8(pAdapter, 0xa29, CCKSwingTable_Ch1_Ch13[CCK_index][7]);
 		} else {
-			rtw_write8(pAdapter, 0xa22, CCKSwingTable_Ch14[CCK_index][0]);
-			rtw_write8(pAdapter, 0xa23, CCKSwingTable_Ch14[CCK_index][1]);
-			rtw_write8(pAdapter, 0xa24, CCKSwingTable_Ch14[CCK_index][2]);
-			rtw_write8(pAdapter, 0xa25, CCKSwingTable_Ch14[CCK_index][3]);
-			rtw_write8(pAdapter, 0xa26, CCKSwingTable_Ch14[CCK_index][4]);
-			rtw_write8(pAdapter, 0xa27, CCKSwingTable_Ch14[CCK_index][5]);
-			rtw_write8(pAdapter, 0xa28, CCKSwingTable_Ch14[CCK_index][6]);
-			rtw_write8(pAdapter, 0xa29, CCKSwingTable_Ch14[CCK_index][7]);
+			usb_write8(pAdapter, 0xa22, CCKSwingTable_Ch14[CCK_index][0]);
+			usb_write8(pAdapter, 0xa23, CCKSwingTable_Ch14[CCK_index][1]);
+			usb_write8(pAdapter, 0xa24, CCKSwingTable_Ch14[CCK_index][2]);
+			usb_write8(pAdapter, 0xa25, CCKSwingTable_Ch14[CCK_index][3]);
+			usb_write8(pAdapter, 0xa26, CCKSwingTable_Ch14[CCK_index][4]);
+			usb_write8(pAdapter, 0xa27, CCKSwingTable_Ch14[CCK_index][5]);
+			usb_write8(pAdapter, 0xa28, CCKSwingTable_Ch14[CCK_index][6]);
+			usb_write8(pAdapter, 0xa29, CCKSwingTable_Ch14[CCK_index][7]);
 		}
 	}
 }
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 178cf8b..e18a010 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -608,9 +608,9 @@ PHY_BBConfig8188E(
 
 	/*  20090923 Joseph: Advised by Steven and Jenyu. Power sequence before init RF. */
 
-	rtw_write8(Adapter, REG_RF_CTRL, RF_EN|RF_RSTB|RF_SDMRSTB);
+	usb_write8(Adapter, REG_RF_CTRL, RF_EN|RF_RSTB|RF_SDMRSTB);
 
-	rtw_write8(Adapter, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD | FEN_BB_GLB_RSTn | FEN_BBRSTB);
+	usb_write8(Adapter, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD | FEN_BB_GLB_RSTn | FEN_BBRSTB);
 
 	/*  Config BB and AGC */
 	rtStatus = phy_BB8188E_Config_ParaFile(Adapter);
@@ -799,14 +799,14 @@ _PHY_SetBWMode92C(
 	case HT_CHANNEL_WIDTH_20:
 		regBwOpMode |= BW_OPMODE_20MHZ;
 		/*  2007/02/07 Mark by Emily because we have not verify whether this register works */
-		rtw_write8(Adapter, REG_BWOPMODE, regBwOpMode);
+		usb_write8(Adapter, REG_BWOPMODE, regBwOpMode);
 		break;
 	case HT_CHANNEL_WIDTH_40:
 		regBwOpMode &= ~BW_OPMODE_20MHZ;
 		/*  2007/02/07 Mark by Emily because we have not verify whether this register works */
-		rtw_write8(Adapter, REG_BWOPMODE, regBwOpMode);
+		usb_write8(Adapter, REG_BWOPMODE, regBwOpMode);
 		regRRSR_RSC = (regRRSR_RSC&0x90) | (pHalData->nCur40MhzPrimeSC<<5);
-		rtw_write8(Adapter, REG_RRSR+2, regRRSR_RSC);
+		usb_write8(Adapter, REG_RRSR+2, regRRSR_RSC);
 		break;
 	default:
 		break;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 52103da..8ce9d0e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -366,7 +366,7 @@ static void writeOFDMPowerReg88E(struct adapter *Adapter, u8 index, u32 *pValue)
 					writeVal = (writeVal > 8) ? (writeVal-8) : 0;
 				else
 					writeVal = (writeVal > 6) ? (writeVal-6) : 0;
-				rtw_write8(Adapter, (u32)(regoffset+i), (u8)writeVal);
+				usb_write8(Adapter, (u32)(regoffset+i), (u8)writeVal);
 			}
 		}
 	}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index 77dce58..3971b70 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -35,7 +35,7 @@ void SwLedOn(struct adapter *padapter, struct LED_871x *pLed)
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped)
 		return;
 	LedCfg = rtw_read8(padapter, REG_LEDCFG2);
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg&0xf0)|BIT5|BIT6); /*  SW control led0 on. */
+	usb_write8(padapter, REG_LEDCFG2, (LedCfg&0xf0)|BIT5|BIT6); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
 
@@ -54,12 +54,12 @@ void SwLedOff(struct adapter *padapter, struct LED_871x *pLed)
 	if (pHalData->bLedOpenDrain) {
 			/*  Open-drain arrangement for controlling the LED) */
 		LedCfg &= 0x90; /*  Set to software control. */
-		rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3));
+		usb_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3));
 		LedCfg = rtw_read8(padapter, REG_MAC_PINMUX_CFG);
 		LedCfg &= 0xFE;
-		rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
+		usb_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
 	} else {
-		rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3|BIT5|BIT6));
+		usb_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3|BIT5|BIT6));
 	}
 exit:
 	pLed->bLedOn = false;
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 3615a60..ef45817 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -159,7 +159,7 @@ static void _InitInterrupt(struct adapter *Adapter)
 	else
 		usb_opt = usb_opt | (INT_BULK_SEL);
 
-	rtw_write8(Adapter, REG_USB_SPECIAL_OPTION, usb_opt);
+	usb_write8(Adapter, REG_USB_SPECIAL_OPTION, usb_opt);
 }
 
 static void _InitQueueReservedPage(struct adapter *Adapter)
@@ -185,7 +185,7 @@ static void _InitQueueReservedPage(struct adapter *Adapter)
 		if (haldata->OutEpQueueSel & TX_SELE_NQ)
 			numNQ = 0x1C;
 		value8 = (u8)_NPQ(numNQ);
-		rtw_write8(Adapter, REG_RQPN_NPQ, value8);
+		usb_write8(Adapter, REG_RQPN_NPQ, value8);
 
 		numPubQ = 0xA8 - numHQ - numLQ - numNQ;
 
@@ -201,11 +201,11 @@ static void _InitQueueReservedPage(struct adapter *Adapter)
 
 static void _InitTxBufferBoundary(struct adapter *Adapter, u8 txpktbuf_bndy)
 {
-	rtw_write8(Adapter, REG_TXPKTBUF_BCNQ_BDNY, txpktbuf_bndy);
-	rtw_write8(Adapter, REG_TXPKTBUF_MGQ_BDNY, txpktbuf_bndy);
-	rtw_write8(Adapter, REG_TXPKTBUF_WMAC_LBK_BF_HD, txpktbuf_bndy);
-	rtw_write8(Adapter, REG_TRXFF_BNDY, txpktbuf_bndy);
-	rtw_write8(Adapter, REG_TDECTRL+1, txpktbuf_bndy);
+	usb_write8(Adapter, REG_TXPKTBUF_BCNQ_BDNY, txpktbuf_bndy);
+	usb_write8(Adapter, REG_TXPKTBUF_MGQ_BDNY, txpktbuf_bndy);
+	usb_write8(Adapter, REG_TXPKTBUF_WMAC_LBK_BF_HD, txpktbuf_bndy);
+	usb_write8(Adapter, REG_TRXFF_BNDY, txpktbuf_bndy);
+	usb_write8(Adapter, REG_TDECTRL+1, txpktbuf_bndy);
 }
 
 static void _InitPageBoundary(struct adapter *Adapter)
@@ -354,12 +354,12 @@ static void _InitTransferPageSize(struct adapter *Adapter)
 
 	u8 value8;
 	value8 = _PSRX(PBP_128) | _PSTX(PBP_128);
-	rtw_write8(Adapter, REG_PBP, value8);
+	usb_write8(Adapter, REG_PBP, value8);
 }
 
 static void _InitDriverInfoSize(struct adapter *Adapter, u8 drvInfoSize)
 {
-	rtw_write8(Adapter, REG_RX_DRVINFO_SZ, drvInfoSize);
+	usb_write8(Adapter, REG_RX_DRVINFO_SZ, drvInfoSize);
 }
 
 static void _InitWMACSetting(struct adapter *Adapter)
@@ -422,9 +422,9 @@ static void _InitEDCA(struct adapter *Adapter)
 
 static void _InitRDGSetting(struct adapter *Adapter)
 {
-	rtw_write8(Adapter, REG_RD_CTRL, 0xFF);
+	usb_write8(Adapter, REG_RD_CTRL, 0xFF);
 	usb_write16(Adapter, REG_RD_NAV_NXT, 0x200);
-	rtw_write8(Adapter, REG_RD_RESP_PKT_TH, 0x05);
+	usb_write8(Adapter, REG_RD_RESP_PKT_TH, 0x05);
 }
 
 static void _InitRxSetting(struct adapter *Adapter)
@@ -439,10 +439,10 @@ static void _InitRetryFunction(struct adapter *Adapter)
 
 	value8 = rtw_read8(Adapter, REG_FWHW_TXQ_CTRL);
 	value8 |= EN_AMPDU_RTY_NEW;
-	rtw_write8(Adapter, REG_FWHW_TXQ_CTRL, value8);
+	usb_write8(Adapter, REG_FWHW_TXQ_CTRL, value8);
 
 	/*  Set ACK timeout */
-	rtw_write8(Adapter, REG_ACKTO, 0x40);
+	usb_write8(Adapter, REG_ACKTO, 0x40);
 }
 
 /*-----------------------------------------------------------------------------
@@ -524,23 +524,23 @@ usb_AggSettingRxUpdate(
 		break;
 	}
 
-	rtw_write8(Adapter, REG_TRXDMA_CTRL, valueDMA);
-	rtw_write8(Adapter, REG_USB_SPECIAL_OPTION, valueUSB);
+	usb_write8(Adapter, REG_TRXDMA_CTRL, valueDMA);
+	usb_write8(Adapter, REG_USB_SPECIAL_OPTION, valueUSB);
 
 	switch (haldata->UsbRxAggMode) {
 	case USB_RX_AGG_DMA:
-		rtw_write8(Adapter, REG_RXDMA_AGG_PG_TH, haldata->UsbRxAggPageCount);
-		rtw_write8(Adapter, REG_RXDMA_AGG_PG_TH+1, haldata->UsbRxAggPageTimeout);
+		usb_write8(Adapter, REG_RXDMA_AGG_PG_TH, haldata->UsbRxAggPageCount);
+		usb_write8(Adapter, REG_RXDMA_AGG_PG_TH+1, haldata->UsbRxAggPageTimeout);
 		break;
 	case USB_RX_AGG_USB:
-		rtw_write8(Adapter, REG_USB_AGG_TH, haldata->UsbRxAggBlockCount);
-		rtw_write8(Adapter, REG_USB_AGG_TO, haldata->UsbRxAggBlockTimeout);
+		usb_write8(Adapter, REG_USB_AGG_TH, haldata->UsbRxAggBlockCount);
+		usb_write8(Adapter, REG_USB_AGG_TO, haldata->UsbRxAggBlockTimeout);
 		break;
 	case USB_RX_AGG_MIX:
-		rtw_write8(Adapter, REG_RXDMA_AGG_PG_TH, haldata->UsbRxAggPageCount);
-		rtw_write8(Adapter, REG_RXDMA_AGG_PG_TH+1, (haldata->UsbRxAggPageTimeout & 0x1F));/* 0x280[12:8] */
-		rtw_write8(Adapter, REG_USB_AGG_TH, haldata->UsbRxAggBlockCount);
-		rtw_write8(Adapter, REG_USB_AGG_TO, haldata->UsbRxAggBlockTimeout);
+		usb_write8(Adapter, REG_RXDMA_AGG_PG_TH, haldata->UsbRxAggPageCount);
+		usb_write8(Adapter, REG_RXDMA_AGG_PG_TH+1, (haldata->UsbRxAggPageTimeout & 0x1F));/* 0x280[12:8] */
+		usb_write8(Adapter, REG_USB_AGG_TH, haldata->UsbRxAggBlockCount);
+		usb_write8(Adapter, REG_USB_AGG_TO, haldata->UsbRxAggBlockTimeout);
 		break;
 	case USB_RX_AGG_DISABLE:
 	default:
@@ -591,8 +591,8 @@ static void _InitBeaconParameters(struct adapter *Adapter)
 
 	/*  TODO: Remove these magic number */
 	usb_write16(Adapter, REG_TBTT_PROHIBIT, 0x6404);/*  ms */
-	rtw_write8(Adapter, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);/*  5ms */
-	rtw_write8(Adapter, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME); /*  2ms */
+	usb_write8(Adapter, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);/*  5ms */
+	usb_write8(Adapter, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME); /*  2ms */
 
 	/*  Suggested by designer timchen. Change beacon AIFS to the largest number */
 	/*  beacause test chip does not contension before sending beacon. by tynli. 2009.11.03 */
@@ -608,9 +608,9 @@ static void _InitBeaconParameters(struct adapter *Adapter)
 static void _BeaconFunctionEnable(struct adapter *Adapter,
 				  bool Enable, bool Linked)
 {
-	rtw_write8(Adapter, REG_BCN_CTRL, (BIT4 | BIT3 | BIT1));
+	usb_write8(Adapter, REG_BCN_CTRL, (BIT4 | BIT3 | BIT1));
 
-	rtw_write8(Adapter, REG_RD_CTRL+1, 0x6F);
+	usb_write8(Adapter, REG_RD_CTRL+1, 0x6F);
 }
 
 /*  Set CCK and OFDM Block "ON" */
@@ -668,7 +668,7 @@ enum rt_rf_power_state RfOnOffDetect(struct adapter *adapt)
 		DBG_88E("pwrdown, 0x5c(BIT7)=%02x\n", val8);
 		rfpowerstate = (val8 & BIT7) ? rf_off : rf_on;
 	} else { /*  rf on/off */
-		rtw_write8(adapt, REG_MAC_PINMUX_CFG, rtw_read8(adapt, REG_MAC_PINMUX_CFG)&~(BIT3));
+		usb_write8(adapt, REG_MAC_PINMUX_CFG, rtw_read8(adapt, REG_MAC_PINMUX_CFG)&~(BIT3));
 		val8 = rtw_read8(adapt, REG_GPIO_IO_SEL);
 		DBG_88E("GPIO_IN=%02x\n", val8);
 		rfpowerstate = (val8 & BIT3) ? rf_on : rf_off;
@@ -825,7 +825,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	/*  Enable MACTXEN/MACRXEN block */
 	value16 = rtw_read16(Adapter, REG_CR);
 	value16 |= (MACTXEN | MACRXEN);
-	rtw_write8(Adapter, REG_CR, value16);
+	usb_write8(Adapter, REG_CR, value16);
 
 	if (haldata->bRDGEnable)
 		_InitRDGSetting(Adapter);
@@ -833,13 +833,13 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	/* Enable TX Report */
 	/* Enable Tx Report Timer */
 	value8 = rtw_read8(Adapter, REG_TX_RPT_CTRL);
-	rtw_write8(Adapter,  REG_TX_RPT_CTRL, (value8|BIT1|BIT0));
+	usb_write8(Adapter,  REG_TX_RPT_CTRL, (value8|BIT1|BIT0));
 	/* Set MAX RPT MACID */
-	rtw_write8(Adapter,  REG_TX_RPT_CTRL+1, 2);/* FOR sta mode ,0: bc/mc ,1:AP */
+	usb_write8(Adapter,  REG_TX_RPT_CTRL+1, 2);/* FOR sta mode ,0: bc/mc ,1:AP */
 	/* Tx RPT Timer. Unit: 32us */
 	usb_write16(Adapter, REG_TX_RPT_TIME, 0xCdf0);
 
-	rtw_write8(Adapter, REG_EARLY_MODE_CONTROL, 0);
+	usb_write8(Adapter, REG_EARLY_MODE_CONTROL, 0);
 
 	usb_write16(Adapter, REG_PKT_VO_VI_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
 	usb_write16(Adapter, REG_PKT_BE_BK_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
@@ -871,13 +871,13 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_MISC11);
 
 	/*  HW SEQ CTRL */
 	/* set 0x0 to 0xFF by tynli. Default enable HW SEQ NUM. */
-	rtw_write8(Adapter, REG_HWSEQ_CTRL, 0xFF);
+	usb_write8(Adapter, REG_HWSEQ_CTRL, 0xFF);
 
 	if (pregistrypriv->wifi_spec)
 		usb_write16(Adapter, REG_FAST_EDCA_CTRL, 0);
 
 	/* Nav limit , suggest by scott */
-	rtw_write8(Adapter, 0x652, 0x0);
+	usb_write8(Adapter, 0x652, 0x0);
 
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_HAL_DM);
 	rtl8188e_InitHalDm(Adapter);
@@ -896,10 +896,10 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_HAL_DM);
 		pwrctrlpriv->rf_pwrstate = rf_on;
 
 		/*  enable Tx report. */
-		rtw_write8(Adapter,  REG_FWHW_TXQ_CTRL+1, 0x0F);
+		usb_write8(Adapter,  REG_FWHW_TXQ_CTRL+1, 0x0F);
 
 		/*  Suggested by SD1 pisa. Added by tynli. 2011.10.21. */
-		rtw_write8(Adapter, REG_EARLY_MODE_CONTROL+3, 0x01);/* Pretx_en, for WEP/TKIP SEC */
+		usb_write8(Adapter, REG_EARLY_MODE_CONTROL+3, 0x01);/* Pretx_en, for WEP/TKIP SEC */
 
 		/* tynli_test_tx_report. */
 		usb_write16(Adapter, REG_TX_RPT_TIME, 0x3DF0);
@@ -928,7 +928,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_LCK);
 
 /* HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_PABIAS); */
 /*	_InitPABias(Adapter); */
-	rtw_write8(Adapter, REG_USB_HRPWM, 0);
+	usb_write8(Adapter, REG_USB_HRPWM, 0);
 
 	/* ack for xmit mgmt frames. */
 	usb_write32(Adapter, REG_FWHW_TXQ_CTRL, rtw_read32(Adapter, REG_FWHW_TXQ_CTRL)|BIT(12));
@@ -951,10 +951,10 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 
 	/* Stop Tx Report Timer. 0x4EC[Bit1]=b'0 */
 	val8 = rtw_read8(Adapter, REG_TX_RPT_CTRL);
-	rtw_write8(Adapter, REG_TX_RPT_CTRL, val8&(~BIT1));
+	usb_write8(Adapter, REG_TX_RPT_CTRL, val8&(~BIT1));
 
 	/*  stop rx */
-	rtw_write8(Adapter, REG_CR, 0x0);
+	usb_write8(Adapter, REG_CR, 0x0);
 
 	/*  Run LPS WL RFOFF flow */
 	HalPwrSeqCmdParsing(Adapter, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_LPS_ENTER_FLOW);
@@ -966,35 +966,35 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 		/*  Reset MCU 0x2[10]=0. */
 		val8 = rtw_read8(Adapter, REG_SYS_FUNC_EN+1);
 		val8 &= ~BIT(2);	/*  0x2[10], FEN_CPUEN */
-		rtw_write8(Adapter, REG_SYS_FUNC_EN+1, val8);
+		usb_write8(Adapter, REG_SYS_FUNC_EN+1, val8);
 	}
 
 	/*  reset MCU ready status */
-	rtw_write8(Adapter, REG_MCUFWDL, 0);
+	usb_write8(Adapter, REG_MCUFWDL, 0);
 
 	/* YJ,add,111212 */
 	/* Disable 32k */
 	val8 = rtw_read8(Adapter, REG_32K_CTRL);
-	rtw_write8(Adapter, REG_32K_CTRL, val8&(~BIT0));
+	usb_write8(Adapter, REG_32K_CTRL, val8&(~BIT0));
 
 	/*  Card disable power action flow */
 	HalPwrSeqCmdParsing(Adapter, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_DISABLE_FLOW);
 
 	/*  Reset MCU IO Wrapper */
 	val8 = rtw_read8(Adapter, REG_RSV_CTRL+1);
-	rtw_write8(Adapter, REG_RSV_CTRL+1, (val8&(~BIT3)));
+	usb_write8(Adapter, REG_RSV_CTRL+1, (val8&(~BIT3)));
 	val8 = rtw_read8(Adapter, REG_RSV_CTRL+1);
-	rtw_write8(Adapter, REG_RSV_CTRL+1, val8|BIT3);
+	usb_write8(Adapter, REG_RSV_CTRL+1, val8|BIT3);
 
 	/* YJ,test add, 111207. For Power Consumption. */
 	val8 = rtw_read8(Adapter, GPIO_IN);
-	rtw_write8(Adapter, GPIO_OUT, val8);
-	rtw_write8(Adapter, GPIO_IO_SEL, 0xFF);/* Reg0x46 */
+	usb_write8(Adapter, GPIO_OUT, val8);
+	usb_write8(Adapter, GPIO_IO_SEL, 0xFF);/* Reg0x46 */
 
 	val8 = rtw_read8(Adapter, REG_GPIO_IO_SEL);
-	rtw_write8(Adapter, REG_GPIO_IO_SEL, (val8<<4));
+	usb_write8(Adapter, REG_GPIO_IO_SEL, (val8<<4));
 	val8 = rtw_read8(Adapter, REG_GPIO_IO_SEL+1);
-	rtw_write8(Adapter, REG_GPIO_IO_SEL+1, val8|0x0F);/* Reg0x43 */
+	usb_write8(Adapter, REG_GPIO_IO_SEL+1, val8|0x0F);/* Reg0x43 */
 	usb_write32(Adapter, REG_BB_PAD_CTRL, 0x00080808);/* set LNA ,TRSW,EX_PA Pin to output mode */
 	haldata->bMacPwrCtrlOn = false;
 	Adapter->bFWReady = false;
@@ -1005,7 +1005,7 @@ static void rtl8192cu_hw_power_down(struct adapter *adapt)
 	/*  Then enable power down control bit of register 0x04 BIT4 and BIT15 as 1. */
 
 	/*  Enable register area 0x0-0xc. */
-	rtw_write8(adapt, REG_RSV_CTRL, 0x0);
+	usb_write8(adapt, REG_RSV_CTRL, 0x0);
 	usb_write16(adapt, REG_APS_FSMCO, 0x8812);
 }
 
@@ -1206,11 +1206,11 @@ static void ResumeTxBeacon(struct adapter *adapt)
 	/*  2010.03.01. Marked by tynli. No need to call workitem beacause we record the value */
 	/*  which should be read from register to a global variable. */
 
-	rtw_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl) | BIT6);
+	usb_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl) | BIT6);
 	haldata->RegFwHwTxQCtrl |= BIT6;
-	rtw_write8(adapt, REG_TBTT_PROHIBIT+1, 0xff);
+	usb_write8(adapt, REG_TBTT_PROHIBIT+1, 0xff);
 	haldata->RegReg542 |= BIT0;
-	rtw_write8(adapt, REG_TBTT_PROHIBIT+2, haldata->RegReg542);
+	usb_write8(adapt, REG_TBTT_PROHIBIT+2, haldata->RegReg542);
 }
 
 static void StopTxBeacon(struct adapter *adapt)
@@ -1220,11 +1220,11 @@ static void StopTxBeacon(struct adapter *adapt)
 	/*  2010.03.01. Marked by tynli. No need to call workitem beacause we record the value */
 	/*  which should be read from register to a global variable. */
 
-	rtw_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl) & (~BIT6));
+	usb_write8(adapt, REG_FWHW_TXQ_CTRL+2, (haldata->RegFwHwTxQCtrl) & (~BIT6));
 	haldata->RegFwHwTxQCtrl &= (~BIT6);
-	rtw_write8(adapt, REG_TBTT_PROHIBIT+1, 0x64);
+	usb_write8(adapt, REG_TBTT_PROHIBIT+1, 0x64);
 	haldata->RegReg542 &= ~(BIT0);
-	rtw_write8(adapt, REG_TBTT_PROHIBIT+2, haldata->RegReg542);
+	usb_write8(adapt, REG_TBTT_PROHIBIT+2, haldata->RegReg542);
 
 	 /* todo: CheckFwRsvdPageContent(Adapter);  2010.06.23. Added by tynli. */
 }
@@ -1235,26 +1235,26 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 	u8 mode = *((u8 *)val);
 
 	/*  disable Port0 TSF update */
-	rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+	usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 
 	/*  set net_type */
 	val8 = rtw_read8(Adapter, MSR)&0x0c;
 	val8 |= mode;
-	rtw_write8(Adapter, MSR, val8);
+	usb_write8(Adapter, MSR, val8);
 
 	DBG_88E("%s()-%d mode = %d\n", __func__, __LINE__, mode);
 
 	if ((mode == _HW_STATE_STATION_) || (mode == _HW_STATE_NOLINK_)) {
 		StopTxBeacon(Adapter);
 
-		rtw_write8(Adapter, REG_BCN_CTRL, 0x19);/* disable atim wnd */
+		usb_write8(Adapter, REG_BCN_CTRL, 0x19);/* disable atim wnd */
 	} else if ((mode == _HW_STATE_ADHOC_)) {
 		ResumeTxBeacon(Adapter);
-		rtw_write8(Adapter, REG_BCN_CTRL, 0x1a);
+		usb_write8(Adapter, REG_BCN_CTRL, 0x1a);
 	} else if (mode == _HW_STATE_AP_) {
 		ResumeTxBeacon(Adapter);
 
-		rtw_write8(Adapter, REG_BCN_CTRL, 0x12);
+		usb_write8(Adapter, REG_BCN_CTRL, 0x12);
 
 		/* Set RCR */
 		usb_write32(Adapter, REG_RCR, 0x7000208e);/* CBSSID_DATA must set to 0,reject ICV_ERR packet */
@@ -1264,25 +1264,25 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 		usb_write16(Adapter, REG_RXFLTMAP1, 0x0400);
 
 		/* Beacon Control related register for first time */
-		rtw_write8(Adapter, REG_BCNDMATIM, 0x02); /*  2ms */
+		usb_write8(Adapter, REG_BCNDMATIM, 0x02); /*  2ms */
 
-		rtw_write8(Adapter, REG_ATIMWND, 0x0a); /*  10ms */
+		usb_write8(Adapter, REG_ATIMWND, 0x0a); /*  10ms */
 		usb_write16(Adapter, REG_BCNTCFG, 0x00);
 		usb_write16(Adapter, REG_TBTT_PROHIBIT, 0xff04);
 		usb_write16(Adapter, REG_TSFTR_SYN_OFFSET, 0x7fff);/*  +32767 (~32ms) */
 
 		/* reset TSF */
-		rtw_write8(Adapter, REG_DUAL_TSF_RST, BIT(0));
+		usb_write8(Adapter, REG_DUAL_TSF_RST, BIT(0));
 
 		/* BIT3 - If set 0, hw will clr bcnq when tx becon ok/fail or port 0 */
-		rtw_write8(Adapter, REG_MBID_NUM, rtw_read8(Adapter, REG_MBID_NUM) | BIT(3) | BIT(4));
+		usb_write8(Adapter, REG_MBID_NUM, rtw_read8(Adapter, REG_MBID_NUM) | BIT(3) | BIT(4));
 
 		/* enable BCN0 Function for if1 */
 		/* don't enable update TSF0 for if1 (due to TSF update when beacon/probe rsp are received) */
-		rtw_write8(Adapter, REG_BCN_CTRL, (DIS_TSF_UDT0_NORMAL_CHIP|EN_BCN_FUNCTION | BIT(1)));
+		usb_write8(Adapter, REG_BCN_CTRL, (DIS_TSF_UDT0_NORMAL_CHIP|EN_BCN_FUNCTION | BIT(1)));
 
 		/* dis BCN1 ATIM  WND if if2 is station */
-		rtw_write8(Adapter, REG_BCN_CTRL_1, rtw_read8(Adapter, REG_BCN_CTRL_1) | BIT(0));
+		usb_write8(Adapter, REG_BCN_CTRL_1, rtw_read8(Adapter, REG_BCN_CTRL_1) | BIT(0));
 	}
 }
 
@@ -1294,7 +1294,7 @@ static void hw_var_set_macaddr(struct adapter *Adapter, u8 variable, u8 *val)
 	reg_macid = REG_MACID;
 
 	for (idx = 0; idx < 6; idx++)
-		rtw_write8(Adapter, (reg_macid+idx), val[idx]);
+		usb_write8(Adapter, (reg_macid+idx), val[idx]);
 }
 
 static void hw_var_set_bssid(struct adapter *Adapter, u8 variable, u8 *val)
@@ -1305,7 +1305,7 @@ static void hw_var_set_bssid(struct adapter *Adapter, u8 variable, u8 *val)
 	reg_bssid = REG_BSSID;
 
 	for (idx = 0; idx < 6; idx++)
-		rtw_write8(Adapter, (reg_bssid+idx), val[idx]);
+		usb_write8(Adapter, (reg_bssid+idx), val[idx]);
 }
 
 static void hw_var_set_bcn_func(struct adapter *Adapter, u8 variable, u8 *val)
@@ -1315,9 +1315,9 @@ static void hw_var_set_bcn_func(struct adapter *Adapter, u8 variable, u8 *val)
 	bcn_ctrl_reg = REG_BCN_CTRL;
 
 	if (*((u8 *)val))
-		rtw_write8(Adapter, bcn_ctrl_reg, (EN_BCN_FUNCTION | EN_TXBCN_RPT));
+		usb_write8(Adapter, bcn_ctrl_reg, (EN_BCN_FUNCTION | EN_TXBCN_RPT));
 	else
-		rtw_write8(Adapter, bcn_ctrl_reg, rtw_read8(Adapter, bcn_ctrl_reg)&(~(EN_BCN_FUNCTION | EN_TXBCN_RPT)));
+		usb_write8(Adapter, bcn_ctrl_reg, rtw_read8(Adapter, bcn_ctrl_reg)&(~(EN_BCN_FUNCTION | EN_TXBCN_RPT)));
 }
 
 static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
@@ -1333,7 +1333,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			val8 = rtw_read8(Adapter, MSR)&0x0c;
 			val8 |= *((u8 *)val);
-			rtw_write8(Adapter, MSR, val8);
+			usb_write8(Adapter, MSR, val8);
 		}
 		break;
 	case HW_VAR_MEDIA_STATUS1:
@@ -1342,7 +1342,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			val8 = rtw_read8(Adapter, MSR) & 0x03;
 			val8 |= *((u8 *)val) << 2;
-			rtw_write8(Adapter, MSR, val8);
+			usb_write8(Adapter, MSR, val8);
 		}
 		break;
 	case HW_VAR_SET_OPMODE:
@@ -1376,9 +1376,9 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			BrateCfg |= 0x01; /*  default enable 1M ACK rate */
 			/*  Set RRSR rate table. */
-			rtw_write8(Adapter, REG_RRSR, BrateCfg & 0xff);
-			rtw_write8(Adapter, REG_RRSR+1, (BrateCfg >> 8) & 0xff);
-			rtw_write8(Adapter, REG_RRSR+2, rtw_read8(Adapter, REG_RRSR+2)&0xf0);
+			usb_write8(Adapter, REG_RRSR, BrateCfg & 0xff);
+			usb_write8(Adapter, REG_RRSR+1, (BrateCfg >> 8) & 0xff);
+			usb_write8(Adapter, REG_RRSR+2, rtw_read8(Adapter, REG_RRSR+2)&0xf0);
 
 			/*  Set RTS initial rate */
 			while (BrateCfg > 0x1) {
@@ -1386,11 +1386,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				RateIndex++;
 			}
 			/*  Ziv - Check */
-			rtw_write8(Adapter, REG_INIRTS_RATE_SEL, RateIndex);
+			usb_write8(Adapter, REG_INIRTS_RATE_SEL, RateIndex);
 		}
 		break;
 	case HW_VAR_TXPAUSE:
-		rtw_write8(Adapter, REG_TXPAUSE, *((u8 *)val));
+		usb_write8(Adapter, REG_TXPAUSE, *((u8 *)val));
 		break;
 	case HW_VAR_BCN_FUNC:
 		hw_var_set_bcn_func(Adapter, variable, val);
@@ -1407,13 +1407,13 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				StopTxBeacon(Adapter);
 
 			/* disable related TSF function */
-			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(3)));
+			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(3)));
 
 			usb_write32(Adapter, REG_TSFTR, tsf);
 			usb_write32(Adapter, REG_TSFTR+4, tsf>>32);
 
 			/* enable related TSF function */
-			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(3));
+			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(3));
 
 			if (((pmlmeinfo->state&0x03) == WIFI_FW_ADHOC_STATE) || ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE))
 				ResumeTxBeacon(Adapter);
@@ -1438,10 +1438,10 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
 		/* reset TSF */
-		rtw_write8(Adapter, REG_DUAL_TSF_RST, (BIT(0)|BIT(1)));
+		usb_write8(Adapter, REG_DUAL_TSF_RST, (BIT(0)|BIT(1)));
 
 		/* disable update TSF */
-		rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+		usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 		break;
 	case HW_VAR_MLME_SITESURVEY:
 		if (*((u8 *)val)) { /* under sitesurvey */
@@ -1453,7 +1453,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
 			/* disable update TSF */
-			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
+			usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
 		} else { /* sitesurvey done */
 			struct mlme_ext_priv	*pmlmeext = &Adapter->mlmeextpriv;
 			struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
@@ -1464,11 +1464,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 
 				/* enable update TSF */
-				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			} else if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 				/* enable update TSF */
-				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			}
 			if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 				usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
@@ -1511,7 +1511,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			} else if (type == 2) {
 				/* sta add event call back */
 				/* enable update TSF */
-				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
+				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 
 				if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE|WIFI_ADHOC_MASTER_STATE))
 					RetryLimit = 0x7;
@@ -1528,7 +1528,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			struct mlme_ext_priv	*pmlmeext = &Adapter->mlmeextpriv;
 			struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 
-			rtw_write8(Adapter, REG_SLOT, val[0]);
+			usb_write8(Adapter, REG_SLOT, val[0]);
 
 			if (pmlmeinfo->WMM_enable == 0) {
 				if (pmlmeext->cur_wireless_mode == WIRELESS_11B)
@@ -1539,20 +1539,20 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				u1bAIFS = aSifsTime + (2 * pmlmeinfo->slotTime);
 
 				/*  <Roger_EXP> Temporary removed, 2008.06.20. */
-				rtw_write8(Adapter, REG_EDCA_VO_PARAM, u1bAIFS);
-				rtw_write8(Adapter, REG_EDCA_VI_PARAM, u1bAIFS);
-				rtw_write8(Adapter, REG_EDCA_BE_PARAM, u1bAIFS);
-				rtw_write8(Adapter, REG_EDCA_BK_PARAM, u1bAIFS);
+				usb_write8(Adapter, REG_EDCA_VO_PARAM, u1bAIFS);
+				usb_write8(Adapter, REG_EDCA_VI_PARAM, u1bAIFS);
+				usb_write8(Adapter, REG_EDCA_BE_PARAM, u1bAIFS);
+				usb_write8(Adapter, REG_EDCA_BK_PARAM, u1bAIFS);
 			}
 		}
 		break;
 	case HW_VAR_RESP_SIFS:
 		/* RESP_SIFS for CCK */
-		rtw_write8(Adapter, REG_R2T_SIFS, val[0]); /*  SIFS_T2T_CCK (0x08) */
-		rtw_write8(Adapter, REG_R2T_SIFS+1, val[1]); /* SIFS_R2T_CCK(0x08) */
+		usb_write8(Adapter, REG_R2T_SIFS, val[0]); /*  SIFS_T2T_CCK (0x08) */
+		usb_write8(Adapter, REG_R2T_SIFS+1, val[1]); /* SIFS_R2T_CCK(0x08) */
 		/* RESP_SIFS for OFDM */
-		rtw_write8(Adapter, REG_T2T_SIFS, val[2]); /* SIFS_T2T_OFDM (0x0a) */
-		rtw_write8(Adapter, REG_T2T_SIFS+1, val[3]); /* SIFS_R2T_OFDM(0x0a) */
+		usb_write8(Adapter, REG_T2T_SIFS, val[2]); /* SIFS_T2T_OFDM (0x0a) */
+		usb_write8(Adapter, REG_T2T_SIFS+1, val[3]); /* SIFS_R2T_OFDM(0x0a) */
 		break;
 	case HW_VAR_ACK_PREAMBLE:
 		{
@@ -1563,11 +1563,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			if (bShortPreamble)
 				regTmp |= 0x80;
 
-			rtw_write8(Adapter, REG_RRSR+2, regTmp);
+			usb_write8(Adapter, REG_RRSR+2, regTmp);
 		}
 		break;
 	case HW_VAR_SEC_CFG:
-		rtw_write8(Adapter, REG_SECCFG, *((u8 *)val));
+		usb_write8(Adapter, REG_SECCFG, *((u8 *)val));
 		break;
 	case HW_VAR_DM_FLAG:
 		podmpriv->SupportAbility = *((u8 *)val);
@@ -1662,7 +1662,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				AcmCtrl &= (~AcmHw_BeqEn);
 
 			DBG_88E("[HW_VAR_ACM_CTRL] Write 0x%X\n", AcmCtrl);
-			rtw_write8(Adapter, REG_ACMHWCTRL, AcmCtrl);
+			usb_write8(Adapter, REG_ACMHWCTRL, AcmCtrl);
 		}
 		break;
 	case HW_VAR_AMPDU_MIN_SPACE:
@@ -1689,7 +1689,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				}
 				if (MinSpacingToSet < SecMinSpace)
 					MinSpacingToSet = SecMinSpace;
-				rtw_write8(Adapter, REG_AMPDU_MIN_SPACE, (rtw_read8(Adapter, REG_AMPDU_MIN_SPACE) & 0xf8) | MinSpacingToSet);
+				usb_write8(Adapter, REG_AMPDU_MIN_SPACE, (rtw_read8(Adapter, REG_AMPDU_MIN_SPACE) & 0xf8) | MinSpacingToSet);
 			}
 		}
 		break;
@@ -1714,7 +1714,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 					if ((pRegToSet[index] & 0x0f) > FactorToSet)
 						pRegToSet[index] = (pRegToSet[index] & 0xf0) | (FactorToSet);
 
-					rtw_write8(Adapter, (REG_AGGLEN_LMT+index), pRegToSet[index]);
+					usb_write8(Adapter, (REG_AGGLEN_LMT+index), pRegToSet[index]);
 				}
 			}
 		}
@@ -1724,7 +1724,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			u8 threshold = *((u8 *)val);
 			if (threshold == 0)
 				threshold = haldata->UsbRxAggPageCount;
-			rtw_write8(Adapter, REG_RXDMA_AGG_PG_TH, threshold);
+			usb_write8(Adapter, REG_RXDMA_AGG_PG_TH, threshold);
 		}
 		break;
 	case HW_VAR_SET_RPWM:
@@ -1798,7 +1798,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			u8 trycnt = 100;
 
 			/* pause tx */
-			rtw_write8(Adapter, REG_TXPAUSE, 0xff);
+			usb_write8(Adapter, REG_TXPAUSE, 0xff);
 
 			/* keep sn */
 			Adapter->xmitpriv.nqos_ssn = rtw_read16(Adapter, REG_NQOS_SEQ);
@@ -1830,7 +1830,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		{
 			u8 maxMacid = *val;
 			DBG_88E("### MacID(%d),Set Max Tx RPT MID(%d)\n", maxMacid, maxMacid+1);
-			rtw_write8(Adapter, REG_TX_RPT_CTRL+1, maxMacid+1);
+			usb_write8(Adapter, REG_TX_RPT_CTRL+1, maxMacid+1);
 		}
 		break;
 	case HW_VAR_H2C_MEDIA_STATUS_RPT:
@@ -1838,7 +1838,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		break;
 	case HW_VAR_BCN_VALID:
 		/* BCN_VALID, BIT16 of REG_TDECTRL = BIT0 of REG_TDECTRL+2, write 1 to clear, Clear by sw */
-		rtw_write8(Adapter, REG_TDECTRL+2, rtw_read8(Adapter, REG_TDECTRL+2) | BIT0);
+		usb_write8(Adapter, REG_TDECTRL+2, rtw_read8(Adapter, REG_TDECTRL+2) | BIT0);
 		break;
 	default:
 		break;
@@ -2163,11 +2163,11 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 
 	/* BCN interval */
 	usb_write16(adapt, REG_BCN_INTERVAL, pmlmeinfo->bcn_interval);
-	rtw_write8(adapt, REG_ATIMWND, 0x02);/*  2ms */
+	usb_write8(adapt, REG_ATIMWND, 0x02);/*  2ms */
 
 	_InitBeaconParameters(adapt);
 
-	rtw_write8(adapt, REG_SLOT, 0x09);
+	usb_write8(adapt, REG_SLOT, 0x09);
 
 	value32 = rtw_read32(adapt, REG_TCR);
 	value32 &= ~TSFRST;
@@ -2177,14 +2177,14 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 	usb_write32(adapt, REG_TCR, value32);
 
 	/*  NOTE: Fix test chip's bug (about contention windows's randomness) */
-	rtw_write8(adapt,  REG_RXTSF_OFFSET_CCK, 0x50);
-	rtw_write8(adapt, REG_RXTSF_OFFSET_OFDM, 0x50);
+	usb_write8(adapt,  REG_RXTSF_OFFSET_CCK, 0x50);
+	usb_write8(adapt, REG_RXTSF_OFFSET_OFDM, 0x50);
 
 	_BeaconFunctionEnable(adapt, true, true);
 
 	ResumeTxBeacon(adapt);
 
-	rtw_write8(adapt, bcn_ctrl_reg, rtw_read8(adapt, bcn_ctrl_reg)|BIT(1));
+	usb_write8(adapt, bcn_ctrl_reg, rtw_read8(adapt, bcn_ctrl_reg)|BIT(1));
 }
 
 static void rtl8188eu_init_default_value(struct adapter *adapt)
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index f2aa3d5..c38cb11 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -181,7 +181,7 @@ static u32 usb_read32(struct adapter *adapter, u32 addr)
 	return le32_to_cpu(data);
 }
 
-static int usb_write8(struct adapter *adapter, u32 addr, u8 val)
+int usb_write8(struct adapter *adapter, u32 addr, u8 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -669,5 +669,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read8 = &usb_read8;
 	pops->_read16 = &usb_read16;
 	pops->_read32 = &usb_read32;
-	pops->_write8 = &usb_write8;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 24b3ee0..6c956f4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -47,7 +47,6 @@ struct _io_ops {
 	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
 	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
 	u32 (*_read32)(struct adapter *pintfhdl, u32 addr);
-	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 };
 
 struct io_req {
@@ -85,7 +84,7 @@ u32 _rtw_read32(struct adapter *adapter, u32 addr);
 u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_read_port_cancel(struct adapter *adapter);
 
-int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
+int usb_write8(struct adapter *adapter, u32 addr, u8 val);
 int usb_write16(struct adapter *adapter, u32 addr, u16 val);
 int usb_write32(struct adapter *adapter, u32 addr, u32 val);
 int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
@@ -97,9 +96,6 @@ void usb_write_port_cancel(struct adapter *adapter);
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
 #define rtw_read32(adapter, addr) _rtw_read32((adapter), (addr))
 
-#define  rtw_write8(adapter, addr, val)					\
-	_rtw_write8((adapter), (addr), (val))
-
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
 
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 526978f..92e07a5 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2222,7 +2222,7 @@ static int rtw_wx_write32(struct net_device *dev,
 
 	switch (bytes) {
 	case 1:
-		rtw_write8(padapter, addr, (u8)data32);
+		usb_write8(padapter, addr, (u8)data32);
 		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%02X\n", __func__, addr, (u8)data32);
 		break;
 	case 2:
@@ -2370,7 +2370,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 		RegRWStruct = (struct mp_rw_reg *)pdata;
 		switch (RegRWStruct->width) {
 		case 1:
-			rtw_write8(padapter, RegRWStruct->offset, (u8)RegRWStruct->value);
+			usb_write8(padapter, RegRWStruct->offset, (u8)RegRWStruct->value);
 			break;
 		case 2:
 			usb_write16(padapter, RegRWStruct->offset, (u16)RegRWStruct->value);
@@ -4122,8 +4122,8 @@ static int rtw_dbg_port(struct net_device *dev,
 	case 0x71:/* write_reg */
 		switch (minor_cmd) {
 		case 1:
-			rtw_write8(padapter, arg, extra_arg);
-			DBG_88E("rtw_write8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
+			usb_write8(padapter, arg, extra_arg);
+			DBG_88E("usb_write8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
 			break;
 		case 2:
 			usb_write16(padapter, arg, extra_arg);
@@ -4576,9 +4576,9 @@ static int rtw_dbg_port(struct net_device *dev,
 			break;
 
 		case 0xfd:
-			rtw_write8(padapter, 0xc50, arg);
+			usb_write8(padapter, 0xc50, arg);
 			DBG_88E("wr(0xc50) = 0x%x\n", rtw_read8(padapter, 0xc50));
-			rtw_write8(padapter, 0xc58, arg);
+			usb_write8(padapter, 0xc58, arg);
 			DBG_88E("wr(0xc58) = 0x%x\n", rtw_read8(padapter, 0xc58));
 			break;
 		case 0xfe:
@@ -6414,7 +6414,7 @@ static int rtw_mp_write_reg(struct net_device *dev,
 			ret = -EINVAL;
 			break;
 		}
-		rtw_write8(padapter, addr, data);
+		usb_write8(padapter, addr, data);
 		break;
 	case 'w':
 		/*  2 bytes */
-- 
1.7.10.4

