Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3L3PEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:04:22 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:44154 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962Ab3L3PDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:03:47 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 3/7] vt6655: Fixed most of the checkpatch warnings in wpactl
Date: Mon, 30 Dec 2013 15:52:33 +0100
Message-Id: <1388415157-17615-4-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wpactl.h: Checkpatch does no longer complain about anything

wpactl.c: The following errors and warnings remain:
		ERROR: need consistens spacing around '&'
		       in line 364, 372 and 411
		       This is okay, 'cause we need pointers to
		       the corresponding variables.

		WARNING: Prefer netdev_err [...] to printk
			 This is also okay, 'cause we check if
			 kmalloc failed or not. This is not a
			 device-related error.

hostap.c and iwctl.c:
	  wpactl.h used the typedef statement, which was removed while
	  fixing checkpatch-errors. For this to work one statement in
	  hostap.c was adjusted.
	  The ckecpatch cleanup of these two files still remains.

Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/hostap.c |   2 +-
 drivers/staging/vt6655/iwctl.c  |   2 +-
 drivers/staging/vt6655/wpactl.c | 300 ++++++++++++++++++++++++----------------
 drivers/staging/vt6655/wpactl.h |  16 +--
 4 files changed, 190 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index ca54b79..6eecd53 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -454,7 +454,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned long dwKeyIndex = 0;
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
-	NDIS_802_11_KEY_RSC   KeyRSC;
+	unsigned long long KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int     ret = 0;
 	int     iNodeIndex = -1;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 2db4bc8..ac3fc16 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1827,7 +1827,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct viawget_wpa_param *param = NULL;
 //original member
-	wpa_alg alg_name;
+	enum wpa_alg alg_name;
 	u8  addr[6];
 	int key_idx, set_tx = 0;
 	u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index ee83704..41e9933 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -51,7 +51,7 @@ static const int frequency_list[] = {
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
@@ -90,7 +90,8 @@ static int wpa_init_wpadev(PSDevice pDevice)
 	struct net_device *dev = pDevice->dev;
 	int ret = 0;
 
-	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
+	pDevice->wpadev =
+		alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
 	if (pDevice->wpadev == NULL)
 		return -ENOMEM;
 
@@ -103,7 +104,8 @@ static int wpa_init_wpadev(PSDevice pDevice)
 	pDevice->wpadev->mem_end = dev->mem_end;
 	ret = register_netdev(pDevice->wpadev);
 	if (ret) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdev(WPA) failed!\n",
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"%s: register_netdev(WPA) failed!\n",
 			dev->name);
 		free_netdev(pDevice->wpadev);
 		return -1;
@@ -115,7 +117,8 @@ static int wpa_init_wpadev(PSDevice pDevice)
 			return -ENOMEM;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdev %s for WPA management\n",
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"%s: Registered netdev %s for WPA management\n",
 		dev->name, pDevice->wpadev->name);
 
 	return 0;
@@ -142,7 +145,8 @@ static int wpa_release_wpadev(PSDevice pDevice)
 	}
 
 	if (pDevice->wpadev) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"%s: Netdevice %s unregistered\n",
 			pDevice->dev->name, pDevice->wpadev->name);
 		unregister_netdev(pDevice->wpadev);
 		free_netdev(pDevice->wpadev);
@@ -196,7 +200,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
 	QWORD   KeyRSC;
-//    NDIS_802_11_KEY_RSC KeyRSC;
+/*    NDIS_802_11_KEY_RSC KeyRSC; */
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
 	int uu, ii;
@@ -206,26 +210,29 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	    param->u.wpa_key.seq_len >= MAX_KEY_LEN)
 		return -EINVAL;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n", param->u.wpa_key.alg_name);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"param->u.wpa_key.alg_name = %d\n",
+		param->u.wpa_key.alg_name);
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		pDevice->bEncryptionEnable = false;
 		pDevice->byKeyIndex = 0;
 		pDevice->bTransmitKey = false;
 		KeyvRemoveAllWEPKey(&(pDevice->sKey), pDevice->PortOffset);
-		for (uu = 0; uu < MAX_KEY_TABLE; uu++) {
+		for (uu = 0; uu < MAX_KEY_TABLE; uu++)
 			MACvDisableKeyEntry(pDevice->PortOffset, uu);
-		}
 		return ret;
 	}
 
