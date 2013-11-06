Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3KFPYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:24:11 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44145 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3KFPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:24:07 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 2/2] x86: add prefetching to do_csum
Date: Wed,  6 Nov 2013 10:23:19 -0500
Message-Id: <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_csum was identified via perf recently as a hot spot when doing
receive on ip over infiniband workloads.  After alot of testing and
ideas, we found the best optimization available to us currently is to
prefetch the entire data buffer prior to doing the checksum

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: sebastien.dugue@bull.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/lib/csum-partial_64.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index 9845371..9f2d3ee 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -29,8 +29,15 @@ static inline unsigned short from32to16(unsigned a)
  * Things tried and found to not make it faster:
  * Manual Prefetching
  * Unrolling to an 128 bytes inner loop.
- * Using interleaving with more registers to break the carry chains.
  */
+
+static inline void prefetch_lines(void *addr, size_t len)
+{
+	void *end = addr + len;
+	for (; addr < end; addr += cache_line_size())
+		asm("prefetch 0(%[buf])\n\t" : : [buf] "r" (addr));
+}
+
 static unsigned do_csum(const unsigned char *buff, unsigned len)
 {
 	unsigned odd, count;
@@ -67,7 +74,9 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
 			/* main loop using 64byte blocks */
 			zero = 0;
 			count64 = count >> 3;
-			while (count64) { 
+
+			prefetch_lines((void *)buff, len);
+			while (count64) {
 				asm("addq 0*8(%[src]),%[res]\n\t"
 				    "adcq 1*8(%[src]),%[res]\n\t"
 				    "adcq 2*8(%[src]),%[res]\n\t"
-- 
1.8.3.1

