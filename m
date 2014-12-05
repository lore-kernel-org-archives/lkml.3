Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaLEXAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:00:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaLEW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Paire <eric.paire@st.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        gong.chen@linux.intel.com, John Sullivan <jsrhbz@kanargh.force9.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 68/73] bitops: Fix shift overflow in GENMASK macros
Date: Fri,  5 Dec 2014 14:45:14 -0800
Message-Id: <20141205224435.971829083@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index be5fd38bd5a0..5d858e02997f 100644
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