-	//spin_unlock_irq(&pDevice->lock);
+	/* spin_unlock_irq(&pDevice->lock); */
 	if (param->u.wpa_key.key && fcpfkernel) {
-		memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
+		memcpy(&abyKey[0], param->u.wpa_key.key,
+		       param->u.wpa_key.key_len);
 	} else {
 		spin_unlock_irq(&pDevice->lock);
 		if (param->u.wpa_key.key &&
-		    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
+		    copy_from_user(&abyKey[0], param->u.wpa_key.key,
+				   param->u.wpa_key.key_len)) {
 			spin_lock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
@@ -258,13 +265,15 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		return ret;
 	}
 
-	//spin_unlock_irq(&pDevice->lock);
+	/* spin_unlock_irq(&pDevice->lock); */
 	if (param->u.wpa_key.seq && fcpfkernel) {
-		memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
+		memcpy(&abySeq[0], param->u.wpa_key.seq,
+		       param->u.wpa_key.seq_len);
 	} else {
 		spin_unlock_irq(&pDevice->lock);
 		if (param->u.wpa_key.seq &&
-		    copy_from_user(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len)) {
+		    copy_from_user(&abySeq[0], param->u.wpa_key.seq,
+				   param->u.wpa_key.seq_len)) {
 			spin_lock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
@@ -277,7 +286,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 				LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
 			else
 				HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
-			//KeyRSC |= (abySeq[ii] << (ii * 8));
+			/* KeyRSC |= (abySeq[ii] << (ii * 8)); */
 		}
 		dwKeyIndex |= 1 << 29;
 	}
@@ -287,13 +296,11 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 		return -EINVAL;
 	}
 
-	if (param->u.wpa_key.alg_name == WPA_ALG_TKIP) {
+	if (param->u.wpa_key.alg_name == WPA_ALG_TKIP)
 		pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-	}
 
-	if (param->u.wpa_key.alg_name == WPA_ALG_CCMP) {
+	if (param->u.wpa_key.alg_name == WPA_ALG_CCMP)
 		pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-	}
 
 	if (param->u.wpa_key.set_tx)
 		dwKeyIndex |= (1 << 31);
@@ -305,7 +312,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	else
 		byKeyDecMode = KEY_CTL_WEP;
 
-	// Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled
+	/* Fix HCT test that set 256 bits KEY
+	 * and Ndis802_11Encryption3Enabled
+	 */
 	if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 		if (param->u.wpa_key.key_len == MAX_KEY_LEN)
 			byKeyDecMode = KEY_CTL_TKIP;
@@ -320,102 +329,120 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 			byKeyDecMode = KEY_CTL_WEP;
 	}
 
-	// Check TKIP key length
+	/* Check TKIP key length */
 	if ((byKeyDecMode == KEY_CTL_TKIP) &&
 	    (param->u.wpa_key.key_len != MAX_KEY_LEN)) {
-		// TKIP Key must be 256 bits
-		//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - TKIP Key must be 256 bits\n"));
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
+		/* TKIP Key must be 256 bits
+		 * DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA
+		 * TKIP Key must be 256 bits\n"));
+		 */
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"return- TKIP Key must be 256 bits!\n");
 		return -EINVAL;
 	}
-	// Check AES key length
+	/* Check AES key length */
 	if ((byKeyDecMode == KEY_CTL_CCMP) &&
 	    (param->u.wpa_key.key_len != AES_KEY_LEN)) {
-		// AES Key must be 128 bits
-		//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - AES Key must be 128 bits\n"));
+		/* AES Key must be 128 bits
+		 * DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA
+		 * AES Key must be 128 bits\n"));
+		 */
 		return -EINVAL;
 	}
 
