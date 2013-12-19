Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3LSPhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:37:43 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56879 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab3LSPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:37:25 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux@rationality.eu, linux-kernel@i4.cs.fau.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tvboxspy@gmail.com, more.andres@gmail.com, gregkh@linuxfoundation.org,
        forest@alittletooquiet.net
Subject: [PATCH 2/2] vt6656: Combined nested conditions
Date: Thu, 19 Dec 2013 16:27:06 +0100
Message-Id: <1387466826-2410-3-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387466826-2410-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1387466826-2410-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

This patch reduces the level of indentation in bssdb.c of the vt6656
driver by transforming nested conditions to a series of logical
conjunctions. E.g.

if (cond1) {
        if (cond2) {
                block();
        }
}

is transformed to

if (cond1 && cond2) {
        block();
}

These adjustments increase the readability of the driver without
altering its semantics. But still the file does not pass checkpatch
completely (mainly due to lines over 80 characters).

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 356 ++++++++++++++++++++---------------------
 1 file changed, 171 insertions(+), 185 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 34bdd4c..15ae5f0 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -106,10 +106,8 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		    && (memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))
 			pbyBSSID = pbyDesireBSSID;
 	}
-	if (pbyDesireSSID != NULL) {
-		if (((PWLAN_IE_SSID)pbyDesireSSID)->len != 0)
-			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
-	}
+	if (pbyDesireSSID != NULL && ((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
+		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
 
 	if ((pbyBSSID != NULL) && (pDevice->bRoaming == false)) {
 		/* match BSSID first */
@@ -117,29 +115,31 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 			pCurrBSS->bSelected = false;
 			if ((pCurrBSS->bActive)
-			    && (pCurrBSS->bSelected == false)) {
-				if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
-					if (pSSID != NULL) {
-						/* compare ssid */
-						if (!memcmp(pSSID->abySSID,
-							   ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
-							   pSSID->len)) {
-							if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO)
-							    || ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
-							    || ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
-								pCurrBSS->bSelected = true;
-								return pCurrBSS;
-							}
-						}
-					} else {
-						if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO)
-						    || ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
-							&& WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
-						    || ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA)
-							&& WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
-							pCurrBSS->bSelected = true;
-							return pCurrBSS;
-						}
+			    && (pCurrBSS->bSelected == false)
+			    && (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID))) {
+				if (pSSID != NULL) {
+					/* compare ssid */
+					if ((!memcmp(pSSID->abySSID,
+						    ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
+						    pSSID->len))
+					    && ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO)
+						|| ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
+						    && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
+						|| ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA)
+						    && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)))) {
+
+						pCurrBSS->bSelected = true;
+						return pCurrBSS;
+					}
+				} else {
+					if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO)
+					    || ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
+						&& WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
+					    || ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA)
+						&& WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+
+						pCurrBSS->bSelected = true;
+						return pCurrBSS;
 					}
 				}
 			}
@@ -152,19 +152,19 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
 			pCurrBSS->bSelected = false;
 			if (pCurrBSS->bActive) {
-				if (pSSID != NULL)
-					/* matched SSID */
-					if (memcmp(pSSID->abySSID,
-						   ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
-						   pSSID->len)
-					    || (pSSID->len != ((PWLAN_IE_SSID) pCurrBSS->abySSID)->len))
+				if ((pSSID != NULL)
+				    /* matched SSID */
+				    && (memcmp(pSSID->abySSID,
+					       ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
+					       pSSID->len)
+					|| (pSSID->len != ((PWLAN_IE_SSID) pCurrBSS->abySSID)->len)))
 						/* SSID not match skip this BSS */
 						continue;
 
 				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA)
 				     && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
 				    || ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA)
-				     && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))) {
+					&& WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))) {
 					/* Type not match skip this BSS */
 					DBG_PRT(MSG_LEVEL_DEBUG,
 						KERN_INFO "BSS type mismatch.... Config[%d] BSS[0x%04x]\n",
@@ -173,18 +173,18 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					continue;
 				}
 
-				if (ePhyType != PHY_TYPE_AUTO) {
-					if (((ePhyType == PHY_TYPE_11A)
-					     && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse))
-					    || ((ePhyType != PHY_TYPE_11A)
-						&& (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
-						/* PhyType not match skip this BSS */
-						DBG_PRT(MSG_LEVEL_DEBUG,
-							KERN_INFO "Physical type mismatch.... ePhyType[%d] BSS[%d]\n",
-							ePhyType,
-							pCurrBSS->eNetworkTypeInUse);
-						continue;
-					}
+				if ((ePhyType != PHY_TYPE_AUTO)
+				    && (((ePhyType == PHY_TYPE_11A)
+					 && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse))
+					|| ((ePhyType != PHY_TYPE_11A)
+					    && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse)))) {
+
+					/* PhyType not match skip this BSS */
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO "Physical type mismatch.... ePhyType[%d] BSS[%d]\n",
+						ePhyType,
+						pCurrBSS->eNetworkTypeInUse);
+					continue;
 				}
 
 				pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
