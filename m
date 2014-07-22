Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaGVUJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:09:24 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59113 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbaGVUJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:03 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 4/5] staging: vt6655: remove unused functions
Date: Tue, 22 Jul 2014 22:08:29 +0200
Message-Id: <1406059710-30903-5-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406059710-30903-1-git-send-email-gclement@baobob.org>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE11hbMgrRxAction is not exported and never used. Deleting it
allows to delete other functions that were only used by
IEEE11hbMgrRxAction.

This allows to fix several warnings reported by sparse.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/IEEE11h.c | 175 ---------------------------------------
 1 file changed, 175 deletions(-)

diff --git a/drivers/staging/vt6655/IEEE11h.c b/drivers/staging/vt6655/IEEE11h.c
index 6cfad1c..180a27c 100644
--- a/drivers/staging/vt6655/IEEE11h.c
+++ b/drivers/staging/vt6655/IEEE11h.c
@@ -41,7 +41,6 @@
 #include "channel.h"
 
 /*---------------------  Static Definitions -------------------------*/
-static int          msglevel                = MSG_LEVEL_INFO;
 
 #pragma pack(1)
 
@@ -98,185 +97,11 @@ typedef struct _WLAN_FRAME_TPCREP {
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-static bool s_bRxMSRReq(PSMgmtObject pMgmt, PWLAN_FRAME_MSRREQ pMSRReq,
-			unsigned int uLength)
-{
-	size_t    uNumOfEIDs = 0;
-	bool bResult = true;
-
-	if (uLength <= WLAN_A3FR_MAXLEN)
-		memcpy(pMgmt->abyCurrentMSRReq, pMSRReq, uLength);
-	uNumOfEIDs = ((uLength - offsetof(WLAN_FRAME_MSRREQ,
-					  sMSRReqEIDs))/
-		      (sizeof(WLAN_IE_MEASURE_REQ)));
-	pMgmt->pCurrMeasureEIDRep = &(((PWLAN_FRAME_MSRREP)
-				       (pMgmt->abyCurrentMSRRep))->sMSRRepEIDs[0]);
-	pMgmt->uLengthOfRepEIDs = 0;
-	bResult = CARDbStartMeasure(pMgmt->pAdapter,
-				    ((PWLAN_FRAME_MSRREQ)
-				     (pMgmt->abyCurrentMSRReq))->sMSRReqEIDs,
-				    uNumOfEIDs
-);
-	return bResult;
-}
-
-static bool s_bRxTPCReq(PSMgmtObject pMgmt,
-			PWLAN_FRAME_TPCREQ pTPCReq,
-			unsigned char byRate,
-			unsigned char byRSSI)
-{
-	PWLAN_FRAME_TPCREP  pFrame;
-	PSTxMgmtPacket      pTxPacket = NULL;
-
-	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
-						    sizeof(STxMgmtPacket));
-
-	pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket +
-				      sizeof(STxMgmtPacket));
-
-	pFrame->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
-				    WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
-);
-
-	memcpy(pFrame->Header.abyAddr1,
-	       pTPCReq->Header.abyAddr2,
-	       WLAN_ADDR_LEN);
-	memcpy(pFrame->Header.abyAddr2,
-	       CARDpGetCurrentAddress(pMgmt->pAdapter),
-	       WLAN_ADDR_LEN);
-	memcpy(pFrame->Header.abyAddr3,
-	       pMgmt->abyCurrBSSID,
-	       WLAN_BSSID_LEN);
-
-	pFrame->byCategory = 0;
-	pFrame->byAction = 3;
-	pFrame->byDialogToken = ((PWLAN_FRAME_MSRREQ)
-				 (pMgmt->abyCurrentMSRReq))->byDialogToken;
-
-	pFrame->sTPCRepEIDs.byElementID = WLAN_EID_TPC_REP;
-	pFrame->sTPCRepEIDs.len = 2;
-	pFrame->sTPCRepEIDs.byTxPower = CARDbyGetTransmitPower(pMgmt->pAdapter);
-	switch (byRate) {
-	case RATE_54M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 65 - byRSSI;
-		break;
-	case RATE_48M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 66 - byRSSI;
-		break;
-	case RATE_36M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 70 - byRSSI;
-		break;
-	case RATE_24M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 74 - byRSSI;
-		break;
-	case RATE_18M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 77 - byRSSI;
-		break;
-	case RATE_12M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 79 - byRSSI;
-		break;
-	case RATE_9M:
-		pFrame->sTPCRepEIDs.byLinkMargin = 81 - byRSSI;
-		break;
-	case RATE_6M:
-	default:
-		pFrame->sTPCRepEIDs.byLinkMargin = 82 - byRSSI;
-		break;
-	}
-
-	pTxPacket->cbMPDULen = sizeof(WLAN_FRAME_TPCREP);
-	pTxPacket->cbPayloadLen = sizeof(WLAN_FRAME_TPCREP) -
-		WLAN_HDR_ADDR3_LEN;
-	if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
-		return false;
-	return true;
-}
 
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
 
