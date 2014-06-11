Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbaFKRXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34228 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaFKRXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/22] staging: rtl8188eu: Remove function _rtw_write16()
Date: Wed, 11 Jun 2014 22:51:32 +0530
Message-Id: <1402507301-3722-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_write16() is a wrapper function, being used to call usb_write16().
Call usb_write16() directly and drop _rtw_write16().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c         |    2 +-
 drivers/staging/rtl8188eu/core/rtw_io.c            |   13 ----
 drivers/staging/rtl8188eu/core/rtw_mp.c            |    8 +--
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      |    2 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    8 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |    4 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   76 ++++++++++----------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |    3 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         |    5 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   12 ++--
 12 files changed, 60 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index eaf0212..d13eed3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -66,7 +66,7 @@ int proc_set_write_reg(struct file *file, const char __user *buffer,
 			rtw_write8(padapter, addr, (u8)val);
 			break;
 		case 2:
-			rtw_write16(padapter, addr, (u16)val);
+			usb_write16(padapter, addr, (u16)val);
 			break;
 		case 4:
 			usb_write32(padapter, addr, val);
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index ebbbbd6..8b11ac2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -101,19 +101,6 @@ int _rtw_write8(struct adapter *adapter, u32 addr, u8 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-int _rtw_write16(struct adapter *adapter, u32 addr, u16 val)
-{
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
-	int ret;
-	_write16 = pintfhdl->io_ops._write16;
-
-	ret = _write16(adapter, addr, val);
-
-	return RTW_STATUS_CODE(ret);
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index d1b2c54..5c5e206 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -53,7 +53,7 @@ void write_macreg(struct adapter *padapter, u32 addr, u32 val, u32 sz)
 		rtw_write8(padapter, addr, (u8)val);
 		break;
 	case 2:
-		rtw_write16(padapter, addr, (u16)val);
+		usb_write16(padapter, addr, (u16)val);
 		break;
 	case 4:
 		usb_write32(padapter, addr, val);
@@ -234,8 +234,8 @@ s32 MPT_InitializeAdapter(struct adapter *pAdapter, u8 Channel)
 	pMptCtx->backup0x52_RF_B = (u8)PHY_QueryRFReg(pAdapter, RF_PATH_A, RF_0x52, 0x000F0);
 
 	/* set ant to wifi side in mp mode */
-	rtw_write16(pAdapter, 0x870, 0x300);
-	rtw_write16(pAdapter, 0x860, 0x110);
+	usb_write16(pAdapter, 0x870, 0x300);
+	usb_write16(pAdapter, 0x860, 0x110);
 
 	if (pAdapter->registrypriv.mp_mode == 1)
 		pmlmepriv->fw_state = WIFI_MP_STATE;
@@ -791,7 +791,7 @@ void SetPacketRx(struct adapter *pAdapter, u8 bStartRx)
 		usb_write32(pAdapter, REG_RCR, pHalData->ReceiveConfig);
 
 		/*  Accept all data frames */
-		rtw_write16(pAdapter, REG_RXFLTMAP2, 0xFFFF);
+		usb_write16(pAdapter, REG_RXFLTMAP2, 0xFFFF);
 	} else {
 		usb_write32(pAdapter, REG_RCR, 0);
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index 71b255d..8aac515 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -860,7 +860,7 @@ int rtl8188eu_oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 			status = NDIS_STATUS_NOT_ACCEPTED;
 			break;
 		}
-		rtw_write16(padapter, offset, (u16)value);
+		usb_write16(padapter, offset, (u16)value);
 		break;
 	case 4:
 		usb_write32(padapter, offset, value);
diff --git a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
index dea220b..ea5ba28 100644
--- a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
+++ b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
@@ -670,7 +670,7 @@ void ODM_RA_Set_TxRPT_Time(struct odm_dm_struct *dm_odm, u16 minRptTime)
 {
 	struct adapter *adapt = dm_odm->Adapter;
 
-	rtw_write16(adapt, REG_TX_RPT_TIME, minRptTime);
+	usb_write16(adapt, REG_TX_RPT_TIME, minRptTime);
 }
 
 void ODM_RA_TxRPT2Handle_8188E(struct odm_dm_struct *dm_odm, u8 *TxRPT_Buf, u16 TxRPT_Len, u32 macid_entry0, u32 macid_entry1)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index b14faac..73277b9 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -615,7 +615,7 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 	if (mstatus == 1) {
 		/*  We should set AID, correct TSF, HW seq enable before set JoinBssReport to Fw in 88/92C. */
 		/*  Suggested by filen. Added by tynli. */
-		rtw_write16(adapt, REG_BCN_PSR_RPT, (0xC000|pmlmeinfo->aid));
+		usb_write16(adapt, REG_BCN_PSR_RPT, (0xC000|pmlmeinfo->aid));
 		/*  Do not set TSF again here or vWiFi beacon DMA INT will not work. */
 
 		/* Set REG_CR bit 8. DMA beacon by SW. */
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index a0659fc..5b627d1 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -236,7 +236,7 @@ static void efuse_read_phymap_from_txpktbuf(
 	dbg_addr = bcnhead*128/8; /* 8-bytes addressing */
 
 	while (1) {
-		rtw_write16(adapter, REG_PKTBUF_DBG_ADDR, dbg_addr+i);
+		usb_write16(adapter, REG_PKTBUF_DBG_ADDR, dbg_addr+i);
 
 		rtw_write8(adapter, REG_TXPKTBUF_DBG, 0);
 		start = jiffies;
@@ -766,20 +766,20 @@ hal_EfusePowerSwitch_RTL8188E(
 		tmpV16 = rtw_read16(pAdapter, REG_SYS_ISO_CTRL);
 		if (!(tmpV16 & PWC_EV12V)) {
 			tmpV16 |= PWC_EV12V;
-			 rtw_write16(pAdapter, REG_SYS_ISO_CTRL, tmpV16);
+			 usb_write16(pAdapter, REG_SYS_ISO_CTRL, tmpV16);
 		}
 		/*  Reset: 0x0000h[28], default valid */
 		tmpV16 =  rtw_read16(pAdapter, REG_SYS_FUNC_EN);
 		if (!(tmpV16 & FEN_ELDR)) {
 			tmpV16 |= FEN_ELDR;
-			rtw_write16(pAdapter, REG_SYS_FUNC_EN, tmpV16);
+			usb_write16(pAdapter, REG_SYS_FUNC_EN, tmpV16);
 		}
 
 		/*  Clock: Gated(0x0008h[5]) 8M(0x0008h[1]) clock from ANA, default valid */
 		tmpV16 = rtw_read16(pAdapter, REG_SYS_CLKR);
 		if ((!(tmpV16 & LOADER_CLK_EN))  || (!(tmpV16 & ANA8M))) {
 			tmpV16 |= (LOADER_CLK_EN | ANA8M);
-			rtw_write16(pAdapter, REG_SYS_CLKR, tmpV16);
+			usb_write16(pAdapter, REG_SYS_CLKR, tmpV16);
 		}
 
 		if (bWrite) {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 73e90e3..178cf8b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -386,7 +386,7 @@ s32 PHY_MACConfig8188E(struct adapter *Adapter)
 		rtStatus = _FAIL;
 
 	/*  2010.07.13 AMPDU aggregation number B */
-	rtw_write16(Adapter, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
+	usb_write16(Adapter, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
 
 	return rtStatus;
 }
@@ -604,7 +604,7 @@ PHY_BBConfig8188E(
 
 	/*  Enable BB and RF */
 	RegVal = rtw_read16(Adapter, REG_SYS_FUNC_EN);
-	rtw_write16(Adapter, REG_SYS_FUNC_EN, (u16)(RegVal|BIT13|BIT0|BIT1));
+	usb_write16(Adapter, REG_SYS_FUNC_EN, (u16)(RegVal|BIT13|BIT0|BIT1));
 
 	/*  20090923 Joseph: Advised by Steven and Jenyu. Power sequence before init RF. */
 
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index f4df6d4..3615a60 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -117,7 +117,7 @@ static u32 rtl8188eu_InitPowerOn(struct adapter *adapt)
 
 	/*  Enable MAC DMA/WMAC/SCHEDULE/SEC block */
 	/*  Set CR bit10 to enable 32k calibration. Suggested by SD1 Gimmy. Added by tynli. 2011.08.31. */
-	rtw_write16(adapt, REG_CR, 0x00);  /* suggseted by zhouzhou, by page, 20111230 */
+	usb_write16(adapt, REG_CR, 0x00);  /* suggseted by zhouzhou, by page, 20111230 */
 
 		/*  Enable MAC DMA/WMAC/SCHEDULE/SEC block */
 	value16 = rtw_read16(adapt, REG_CR);
@@ -125,7 +125,7 @@ static u32 rtl8188eu_InitPowerOn(struct adapter *adapt)
 				| PROTOCOL_EN | SCHEDULE_EN | ENSEC | CALTMR_EN);
 	/*  for SDIO - Set CR bit10 to enable 32k calibration. Suggested by SD1 Gimmy. Added by tynli. 2011.08.31. */
 
-	rtw_write16(adapt, REG_CR, value16);
+	usb_write16(adapt, REG_CR, value16);
 	haldata->bMacPwrCtrlOn = true;
 
 	return _SUCCESS;
@@ -193,8 +193,8 @@ static void _InitQueueReservedPage(struct adapter *Adapter)
 		value32 = _HPQ(numHQ) | _LPQ(numLQ) | _PUBQ(numPubQ) | LD_RQPN;
 		usb_write32(Adapter, REG_RQPN, value32);
 	} else {
-		rtw_write16(Adapter, REG_RQPN_NPQ, 0x0000);/* Just follow MP Team,??? Georgia 03/28 */
-		rtw_write16(Adapter, REG_RQPN_NPQ, 0x0d);
+		usb_write16(Adapter, REG_RQPN_NPQ, 0x0000);/* Just follow MP Team,??? Georgia 03/28 */
+		usb_write16(Adapter, REG_RQPN_NPQ, 0x0d);
 		usb_write32(Adapter, REG_RQPN, 0x808E000d);/* reserve 7 page for LPS */
 	}
 }
@@ -214,7 +214,7 @@ static void _InitPageBoundary(struct adapter *Adapter)
 	/*  */
 	u16 rxff_bndy = MAX_RX_DMA_BUFFER_SIZE_88E-1;
 
-	rtw_write16(Adapter, (REG_TRXFF_BNDY + 2), rxff_bndy);
+	usb_write16(Adapter, (REG_TRXFF_BNDY + 2), rxff_bndy);
 }
 
 static void _InitNormalChipRegPriority(struct adapter *Adapter, u16 beQ,
@@ -227,7 +227,7 @@ static void _InitNormalChipRegPriority(struct adapter *Adapter, u16 beQ,
 		   _TXDMA_VIQ_MAP(viQ)	| _TXDMA_VOQ_MAP(voQ) |
 		   _TXDMA_MGQ_MAP(mgtQ) | _TXDMA_HIQ_MAP(hiQ);
 
-	rtw_write16(Adapter, REG_TRXDMA_CTRL, value16);
+	usb_write16(Adapter, REG_TRXDMA_CTRL, value16);
 }
 
 static void _InitNormalChipOneOutEpPriority(struct adapter *Adapter)
@@ -394,24 +394,24 @@ static void _InitAdaptiveCtrl(struct adapter *Adapter)
 
 	/*  SIFS (used in NAV) */
 	value16 = _SPEC_SIFS_CCK(0x10) | _SPEC_SIFS_OFDM(0x10);
-	rtw_write16(Adapter, REG_SPEC_SIFS, value16);
+	usb_write16(Adapter, REG_SPEC_SIFS, value16);
 
 	/*  Retry Limit */
 	value16 = _LRL(0x30) | _SRL(0x30);
-	rtw_write16(Adapter, REG_RL, value16);
+	usb_write16(Adapter, REG_RL, value16);
 }
 
 static void _InitEDCA(struct adapter *Adapter)
 {
 	/*  Set Spec SIFS (used in NAV) */
-	rtw_write16(Adapter, REG_SPEC_SIFS, 0x100a);
-	rtw_write16(Adapter, REG_MAC_SPEC_SIFS, 0x100a);
+	usb_write16(Adapter, REG_SPEC_SIFS, 0x100a);
+	usb_write16(Adapter, REG_MAC_SPEC_SIFS, 0x100a);
 
 	/*  Set SIFS for CCK */
-	rtw_write16(Adapter, REG_SIFS_CTX, 0x100a);
+	usb_write16(Adapter, REG_SIFS_CTX, 0x100a);
 
 	/*  Set SIFS for OFDM */
-	rtw_write16(Adapter, REG_SIFS_TRX, 0x100a);
+	usb_write16(Adapter, REG_SIFS_TRX, 0x100a);
 
 	/*  TXOP */
 	usb_write32(Adapter, REG_EDCA_BE_PARAM, 0x005EA42B);
@@ -423,7 +423,7 @@ static void _InitEDCA(struct adapter *Adapter)
 static void _InitRDGSetting(struct adapter *Adapter)
 {
 	rtw_write8(Adapter, REG_RD_CTRL, 0xFF);
-	rtw_write16(Adapter, REG_RD_NAV_NXT, 0x200);
+	usb_write16(Adapter, REG_RD_NAV_NXT, 0x200);
 	rtw_write8(Adapter, REG_RD_RESP_PKT_TH, 0x05);
 }
 
@@ -587,16 +587,16 @@ static void _InitBeaconParameters(struct adapter *Adapter)
 {
 	struct hal_data_8188e	*haldata = GET_HAL_DATA(Adapter);
 
-	rtw_write16(Adapter, REG_BCN_CTRL, 0x1010);
+	usb_write16(Adapter, REG_BCN_CTRL, 0x1010);
 
 	/*  TODO: Remove these magic number */
-	rtw_write16(Adapter, REG_TBTT_PROHIBIT, 0x6404);/*  ms */
+	usb_write16(Adapter, REG_TBTT_PROHIBIT, 0x6404);/*  ms */
 	rtw_write8(Adapter, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);/*  5ms */
 	rtw_write8(Adapter, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME); /*  2ms */
 
 	/*  Suggested by designer timchen. Change beacon AIFS to the largest number */
 	/*  beacause test chip does not contension before sending beacon. by tynli. 2009.11.03 */
-	rtw_write16(Adapter, REG_BCNTCFG, 0x660F);
+	usb_write16(Adapter, REG_BCNTCFG, 0x660F);
 
 	haldata->RegBcnCtrlVal = rtw_read8(Adapter, REG_BCN_CTRL);
 	haldata->RegTxPause = rtw_read8(Adapter, REG_TXPAUSE);
@@ -837,12 +837,12 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	/* Set MAX RPT MACID */
 	rtw_write8(Adapter,  REG_TX_RPT_CTRL+1, 2);/* FOR sta mode ,0: bc/mc ,1:AP */
 	/* Tx RPT Timer. Unit: 32us */
-	rtw_write16(Adapter, REG_TX_RPT_TIME, 0xCdf0);
+	usb_write16(Adapter, REG_TX_RPT_TIME, 0xCdf0);
 
 	rtw_write8(Adapter, REG_EARLY_MODE_CONTROL, 0);
 
-	rtw_write16(Adapter, REG_PKT_VO_VI_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
-	rtw_write16(Adapter, REG_PKT_BE_BK_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
+	usb_write16(Adapter, REG_PKT_VO_VI_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
+	usb_write16(Adapter, REG_PKT_BE_BK_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
 
 	/* Keep RfRegChnlVal for later use. */
 	haldata->RfRegChnlVal[0] = PHY_QueryRFReg(Adapter, (enum rf_radio_path)0, RF_CHNLBW, bRFRegOffsetMask);
@@ -874,7 +874,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_MISC11);
 	rtw_write8(Adapter, REG_HWSEQ_CTRL, 0xFF);
 
 	if (pregistrypriv->wifi_spec)
-		rtw_write16(Adapter, REG_FAST_EDCA_CTRL, 0);
+		usb_write16(Adapter, REG_FAST_EDCA_CTRL, 0);
 
 	/* Nav limit , suggest by scott */
 	rtw_write8(Adapter, 0x652, 0x0);
@@ -902,10 +902,10 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_HAL_DM);
 		rtw_write8(Adapter, REG_EARLY_MODE_CONTROL+3, 0x01);/* Pretx_en, for WEP/TKIP SEC */
 
 		/* tynli_test_tx_report. */
-		rtw_write16(Adapter, REG_TX_RPT_TIME, 0x3DF0);
+		usb_write16(Adapter, REG_TX_RPT_TIME, 0x3DF0);
 
 		/* enable tx DMA to drop the redundate data of packet */
-		rtw_write16(Adapter, REG_TXDMA_OFFSET_CHK, (rtw_read16(Adapter, REG_TXDMA_OFFSET_CHK) | DROP_DATA_EN));
+		usb_write16(Adapter, REG_TXDMA_OFFSET_CHK, (rtw_read16(Adapter, REG_TXDMA_OFFSET_CHK) | DROP_DATA_EN));
 
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_IQK);
 		/*  2010/08/26 MH Merge from 8192CE. */
@@ -1006,7 +1006,7 @@ static void rtl8192cu_hw_power_down(struct adapter *adapt)
 
 	/*  Enable register area 0x0-0xc. */
 	rtw_write8(adapt, REG_RSV_CTRL, 0x0);
-	rtw_write16(adapt, REG_APS_FSMCO, 0x8812);
+	usb_write16(adapt, REG_APS_FSMCO, 0x8812);
 }
 
 static u32 rtl8188eu_hal_deinit(struct adapter *Adapter)
@@ -1259,17 +1259,17 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 		/* Set RCR */
 		usb_write32(Adapter, REG_RCR, 0x7000208e);/* CBSSID_DATA must set to 0,reject ICV_ERR packet */
 		/* enable to rx data frame */
-		rtw_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
+		usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 		/* enable to rx ps-poll */
-		rtw_write16(Adapter, REG_RXFLTMAP1, 0x0400);
+		usb_write16(Adapter, REG_RXFLTMAP1, 0x0400);
 
 		/* Beacon Control related register for first time */
 		rtw_write8(Adapter, REG_BCNDMATIM, 0x02); /*  2ms */
 
 		rtw_write8(Adapter, REG_ATIMWND, 0x0a); /*  10ms */
-		rtw_write16(Adapter, REG_BCNTCFG, 0x00);
-		rtw_write16(Adapter, REG_TBTT_PROHIBIT, 0xff04);
-		rtw_write16(Adapter, REG_TSFTR_SYN_OFFSET, 0x7fff);/*  +32767 (~32ms) */
+		usb_write16(Adapter, REG_BCNTCFG, 0x00);
+		usb_write16(Adapter, REG_TBTT_PROHIBIT, 0xff04);
+		usb_write16(Adapter, REG_TSFTR_SYN_OFFSET, 0x7fff);/*  +32767 (~32ms) */
 
 		/* reset TSF */
 		rtw_write8(Adapter, REG_DUAL_TSF_RST, BIT(0));
@@ -1435,7 +1435,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 	case HW_VAR_MLME_DISCONNECT:
 		/* Set RCR to not to receive data frame when NO LINK state */
 		/* reject all data frames */
-		rtw_write16(Adapter, REG_RXFLTMAP2, 0x00);
+		usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
 		/* reset TSF */
 		rtw_write8(Adapter, REG_DUAL_TSF_RST, (BIT(0)|BIT(1)));
@@ -1450,7 +1450,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			v &= ~(RCR_CBSSID_BCN);
 			usb_write32(Adapter, REG_RCR, v);
 			/* reject all data frame */
-			rtw_write16(Adapter, REG_RXFLTMAP2, 0x00);
+			usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
 			/* disable update TSF */
 			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(4));
@@ -1461,12 +1461,12 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			if ((is_client_associated_to_ap(Adapter)) ||
 			    ((pmlmeinfo->state&0x03) == WIFI_FW_ADHOC_STATE)) {
 				/* enable to rx data frame */
-				rtw_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
+				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 
 				/* enable update TSF */
 				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			} else if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
-				rtw_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
+				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 				/* enable update TSF */
 				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			}
@@ -1491,7 +1491,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			if (type == 0) { /*  prepare to join */
 				/* enable to rx data frame.Accept all data frame */
-				rtw_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
+				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 
 				if (Adapter->in_cta_test) {
 					u32 v = rtw_read32(Adapter, REG_RCR);
@@ -1507,7 +1507,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 					RetryLimit = 0x7;
 			} else if (type == 1) {
 				/* joinbss_event call back when join res < 0 */
-				rtw_write16(Adapter, REG_RXFLTMAP2, 0x00);
+				usb_write16(Adapter, REG_RXFLTMAP2, 0x00);
 			} else if (type == 2) {
 				/* sta add event call back */
 				/* enable update TSF */
@@ -1516,11 +1516,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE|WIFI_ADHOC_MASTER_STATE))
 					RetryLimit = 0x7;
 			}
-			rtw_write16(Adapter, REG_RL, RetryLimit << RETRY_LIMIT_SHORT_SHIFT | RetryLimit << RETRY_LIMIT_LONG_SHIFT);
+			usb_write16(Adapter, REG_RL, RetryLimit << RETRY_LIMIT_SHORT_SHIFT | RetryLimit << RETRY_LIMIT_LONG_SHIFT);
 		}
 		break;
 	case HW_VAR_BEACON_INTERVAL:
-		rtw_write16(Adapter, REG_BCN_INTERVAL, *((u16 *)val));
+		usb_write16(Adapter, REG_BCN_INTERVAL, *((u16 *)val));
 		break;
 	case HW_VAR_SLOT_TIME:
 		{
@@ -1814,7 +1814,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 					DBG_88E("Stop RX DMA failed......\n");
 
 				/* RQPN Load 0 */
-				rtw_write16(Adapter, REG_RQPN_NPQ, 0x0);
+				usb_write16(Adapter, REG_RQPN_NPQ, 0x0);
 				usb_write32(Adapter, REG_RQPN, 0x80000000);
 				mdelay(10);
 			}
@@ -2162,7 +2162,7 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 	/* reset TSF, enable update TSF, correcting TSF On Beacon */
 
 	/* BCN interval */
-	rtw_write16(adapt, REG_BCN_INTERVAL, pmlmeinfo->bcn_interval);
+	usb_write16(adapt, REG_BCN_INTERVAL, pmlmeinfo->bcn_interval);
 	rtw_write8(adapt, REG_ATIMWND, 0x02);/*  2ms */
 
 	_InitBeaconParameters(adapt);
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index b3b1cf0..f2aa3d5 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -201,7 +201,7 @@ static int usb_write8(struct adapter *adapter, u32 addr, u8 val)
 	return ret;
 }
 
-static int usb_write16(struct adapter *adapter, u32 addr, u16 val)
+int usb_write16(struct adapter *adapter, u32 addr, u16 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -670,5 +670,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read16 = &usb_read16;
 	pops->_read32 = &usb_read32;
 	pops->_write8 = &usb_write8;
-	pops->_write16 = &usb_write16;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index f5dc069..24b3ee0 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -48,7 +48,6 @@ struct _io_ops {
 	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
 	u32 (*_read32)(struct adapter *pintfhdl, u32 addr);
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
-	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
 };
 
 struct io_req {
@@ -87,7 +86,7 @@ u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_read_port_cancel(struct adapter *adapter);
 
 int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
-int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
+int usb_write16(struct adapter *adapter, u32 addr, u16 val);
 int usb_write32(struct adapter *adapter, u32 addr, u32 val);
 int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
@@ -100,8 +99,6 @@ void usb_write_port_cancel(struct adapter *adapter);
 
 #define  rtw_write8(adapter, addr, val)					\
 	_rtw_write8((adapter), (addr), (val))
-#define  rtw_write16(adapter, addr, val)				\
-	_rtw_write16((adapter), (addr), (val))
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 89728f2..526978f 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2226,7 +2226,7 @@ static int rtw_wx_write32(struct net_device *dev,
 		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%02X\n", __func__, addr, (u8)data32);
 		break;
 	case 2:
-		rtw_write16(padapter, addr, (u16)data32);
+		usb_write16(padapter, addr, (u16)data32);
 		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%04X\n", __func__, addr, (u16)data32);
 		break;
 	case 4:
@@ -2373,7 +2373,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 			rtw_write8(padapter, RegRWStruct->offset, (u8)RegRWStruct->value);
 			break;
 		case 2:
-			rtw_write16(padapter, RegRWStruct->offset, (u16)RegRWStruct->value);
+			usb_write16(padapter, RegRWStruct->offset, (u16)RegRWStruct->value);
 			break;
 		case 4:
 			usb_write32(padapter, RegRWStruct->offset, (u32)RegRWStruct->value);
@@ -4126,8 +4126,8 @@ static int rtw_dbg_port(struct net_device *dev,
 			DBG_88E("rtw_write8(0x%x) = 0x%02x\n", arg, rtw_read8(padapter, arg));
 			break;
 		case 2:
-			rtw_write16(padapter, arg, extra_arg);
-			DBG_88E("rtw_write16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
+			usb_write16(padapter, arg, extra_arg);
+			DBG_88E("usb_write16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
 			break;
 		case 4:
 			usb_write32(padapter, arg, extra_arg);
@@ -4311,7 +4311,7 @@ static int rtw_dbg_port(struct net_device *dev,
 				value = value | 0x10;
 
 			write_value = value | (value << 5);
-			rtw_write16(padapter, 0x6d9, write_value);
+			usb_write16(padapter, 0x6d9, write_value);
 		}
 		break;
 	case 0x7a:
@@ -6422,7 +6422,7 @@ static int rtw_mp_write_reg(struct net_device *dev,
 			ret = -EINVAL;
 			break;
 		}
-		rtw_write16(padapter, addr, data);
+		usb_write16(padapter, addr, data);
 		break;
 	case 'd':
 		/*  4 bytes */
-- 
1.7.10.4

