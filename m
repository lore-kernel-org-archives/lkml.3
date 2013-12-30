Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3L3O6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:58:49 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:41842 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037Ab3L3O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:58:46 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 5/7] vt6655: Fixed most of the checkpatch warnings in wpa
Date: Mon, 30 Dec 2013 15:52:35 +0100
Message-Id: <1388415157-17615-6-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wpa.h: Checkpatch does no longer complain about anything.

wpactl.c: Some long-line-warnings still remain but fixing them
	  would deteriorate code readability.

Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wpa.c | 156 ++++++++++++++++++++++++++++---------------
 drivers/staging/vt6655/wpa.h |   2 +-
 2 files changed, 102 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 990ea0f..fdd2722 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -116,14 +116,17 @@ WPA_ParseRSN(
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WPA_ParseRSN: [%d]\n", pRSN->len);
 
-	// information element header makes sense
-	if ((pRSN->len >= 6) // oui1(4)+ver(2)
-	    && (pRSN->byElementID == WLAN_EID_RSN_WPA) && !memcmp(pRSN->abyOUI, abyOUI01, 4)
+	/* information element header makes sense */
+	if ((pRSN->len >= 6) /* oui1(4)+ver(2) */
+	    && (pRSN->byElementID == WLAN_EID_RSN_WPA)
+	    && !memcmp(pRSN->abyOUI, abyOUI01, 4)
 	    && (pRSN->wVersion == 1)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Legal RSN\n");
-		// update each variable if pRSN is long enough to contain the variable
-		if (pRSN->len >= 10) //oui1(4)+ver(2)+GKSuite(4)
-		{
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Legal RSN\n");
+		/* update each variable if pRSN is
+		 * long enough to contain the variable
+		 */
+		if (pRSN->len >= 10) { /* oui1(4)+ver(2)+GKSuite(4) */
 			if (!memcmp(pRSN->abyMulticast, abyOUI01, 4))
 				pBSSList->byGKType = WPA_WEP40;
 			else if (!memcmp(pRSN->abyMulticast, abyOUI02, 4))
@@ -135,80 +138,117 @@ WPA_ParseRSN(
 			else if (!memcmp(pRSN->abyMulticast, abyOUI05, 4))
 				pBSSList->byGKType = WPA_WEP104;
 			else
-				// any vendor checks here
+				/* any vendor checks here */
 				pBSSList->byGKType = WPA_NONE;
 
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "byGKType: %x\n", pBSSList->byGKType);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"byGKType: %x\n", pBSSList->byGKType);
 		}
 
-		if (pRSN->len >= 12) //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
-		{
+		if (pRSN->len >= 12) { /* oui1(4)+ver(2)+GKS(4)+PKSCnt(2) */
 			j = 0;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
-			for (i = 0; (i < pRSN->wPKCount) && (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
-				if (pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
-					if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
-						pBSSList->abyPKType[j++] = WPA_NONE;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI02, 4))
-						pBSSList->abyPKType[j++] = WPA_TKIP;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI03, 4))
-						pBSSList->abyPKType[j++] = WPA_AESWRAP;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI04, 4))
-						pBSSList->abyPKType[j++] = WPA_AESCCMP;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n",
+				pRSN->wPKCount, sizeof(pBSSList->abyPKType));
+			for (i = 0; (i < pRSN->wPKCount)
+			     && (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
+				/* oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i) */
+				if (pRSN->len >= 12+i*4+4) {
+					if (!memcmp(pRSN->PKSList[i].abyOUI,
+						    abyOUI00, 4))
+						pBSSList->abyPKType[j++] =
+							WPA_NONE;
+					else if (!memcmp(pRSN->PKSList[i].abyOUI,
+							 abyOUI02, 4))
+						pBSSList->abyPKType[j++] =
+							WPA_TKIP;
+					else if (!memcmp(pRSN->PKSList[i].abyOUI,
+							 abyOUI03, 4))
+						pBSSList->abyPKType[j++] =
+							WPA_AESWRAP;
+					else if (!memcmp(pRSN->PKSList[i].abyOUI,
+							 abyOUI04, 4))
+						pBSSList->abyPKType[j++] =
+							WPA_AESCCMP;
 					else
-						// any vendor checks here
+						/* any vendor checks here */
 						;
 				} else
 					break;
-				//DBG_PRN_GRP14(("abyPKType[%d]: %X\n", j-1, pBSSList->abyPKType[j-1]));
-			} //for
+				/* DBG_PRN_GRP14(("abyPKType[%d]: %X\n", j-1,
+				 *		 pBSSList->abyPKType[j-1]));
+				*/
+			} /* for */
 			pBSSList->wPKCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wPKCount: %d\n", pBSSList->wPKCount);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wPKCount: %d\n", pBSSList->wPKCount);
 		}
 
 		m = pRSN->wPKCount;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "m: %d\n", m);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "14+m*4: %d\n", 14+m*4);
 
-		if (pRSN->len >= 14+m*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)
-			// overlay IE_RSN_Auth structure into correct place
-			pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
+		/* oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2) */
+		if (pRSN->len >= 14+m*4) {
+			/* overlay IE_RSN_Auth structure into correct place */
+			pIE_RSN_Auth =
+				(PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
 			j = 0;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
-				pIE_RSN_Auth->wAuthCount, sizeof(pBSSList->abyAuthType));
-			for (i = 0; (i < pIE_RSN_Auth->wAuthCount) && (j < ARRAY_SIZE(pBSSList->abyAuthType)); i++) {
-				if (pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
-					if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI01, 4))
-						pBSSList->abyAuthType[j++] = WPA_AUTH_IEEE802_1X;
-					else if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI02, 4))
-						pBSSList->abyAuthType[j++] = WPA_AUTH_PSK;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
+				pIE_RSN_Auth->wAuthCount,
+				sizeof(pBSSList->abyAuthType));
+			for (i = 0; (i < pIE_RSN_Auth->wAuthCount)
+			     && (j < ARRAY_SIZE(pBSSList->abyAuthType)); i++) {
+				/* oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i) */
+				if (pRSN->len >= 14+4+(m+i)*4) {
+					if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI,
+						    abyOUI01, 4))
+						pBSSList->abyAuthType[j++] =
+							WPA_AUTH_IEEE802_1X;
+					else if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI,
+							 abyOUI02, 4))
+						pBSSList->abyAuthType[j++] =
+							WPA_AUTH_PSK;
 					else