-/*+
- *
- * Description:
- *      Handles action management frames.
- *
- * Parameters:
- *  In:
- *      pMgmt           - Management Object structure
- *      pRxPacket       - Received packet
- *  Out:
- *      none
- *
- * Return Value: None.
- *
- -*/
-bool
-IEEE11hbMgrRxAction(void *pMgmtHandle, void *pRxPacket)
-{
-	PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
-	PWLAN_FRAME_ACTION      pAction = NULL;
-	unsigned int uLength = 0;
-	PWLAN_IE_CH_SW          pChannelSwitch = NULL;
-
-	/* decode the frame */
-	uLength = ((PSRxMgmtPacket)pRxPacket)->cbMPDULen;
-	if (uLength > WLAN_A3FR_MAXLEN)
-		return false;
-
-	pAction = (PWLAN_FRAME_ACTION)
-		(((PSRxMgmtPacket)pRxPacket)->p80211Header);
-
-	if (pAction->byCategory == 0) {
-		switch (pAction->byAction) {
-		case ACTION_MSRREQ:
-			return s_bRxMSRReq(pMgmt,
-					   (PWLAN_FRAME_MSRREQ)
-					   pAction,
-					   uLength);
-			break;
-		case ACTION_MSRREP:
-			break;
-		case ACTION_TPCREQ:
-			return s_bRxTPCReq(pMgmt,
-					   (PWLAN_FRAME_TPCREQ) pAction,
-					   ((PSRxMgmtPacket)pRxPacket)->byRxRate,
-					   (unsigned char)
-					   ((PSRxMgmtPacket)pRxPacket)->uRSSI);
-			break;
-		case ACTION_TPCREP:
-			break;
-		case ACTION_CHSW:
-			pChannelSwitch = (PWLAN_IE_CH_SW) (pAction->abyVars);
-			if ((pChannelSwitch->byElementID == WLAN_EID_CH_SWITCH)
-			    && (pChannelSwitch->len == 3)) {
-				/* valid element id */
-				CARDbChannelSwitch(pMgmt->pAdapter,
-						   pChannelSwitch->byMode,
-						   get_channel_mapping(pMgmt->pAdapter,
-								       pChannelSwitch->byChannel,
-								       pMgmt->eCurrentPHYMode),
-						   pChannelSwitch->byCount);
-			}
-			break;
-		default:
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO "Unknown Action = %d\n",
-				pAction->byAction);
-			break;
-		}
-	} else {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unknown Category = %d\n",
-			pAction->byCategory);
-		pAction->byCategory |= 0x80;
-
-		return true;
-	}
-	return true;
-}
-
 bool IEEE11hbMSRRepTx(void *pMgmtHandle)
 {
 	PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
-- 
1.8.5.5

