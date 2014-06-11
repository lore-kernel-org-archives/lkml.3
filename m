Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbaFKRXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39439 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaFKRXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/22] staging: rtl8188eu: Remove function _rtw_write32()
Date: Wed, 11 Jun 2014 22:51:31 +0530
Message-Id: <1402507301-3722-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_write32() is a wrapper function, being used to call usb_write32().
Call usb_write32() directly and drop _rtw_write32().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_io.c           |   12 ---
 drivers/staging/rtl8188eu/core/rtw_mp.c           |   16 ++--
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    2 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c    |    2 +-
 drivers/staging/rtl8188eu/hal/odm.c               |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c      |    6 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    6 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c   |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |   94 ++++++++++-----------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |    3 +-
 drivers/staging/rtl8188eu/include/rtw_io.h        |    5 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   14 +--
 13 files changed, 76 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index 995b74b..eaf0212 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -69,7 +69,7 @@ int proc_set_write_reg(struct file *file, const char __user *buffer,
 			rtw_write16(padapter, addr, (u16)val);
 			break;
 		case 4:
-			rtw_write32(padapter, addr, val);
+			usb_write32(padapter, addr, val);
 			break;
 		default:
 			DBG_88E("error write length =%d", len);
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 182074f..ebbbbd6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -113,18 +113,6 @@ int _rtw_write16(struct adapter *adapter, u32 addr, u16 val)
 
 	return RTW_STATUS_CODE(ret);
 }
-int _rtw_write32(struct adapter *adapter, u32 addr, u32 val)
-{
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
-	int ret;
-	_write32 = pintfhdl->io_ops._write32;
-
-	ret = _write32(adapter, addr, val);
-
-	return RTW_STATUS_CODE(ret);
-}
 
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 17427a6..d1b2c54 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -56,7 +56,7 @@ void write_macreg(struct adapter *padapter, u32 addr, u32 val, u32 sz)
 		rtw_write16(padapter, addr, (u16)val);
 		break;
 	case 4:
-		rtw_write32(padapter, addr, val);
+		usb_write32(padapter, addr, val);
 		break;
 	default:
 		break;
@@ -221,7 +221,7 @@ s32 MPT_InitializeAdapter(struct adapter *pAdapter, u8 Channel)
 	/*  */
 
 	/*  Don't accept any packets */
-	rtw_write32(pAdapter, REG_RCR, 0);
+	usb_write32(pAdapter, REG_RCR, 0);
 
 	PHY_IQCalibrate(pAdapter, false);
 	dm_CheckTXPowerTracking(&pHalData->odmpriv);	/* trigger thermal meter */
@@ -788,12 +788,12 @@ void SetPacketRx(struct adapter *pAdapter, u8 bStartRx)
 
 		pHalData->ReceiveConfig |= ACRC32;
 
-		rtw_write32(pAdapter, REG_RCR, pHalData->ReceiveConfig);
+		usb_write32(pAdapter, REG_RCR, pHalData->ReceiveConfig);
 
 		/*  Accept all data frames */
 		rtw_write16(pAdapter, REG_RXFLTMAP2, 0xFFFF);
 	} else {
-		rtw_write32(pAdapter, REG_RCR, 0);
+		usb_write32(pAdapter, REG_RCR, 0);
 	}
 }
 
@@ -805,7 +805,7 @@ void ResetPhyRxPktCount(struct adapter *pAdapter)
 		phyrx_set = 0;
 		phyrx_set |= _RXERR_RPT_SEL(i);	/* select */
 		phyrx_set |= RXERR_RPT_RST;	/*  set counter to zero */
-		rtw_write32(pAdapter, REG_RXERR_RPT, phyrx_set);
+		usb_write32(pAdapter, REG_RXERR_RPT, phyrx_set);
 	}
 }
 
@@ -815,7 +815,7 @@ static u32 GetPhyRxPktCounts(struct adapter *pAdapter, u32 selbit)
 	u32 phyrx_set = 0, count = 0;
 
 	phyrx_set = _RXERR_RPT_SEL(selbit & 0xF);
-	rtw_write32(pAdapter, REG_RXERR_RPT, phyrx_set);
+	usb_write32(pAdapter, REG_RXERR_RPT, phyrx_set);
 
 	/* Read packet count */
 	count = rtw_read32(pAdapter, REG_RXERR_RPT) & RXERR_COUNTER_MASK;
