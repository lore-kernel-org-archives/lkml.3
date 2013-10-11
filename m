Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3JKQwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:52:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56464 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3JKQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:52:17 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Date: Fri, 11 Oct 2013 12:51:38 -0400
Message-Id: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sébastien Dugué reported to me that devices implementing ipoib (which don't have
checksum offload hardware were spending a significant amount of time computing
checksums.  We found that by splitting the checksum computation into two
separate streams, each skipping successive elements of the buffer being summed,
we could parallelize the checksum operation accros multiple alus.  Since neither
chain is dependent on the result of the other, we get a speedup in execution (on
hardware that has multiple alu's available, which is almost ubiquitous on x86),
and only a negligible decrease on hardware that has only a single alu (an extra
addition is introduced).  Since addition in commutative, the result is the same,
only faster

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: sebastien.dugue@bull.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/lib/csum-partial_64.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index 9845371..2c7bc50 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -29,11 +29,12 @@ static inline unsigned short from32to16(unsigned a)
  * Things tried and found to not make it faster:
  * Manual Prefetching
  * Unrolling to an 128 bytes inner loop.
- * Using interleaving with more registers to break the carry chains.
  */
 static unsigned do_csum(const unsigned char *buff, unsigned len)
 {
 	unsigned odd, count;
+	unsigned long result1 = 0;
+	unsigned long result2 = 0;
 	unsigned long result = 0;
 
 	if (unlikely(len == 0))
@@ -68,22 +69,34 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
 			zero = 0;
 			count64 = count >> 3;
 			while (count64) { 
-				asm("addq 0*8(%[src]),%[res]\n\t"
-				    "adcq 1*8(%[src]),%[res]\n\t"
-				    "adcq 2*8(%[src]),%[res]\n\t"
-				    "adcq 3*8(%[src]),%[res]\n\t"
-				    "adcq 4*8(%[src]),%[res]\n\t"
-				    "adcq 5*8(%[src]),%[res]\n\t"
-				    "adcq 6*8(%[src]),%[res]\n\t"
-				    "adcq 7*8(%[src]),%[res]\n\t"
-				    "adcq %[zero],%[res]"
-				    : [res] "=r" (result)
+				asm("addq 0*8(%[src]),%[res1]\n\t"
+				    "adcq 2*8(%[src]),%[res1]\n\t"
+				    "adcq 4*8(%[src]),%[res1]\n\t"
+				    "adcq 6*8(%[src]),%[res1]\n\t"
+				    "adcq %[zero],%[res1]\n\t"
+
+				    "addq 1*8(%[src]),%[res2]\n\t"
+				    "adcq 3*8(%[src]),%[res2]\n\t"
+				    "adcq 5*8(%[src]),%[res2]\n\t"
+				    "adcq 7*8(%[src]),%[res2]\n\t"
+				    "adcq %[zero],%[res2]"
+				    : [res1] "=r" (result1),
+				      [res2] "=r" (result2)
 				    : [src] "r" (buff), [zero] "r" (zero),
-				    "[res]" (result));
+				      "[res1]" (result1), "[res2]" (result2));
 				buff += 64;
 				count64--;
 			}
 
+			asm("addq %[res1],%[res]\n\t"
+			    "adcq %[res2],%[res]\n\t"
+			    "adcq %[zero],%[res]"
+			    : [res] "=r" (result)
+			    : [res1] "r" (result1),
+			      [res2] "r" (result2),
+			      [zero] "r" (zero),
+			      "0" (result));
+
 			/* last up to 7 8byte blocks */
 			count %= 8; 
 			while (count) { 
-- 
1.8.3.1

