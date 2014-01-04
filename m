Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaADP0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:26:14 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49384 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbaADP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:09 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] Staging: vt6656: Combined nested conditions
Date: Sat,  4 Jan 2014 16:25:15 +0100
Message-Id: <1388849118-11994-11-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
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

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 281 ++++++++++++++++++++---------------------
 1 file changed, 139 insertions(+), 142 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 1972a5b..c780869 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -107,10 +107,9 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))
 				pbyBSSID = pbyDesireBSSID;
 	}
-	if (pbyDesireSSID != NULL) {
-		if (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
-			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
-	}
+	if ((pbyDesireSSID != NULL) &&
+	    (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0))
+		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
 
 	if ((pbyBSSID != NULL) && (pDevice->bRoaming == false)) {
 		/* match BSSID first */
@@ -120,27 +119,27 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pCurrBSS->bSelected = false;
 
 			if ((pCurrBSS->bActive) &&
-				(pCurrBSS->bSelected == false)) {
-				if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
-					if (pSSID != NULL) {
-						/* compare ssid */
-						if (!memcmp(pSSID->abySSID,
-							((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
-							pSSID->len)) {
-							if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-								((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-								((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
-								) {
-								pCurrBSS->bSelected = true;
-								return pCurrBSS;
-							}
-						}
-					} else if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-						((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-						((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+			    (pCurrBSS->bSelected == false) &&
+			    (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID))) {
+				if (pSSID != NULL) {
+					/* compare ssid */
+					if ((!memcmp(pSSID->abySSID,
+						     ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
+						     pSSID->len)) &&
+					    ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
+					     ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) &&
+					      WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+					     ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) &&
+					      WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)))) {
+
 						pCurrBSS->bSelected = true;
 						return pCurrBSS;
 					}
+				} else if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
+					((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+					pCurrBSS->bSelected = true;
+					return pCurrBSS;
 				}
 			}
 		}
@@ -156,16 +155,17 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pCurrBSS->bSelected = false;
 			if (pCurrBSS->bActive) {
 
-				if (pSSID != NULL) {
-					/* matched SSID */
-					if (memcmp(pSSID->abySSID,
-						((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
-						pSSID->len) ||
-						(pSSID->len != ((PWLAN_IE_SSID) pCurrBSS->abySSID)->len)) {
-						/* SSID not match skip this BSS */
-						continue;
-					  }
+				if ((pSSID != NULL) &&
+				    /* matched SSID */
+				    (memcmp(pSSID->abySSID,
+					    ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
+					    pSSID->len) ||
+				     (pSSID->len !=
+					((PWLAN_IE_SSID) pCurrBSS->abySSID)->len))) {
+					/* SSID not match skip this BSS */
+					continue;
 				}
+
 				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
 					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
 					) {
@@ -174,13 +174,14 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					continue;
 				}
 
-				if (ePhyType != PHY_TYPE_AUTO) {
-					if (((ePhyType == PHY_TYPE_11A) && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
-						((ePhyType != PHY_TYPE_11A) && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
-						/* PhyType not match skip this BSS */
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
-						continue;
-					}
+				if ((ePhyType != PHY_TYPE_AUTO) &&
+				    (((ePhyType == PHY_TYPE_11A) &&
+				     (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
+				    ((ePhyType != PHY_TYPE_11A) &&
+				     (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse)))) {
+					/* PhyType not match skip this BSS */
+					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
+					continue;
 				}
 
 				pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
@@ -228,21 +229,20 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 	int ii;
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-		if (bKeepCurrBSSID) {
-			if (pMgmt->sBSSList[ii].bActive &&
-				ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
-				pMgmt->abyCurrBSSID)) {
-
-				/* mike mark:
-				 * there are two BSSID's in list. If that AP is
-				 * in hidden ssid mode, one SSID is null, but
-				 * other's might not be obvious, so if it
-				 * associate's with your STA, you must keep the
-				 * two of them!!  bKeepCurrBSSID = false;
-				 */
-
-				continue;
-			}
+		if (bKeepCurrBSSID &&
+		    pMgmt->sBSSList[ii].bActive &&
+		    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+			             pMgmt->abyCurrBSSID)) {
+
+			/* mike mark:
+			 * there are two BSSID's in list. If that AP is
+			 * in hidden ssid mode, one SSID is null, but
+			 * other's might not be obvious, so if it
+			 * associate's with your STA, you must keep the
+			 * two of them!!  bKeepCurrBSSID = false;
+			 */
+
+			continue;
 		}
 
 		pMgmt->sBSSList[ii].bActive = false;
@@ -268,16 +268,13 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		pBSSList = &(pMgmt->sBSSList[ii]);
-		if (pBSSList->bActive) {
-			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
-				if (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len) {
-					if (memcmp(pSSID->abySSID,
-						((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
-						pSSID->len) == 0)
-						return pBSSList;
-				}
-			}
-		}
+		if ((pBSSList->bActive) &&
+		    (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) &&
+		    (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len) &&
+		    (memcmp(pSSID->abySSID,
+			    ((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
+			    pSSID->len) == 0))
+			return pBSSList;
 	}
 
 	return NULL;
@@ -371,11 +368,10 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	pBSSList->bySQ = pRxPacket->bySQ;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS)
-			bParsingQuiet = true;
-	}
+	    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
+	    /* assoc with BSS */
+	    (pBSSList == pMgmt->pCurrBSS))
+		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList);
 
@@ -421,13 +417,19 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 					 pBSSList->abyBSSID,
 					 &pBSSList->sRSNCapObj);
 
-			if ((pDevice->bLinkPass == true) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-				if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, PAIRWISE_KEY, &pTransmitKey) == true) ||
-					(KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, GROUP_KEY, &pTransmitKey) == true)) {
-					pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
-					pDevice->gsPMKIDCandidate.Version = 1;
+			if ((pDevice->bLinkPass == true) &&
+			    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
+			    ((KeybGetTransmitKey(&(pDevice->sKey),
+						 pDevice->abyBSSID,
+						 PAIRWISE_KEY,
+						 &pTransmitKey) == true) ||
+			     (KeybGetTransmitKey(&(pDevice->sKey),
+						 pDevice->abyBSSID,
+						 GROUP_KEY,
+						 &pTransmitKey) == true))) {
+				pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
+				pDevice->gsPMKIDCandidate.Version = 1;
 
-				}
 
 			}
 		}
@@ -524,11 +526,10 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	pBSSList->bySQ = pRxPacket->bySQ;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS)
-			bParsingQuiet = true;
-	}
+	    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
+	    /* assoc with BSS */
+	    (pBSSList == pMgmt->pCurrBSS))
+		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList); /* mike update */
 
@@ -597,12 +598,11 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 
 	/* Index = 0 reserved for AP Node */
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
-		if (pMgmt->sNodeDBTable[ii].bActive) {
-			if (ether_addr_equal(abyDstAddr,
-				pMgmt->sNodeDBTable[ii].abyMACAddr)) {
-				*puNodeIndex = ii;
-				return true;
-			}
+		if ((pMgmt->sNodeDBTable[ii].bActive) &&
+		    (ether_addr_equal(abyDstAddr,
+				      pMgmt->sNodeDBTable[ii].abyMACAddr))) {
+			*puNodeIndex = ii;
+			return true;
 		}
 	}
 
@@ -1064,16 +1064,15 @@ void BSSvSecondCallBack(struct work_struct *work)
 	}
 
 	if (pDevice->bLinkPass == true) {
-		if (pMgmt->eAuthenMode < WMAC_AUTH_WPA ||
-			pDevice->fWPA_Authened == true) {
-			if (++pDevice->tx_data_time_out > 40) {
-				pDevice->tx_trigger = true;
+		if ((pMgmt->eAuthenMode < WMAC_AUTH_WPA ||
+		     pDevice->fWPA_Authened == true) &&
+		    (++pDevice->tx_data_time_out > 40)) {
+			pDevice->tx_trigger = true;
 
-				PSbSendNullPacket(pDevice);
+			PSbSendNullPacket(pDevice);
 
-				pDevice->tx_trigger = false;
-				pDevice->tx_data_time_out = 0;
-			}
+			pDevice->tx_trigger = false;
+			pDevice->tx_data_time_out = 0;
 		}
 
 		if (netif_queue_stopped(pDevice->dev))
@@ -1177,58 +1176,56 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			}
 		}
 