@@ -857,11 +857,11 @@ static u32 rtw_GetPSDData(struct adapter *pAdapter, u32 point)
 	psd_val &= 0xFFBFFC00;
 	psd_val |= point;
 
-	rtw_write32(pAdapter, 0x808, psd_val);
+	usb_write32(pAdapter, 0x808, psd_val);
 	mdelay(1);
 	psd_val |= 0x00400000;
 
-	rtw_write32(pAdapter, 0x808, psd_val);
+	usb_write32(pAdapter, 0x808, psd_val);
 	mdelay(1);
 	psd_val = rtw_read32(pAdapter, 0x8B4);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index e783968..71b255d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -863,7 +863,7 @@ int rtl8188eu_oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 		rtw_write16(padapter, offset, (u16)value);
 		break;
 	case 4:
-		rtw_write32(padapter, offset, value);
+		usb_write32(padapter, offset, value);
 		break;
 	default:
 		status = NDIS_STATUS_NOT_ACCEPTED;
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index c951616..59bd949 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -850,7 +850,7 @@ _PHY_ReloadMACRegisters(
 	for (i = 0; i < (IQK_MAC_REG_NUM - 1); i++) {
 		rtw_write8(adapt, MACReg[i], (u8)MACBackup[i]);
 	}
-	rtw_write32(adapt, MACReg[i], MACBackup[i]);
+	usb_write32(adapt, MACReg[i], MACBackup[i]);
 }
 
 void
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 2a0ac4a..dfab77e 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1363,7 +1363,7 @@ void odm_EdcaTurboCheckCE(struct odm_dm_struct *pDM_Odm)
 			else
 				edca_param = EDCAParam[HT_IOT_PEER_UNKNOWN][trafficIndex];
 
-			rtw_write32(Adapter, REG_EDCA_BE_PARAM, edca_param);
+			usb_write32(Adapter, REG_EDCA_BE_PARAM, edca_param);
 
 			pDM_Odm->DM_EDCA_Table.prv_traffic_idx = trafficIndex;
 		}
@@ -1373,7 +1373,7 @@ void odm_EdcaTurboCheckCE(struct odm_dm_struct *pDM_Odm)
 		/*  Turn Off EDCA turbo here. */
 		/*  Restore original EDCA according to the declaration of AP. */
 		 if (pDM_Odm->DM_EDCA_Table.bCurrentTurboEDCA) {
-			rtw_write32(Adapter, REG_EDCA_BE_PARAM, pHalData->AcParam_BE);
+			usb_write32(Adapter, REG_EDCA_BE_PARAM, pHalData->AcParam_BE);
 			pDM_Odm->DM_EDCA_Table.bCurrentTurboEDCA = false;
 		}
 	}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 021e587..b14faac 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -726,9 +726,9 @@ void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state)
 				p2p_ps_offload->NoA1_En = 1;
 
 			/*  config P2P NoA Descriptor Register */