@@ -193,13 +193,11 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					pCurrBSS->abyBSSID);
 				jj++;
 
-				if (pSelect == NULL) {
+				if (pSelect == NULL)
+					pSelect = pCurrBSS;
+				/* compare RSSI, select the strongest signal */
+				else if (pCurrBSS->uRSSI < pSelect->uRSSI)
 					pSelect = pCurrBSS;
-				} else {
-					/* compare RSSI, select the strongest signal */
-					if (pCurrBSS->uRSSI < pSelect->uRSSI)
-						pSelect = pCurrBSS;
-				}
 			}
 		}
 
@@ -232,19 +230,18 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 	int ii;
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-		if (bKeepCurrBSSID) {
-			if (pMgmt->sBSSList[ii].bActive
-			    && ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
-						pMgmt->abyCurrBSSID)) {
-				/* mike mark:
-				 * there are two BSSID's in list. If that AP is
-				 * in hidden ssid mode, one SSID is null, but
-				 * other's might not be obvious, so if it
-				 * associate's with your STA, you must keep the
-				 * two of them!!  bKeepCurrBSSID = false;
-				 */
-				continue;
-			}
+		if ((bKeepCurrBSSID)
+		    && (pMgmt->sBSSList[ii].bActive)
+		    && ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+					pMgmt->abyCurrBSSID)) {
+			/* mike mark:
+			 * there are two BSSID's in list. If that AP is
+			 * in hidden ssid mode, one SSID is null, but
+			 * other's might not be obvious, so if it
+			 * associate's with your STA, you must keep the
+			 * two of them!!  bKeepCurrBSSID = false;
+			 */
+			continue;
 		}
 
 		pMgmt->sBSSList[ii].bActive = false;
@@ -269,20 +266,18 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		pBSSList = &(pMgmt->sBSSList[ii]);
-		if (pBSSList->bActive) {
-			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
-				if (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len) {
-					if (memcmp(pSSID->abySSID,
-							((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
-							pSSID->len) == 0)
-						return pBSSList;
-				}
-			}
-		}
+
+		if ((pBSSList->bActive)
+		    && (ether_addr_equal(pBSSList->abyBSSID, abyBSSID))
+		    && (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len)
+		    && (memcmp(pSSID->abySSID,
+			       ((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
+			       pSSID->len) == 0))
+			return pBSSList;
 	}
 
 	return NULL;
-};
+}
 
 /* Routine Description:
  *	  Insert a BSS set into known BSS list
@@ -383,11 +378,10 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	pBSSList->bySQ = pRxPacket->bySQ;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
-	    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS)
-			bParsingQuiet = true;
-	}
+	    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)
+	    /* assoc with BSS */
+	    && (pBSSList == pMgmt->pCurrBSS))
+		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList);
 
@@ -433,23 +427,22 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 				pSSID->len))) {
 
 			bAdd_PMKID_Candidate((void *) pDevice,
-						 pBSSList->abyBSSID,
-						 &pBSSList->sRSNCapObj);
+					     pBSSList->abyBSSID,
+					     &pBSSList->sRSNCapObj);
 
 			if ((pDevice->bLinkPass == true)
-			    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-				if ((KeybGetTransmitKey(&(pDevice->sKey),
-							pDevice->abyBSSID,
-							PAIRWISE_KEY,
-							&pTransmitKey) == true)
-				    || (KeybGetTransmitKey(&(pDevice->sKey),
-							   pDevice->abyBSSID,
-							   GROUP_KEY,
-							   &pTransmitKey) == true)) {
-					pDevice->gsPMKIDCandidate.StatusType =
-						Ndis802_11StatusType_PMKID_CandidateList;
-					pDevice->gsPMKIDCandidate.Version = 1;
-				}
+			    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)
+			    && ((KeybGetTransmitKey(&(pDevice->sKey),
+						    pDevice->abyBSSID,
+						    PAIRWISE_KEY,
+						    &pTransmitKey) == true)
+				|| (KeybGetTransmitKey(&(pDevice->sKey),
+						       pDevice->abyBSSID,
+						       GROUP_KEY,
+						       &pTransmitKey) == true))) {
+				pDevice->gsPMKIDCandidate.StatusType =
+					Ndis802_11StatusType_PMKID_CandidateList;
+				pDevice->gsPMKIDCandidate.Version = 1;
 			}
 		}
 	}
