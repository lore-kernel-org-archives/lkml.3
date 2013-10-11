Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3JKKoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:44:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3JKKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 086/100] powerpc: Fix parameter clobber in csum_partial_copy_generic()
Date: Fri, 11 Oct 2013 11:41:56 +0100
Message-Id: <1381488130-30235-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

commit d9813c3681a36774b254c0cdc9cce53c9e22c756 upstream.

The csum_partial_copy_generic() uses register r7 to adjust the remaining
bytes to process.  Unfortunately, r7 also holds a parameter, namely the
address of the flag to set in case of access exceptions while reading
the source buffer.  Lacking a quantum implementation of PowerPC, this
commit instead uses register r9 to do the adjusting, leaving r7's
pointer uncorrupted.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/lib/checksum_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
index 18245af..afa2eba 100644
--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -272,8 +272,8 @@ _GLOBAL(csum_partial_copy_generic)
 	rldicl. r6,r3,64-1,64-2		/* r6 = (r3 & 0x3) >> 1 */
 	beq	.Lcopy_aligned
 
-	li	r7,4
-	sub	r6,r7,r6
+	li	r9,4
+	sub	r6,r9,r6
 	mtctr	r6
 
 1:
-- 
1.8.3.2