-			rtw_write32(adapt, REG_NOA_DESC_DURATION, pwdinfo->noa_duration[i]);
-			rtw_write32(adapt, REG_NOA_DESC_INTERVAL, pwdinfo->noa_interval[i]);
-			rtw_write32(adapt, REG_NOA_DESC_START, pwdinfo->noa_start_time[i]);
+			usb_write32(adapt, REG_NOA_DESC_DURATION, pwdinfo->noa_duration[i]);
+			usb_write32(adapt, REG_NOA_DESC_INTERVAL, pwdinfo->noa_interval[i]);
+			usb_write32(adapt, REG_NOA_DESC_START, pwdinfo->noa_start_time[i]);
 			rtw_write8(adapt, REG_NOA_DESC_COUNT, pwdinfo->noa_count[i]);
 		}
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 1a53a16..a0659fc 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -372,7 +372,7 @@ void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter *Adapter, int data_len)
 	rtw_write8(Adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
 	if (pbuf) {
 		for (addr = 0; addr < data_cnts; addr++) {
-			rtw_write32(Adapter, 0x140, addr);
+			usb_write32(Adapter, 0x140, addr);
 			msleep(1);
 			loop = 0;
 			do {
@@ -563,7 +563,7 @@ static s32 _FWFreeToGo(struct adapter *padapter)
 	value32 = rtw_read32(padapter, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
-	rtw_write32(padapter, REG_MCUFWDL, value32);
+	usb_write32(padapter, REG_MCUFWDL, value32);
 
 	_8051Reset88E(padapter);
 
@@ -1903,7 +1903,7 @@ static s32 _LLTWrite(struct adapter *padapter, u32 address, u32 data)
 	u32	value = _LLT_INIT_ADDR(address) | _LLT_INIT_DATA(data) | _LLT_OP(_LLT_WRITE_ACCESS);
 	u16	LLTReg = REG_LLT_INIT;
 
-	rtw_write32(padapter, LLTReg, value);
+	usb_write32(padapter, LLTReg, value);
 
 	/* polling */
 	do {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 941ff74..73e90e3 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -129,7 +129,7 @@ void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u3
 		Data = ((OriginalValue & (~BitMask)) | (Data << BitShift));
 	}
 
-	rtw_write32(Adapter, RegAddr, Data);
+	usb_write32(Adapter, RegAddr, Data);
 }
 
 
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 88dbc95..f4df6d4 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -139,14 +139,14 @@ static void _InitInterrupt(struct adapter *Adapter)
 	struct hal_data_8188e	*haldata = GET_HAL_DATA(Adapter);
 
 	/* HISR write one to clear */
-	rtw_write32(Adapter, REG_HISR_88E, 0xFFFFFFFF);
+	usb_write32(Adapter, REG_HISR_88E, 0xFFFFFFFF);
 	/*  HIMR - */
 	imr = IMR_PSTIMEOUT_88E | IMR_TBDER_88E | IMR_CPWM_88E | IMR_CPWM2_88E;
-	rtw_write32(Adapter, REG_HIMR_88E, imr);
+	usb_write32(Adapter, REG_HIMR_88E, imr);
 	haldata->IntrMask[0] = imr;
 
 	imr_ex = IMR_TXERR_88E | IMR_RXERR_88E | IMR_TXFOVW_88E | IMR_RXFOVW_88E;
-	rtw_write32(Adapter, REG_HIMRE_88E, imr_ex);
+	usb_write32(Adapter, REG_HIMRE_88E, imr_ex);
 	haldata->IntrMask[1] = imr_ex;
 
 	/*  REG_USB_SPECIAL_OPTION - BIT(4) */
@@ -191,11 +191,11 @@ static void _InitQueueReservedPage(struct adapter *Adapter)
 
 		/*  TX DMA */
 		value32 = _HPQ(numHQ) | _LPQ(numLQ) | _PUBQ(numPubQ) | LD_RQPN;
-		rtw_write32(Adapter, REG_RQPN, value32);
+		usb_write32(Adapter, REG_RQPN, value32);
 	} else {
 		rtw_write16(Adapter, REG_RQPN_NPQ, 0x0000);/* Just follow MP Team,??? Georgia 03/28 */
 		rtw_write16(Adapter, REG_RQPN_NPQ, 0x0d);
-		rtw_write32(Adapter, REG_RQPN, 0x808E000d);/* reserve 7 page for LPS */
+		usb_write32(Adapter, REG_RQPN, 0x808E000d);/* reserve 7 page for LPS */
 	}
 }
 
@@ -345,7 +345,7 @@ static void _InitNetworkType(struct adapter *Adapter)
 	/*  TODO: use the other function to set network type */
 	value32 = (value32 & ~MASK_NETTYPE) | _NETTYPE(NT_LINK_AP);
 
-	rtw_write32(Adapter, REG_CR, value32);
+	usb_write32(Adapter, REG_CR, value32);
 }
 
 static void _InitTransferPageSize(struct adapter *Adapter)
@@ -372,11 +372,11 @@ static void _InitWMACSetting(struct adapter *Adapter)
 				  RCR_APP_MIC | RCR_APP_PHYSTS;
 
 	/*  some REG_RCR will be modified later by phy_ConfigMACWithHeaderFile() */
-	rtw_write32(Adapter, REG_RCR, haldata->ReceiveConfig);
+	usb_write32(Adapter, REG_RCR, haldata->ReceiveConfig);
 
 	/*  Accept all multicast address */
-	rtw_write32(Adapter, REG_MAR, 0xFFFFFFFF);
-	rtw_write32(Adapter, REG_MAR + 4, 0xFFFFFFFF);
+	usb_write32(Adapter, REG_MAR, 0xFFFFFFFF);
+	usb_write32(Adapter, REG_MAR + 4, 0xFFFFFFFF);
 }
 
 static void _InitAdaptiveCtrl(struct adapter *Adapter)
