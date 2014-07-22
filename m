Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbaGVWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaGVWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 039/116] s390/lowcore: reserve 96 bytes for IRB in lowcore
Date: Tue, 22 Jul 2014 15:20:50 -0700
Message-Id: <1406067727-19683-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/include/asm/lowcore.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index bbf8141..2bed4f0 100644
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