-	// spin_lock_irq(&pDevice->lock);
+	/* spin_lock_irq(&pDevice->lock); */
 	if (is_broadcast_ether_addr(&param->addr[0]) || (param->addr == NULL)) {
-		// If is_broadcast_ether_addr, set the key as every key entry's group key.
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
+		/* If is_broadcast_ether_addr,
+		 * set the key as every key entry's group key.
+		 */
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Groupe Key Assign.\n");
 
 		if (KeybSetAllGroupKey(&(pDevice->sKey),
 					dwKeyIndex,
 					param->u.wpa_key.key_len,
-					(PQWORD) &(KeyRSC),
-					(unsigned char *)abyKey,
+					(PQWORD) &KeyRSC,
+					(unsigned char *) abyKey,
 					byKeyDecMode,
 					pDevice->PortOffset,
 					pDevice->byLocalID) &&
 		    KeybSetDefaultKey(&(pDevice->sKey),
 				       dwKeyIndex,
 				       param->u.wpa_key.key_len,
-				       (PQWORD) &(KeyRSC),
-				       (unsigned char *)abyKey,
+				       (PQWORD) &KeyRSC,
+				       (unsigned char *) abyKey,
 				       byKeyDecMode,
 				       pDevice->PortOffset,
 				       pDevice->byLocalID)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"GROUP Key Assign.\n");
 
 		} else {
-			//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -KeybSetDefaultKey Fail.0\n"));
-			// spin_unlock_irq(&pDevice->lock);
+			/* DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA
+			 * -KeybSetDefaultKey Fail.0\n"));
+			 * spin_unlock_irq(&pDevice->lock);
+			 */
 			return -EINVAL;
 		}
 
 	} else {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Assign.\n");
-		// BSSID not 0xffffffffffff
-		// Pairwise Key can't be WEP
+		/* BSSID not 0xffffffffffff
+		   Pairwise Key can't be WEP */
 		if (byKeyDecMode == KEY_CTL_WEP) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
-			//spin_unlock_irq(&pDevice->lock);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Pairwise Key can't be WEP\n");
+			/* spin_unlock_irq(&pDevice->lock); */
 			return -EINVAL;
 		}
 
-		dwKeyIndex |= (1 << 30); // set pairwise key
+		dwKeyIndex |= (1 << 30); /* set pairwise key */
 		if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
-			//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - WMAC_CONFIG_IBSS_STA\n"));
-			//spin_unlock_irq(&pDevice->lock);
+			/* DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA
+			 * WMAC_CONFIG_IBSS_STA\n"));
+			 * spin_unlock_irq(&pDevice->lock);
+			 */
 			return -EINVAL;
 		}
 		if (KeybSetKey(&(pDevice->sKey),
 			       &param->addr[0],
 			       dwKeyIndex,
 			       param->u.wpa_key.key_len,
-			       (PQWORD) &(KeyRSC),
-			       (unsigned char *)abyKey,
+			       (PQWORD) &KeyRSC,
+			       (unsigned char *) abyKey,
 			       byKeyDecMode,
 			       pDevice->PortOffset,
 			       pDevice->byLocalID)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Pairwise Key Set\n");
 
 		} else {
-			// Key Table Full
+			/* Key Table Full */
 			if (ether_addr_equal(param->addr, pDevice->abyBSSID)) {
-				//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
-				//spin_unlock_irq(&pDevice->lock);
+				/* DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA
+				 * -Key Table Full.2\n"));
+				 * spin_unlock_irq(&pDevice->lock); */
 				return -EINVAL;
 
 			} else {
-				// Save Key and configure just before associate/reassociate to BSSID
-				// we do not implement now
-				//spin_unlock_irq(&pDevice->lock);
+				/* Save Key and configure just before
+				 * associate/reassociate
+				 * to BSSID we do not implement now
+				 * spin_unlock_irq(&pDevice->lock);
+				 */
 				return -EINVAL;
 			}
 		}
-	} // BSSID not 0xffffffffffff
+	} /* BSSID not 0xffffffffffff */
 	if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
 		pDevice->byKeyIndex = (unsigned char)param->u.wpa_key.key_index;
 		pDevice->bTransmitKey = true;
 	}
 	pDevice->bEncryptionEnable = true;