@@ -388,7 +388,7 @@ static void _InitAdaptiveCtrl(struct adapter *Adapter)
 	value32 = rtw_read32(Adapter, REG_RRSR);
 	value32 &= ~RATE_BITMAP_ALL;
 	value32 |= RATE_RRSR_CCK_ONLY_1M;
-	rtw_write32(Adapter, REG_RRSR, value32);
+	usb_write32(Adapter, REG_RRSR, value32);
 
 	/*  CF-END Threshold */
 
@@ -414,10 +414,10 @@ static void _InitEDCA(struct adapter *Adapter)
 	rtw_write16(Adapter, REG_SIFS_TRX, 0x100a);
 
 	/*  TXOP */
-	rtw_write32(Adapter, REG_EDCA_BE_PARAM, 0x005EA42B);
-	rtw_write32(Adapter, REG_EDCA_BK_PARAM, 0x0000A44F);
-	rtw_write32(Adapter, REG_EDCA_VI_PARAM, 0x005EA324);
-	rtw_write32(Adapter, REG_EDCA_VO_PARAM, 0x002FA226);
+	usb_write32(Adapter, REG_EDCA_BE_PARAM, 0x005EA42B);
+	usb_write32(Adapter, REG_EDCA_BK_PARAM, 0x0000A44F);
+	usb_write32(Adapter, REG_EDCA_VI_PARAM, 0x005EA324);
+	usb_write32(Adapter, REG_EDCA_VO_PARAM, 0x002FA226);
 }
 
 static void _InitRDGSetting(struct adapter *Adapter)
@@ -429,8 +429,8 @@ static void _InitRDGSetting(struct adapter *Adapter)
 
 static void _InitRxSetting(struct adapter *Adapter)
 {
-	rtw_write32(Adapter, REG_MACID, 0x87654321);
-	rtw_write32(Adapter, 0x0700, 0x87654321);
+	usb_write32(Adapter, REG_MACID, 0x87654321);
+	usb_write32(Adapter, 0x0700, 0x87654321);
 }
 
 static void _InitRetryFunction(struct adapter *Adapter)
@@ -473,7 +473,7 @@ static void usb_AggSettingTxUpdate(struct adapter *Adapter)
 		value32 = value32 & ~(BLK_DESC_NUM_MASK << BLK_DESC_NUM_SHIFT);
 		value32 |= ((haldata->UsbTxAggDescNum & BLK_DESC_NUM_MASK) << BLK_DESC_NUM_SHIFT);
 
-		rtw_write32(Adapter, REG_TDECTRL, value32);
+		usb_write32(Adapter, REG_TDECTRL, value32);
 	}
 }	/*  usb_AggSettingTxUpdate */
 
@@ -633,7 +633,7 @@ static void _InitAntenna_Selection(struct adapter *Adapter)
 		return;
 	DBG_88E("==>  %s ....\n", __func__);
 
-	rtw_write32(Adapter, REG_LEDCFG0, rtw_read32(Adapter, REG_LEDCFG0)|BIT23);
+	usb_write32(Adapter, REG_LEDCFG0, rtw_read32(Adapter, REG_LEDCFG0)|BIT23);
 	PHY_SetBBReg(Adapter, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 
 	if (PHY_QueryBBReg(Adapter, rFPGA0_XA_RFInterfaceOE, 0x300) == Antenna_A)
@@ -867,7 +867,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_MISC11);
 	/*  Disable BAR, suggested by Scott */
 	/*  2010.04.09 add by hpfan */
 	/*  */
-	rtw_write32(Adapter, REG_BAR_MODE_CTRL, 0x0201ffff);
+	usb_write32(Adapter, REG_BAR_MODE_CTRL, 0x0201ffff);
 
 	/*  HW SEQ CTRL */
 	/* set 0x0 to 0xFF by tynli. Default enable HW SEQ NUM. */
@@ -931,7 +931,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_LCK);
 	rtw_write8(Adapter, REG_USB_HRPWM, 0);
 
 	/* ack for xmit mgmt frames. */