@@ -553,11 +546,10 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	pBSSList->bySQ = pRxPacket->bySQ;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
-	    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
+	    && (pMgmt->eCurrState == WMAC_STATE_ASSOC)
 		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS)
-			bParsingQuiet = true;
-	}
+	    &&  (pBSSList == pMgmt->pCurrBSS))
+		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList);	/* mike update */
 
@@ -625,12 +617,12 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 
 	/* Index = 0 reserved for AP Node */
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
-		if (pMgmt->sNodeDBTable[ii].bActive) {
-			if (ether_addr_equal(abyDstAddr,
-					     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
-				*puNodeIndex = ii;
-				return true;
-			}
+		if ((pMgmt->sNodeDBTable[ii].bActive)
+		    && (ether_addr_equal(abyDstAddr,
+					 pMgmt->sNodeDBTable[ii].abyMACAddr))) {
+
+			*puNodeIndex = ii;
+			return true;
 		}
 	}
 
@@ -936,8 +928,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 					KERN_INFO "Index= %d, Queue = %d pending\n",
 					ii,
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt);
-				if (ii > 0
-				    && pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15) {
+				if ((ii > 0)
+				    && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
 					BSSvRemoveOneNode(pDevice, ii);
 					DBG_PRT(MSG_LEVEL_NOTICE,
 						KERN_INFO "Pending many queues PS STA Index = %d remove\n",
@@ -956,11 +948,9 @@ void BSSvSecondCallBack(struct work_struct *work)
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
 
@@ -970,12 +960,10 @@ void BSSvSecondCallBack(struct work_struct *work)
 				BBvSetShortSlotTime(pDevice);
 				vUpdateIFS((void *) pDevice);
 			}
-		} else {
-			if (!pDevice->bShortSlotTime) {
-				pDevice->bShortSlotTime = true;
-				BBvSetShortSlotTime(pDevice);
-				vUpdateIFS((void *) pDevice);
-			}
+		} else if (!pDevice->bShortSlotTime) {
+			pDevice->bShortSlotTime = true;
+			BBvSetShortSlotTime(pDevice);
+			vUpdateIFS((void *) pDevice);
 		}
 
 		/* on/off barker long preamble mode */
@@ -985,11 +973,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 				MACvEnableBarkerPreambleMd(pDevice);
 				pDevice->bBarkerPreambleMd = true;
 			}
-		} else {
-			if (pDevice->bBarkerPreambleMd) {
-				MACvDisableBarkerPreambleMd(pDevice);
-				pDevice->bBarkerPreambleMd = false;
-			}
+		} else if (pDevice->bBarkerPreambleMd) {
+			MACvDisableBarkerPreambleMd(pDevice);
+			pDevice->bBarkerPreambleMd = false;
 		}
 	}
 
