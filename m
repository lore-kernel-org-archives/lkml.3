Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJOM04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:26:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:64026 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaJOM0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,724,1406617200"; 
   d="scan'208";a="589371908"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: gregkh@linuxfoundation.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        mail@beyermatthias.de, devel@driverdev.osuosl.org
Subject: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Date: Wed, 15 Oct 2014 05:26:39 -0700
Message-Id: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Beceem WIMAX was generating compile warnings on 64bit machines,
which were:

drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(
   ^
drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(
   ^
drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(

This resolves the issue by generating 64bit friendly code.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/staging/bcm/CmHost.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index adca0ce..29fa05d 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1499,9 +1499,15 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter,
 	}
 
 	/* this can't possibly be right */
+#ifdef CONFIG_32BIT
 	pstAddIndication->psfAuthorizedSet =
 		(struct bcm_connect_mgr_params *) ntohl(
 				(ULONG)pstAddIndication->psfAuthorizedSet);
+#else
+	pstAddIndication->psfAuthorizedSet =
+		(struct bcm_connect_mgr_params *)(u64)ntohl(
+				(ULONG)pstAddIndication->psfAuthorizedSet);
+#endif
 
 	if (pstAddIndicationAlt->u8Type == DSA_REQ) {
 		struct bcm_add_request AddRequest;
@@ -1542,9 +1548,15 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter,
 		return 0;
 	}
 
+#ifdef CONFIG_32BIT
 	pstAddIndication->psfAdmittedSet =
 		(struct bcm_connect_mgr_params *) ntohl(
 				(ULONG) pstAddIndication->psfAdmittedSet);
+#else
+	pstAddIndication->psfAdmittedSet =
+		(struct bcm_connect_mgr_params *)(u64)ntohl(
+				(ULONG) pstAddIndication->psfAdmittedSet);
+#endif
 
 	/* ACTIVE SET */
 	pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)
@@ -1560,9 +1572,15 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter,
 		return 0;
 	}
 
+#ifdef CONFIG_32BIT
 	pstAddIndication->psfActiveSet =
 		(struct bcm_connect_mgr_params *) ntohl(
 				(ULONG)pstAddIndication->psfActiveSet);
+#else
+	pstAddIndication->psfActiveSet =
+		(struct bcm_connect_mgr_params *)(u64)ntohl(
+				(ULONG)pstAddIndication->psfActiveSet);
+#endif
 
 	(*puBufferLength) = sizeof(struct bcm_add_indication);
 	*(struct bcm_add_indication *)pvBuffer = *pstAddIndication;
-- 
1.9.3