-	//spin_unlock_irq(&pDevice->lock);
+	/*spin_unlock_irq(&pDevice->lock); */
 
 /*
-  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx \n",
+  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx\n",
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][0],
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][1],
   pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][2],
@@ -476,7 +503,8 @@ static int wpa_set_disassociate(PSDevice pDevice,
 	spin_lock_irq(&pDevice->lock);
 	if (pDevice->bLinkPass) {
 		if (!memcmp(param->addr, pMgmt->abyCurrBSSID, 6))
-			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE, NULL);
+			bScheduleCommand((void *)pDevice,
+					 WLAN_CMD_DISASSOCIATE, NULL);
 	}
 	spin_unlock_irq(&pDevice->lock);
 
@@ -558,7 +586,8 @@ static int wpa_get_ssid(PSDevice pDevice,
 
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 
-	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID , pItemSSID->len);
+	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID,
+	       pItemSSID->len);
 	param->u.wpa_associate.ssid_len = pItemSSID->len;
 
 	return ret;
@@ -596,7 +625,7 @@ static int wpa_get_scan(PSDevice pDevice,
 	ptempBSS = kmalloc(sizeof(KnownBSS), (int)GFP_ATOMIC);
 
 	if (ptempBSS == NULL) {
-		printk("bubble sort kmalloc memory fail@@@\n");
+		printk(KERN_ERR "bubble sort kmalloc memory fail@@@\n");
 
 		ret = -ENOMEM;
 
@@ -606,14 +635,18 @@ static int wpa_get_scan(PSDevice pDevice,
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		for (jj = 0; jj < MAX_BSS_NUM - ii - 1; jj++) {
-			if ((pMgmt->sBSSList[jj].bActive != true) ||
+			if ((pMgmt->sBSSList[jj].bActive != true)
+			    || ((pMgmt->sBSSList[jj].uRSSI > pMgmt->sBSSList[jj + 1].uRSSI)
+			    && (pMgmt->sBSSList[jj + 1].bActive != false))) {
+				memcpy(ptempBSS, &pMgmt->sBSSList[jj],
+				       sizeof(KnownBSS));
 
-			    ((pMgmt->sBSSList[jj].uRSSI > pMgmt->sBSSList[jj + 1].uRSSI) && (pMgmt->sBSSList[jj + 1].bActive != false))) {
-				memcpy(ptempBSS, &pMgmt->sBSSList[jj], sizeof(KnownBSS));
+				memcpy(&pMgmt->sBSSList[jj],
+				       &pMgmt->sBSSList[jj + 1],
+				       sizeof(KnownBSS));
 
-				memcpy(&pMgmt->sBSSList[jj], &pMgmt->sBSSList[jj + 1], sizeof(KnownBSS));
-
-				memcpy(&pMgmt->sBSSList[jj + 1], ptempBSS, sizeof(KnownBSS));
+				memcpy(&pMgmt->sBSSList[jj + 1], ptempBSS,
+				       sizeof(KnownBSS));
 
 			}
 
@@ -624,7 +657,7 @@ static int wpa_get_scan(PSDevice pDevice,
 	kfree(ptempBSS);
 #endif
 
-//******mike:bubble sort by stronger RSSI*****//
+/******mike:bubble sort by stronger RSSI*****/
 
 	count = 0;
 	pBSS = &(pMgmt->sBSSList[0]);
@@ -635,7 +668,8 @@ static int wpa_get_scan(PSDevice pDevice,
 		count++;
 	}
 
-	pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
+	pBuf = kcalloc(count, sizeof(struct viawget_scan_result),
+		       (int)GFP_ATOMIC);
 
 	if (pBuf == NULL) {
 		ret = -ENOMEM;
@@ -650,24 +684,29 @@ static int wpa_get_scan(PSDevice pDevice,
 				break;
 			memcpy(scan_buf->bssid, pBSS->abyBSSID, WLAN_BSSID_LEN);
 			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
-			memcpy(scan_buf->ssid, pItemSSID->abySSID, pItemSSID->len);
+			memcpy(scan_buf->ssid, pItemSSID->abySSID,
+			       pItemSSID->len);
 			scan_buf->ssid_len = pItemSSID->len;
 			scan_buf->freq = frequency_list[pBSS->uChannel-1];
 			scan_buf->caps = pBSS->wCapInfo;
-			//scan_buf->caps = pBSS->wCapInfo;
-			//scan_buf->qual =
-			//scan_buf->noise =
-			//scan_buf->level =
-			//scan_buf->maxrate =
+			/*scan_buf->caps = pBSS->wCapInfo;
+			 *scan_buf->qual =
+			 *scan_buf->noise =
+			 *scan_buf->level =
+			 *scan_buf->maxrate =
+			 */
 			if (pBSS->wWPALen != 0) {
 				scan_buf->wpa_ie_len = pBSS->wWPALen;
-				memcpy(scan_buf->wpa_ie, pBSS->byWPAIE, pBSS->wWPALen);
+				memcpy(scan_buf->wpa_ie, pBSS->byWPAIE,
+				       pBSS->wWPALen);
 			}
 			if (pBSS->wRSNLen != 0) {
 				scan_buf->rsn_ie_len = pBSS->wRSNLen;
-				memcpy(scan_buf->rsn_ie, pBSS->byRSNIE, pBSS->wRSNLen);
+				memcpy(scan_buf->rsn_ie, pBSS->byRSNIE,
+				       pBSS->wRSNLen);
 			}
-			scan_buf = (struct viawget_scan_result *)((unsigned char *)scan_buf + sizeof(struct viawget_scan_result));
+			scan_buf = (struct viawget_scan_result *)((unsigned char *)scan_buf
+				   + sizeof(struct viawget_scan_result));
 			jj++;
 		}
 	}
