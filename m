Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3JJPqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:46:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3JJPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 097/104] powerpc: Fix parameter clobber in csum_partial_copy_generic()
Date: Thu, 10 Oct 2013 08:42:25 -0700
Message-Id: <1381419752-29733-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/lib/checksum_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
index 167f725..609665a 100644
--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -269,8 +269,8 @@ _GLOBAL(csum_partial_copy_generic)
 	rldicl. r6,r3,64-1,64-2		/* r6 = (r3 & 0x3) >> 1 */
 	beq	.Lcopy_aligned
 
-	li	r7,4
-	sub	r6,r7,r6
+	li	r9,4
+	sub	r6,r9,r6
 	mtctr	r6
 
 1:
-- 
1.8.1.2