-		if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
-		     (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
-
-			if (BSSbIsSTAInNodeDB((void *) pDevice,
-					      pbyDestAddr,
-					      &uNodeIndex)) {
-				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
-				if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-					/* transmit success, TxAttempts at least plus one */
-					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
-					if ((byFallBack == AUTO_FB_NONE) ||
-						(wRate < RATE_18M)) {
-						wFallBackRate = wRate;
-					} else if (byFallBack == AUTO_FB_0) {
-						if (byTxRetry < 5)
-							wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+		if (((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
+		     (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) &&
+		    (BSSbIsSTAInNodeDB((void *) pDevice,
+				       pbyDestAddr,
+				       &uNodeIndex))) {
+			pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
+			if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+				/* transmit success, TxAttempts at least plus one */
+				pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
+				if ((byFallBack == AUTO_FB_NONE) ||
+					(wRate < RATE_18M)) {
+					wFallBackRate = wRate;
+				} else if (byFallBack == AUTO_FB_0) {
+					if (byTxRetry < 5)
+						wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+					else
+						wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
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
+			pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
+			if (byTxRetry != 0) {
+				pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] += byTxRetry;
+				if ((byFallBack == AUTO_FB_NONE) ||
+					(wRate < RATE_18M)) {
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] += byTxRetry;
+				} else if (byFallBack == AUTO_FB_0) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
+							wFallBackRate =
+								awHWRetry0[wRate-RATE_18M][ii];
 						else
-							wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
-					} else if (byFallBack == AUTO_FB_1) {
-						if (byTxRetry < 5)
-							wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+							wFallBackRate =
+								awHWRetry0[wRate-RATE_18M][4];
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
+					}
+				} else if (byFallBack == AUTO_FB_1) {
+					for (ii = 0; ii < byTxRetry; ii++) {
+						if (ii < 5)
+							wFallBackRate = awHWRetry1[wRate-RATE_18M][ii];
 						else
 							wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
-					}
-					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
-				} else {
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFailures++;
-				}
-				pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
-				if (byTxRetry != 0) {
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] += byTxRetry;
-					if ((byFallBack == AUTO_FB_NONE) ||
-						(wRate < RATE_18M)) {
-						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] += byTxRetry;
-					} else if (byFallBack == AUTO_FB_0) {
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
-								wFallBackRate = awHWRetry1[wRate-RATE_18M][ii];
-							else
-								wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
-							pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
-						}
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wFallBackRate]++;
 					}
 				}
 			}
-- 
1.8.1.2