-	rtw_write32(Adapter, REG_FWHW_TXQ_CTRL, rtw_read32(Adapter, REG_FWHW_TXQ_CTRL)|BIT(12));
+	usb_write32(Adapter, REG_FWHW_TXQ_CTRL, rtw_read32(Adapter, REG_FWHW_TXQ_CTRL)|BIT(12));
 
 exit:
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_END);
@@ -995,7 +995,7 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 	rtw_write8(Adapter, REG_GPIO_IO_SEL, (val8<<4));
 	val8 = rtw_read8(Adapter, REG_GPIO_IO_SEL+1);
 	rtw_write8(Adapter, REG_GPIO_IO_SEL+1, val8|0x0F);/* Reg0x43 */
-	rtw_write32(Adapter, REG_BB_PAD_CTRL, 0x00080808);/* set LNA ,TRSW,EX_PA Pin to output mode */
+	usb_write32(Adapter, REG_BB_PAD_CTRL, 0x00080808);/* set LNA ,TRSW,EX_PA Pin to output mode */
 	haldata->bMacPwrCtrlOn = false;
 	Adapter->bFWReady = false;
 }
@@ -1014,8 +1014,8 @@ static u32 rtl8188eu_hal_deinit(struct adapter *Adapter)
 
 	DBG_88E("==> %s\n", __func__);
 
-	rtw_write32(Adapter, REG_HIMR_88E, IMR_DISABLED_88E);
-	rtw_write32(Adapter, REG_HIMRE_88E, IMR_DISABLED_88E);
+	usb_write32(Adapter, REG_HIMR_88E, IMR_DISABLED_88E);
+	usb_write32(Adapter, REG_HIMRE_88E, IMR_DISABLED_88E);
 
 	DBG_88E("bkeepfwalive(%x)\n", Adapter->pwrctrlpriv.bkeepfwalive);
 	if (Adapter->pwrctrlpriv.bkeepfwalive) {
@@ -1257,7 +1257,7 @@ static void hw_var_set_opmode(struct adapter *Adapter, u8 variable, u8 *val)
 		rtw_write8(Adapter, REG_BCN_CTRL, 0x12);
 
 		/* Set RCR */
-		rtw_write32(Adapter, REG_RCR, 0x7000208e);/* CBSSID_DATA must set to 0,reject ICV_ERR packet */
+		usb_write32(Adapter, REG_RCR, 0x7000208e);/* CBSSID_DATA must set to 0,reject ICV_ERR packet */
 		/* enable to rx data frame */
 		rtw_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 		/* enable to rx ps-poll */
@@ -1409,8 +1409,8 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			/* disable related TSF function */
 			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(3)));
 
-			rtw_write32(Adapter, REG_TSFTR, tsf);
-			rtw_write32(Adapter, REG_TSFTR+4, tsf>>32);
+			usb_write32(Adapter, REG_TSFTR, tsf);
+			usb_write32(Adapter, REG_TSFTR+4, tsf>>32);
 
 			/* enable related TSF function */
 			rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)|BIT(3));
@@ -1421,7 +1421,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		break;
 	case HW_VAR_CHECK_BSSID:
 		if (*((u8 *)val)) {
-			rtw_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
+			usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
 		} else {
 			u32 val32;
 
@@ -1429,7 +1429,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			val32 &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 
-			rtw_write32(Adapter, REG_RCR, val32);
+			usb_write32(Adapter, REG_RCR, val32);
 		}
 		break;
 	case HW_VAR_MLME_DISCONNECT:
@@ -1448,7 +1448,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			/* config RCR to receive different BSSID & not to receive data frame */
 			u32 v = rtw_read32(Adapter, REG_RCR);
 			v &= ~(RCR_CBSSID_BCN);
-			rtw_write32(Adapter, REG_RCR, v);
+			usb_write32(Adapter, REG_RCR, v);
 			/* reject all data frame */
 			rtw_write16(Adapter, REG_RXFLTMAP2, 0x00);
 
@@ -1471,14 +1471,14 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				rtw_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			}
 			if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
-				rtw_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
+				usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
 			} else {
 				if (Adapter->in_cta_test) {
 					u32 v = rtw_read32(Adapter, REG_RCR);
 					v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
-					rtw_write32(Adapter, REG_RCR, v);
+					usb_write32(Adapter, REG_RCR, v);
 				} else {
-					rtw_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
+					usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
 				}
 			}
 		}