-						// any vendor checks here
+						/* any vendor checks here */
 						;
 				} else
 					break;
-				//DBG_PRN_GRP14(("abyAuthType[%d]: %X\n", j-1, pBSSList->abyAuthType[j-1]));
+				/* DBG_PRN_GRP14(("abyAuthType[%d]: %X\n",
+				 *		 j-1,
+				 *		 pBSSList->abyAuthType[j-1]));
+				 */
 			}
 			if (j > 0)
 				pBSSList->wAuthCount = (unsigned short)j;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wAuthCount: %d\n", pBSSList->wAuthCount);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"wAuthCount: %d\n", pBSSList->wAuthCount);
 		}
 
 		if (pIE_RSN_Auth != NULL) {
 			n = pIE_RSN_Auth->wAuthCount;
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "n: %d\n", n);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
 
-			if (pRSN->len+2 >= 14+4+(m+n)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*n)+Cap(2)
+			/* oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*n)+Cap(2) */
+			if (pRSN->len+2 >= 14+4+(m+n)*4) {
 				pbyCaps = (unsigned char *)pIE_RSN_Auth->AuthKSList[n].abyOUI;
-				pBSSList->byDefaultK_as_PK = (*pbyCaps) & WPA_GROUPFLAG;
-				pBSSList->byReplayIdx = 2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
+				pBSSList->byDefaultK_as_PK =
+					(*pbyCaps) & WPA_GROUPFLAG;
+				pBSSList->byReplayIdx =
+					2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
 				pBSSList->sRSNCapObj.bRSNCapExist = true;
-				pBSSList->sRSNCapObj.wRSNCap = *(unsigned short *)pbyCaps;
-				//DBG_PRN_GRP14(("pbyCaps: %X\n", *pbyCaps));
-				//DBG_PRN_GRP14(("byDefaultK_as_PK: %X\n", pBSSList->byDefaultK_as_PK));
-				//DBG_PRN_GRP14(("byReplayIdx: %X\n", pBSSList->byReplayIdx));
+				pBSSList->sRSNCapObj.wRSNCap =
+					*(unsigned short *)pbyCaps;
+				/* DBG_PRN_GRP14(("pbyCaps: %X\n", *pbyCaps));
+				 * DBG_PRN_GRP14(("byDefaultK_as_PK: %X\n",
+				 *		 pBSSList->byDefaultK_as_PK));
+				 * DBG_PRN_GRP14(("byReplayIdx: %X\n",
+				 *		 pBSSList->byReplayIdx));
+				 */
 			}
 		}
 		pBSSList->bWPAValid = true;
@@ -254,11 +294,16 @@ WPA_SearchRSN(
 			for (ii = 0; ii < pBSSList->wPKCount; ii++) {
 				if (pBSSList->abyPKType[ii] == WPA_AESCCMP)
 					byPKType = WPA_AESCCMP;
-				else if ((pBSSList->abyPKType[ii] == WPA_TKIP) && (byPKType != WPA_AESCCMP))
+				else if ((pBSSList->abyPKType[ii] == WPA_TKIP)
+					 && (byPKType != WPA_AESCCMP))
 					byPKType = WPA_TKIP;
-				else if ((pBSSList->abyPKType[ii] == WPA_WEP40) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
+				else if ((pBSSList->abyPKType[ii] == WPA_WEP40)
+					 && (byPKType != WPA_AESCCMP)
+					 && (byPKType != WPA_TKIP))
 					byPKType = WPA_WEP40;
-				else if ((pBSSList->abyPKType[ii] == WPA_WEP104) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
+				else if ((pBSSList->abyPKType[ii] == WPA_WEP104)
+					 && (byPKType != WPA_AESCCMP)
+					 && (byPKType != WPA_TKIP))
 					byPKType = WPA_WEP104;
 			}
 			if (byEncrypt != byPKType)
@@ -295,10 +340,11 @@ WPAb_Is_RSN(
 	if (pRSN == NULL)
 		return false;
 
-	if ((pRSN->len >= 6) && // oui1(4)+ver(2)
-	    (pRSN->byElementID == WLAN_EID_RSN_WPA) &&  !memcmp(pRSN->abyOUI, abyOUI01, 4) &&
-	    (pRSN->wVersion == 1)) {
+	if ((pRSN->len >= 6) /* oui1(4)+ver(2) */
+	    && (pRSN->byElementID == WLAN_EID_RSN_WPA)
+	    && !memcmp(pRSN->abyOUI, abyOUI01, 4)
+	    && (pRSN->wVersion == 1))
 		return true;
-	} else
+	else
 		return false;
 }
diff --git a/drivers/staging/vt6655/wpa.h b/drivers/staging/vt6655/wpa.h
index 1d1918a..d012cb9 100644
--- a/drivers/staging/vt6655/wpa.h
+++ b/drivers/staging/vt6655/wpa.h
@@ -80,4 +80,4 @@ WPAb_Is_RSN(
 	PWLAN_IE_RSN_EXT pRSN
 );
 
-#endif // __WPA_H__
+#endif /* __WPA_H__ */
-- 
1.8.1.2

