Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3IATVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 15:21:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48358 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753601Ab3IATVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 15:21:24 -0400
Message-ID: <1378062947.1953.9.camel@joe-AO722>
Subject: [PATCH staging] Staging: Convert uses of compare_ether_addr to
 ether_addr_equal
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 12:15:47 -0700
In-Reply-To: <1378061483.1953.3.camel@joe-AO722>
References: <1378061483.1953.3.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preliminary to removing compare_ether_addr altogether:

Use the new bool function ether_addr_equal to add
some clarity and reduce the likelihood for misuse
of compare_ether_addr for sorting.

Additionally:

Used is_zero_ether_addr, removed now unused variable
Converted uses of &foo[0] to foo

Done via cocci script: (and a little typing)

$ cat compare_ether_addr.cocci
@@
expression a,b;
@@
-	!compare_ether_addr(a, b)
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	compare_ether_addr(a, b)
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) == 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) != 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) == 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) != 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!!ether_addr_equal(a, b)
+	ether_addr_equal(a, b)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 18 +++++++++---------
 drivers/staging/rtl8192e/rtllib_rx.c           | 13 ++++++-------
 drivers/staging/slicoss/slicoss.c              |  6 +++---
 drivers/staging/vt6655/bssdb.c                 | 11 +++++++----
 drivers/staging/vt6655/dpc.c                   |  7 ++++---
 drivers/staging/vt6655/iwctl.c                 |  6 ++++--
 drivers/staging/vt6655/key.c                   | 10 +++++-----
 drivers/staging/vt6655/wctl.c                  |  8 ++++----
 drivers/staging/vt6655/wmgr.c                  |  3 ++-
 drivers/staging/vt6655/wpactl.c                |  2 +-
 drivers/staging/vt6656/bssdb.c                 | 12 ++++++------
 drivers/staging/vt6656/dpc.c                   | 13 ++++++-------
 drivers/staging/vt6656/iwctl.c                 |  8 ++++----
 drivers/staging/vt6656/key.c                   | 10 +++++-----
 drivers/staging/vt6656/wctl.c                  |  7 +++----
 drivers/staging/vt6656/wmgr.c                  |  4 ++--
 drivers/staging/vt6656/wpactl.c                |  2 +-
 17 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 50c7bb7..8a6e373 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -1866,15 +1866,15 @@ static void rtl8192_TranslateRxSignalStuff(struct net_device *dev,
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
 
-	bpacket_match_bssid = ((RTLLIB_FTYPE_CTL != type) &&
-			(!compare_ether_addr(priv->rtllib->
-			current_network.bssid,
-			   (fc & RTLLIB_FCTL_TODS) ? hdr->addr1 :
-			   (fc & RTLLIB_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
-		&& (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV));
-	bpacket_toself =  bpacket_match_bssid &&	/* check this */
-			  (!compare_ether_addr(praddr,
-			  priv->rtllib->dev->dev_addr));
+	bpacket_match_bssid =
+		((RTLLIB_FTYPE_CTL != type) &&
+		 ether_addr_equal(priv->rtllib->current_network.bssid,
+				  (fc & RTLLIB_FCTL_TODS) ? hdr->addr1 :
+				  (fc & RTLLIB_FCTL_FROMDS) ? hdr->addr2 :
+				  hdr->addr3) &&
+		 (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV));
+	bpacket_toself = bpacket_match_bssid &&		/* check this */
+			 ether_addr_equal(praddr, priv->rtllib->dev->dev_addr);
 	if (WLAN_FC_GET_FRAMETYPE(fc) == RTLLIB_STYPE_BEACON)
 		bPacketBeacon = true;
 	if (bpacket_match_bssid)
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index e75364e..5a617ce 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -953,16 +953,15 @@ static void rtllib_rx_extract_addr(struct rtllib_device *ieee,
 static int rtllib_rx_data_filter(struct rtllib_device *ieee, u16 fc,
 				 u8 *dst, u8 *src, u8 *bssid, u8 *addr2)
 {
-	u8 zero_addr[ETH_ALEN] = {0};
 	u8 type, stype;
 
 	type = WLAN_FC_GET_TYPE(fc);
 	stype = WLAN_FC_GET_STYPE(fc);
 
 	/* Filter frames from different BSS */
-	if (((fc & RTLLIB_FCTL_DSTODS) != RTLLIB_FCTL_DSTODS)
-		&& (compare_ether_addr(ieee->current_network.bssid, bssid) != 0)
-		&& memcmp(ieee->current_network.bssid, zero_addr, ETH_ALEN)) {
+	if (((fc & RTLLIB_FCTL_DSTODS) != RTLLIB_FCTL_DSTODS) &&
+	    !ether_addr_equal(ieee->current_network.bssid, bssid) &&
+	    !is_zero_ether_addr(ieee->current_network.bssid)) {
 		return -1;
 	}
 
@@ -970,8 +969,8 @@ static int rtllib_rx_data_filter(struct rtllib_device *ieee, u16 fc,
 	if (ieee->IntelPromiscuousModeInfo.bPromiscuousOn  &&
 		ieee->IntelPromiscuousModeInfo.bFilterSourceStationFrame) {
 		if ((fc & RTLLIB_FCTL_TODS) && !(fc & RTLLIB_FCTL_FROMDS) &&
-			(compare_ether_addr(dst, ieee->current_network.bssid) != 0) &&
-			(compare_ether_addr(bssid, ieee->current_network.bssid) == 0)) {
+		    !ether_addr_equal(dst, ieee->current_network.bssid) &&
+		    ether_addr_equal(bssid, ieee->current_network.bssid)) {
 			return -1;
 		}
 	}
@@ -1271,7 +1270,7 @@ static int rtllib_rx_InfraAdhoc(struct rtllib_device *ieee, struct sk_buff *skb,
 	/*Filter pkt not to me*/
 	multicast = is_multicast_ether_addr(hdr->addr1);
 	unicast = !multicast;
-	if (unicast && (compare_ether_addr(dev->dev_addr, hdr->addr1) != 0)) {
+	if (unicast && !ether_addr_equal(dev->dev_addr, hdr->addr1)) {
 		if (ieee->bNetPromiscuousMode)
 			bToOtherSTA = true;
 		else
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 869dcd3..b6eb5df 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -791,8 +791,8 @@ static bool slic_mac_filter(struct adapter *adapter,
 			struct mcast_address *mcaddr = adapter->mcastaddrs;
 
 			while (mcaddr) {
-				if (!compare_ether_addr(mcaddr->address,
-							ether_frame->ether_dhost)) {
+				if (ether_addr_equal(mcaddr->address,
+						     ether_frame->ether_dhost)) {
 					adapter->rcv_multicasts++;
 					netdev->stats.multicast++;
 					return true;
@@ -2333,7 +2333,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
 	/* Check to see if it already exists */
 	mlist = adapter->mcastaddrs;
 	while (mlist) {
-		if (!compare_ether_addr(mlist->address, address))
+		if (ether_addr_equal(mlist->address, address))
 			return 0;
 		mlist = mlist->next;
 	}
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index f983915..a23b591 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -148,7 +148,8 @@ BSSpSearchBSSList(
 			if (pDevice->bLinkPass == false) pCurrBSS->bSelected = false;
 			if ((pCurrBSS->bActive) &&
 			    (pCurrBSS->bSelected == false)) {
-				if (!compare_ether_addr(pCurrBSS->abyBSSID, pbyBSSID)) {
+				if (ether_addr_equal(pCurrBSS->abyBSSID,
+						     pbyBSSID)) {
 					if (pSSID != NULL) {
 						// compare ssid
 						if (!memcmp(pSSID->abySSID,
@@ -275,7 +276,8 @@ BSSvClearBSSList(
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		if (bKeepCurrBSSID) {
 			if (pMgmt->sBSSList[ii].bActive &&
-			    !compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID, pMgmt->abyCurrBSSID)) {
+			    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+					     pMgmt->abyCurrBSSID)) {
 				// bKeepCurrBSSID = false;
 				continue;
 			}
@@ -318,7 +320,7 @@ BSSpAddrIsInBSSList(
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		pBSSList = &(pMgmt->sBSSList[ii]);
 		if (pBSSList->bActive) {
-			if (!compare_ether_addr(pBSSList->abyBSSID, abyBSSID)) {
+			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
 				if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len) {
 					if (memcmp(pSSID->abySSID,
 						   ((PWLAN_IE_SSID)pBSSList->abySSID)->abySSID,
@@ -733,7 +735,8 @@ BSSDBbIsSTAInNodeDB(void *pMgmtObject, unsigned char *abyDstAddr,
 	// Index = 0 reserved for AP Node
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
-			if (!compare_ether_addr(abyDstAddr, pMgmt->sNodeDBTable[ii].abyMACAddr)) {
+			if (ether_addr_equal(abyDstAddr,
+					     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
 				*puNodeIndex = ii;
 				return true;
 			}
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index a9533f3..0ff51cb 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -172,9 +172,9 @@ s_vProcessRxMACHeader(PSDevice pDevice, unsigned char *pbyRxBufferAddr,
 	};
 
 	pbyRxBuffer = (unsigned char *)(pbyRxBufferAddr + cbHeaderSize);
-	if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_Bridgetunnel[0])) {
+	if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_Bridgetunnel)) {
 		cbHeaderSize += 6;
-	} else if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_RFC1042[0])) {
+	} else if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_RFC1042)) {
 		cbHeaderSize += 6;
 		pwType = (unsigned short *)(pbyRxBufferAddr + cbHeaderSize);
 		if ((*pwType != TYPE_PKT_IPX) && (*pwType != cpu_to_le16(0xF380))) {
@@ -420,7 +420,8 @@ device_receive_frame(
 	s_vGetDASA(skb->data+4, &cbHeaderSize, &pDevice->sRxEthHeader);
 
 	// filter packet send from myself
-	if (!compare_ether_addr((unsigned char *)&(pDevice->sRxEthHeader.abySrcAddr[0]), pDevice->abyCurrentNetAddr))
+	if (ether_addr_equal(pDevice->sRxEthHeader.abySrcAddr,
+			     pDevice->abyCurrentNetAddr))
 		return false;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) || (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)) {
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 9de698e..4bff8aa 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -663,7 +663,8 @@ int iwctl_siwap(struct net_device *dev,
 			unsigned int ii, uSameBssidNum = 0;
 			for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 				if (pMgmt->sBSSList[ii].bActive &&
-				    !compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID, pMgmt->abyDesireBSSID)) {
+				    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+						     pMgmt->abyDesireBSSID)) {
 					uSameBssidNum++;
 				}
 			}
@@ -840,7 +841,8 @@ int iwctl_siwessid(struct net_device *dev,
 					//         by means of judging if there are two same BSSID exist in list ?
 					for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 						if (pMgmt->sBSSList[ii].bActive &&
-						    !compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID, pCurr->abyBSSID)) {
+						    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+								     pCurr->abyBSSID)) {
 							uSameBssidNum++;
 						}
 					}
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 92b84b5..04c1304 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -141,7 +141,7 @@ bool KeybGetKey(
 	*pKey = NULL;
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
 		if ((pTable->KeyTable[i].bInUse == true) &&
-		    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			if (dwKeyIndex == 0xFFFFFFFF) {
 				if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
 					*pKey = &(pTable->KeyTable[i].PairwiseKey);
@@ -208,7 +208,7 @@ bool KeybSetKey(
 			j = i;
 		}
 		if ((pTable->KeyTable[i].bInUse == true) &&
-		    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			// found table already exist
 			if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
 				// Pairwise key
@@ -385,7 +385,7 @@ bool KeybRemoveKey(
 
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
 		if ((pTable->KeyTable[i].bInUse == true) &&
-		    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
 				pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
 				s_vCheckKeyTableValid(pTable, dwIoBase);
@@ -429,7 +429,7 @@ bool KeybRemoveAllKey(
 
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
 		if ((pTable->KeyTable[i].bInUse == true) &&
-		    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
 			for (u = 0; u < MAX_GROUP_KEY; u++) {
 				pTable->KeyTable[i].GroupKey[u].bKeyValid = false;
@@ -512,7 +512,7 @@ bool KeybGetTransmitKey(
 	*pKey = NULL;
 	for (i = 0; i < MAX_KEY_TABLE; i++) {
 		if ((pTable->KeyTable[i].bInUse == true) &&
-		    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 			if (dwKeyType == PAIRWISE_KEY) {
 				if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
 					*pKey = &(pTable->KeyTable[i].PairwiseKey);
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
index 9eb81b4..f05f9f5 100644
--- a/drivers/staging/vt6655/wctl.c
+++ b/drivers/staging/vt6655/wctl.c
@@ -75,8 +75,8 @@ bool WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader)
 		for (ii = 0; ii < DUPLICATE_RX_CACHE_LENGTH; ii++) {
 			pCacheEntry = &(pCache->asCacheEntry[uIndex]);
 			if ((pCacheEntry->wFmSequence == pMACHeader->wSeqCtl) &&
-			    (!compare_ether_addr(&(pCacheEntry->abyAddr2[0]), &(pMACHeader->abyAddr2[0])))
-) {
+			    ether_addr_equal(pCacheEntry->abyAddr2,
+					     pMACHeader->abyAddr2)) {
 				/* Duplicate match */
 				return true;
 			}
@@ -111,8 +111,8 @@ unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
 
 	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
 		if ((pDevice->sRxDFCB[ii].bInUse == true) &&
-		    (!compare_ether_addr(&(pDevice->sRxDFCB[ii].abyAddr2[0]), &(pMACHeader->abyAddr2[0])))
-) {
+		    ether_addr_equal(pDevice->sRxDFCB[ii].abyAddr2,
+				     pMACHeader->abyAddr2)) {
 			//
 			return ii;
 		}
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 9938813..ed4b32b 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -1680,7 +1680,8 @@ s_vMgrRxDeauthentication(
 			vMgrDecodeDeauthen(&sFrame);
 			DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO  "AP deauthed me, reason=%d.\n", cpu_to_le16((*(sFrame.pwReason))));
 			// TODO: update BSS list for specific BSSID if pre-authentication case
-			if (!compare_ether_addr(sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID)) {
+			if (ether_addr_equal(sFrame.pHdr->sA3.abyAddr3,
+					     pMgmt->abyCurrBSSID)) {
 				if (pMgmt->eCurrState >= WMAC_STATE_AUTHPENDING) {
 					pMgmt->sNodeDBTable[0].bActive = false;
 					pMgmt->eCurrMode = WMAC_MODE_STANDBY;
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 869f62c..71bf1d7 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -394,7 +394,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 
 		} else {
 			// Key Table Full
-			if (!compare_ether_addr(&param->addr[0], pDevice->abyBSSID)) {
+			if (ether_addr_equal(param->addr, pDevice->abyBSSID)) {
 				//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
 				//spin_unlock_irq(&pDevice->lock);
 				return -EINVAL;
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index ee79bbd..ed1d609 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -126,7 +126,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
             if ((pCurrBSS->bActive) &&
                 (pCurrBSS->bSelected == false)) {
-		    if (!compare_ether_addr(pCurrBSS->abyBSSID, pbyBSSID)) {
+		    if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
                     if (pSSID != NULL) {
                         // compare ssid
                         if ( !memcmp(pSSID->abySSID,
@@ -242,8 +242,8 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
         if (bKeepCurrBSSID) {
             if (pMgmt->sBSSList[ii].bActive &&
-		!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-				    pMgmt->abyCurrBSSID)) {
+		ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+				 pMgmt->abyCurrBSSID)) {
  //mike mark: there are two BSSID's in list. If that AP is in hidden ssid mode, one SSID is null,
  //                 but other's might not be obvious, so if it associate's with your STA,
  //                 you must keep the two of them!!
@@ -277,7 +277,7 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
         pBSSList = &(pMgmt->sBSSList[ii]);
         if (pBSSList->bActive) {
-		if (!compare_ether_addr(pBSSList->abyBSSID, abyBSSID)) {
+		if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
                 if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len){
                     if (memcmp(pSSID->abySSID,
                             ((PWLAN_IE_SSID)pBSSList->abySSID)->abySSID,
@@ -623,8 +623,8 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
     // Index = 0 reserved for AP Node
     for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
         if (pMgmt->sNodeDBTable[ii].bActive) {
-		if (!compare_ether_addr(abyDstAddr,
-					pMgmt->sNodeDBTable[ii].abyMACAddr)) {
+		if (ether_addr_equal(abyDstAddr,
+				     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
                 *puNodeIndex = ii;
                 return true;
             }
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 4bc362f..55eb7f0 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -136,9 +136,9 @@ static void s_vProcessRxMACHeader(struct vnt_private *pDevice,
     };
 
     pbyRxBuffer = (u8 *) (pbyRxBufferAddr + cbHeaderSize);
-    if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_Bridgetunnel[0])) {
+    if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_Bridgetunnel)) {
         cbHeaderSize += 6;
-    } else if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_RFC1042[0])) {
+    } else if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_RFC1042)) {
         cbHeaderSize += 6;
         pwType = (u16 *) (pbyRxBufferAddr + cbHeaderSize);
 	if ((*pwType == cpu_to_be16(ETH_P_IPX)) ||
@@ -361,7 +361,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
     if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
         (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
        if (pMgmt->sNodeDBTable[0].bActive) {
-	 if (!compare_ether_addr(pMgmt->abyCurrBSSID, pMACHeader->addr2)) {
+	 if (ether_addr_equal(pMgmt->abyCurrBSSID, pMACHeader->addr2)) {
 	    if (pMgmt->sNodeDBTable[0].uInActiveCount != 0)
                   pMgmt->sNodeDBTable[0].uInActiveCount = 0;
            }
@@ -374,8 +374,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
             return false;
         }
 
-	if (compare_ether_addr(pDevice->abyCurrentNetAddr,
-			       pMACHeader->addr1)) {
+	if (!ether_addr_equal(pDevice->abyCurrentNetAddr, pMACHeader->addr1)) {
 		return false;
         }
     }
@@ -383,8 +382,8 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
     // Use for TKIP MIC
     s_vGetDASA(pbyFrame, &cbHeaderSize, &pDevice->sRxEthHeader);
 
-    if (!compare_ether_addr((u8 *)&(pDevice->sRxEthHeader.h_source[0]),
-			    pDevice->abyCurrentNetAddr))
+    if (ether_addr_equal((u8 *)pDevice->sRxEthHeader.h_source,
+			 pDevice->abyCurrentNetAddr))
         return false;
 
     if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) || (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)) {
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index d0cf7d8..033cb50 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -657,8 +657,8 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 			unsigned uSameBssidNum = 0;
 			for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 				if (pMgmt->sBSSList[ii].bActive &&
-					!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-							pMgmt->abyDesireBSSID)) {
+					ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+							 pMgmt->abyDesireBSSID)) {
 					uSameBssidNum++;
 				}
 			}
@@ -840,8 +840,8 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 				// are two same BSSID exist in list ?
 				for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 					if (pMgmt->sBSSList[ii].bActive &&
-						!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-								pCurr->abyBSSID)) {
+						ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
+								 pCurr->abyBSSID)) {
 						uSameBssidNum++;
 					}
 				}
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 205590b..be92c04 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -151,7 +151,7 @@ int KeybGetKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyIndex,
     *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
         if ((pTable->KeyTable[i].bInUse == true) &&
-	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             if (dwKeyIndex == 0xFFFFFFFF) {
                 if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
                     *pKey = &(pTable->KeyTable[i].PairwiseKey);
@@ -213,7 +213,7 @@ int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
             j = i;
         }
         if ((pTable->KeyTable[i].bInUse == true) &&
-	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             // found table already exist
             if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
                 // Pairwise key
@@ -395,7 +395,7 @@ int KeybRemoveKey(struct vnt_private *pDevice, PSKeyManagement pTable,
     } else {
         for (i=0;i<MAX_KEY_TABLE;i++) {
             if ( (pTable->KeyTable[i].bInUse == true) &&
-		 !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+		 ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 
                 if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
                     pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
@@ -445,7 +445,7 @@ int KeybRemoveAllKey(struct vnt_private *pDevice, PSKeyManagement pTable,
 
     for (i=0;i<MAX_KEY_TABLE;i++) {
         if ((pTable->KeyTable[i].bInUse == true) &&
-	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
 	    for (u = 0; u < MAX_GROUP_KEY; u++)
 		pTable->KeyTable[i].GroupKey[u].bKeyValid = false;
@@ -480,7 +480,7 @@ int KeybGetTransmitKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyType,
 
     for (i = 0; i < MAX_KEY_TABLE; i++) {
         if ((pTable->KeyTable[i].bInUse == true) &&
-	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
+	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 
             if (dwKeyType == PAIRWISE_KEY) {
 
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
index 47a655d..814342c 100644
--- a/drivers/staging/vt6656/wctl.c
+++ b/drivers/staging/vt6656/wctl.c
@@ -69,8 +69,7 @@ bool WCTLbIsDuplicate (PSCache pCache, struct ieee80211_hdr *pMACHeader)
         for (ii = 0; ii < DUPLICATE_RX_CACHE_LENGTH; ii++) {
             pCacheEntry = &(pCache->asCacheEntry[uIndex]);
             if ((pCacheEntry->wFmSequence == pMACHeader->seq_ctrl) &&
-		(!compare_ether_addr(&(pCacheEntry->abyAddr2[0]),
-				     &(pMACHeader->addr2[0]))) &&
+		ether_addr_equal(pCacheEntry->abyAddr2, pMACHeader->addr2) &&
                 (LOBYTE(pCacheEntry->wFrameCtl) == LOBYTE(pMACHeader->frame_control))
                 ) {
                 /* Duplicate match */
@@ -110,8 +109,8 @@ unsigned int WCTLuSearchDFCB(struct vnt_private *pDevice,
 
 	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
 		if ((pDevice->sRxDFCB[ii].bInUse == true) &&
-		    (!compare_ether_addr(&(pDevice->sRxDFCB[ii].abyAddr2[0]),
-					  &(pMACHeader->addr2[0])))) {
+		    ether_addr_equal(pDevice->sRxDFCB[ii].abyAddr2,
+				     pMACHeader->addr2)) {
 			return ii;
 		}
 	}
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index b6cbd13..bc808ef 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1422,8 +1422,8 @@ static void s_vMgrRxDeauthentication(struct vnt_private *pDevice,
 	   pDevice->fWPA_Authened = false;
             DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO  "AP deauthed me, reason=%d.\n", cpu_to_le16((*(sFrame.pwReason))));
             // TODO: update BSS list for specific BSSID if pre-authentication case
-	    if (!compare_ether_addr(sFrame.pHdr->sA3.abyAddr3,
-				    pMgmt->abyCurrBSSID)) {
+	    if (ether_addr_equal(sFrame.pHdr->sA3.abyAddr3,
+				 pMgmt->abyCurrBSSID)) {
                 if (pMgmt->eCurrState >= WMAC_STATE_AUTHPENDING) {
                     pMgmt->sNodeDBTable[0].bActive = false;
                     pMgmt->eCurrMode = WMAC_MODE_STANDBY;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 9f1b413..003bd7c 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -227,7 +227,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
 		} else {
 			// Key Table Full
-			if (!compare_ether_addr(&param->addr[0], pDevice->abyBSSID)) {
+			if (ether_addr_equal(param->addr, pDevice->abyBSSID)) {
 				//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
 				return -EINVAL;
 			} else {