@@ -675,9 +714,9 @@ static int wpa_get_scan(PSDevice pDevice,
 	if (jj < count)
 		count = jj;
 
-	if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count)) {
+	if (copy_to_user(param->u.scan_results.buf, pBuf,
+			 sizeof(struct viawget_scan_result) * count))
 		ret = -EFAULT;
-	}
 	param->u.scan_results.scan_count = count;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count)
 
@@ -709,20 +748,27 @@ static int wpa_set_associate(PSDevice pDevice,
 	int ret = 0;
 	bool bWepEnabled = false;
 
-	// set key type & algorithm
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n", param->u.wpa_associate.auth_alg);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n", param->u.wpa_associate.mode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
+	/* set key type & algorithm */
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n",
+		param->u.wpa_associate.pairwise_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n",
+		param->u.wpa_associate.group_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n",
+		param->u.wpa_associate.key_mgmt_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n",
+		param->u.wpa_associate.auth_alg);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n",
+		param->u.wpa_associate.mode);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n",
+		param->u.wpa_associate.wpa_ie_len);
 
 	if (param->u.wpa_associate.wpa_ie_len) {
 		if (!param->u.wpa_associate.wpa_ie)
 			return -EINVAL;
 		if (param->u.wpa_associate.wpa_ie_len > sizeof(abyWPAIE))
 			return -EINVAL;
-		if (copy_from_user(&abyWPAIE[0], param->u.wpa_associate.wpa_ie, param->u.wpa_associate.wpa_ie_len))
+		if (copy_from_user(&abyWPAIE[0], param->u.wpa_associate.wpa_ie,
+				   param->u.wpa_associate.wpa_ie_len))
 			return -EFAULT;
 	}
 
@@ -730,18 +776,18 @@ static int wpa_set_associate(PSDevice pDevice,
 		pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
 	else
 		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-	// set ssid
+	/* set ssid */
 	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 	pItemSSID->byElementID = WLAN_EID_SSID;
 	pItemSSID->len = param->u.wpa_associate.ssid_len;
 	memcpy(pItemSSID->abySSID, param->u.wpa_associate.ssid, pItemSSID->len);
-	// set bssid
+	/* set bssid */
 	if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
 		memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
-	else {
-		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pItemSSID->abySSID);
-	}
+	else
+		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN,
+				 pItemSSID->abySSID);
 
 	if (param->u.wpa_associate.wpa_ie_len == 0) {
 		if (param->u.wpa_associate.auth_alg & AUTH_ALG_SHARED_KEY)
@@ -776,43 +822,54 @@ static int wpa_set_associate(PSDevice pDevice,
 		break;
 	case CIPHER_NONE:
 		if (param->u.wpa_associate.group_suite == CIPHER_CCMP)
-			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
+			pDevice->eEncryptionStatus =
+				Ndis802_11Encryption3Enabled;
 		else
-			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
+			pDevice->eEncryptionStatus =
+				Ndis802_11Encryption2Enabled;
 		break;
 	default:
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	}
 
-//DavidWang add for WPA_supplicant support open/share mode
+/* DavidWang add for WPA_supplicant support open/share mode */
 
 	if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) {
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		//pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY;
+		/* pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY; */
 		pMgmt->bShareKeyAlgorithm = true;
 	} else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
-		if (!bWepEnabled)  pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-		else pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		//pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-		//pMgmt->bShareKeyAlgorithm = false; //20080717-06,<Modify> by chester//Fix Open mode, WEP encryption
-	}
-//mike save old encryption status
+		if (!bWepEnabled)
+			pDevice->eEncryptionStatus =
+				Ndis802_11EncryptionDisabled;
+		else
+			pDevice->eEncryptionStatus =
+				Ndis802_11Encryption1Enabled;
+		/* pMgmt->eAuthenMode = WMAC_AUTH_OPEN; */
+		/* pMgmt->bShareKeyAlgorithm = false;
+		 * 20080717-06,<Modify> by chester//Fix Open mode,
+		 * WEP encryption
+		 */
+	}
+/* mike save old encryption status */
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
 
 	if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
 		pDevice->bEncryptionEnable = true;
 	else
 		pDevice->bEncryptionEnable = false;
