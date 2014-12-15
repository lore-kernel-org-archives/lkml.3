Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaLOPIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:08:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaLOO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux@rasmusvillemoes.dk, gong.chen@linux.intel.com,
        John Sullivan <jsrhbz@kanargh.force9.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 027/168] bitops: Fix shift overflow in GENMASK macros
Date: Mon, 15 Dec 2014 14:24:41 +0000
Message-Id: <1418653622-21105-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime COQUELIN <maxime.coquelin@st.com>

commit 00b4d9a14125f1e51874def2b9de6092e007412d upstream.

On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
instead of the expected ~0UL.

This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).

This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
1 << 64 for GENMASK_ULL.

Reported-by: Eric Paire <eric.paire@st.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: linux@rasmusvillemoes.dk
Cc: gong.chen@linux.intel.com
Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Fixes: 10ef6b0dffe4 ("bitops: Introduce a more generic BITMASK macro")
Link: http://lkml.kernel.org/r/1415267659-10563-1-git-send-email-maxime.coquelin@st.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/bitops.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cbc5833fb221..38b5f5c88c18 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -18,8 +18,11 @@
  * position @h. For example
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
-#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
-#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
+#define GENMASK(h, l) \
+	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
+
+#define GENMASK_ULL(h, l) \
+	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
-- 
2.1.3

