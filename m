Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbaGCJWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbaGCJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/198] s390/lowcore: reserve 96 bytes for IRB in lowcore
Date: Thu,  3 Jul 2014 10:18:35 +0100
Message-Id: <1404379241-8590-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 993072ee67aa179c48c85eb19869804e68887d86 upstream.

The IRB might be 96 bytes if the extended-I/O-measurement facility is
used. This feature is currently not used by Linux, but struct irb
already has the emw defined. So let's make the irb in lowcore match the
size of the internal data structure to be future proof.
We also have to add a pad, to correctly align the paste.

The bigger irb field also circumvents a bug in some QEMU versions that
always write the emw field on test subchannel and therefore destroy the
paste definitions of this CPU. Running under these QEMU version broke
some timing functions in the VDSO and all users of these functions,
e.g. some JREs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/include/asm/lowcore.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index bbf8141408cd..2bed4f02a558 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -142,9 +142,9 @@ struct _lowcore {
 	__u8	pad_0x02fc[0x0300-0x02fc];	/* 0x02fc */
 
 	/* Interrupt response block */
-	__u8	irb[64];			/* 0x0300 */
+	__u8	irb[96];			/* 0x0300 */
 
-	__u8	pad_0x0340[0x0e00-0x0340];	/* 0x0340 */
+	__u8	pad_0x0360[0x0e00-0x0360];	/* 0x0360 */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
@@ -288,12 +288,13 @@ struct _lowcore {
 	__u8	pad_0x03a0[0x0400-0x03a0];	/* 0x03a0 */
 
 	/* Interrupt response block. */
-	__u8	irb[64];			/* 0x0400 */
+	__u8	irb[96];			/* 0x0400 */
+	__u8	pad_0x0460[0x0480-0x0460];	/* 0x0460 */
 
 	/* Per cpu primary space access list */
-	__u32	paste[16];			/* 0x0440 */
+	__u32	paste[16];			/* 0x0480 */
 
-	__u8	pad_0x0480[0x0e00-0x0480];	/* 0x0480 */
+	__u8	pad_0x04c0[0x0e00-0x04c0];	/* 0x04c0 */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
-- 
1.9.1