-	if (!((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
-	      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && bWepEnabled)))  //DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP
+
+	/* DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP */
+	if (!((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY)
+	      || ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && bWepEnabled)))
 		KeyvInitTable(&pDevice->sKey, pDevice->PortOffset);
 	spin_lock_irq(&pDevice->lock);
 	pDevice->bLinkPass = false;
 	memset(pMgmt->abyCurrBSSID, 0, 6);
 	pMgmt->eCurrState = WMAC_STATE_IDLE;
 	netif_stop_queue(pDevice->dev);
-	//20080701-02,<Add> by Mike Liu
-/*******search if ap_scan=2 ,which is associating request in hidden ssid mode ****/
+	/* 20080701-02,<Add> by Mike Liu */
+/* search if ap_scan=2 ,which is associating request in hidden ssid mode */
 	{
 		PKnownBSS       pCurr = NULL;
 		pCurr = BSSpSearchBSSList(pDevice,
@@ -822,8 +879,9 @@ static int wpa_set_associate(PSDevice pDevice,
 );
 
 		if (pCurr == NULL) {
-			printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
-			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->abyDesireSSID);
+			netdev_info(pDevice->dev, "wpa_set_associate---->hidden mode site survey before associate.......\n");
+			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN,
+					 pMgmt->abyDesireSSID);
 		}
 	}
 /****************************************************************/
@@ -869,18 +927,18 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	switch (param->cmd) {
 	case VIAWGET_SET_WPA:
 		ret = wpa_set_wpa(pDevice, param);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA\n");
 		break;
 
 	case VIAWGET_SET_KEY:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY\n");
 		spin_lock_irq(&pDevice->lock);
 		ret = wpa_set_keys(pDevice, param, false);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
 	case VIAWGET_SET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN\n");
 		ret = wpa_set_scan(pDevice, param);
 		break;
 
@@ -891,38 +949,42 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 		break;
 
 	case VIAWGET_GET_SSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID\n");
 		ret = wpa_get_ssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_BSSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID\n");
 		ret = wpa_get_bssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_SET_ASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"VIAWGET_SET_ASSOCIATE\n");
 		ret = wpa_set_associate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DISASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"VIAWGET_SET_DISASSOCIATE\n");
 		ret = wpa_set_disassociate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DROP_UNENCRYPT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"VIAWGET_SET_DROP_UNENCRYPT\n");
 		break;
 
 	case VIAWGET_SET_DEAUTHENTICATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"VIAWGET_SET_DEAUTHENTICATE\n");
 		break;
 
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
-			param->cmd);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"wpa_ioctl: unknown cmd=%d\n", param->cmd);
 		return -EOPNOTSUPP;
 		break;
 	}
diff --git a/drivers/staging/vt6655/wpactl.h b/drivers/staging/vt6655/wpactl.h
index b9e2ab2..f398e15 100644
--- a/drivers/staging/vt6655/wpactl.h
+++ b/drivers/staging/vt6655/wpactl.h
@@ -36,13 +36,13 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
-//WPA related
+/* WPA related */
 
-typedef enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-typedef enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-	       CIPHER_WEP104 } wpa_cipher;
-typedef enum { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
-	       KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE } wpa_key_mgmt;
+enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
+enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
+	       CIPHER_WEP104 };
+enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK,
+	       KEY_MGMT_NONE, KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE };
 
 #define AUTH_ALG_OPEN_SYSTEM	0x01
 #define AUTH_ALG_SHARED_KEY	0x02
@@ -51,8 +51,6 @@ typedef enum { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define GENERIC_INFO_ELEM 0xdd
 #define RSN_INFO_ELEM 0x30
 
-typedef unsigned long long   NDIS_802_11_KEY_RSC;
-
 /*---------------------  Export Classes  ----------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -63,4 +61,4 @@ int wpa_set_wpadev(PSDevice pDevice, int val);
 int wpa_ioctl(PSDevice pDevice, struct iw_point *p);
 int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel);
 
-#endif // __WPACL_H__
+#endif /* __WPACL_H__ */
-- 
1.8.1.2