@@ -1496,9 +1496,9 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				if (Adapter->in_cta_test) {
 					u32 v = rtw_read32(Adapter, REG_RCR);
 					v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
-					rtw_write32(Adapter, REG_RCR, v);
+					usb_write32(Adapter, REG_RCR, v);
 				} else {
-					rtw_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
+					usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
 				}
 
 				if (check_fwstate(pmlmepriv, WIFI_STATION_STATE))
@@ -1607,36 +1607,36 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				ulCommand = CAM_CONTENT_COUNT*ucIndex+i;
 				ulCommand = ulCommand | CAM_POLLINIG|CAM_WRITE;
 				/*  write content 0 is equall to mark invalid */
-				rtw_write32(Adapter, WCAMI, ulContent);  /* delay_ms(40); */
-				rtw_write32(Adapter, RWCAM, ulCommand);  /* delay_ms(40); */
+				usb_write32(Adapter, WCAMI, ulContent);  /* delay_ms(40); */
+				usb_write32(Adapter, RWCAM, ulCommand);  /* delay_ms(40); */
 			}
 		}
 		break;
 	case HW_VAR_CAM_INVALID_ALL:
-		rtw_write32(Adapter, RWCAM, BIT(31)|BIT(30));
+		usb_write32(Adapter, RWCAM, BIT(31)|BIT(30));
 		break;
 	case HW_VAR_CAM_WRITE:
 		{
 			u32 cmd;
 			u32 *cam_val = (u32 *)val;
-			rtw_write32(Adapter, WCAMI, cam_val[0]);
+			usb_write32(Adapter, WCAMI, cam_val[0]);
 
 			cmd = CAM_POLLINIG | CAM_WRITE | cam_val[1];
-			rtw_write32(Adapter, RWCAM, cmd);
+			usb_write32(Adapter, RWCAM, cmd);
 		}
 		break;
 	case HW_VAR_AC_PARAM_VO:
-		rtw_write32(Adapter, REG_EDCA_VO_PARAM, ((u32 *)(val))[0]);
+		usb_write32(Adapter, REG_EDCA_VO_PARAM, ((u32 *)(val))[0]);
 		break;
 	case HW_VAR_AC_PARAM_VI:
-		rtw_write32(Adapter, REG_EDCA_VI_PARAM, ((u32 *)(val))[0]);
+		usb_write32(Adapter, REG_EDCA_VI_PARAM, ((u32 *)(val))[0]);
 		break;
 	case HW_VAR_AC_PARAM_BE:
 		haldata->AcParam_BE = ((u32 *)(val))[0];
-		rtw_write32(Adapter, REG_EDCA_BE_PARAM, ((u32 *)(val))[0]);
+		usb_write32(Adapter, REG_EDCA_BE_PARAM, ((u32 *)(val))[0]);
 		break;
 	case HW_VAR_AC_PARAM_BK:
-		rtw_write32(Adapter, REG_EDCA_BK_PARAM, ((u32 *)(val))[0]);
+		usb_write32(Adapter, REG_EDCA_BK_PARAM, ((u32 *)(val))[0]);
 		break;
 	case HW_VAR_ACM_CTRL:
 		{
@@ -1805,7 +1805,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			if (!pwrpriv->bkeepfwalive) {
 				/* RX DMA stop */
-				rtw_write32(Adapter, REG_RXPKT_NUM, (rtw_read32(Adapter, REG_RXPKT_NUM)|RW_RELEASE_EN));
+				usb_write32(Adapter, REG_RXPKT_NUM, (rtw_read32(Adapter, REG_RXPKT_NUM)|RW_RELEASE_EN));
 				do {
 					if (!(rtw_read32(Adapter, REG_RXPKT_NUM)&RXDMA_IDLE))
 						break;
@@ -1815,7 +1815,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 				/* RQPN Load 0 */
 				rtw_write16(Adapter, REG_RQPN_NPQ, 0x0);
-				rtw_write32(Adapter, REG_RQPN, 0x80000000);
+				usb_write32(Adapter, REG_RQPN, 0x80000000);
 				mdelay(10);
 			}
 		}
@@ -2171,10 +2171,10 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 
 	value32 = rtw_read32(adapt, REG_TCR);
 	value32 &= ~TSFRST;
-	rtw_write32(adapt,  REG_TCR, value32);
+	usb_write32(adapt,  REG_TCR, value32);
 
 	value32 |= TSFRST;
-	rtw_write32(adapt, REG_TCR, value32);
+	usb_write32(adapt, REG_TCR, value32);
 
 	/*  NOTE: Fix test chip's bug (about contention windows's randomness) */
 	rtw_write8(adapt,  REG_RXTSF_OFFSET_CCK, 0x50);
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index cfba5d6..b3b1cf0 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -227,7 +227,7 @@ static int usb_write16(struct adapter *adapter, u32 addr, u16 val)
 	return ret;
 }
 
