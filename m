Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaADP0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:26:06 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49354 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbaADP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:03 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] Staging: vt6656: Combine "else { if" to "else if"
Date: Sat,  4 Jan 2014 16:25:13 +0100
Message-Id: <1388849118-11994-9-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

This patch combines single ifs within the block of an else to a single
else if statement.

Therefore code that looks like that

else {
	if (cond) {
		statements;
	} else {
		other_statements;
	}
}

is converted to code that looks like that

else if (cond) {
	statements;
} else {
	other_statements;
}

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 114 +++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index bd64d59..e281d3c 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -137,14 +137,11 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 								return pCurrBSS;
 							}
 						}
-					} else {
-						if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-							((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-							((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
-							) {
-							pCurrBSS->bSelected = true;
-							return pCurrBSS;
-						}
+					} else if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
+						((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+						((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+						pCurrBSS->bSelected = true;
+						return pCurrBSS;
 					}
 				}
 			}
@@ -196,11 +193,9 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
 				if (pSelect == NULL) {
 					pSelect = pCurrBSS;
-				} else {
-					/* compare RSSI, select the strongest signal */
-					if (pCurrBSS->uRSSI < pSelect->uRSSI) {
-						pSelect = pCurrBSS;
-					}
+				/* compare RSSI, select the strongest signal */
+				} else if (pCurrBSS->uRSSI < pSelect->uRSSI) {
+					pSelect = pCurrBSS;
 				}
 			}
 		}
@@ -364,15 +359,12 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
 	/* Check if BSS is 802.11a/b/g */
-	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
+	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G)
 		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
-	} else {
-		if (pBSSList->sERP.bERPExist == true) {
-			pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
-		} else {
-			pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
-		}
-	}
+	else if (pBSSList->sERP.bERPExist == true)
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
+	else
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
 
 	pBSSList->byRxRate = pRxPacket->byRxRate;
 	pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
@@ -521,15 +513,12 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
 	/* Check if BSS is 802.11a/b/g */
-	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
+	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G)
 		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
-	} else {
-		if (pBSSList->sERP.bERPExist == true) {
-			pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
-		} else {
-			pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
-		}
-	}
+	else if (pBSSList->sERP.bERPExist == true)
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
+	else
+		pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
 
 	pBSSList->byRxRate = pRxPacket->byRxRate;
 	pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
@@ -891,11 +880,10 @@ void BSSvSecondCallBack(struct work_struct *work)
 					/* ii = 0 for multicast node (AP & Adhoc) */
 					RATEvTxRateFallBack((void *) pDevice,
 						&(pMgmt->sNodeDBTable[ii]));
-				} else {
+				} else if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 					/* ii = 0 reserved for unicast AP node (Infra STA) */
-					if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
-						RATEvTxRateFallBack((void *) pDevice,
-							&(pMgmt->sNodeDBTable[ii]));
+					RATEvTxRateFallBack((void *) pDevice,
+						&(pMgmt->sNodeDBTable[ii]));
 				}
 
 			}
@@ -922,11 +910,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 				MACvEnableProtectMD(pDevice);
 				pDevice->bProtectMode = true;
 			}
-		} else {
-			if (pDevice->bProtectMode) {
-				MACvDisableProtectMD(pDevice);
-				pDevice->bProtectMode = false;
-			}
+		} else if (pDevice->bProtectMode) {
+			MACvDisableProtectMD(pDevice);
+			pDevice->bProtectMode = false;
 		}
 		/* on/off short slot time */
 
@@ -936,12 +922,10 @@ void BSSvSecondCallBack(struct work_struct *work)
 				BBvSetShortSlotTime(pDevice);
 				vUpdateIFS((void *) pDevice);
 			}
-		} else {
-			if (!pDevice->bShortSlotTime) {
+		} else if (!pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = true;
 				BBvSetShortSlotTime(pDevice);
 				vUpdateIFS((void *) pDevice);
-			}
 		}
 
 		/* on/off barker long preamble mode */
@@ -951,11 +935,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 				MACvEnableBarkerPreambleMd(pDevice);
 				pDevice->bBarkerPreambleMd = true;
 			}
-		} else {
-			if (pDevice->bBarkerPreambleMd) {
+		} else if (pDevice->bBarkerPreambleMd) {
 				MACvDisableBarkerPreambleMd(pDevice);
 				pDevice->bBarkerPreambleMd = false;
-			}
 		}
 
 	}
@@ -1031,28 +1013,26 @@ void BSSvSecondCallBack(struct work_struct *work)
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
 				}
+			} else if (pDevice->uAutoReConnectTime < 10) {
+				pDevice->uAutoReConnectTime++;
+				/* network manager support need not do Roaming scan??? */
+				if (pDevice->bWPASuppWextEnabled == true)
+					pDevice->uAutoReConnectTime = 0;
 			} else {
-				if (pDevice->uAutoReConnectTime < 10) {
-					pDevice->uAutoReConnectTime++;
-					/* network manager support need not do Roaming scan??? */
-					if (pDevice->bWPASuppWextEnabled == true)
-						pDevice->uAutoReConnectTime = 0;
-				} else {
-					/* mike use old encryption status for wpa reauthen */
-					if (pDevice->bWPADEVUp)
-						pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
+				/* mike use old encryption status for wpa reauthen */
+				if (pDevice->bWPADEVUp)
+					pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
 
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
-					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
-					pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-					bScheduleCommand((void *) pDevice,
-							 WLAN_CMD_BSSID_SCAN,
-							 pMgmt->abyDesireSSID);
-					bScheduleCommand((void *) pDevice,
-							 WLAN_CMD_SSID,
-							 pMgmt->abyDesireSSID);
-					pDevice->uAutoReConnectTime = 0;
-				}
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
+				BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+				bScheduleCommand((void *) pDevice,
+						 WLAN_CMD_BSSID_SCAN,
+						 pMgmt->abyDesireSSID);
+				bScheduleCommand((void *) pDevice,
+						 WLAN_CMD_SSID,
+						 pMgmt->abyDesireSSID);
+				pDevice->uAutoReConnectTime = 0;
 			}
 		}
 	}
@@ -1203,11 +1183,11 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 		}
 
 		if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
-			(pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
+		     (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
 
 			if (BSSbIsSTAInNodeDB((void *) pDevice,
-						  pbyDestAddr,
-						  &uNodeIndex)) {
+					      pbyDestAddr,
+					      &uNodeIndex)) {
 				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
 				if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
 					/* transmit success, TxAttempts at least plus one */
-- 
1.8.1.2

