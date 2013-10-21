Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3JUJKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:10:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39679 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994Ab3JUIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Anton Blanchard" <anton@samba.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.668359650@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 097/149] powerpc: Fix parameter clobber in
 csum_partial_copy_generic()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/lib/checksum_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