-static int usb_write32(struct adapter *adapter, u32 addr, u32 val)
+int usb_write32(struct adapter *adapter, u32 addr, u32 val)
 {
 	u8 request;
 	u8 requesttype;
@@ -671,5 +671,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read32 = &usb_read32;
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
-	pops->_write32 = &usb_write32;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 9c34328..f5dc069 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -49,7 +49,6 @@ struct _io_ops {
 	u32 (*_read32)(struct adapter *pintfhdl, u32 addr);
 	int (*_write8)(struct adapter *pintfhdl, u32 addr, u8 val);
 	int (*_write16)(struct adapter *pintfhdl, u32 addr, u16 val);
-	int (*_write32)(struct adapter *pintfhdl, u32 addr, u32 val);
 };
 
 struct io_req {
@@ -89,7 +88,7 @@ void usb_read_port_cancel(struct adapter *adapter);
 
 int _rtw_write8(struct adapter *adapter, u32 addr, u8 val);
 int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
-int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
+int usb_write32(struct adapter *adapter, u32 addr, u32 val);
 int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
 u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
@@ -103,8 +102,6 @@ void usb_write_port_cancel(struct adapter *adapter);
 	_rtw_write8((adapter), (addr), (val))
 #define  rtw_write16(adapter, addr, val)				\
 	_rtw_write16((adapter), (addr), (val))
-#define  rtw_write32(adapter, addr, val)				\
-	_rtw_write32((adapter), (addr), (val))
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 897f03f..89728f2 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2230,7 +2230,7 @@ static int rtw_wx_write32(struct net_device *dev,
 		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%04X\n", __func__, addr, (u16)data32);
 		break;
 	case 4:
-		rtw_write32(padapter, addr, data32);
+		usb_write32(padapter, addr, data32);
 		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%08X\n", __func__, addr, data32);
 		break;
 	default:
@@ -2376,7 +2376,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 			rtw_write16(padapter, RegRWStruct->offset, (u16)RegRWStruct->value);
 			break;
 		case 4:
-			rtw_write32(padapter, RegRWStruct->offset, (u32)RegRWStruct->value);
+			usb_write32(padapter, RegRWStruct->offset, (u32)RegRWStruct->value);
 			break;
 		default:
 			break;
@@ -3948,12 +3948,12 @@ static int rtw_cta_test_start(struct net_device *dev,
 	if (padapter->in_cta_test) {
 		u32 v = rtw_read32(padapter, REG_RCR);
 		v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
-		rtw_write32(padapter, REG_RCR, v);
+		usb_write32(padapter, REG_RCR, v);
 		DBG_88E("enable RCR_ADF\n");
 	} else {
 		u32 v = rtw_read32(padapter, REG_RCR);
 		v |= RCR_CBSSID_DATA | RCR_CBSSID_BCN;/*  RCR_ADF */
-		rtw_write32(padapter, REG_RCR, v);
+		usb_write32(padapter, REG_RCR, v);
 		DBG_88E("disable RCR_ADF\n");
 	}
 	return ret;
@@ -4130,8 +4130,8 @@ static int rtw_dbg_port(struct net_device *dev,
 			DBG_88E("rtw_write16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
 			break;
 		case 4:
-			rtw_write32(padapter, arg, extra_arg);
-			DBG_88E("rtw_write32(0x%x) = 0x%08x\n", arg, rtw_read32(padapter, arg));
+			usb_write32(padapter, arg, extra_arg);
+			DBG_88E("usb_write32(0x%x) = 0x%08x\n", arg, rtw_read32(padapter, arg));
 			break;
 		}
 		break;
@@ -6426,7 +6426,7 @@ static int rtw_mp_write_reg(struct net_device *dev,
 		break;
 	case 'd':
 		/*  4 bytes */
-		rtw_write32(padapter, addr, data);
+		usb_write32(padapter, addr, data);
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.7.10.4

