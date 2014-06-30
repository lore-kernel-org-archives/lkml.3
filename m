Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaF3Mfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:35:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964866AbaF3Mbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/181] s390/lowcore: reserve 96 bytes for IRB in lowcore
Date: Mon, 30 Jun 2014 13:52:23 +0200
Message-Id: <9202bf159dd6994988162fe14e303549c7918764.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