@@ -1051,7 +1037,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			}
 		} else if (pItemSSID->len != 0) {
 			/* Davidwang */
-			if (pDevice->bEnableRoaming == true
+			if ((pDevice->bEnableRoaming == true)
 			    && !(pMgmt->Cisco_cckm)) {
 				DBG_PRT(MSG_LEVEL_DEBUG,
 					KERN_INFO "bRoaming %d, !\n",
@@ -1059,8 +1045,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 				DBG_PRT(MSG_LEVEL_DEBUG,
 					KERN_INFO "bIsRoaming %d, !\n",
 					pDevice->bIsRoaming);
-				if (pDevice->bRoaming == true
-				      && pDevice->bIsRoaming == true) {
+				if ((pDevice->bRoaming == true)
+				      && (pDevice->bIsRoaming == true)) {
 					DBG_PRT(MSG_LEVEL_DEBUG,
 						KERN_INFO "Fast   Roaming ...\n");
 					BSSvClearBSSList((void *) pDevice,
@@ -1074,8 +1060,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 					pDevice->uAutoReConnectTime = 0;
 					pDevice->uIsroamingTime = 0;
 					pDevice->bRoaming = false;
-				} else if (pDevice->bRoaming == false
-					   && pDevice->bIsRoaming == true) {
+				} else if ((pDevice->bRoaming == false)
+					   && (pDevice->bIsRoaming == true)) {
 					pDevice->uIsroamingTime++;
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
@@ -1220,9 +1206,9 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
 				/* transmit success, TxAttempts at least plus one */
 				pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
 				if ((byFallBack == AUTO_FB_NONE)
-				    || (wRate < RATE_18M))
+				    || (wRate < RATE_18M)) {
 					wFallBackRate = wRate;
-				else if (byFallBack == AUTO_FB_0) {
+				} else if (byFallBack == AUTO_FB_0) {
 					if (byTxRetry < 5)
 						wFallBackRate =
 							awHWRetry0[wRate-RATE_18M][byTxRetry];
@@ -1245,10 +1231,10 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
 			if (byTxRetry != 0) {
 				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE] += byTxRetry;
 				if ((byFallBack == AUTO_FB_NONE)
-				    || (wRate < RATE_18M))
+				    || (wRate < RATE_18M)) {
 					pMgmt->sNodeDBTable[0].uTxFail[wRate] +=
 						byTxRetry;
-				else if (byFallBack == AUTO_FB_0) {
+				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
 						if (ii < 5)
 							wFallBackRate =
@@ -1272,63 +1258,63 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
 			}
 		}
 
-		if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
-		    || (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
-
-			if (BSSbIsSTAInNodeDB((void *) pDevice,
-					      pbyDestAddr,
-					      &uNodeIndex)) {
-				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
-				if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-					/* transmit success, TxAttempts at least plus one */
-					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
-					if ((byFallBack == AUTO_FB_NONE)
-					    || (wRate < RATE_18M))
-						wFallBackRate = wRate;
-					else if (byFallBack == AUTO_FB_0) {
-						if (byTxRetry < 5)
+		if (((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
+		     || (pMgmt->eCurrMode == WMAC_MODE_ESS_AP))
+		    && (BSSbIsSTAInNodeDB((void *) pDevice,
+					  pbyDestAddr,
+					  &uNodeIndex))) {
+			pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
+			if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+				/* transmit success, TxAttempts at least plus one */
+				pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
+				if ((byFallBack == AUTO_FB_NONE)
+				    || (wRate < RATE_18M)) {
+					wFallBackRate = wRate;
+				} else if (byFallBack == AUTO_FB_0) {
+					if (byTxRetry < 5)
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][byTxRetry];
+					else
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][4];
+				} else if (byFallBack == AUTO_FB_1) {
+					if (byTxRetry < 5)
+						wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+					else
+						wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+				}
+				pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
+			} else {
+				pMgmt->sNodeDBTable[uNodeIndex].uTxFailures++;
+			}
+
+			pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
+			if (byTxRetry != 0) {
+				pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] +=
+									byTxRetry;
+				if ((byFallBack == AUTO_FB_NONE)
+				    || (wRate < RATE_18M)) {
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] +=
+									byTxRetry;
+				} else if (byFallBack == AUTO_FB_0) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
 							wFallBackRate =
-								awHWRetry0[wRate-RATE_18M][byTxRetry];
+								awHWRetry0[wRate-RATE_18M][ii];
 						else
 							wFallBackRate =
 								awHWRetry0[wRate-RATE_18M][4];
-					} else if (byFallBack == AUTO_FB_1) {
-						if (byTxRetry < 5)
-							wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
-						else
-							wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
 					}
-					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
-				} else
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFailures++;
-				pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
-				if (byTxRetry != 0) {
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] +=
-										byTxRetry;
-					if ((byFallBack == AUTO_FB_NONE)
-					    || (wRate < RATE_18M))
-						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] +=
-										byTxRetry;
-					else if (byFallBack == AUTO_FB_0) {
-						for (ii = 0; ii < byTxRetry; ii++) {
-							if (ii < 5)
-								wFallBackRate =
-									awHWRetry0[wRate-RATE_18M][ii];
-							else
-								wFallBackRate =
-									awHWRetry0[wRate-RATE_18M][4];
-							pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
-						}
-					} else if (byFallBack == AUTO_FB_1) {
-						for (ii = 0; ii < byTxRetry; ii++) {
-							if (ii < 5)
-								wFallBackRate =
-									awHWRetry1[wRate-RATE_18M][ii];
-							else
-								wFallBackRate =
-									awHWRetry1[wRate-RATE_18M][4];
-							pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
-						}
+				} else if (byFallBack == AUTO_FB_1) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
+							wFallBackRate =
+								awHWRetry1[wRate-RATE_18M][ii];
+						else
+							wFallBackRate =
+								awHWRetry1[wRate-RATE_18M][4];
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
 					}
 				}
 			}
-- 
1.8.1.2

