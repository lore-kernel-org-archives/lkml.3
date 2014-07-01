Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaGAM4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:56:35 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56675 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaGAM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:56:34 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: message: fusion: Simplify rounding
Date: Tue,  1 Jul 2014 14:56:20 +0200
Message-Id: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rounding up to a multiple of 4 should be done using the ALIGN
macro. As a bonus, this also makes the generated code smaller.

In GetIocFacts(), sz is assigned to a few lines below without being
read in the meantime, so it is ok that it doesn't end up with the same
value as facts->FWImageSize.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/message/fusion/mptbase.c | 7 +------
 drivers/message/fusion/mptctl.c  | 7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ebc0af7..10b16a1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -3175,12 +3175,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 			facts->FWImageSize = le32_to_cpu(facts->FWImageSize);
 		}
 
-		sz = facts->FWImageSize;
-		if ( sz & 0x01 )
-			sz += 1;
-		if ( sz & 0x02 )
-			sz += 2;
-		facts->FWImageSize = sz;
+		facts->FWImageSize = ALIGN(facts->FWImageSize, 4);
 
 		if (!facts->RequestFrameSize) {
 			/*  Something is wrong!  */
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 8a050e8..1004392 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1749,12 +1749,7 @@ mptctl_replace_fw (unsigned long arg)
 
 	/* Allocate memory for the new FW image
 	 */
-	newFwSize = karg.newImageSize;
-
-	if (newFwSize & 0x01)
-		newFwSize += 1;
-	if (newFwSize & 0x02)
-		newFwSize += 2;
+	newFwSize = ALIGN(karg.newImageSize, 4);
 
 	mpt_alloc_fw_memory(ioc, newFwSize);
 	if (ioc->cached_fw == NULL)
-- 
1.9.2

