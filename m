Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbaGHTRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54335 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Sebastian Ott" <sebott@linux.vnet.ibm.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.859778775@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 045/125] s390/lowcore: reserve 96 bytes for IRB in lowcore
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: offsets of the affected fields in the 64-bit version
 of struct _lowcore are 128 bytes smaller]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/lowcore.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -140,9 +140,9 @@ struct _lowcore {
 	__u8	pad_0x02e8[0x0300-0x02e8];	/* 0x02e8 */
 
 	/* Interrupt response block */
-	__u8	irb[64];			/* 0x0300 */
+	__u8	irb[96];			/* 0x0300 */
 
-	__u8	pad_0x0340[0x0e00-0x0340];	/* 0x0340 */
+	__u8	pad_0x0360[0x0e00-0x0360];	/* 0x0360 */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
@@ -274,12 +274,13 @@ struct _lowcore {
 	__u64	cmf_hpp;			/* 0x0378 */
 
 	/* Interrupt response block. */
-	__u8	irb[64];			/* 0x0380 */
+	__u8	irb[96];			/* 0x0380 */
+	__u8	pad_0x03e0[0x0400-0x03e0];	/* 0x03e0 */
 
 	/* Per cpu primary space access list */
-	__u32	paste[16];			/* 0x03c0 */
+	__u32	paste[16];			/* 0x0400 */
 
-	__u8	pad_0x0400[0x0e00-0x0400];	/* 0x0400 */
+	__u8	pad_0x0440[0x0e00-0x0440];	/* 0x0440 */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information

