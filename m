Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaKPJuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:50:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaKPJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:46 -0500
Date: Sun, 16 Nov 2014 01:49:59 -0800
From: tip-bot for Maxime COQUELIN <tipbot@zytor.com>
Message-ID: <tip-00b4d9a14125f1e51874def2b9de6092e007412d@git.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.paire@st.com, peterz@infradead.org, torvalds@linux-foundation.org,
        mingo@kernel.org, linux@rasmusvillemoes.dk, tytso@mit.edu,
        jsrhbz@kanargh.force9.co.uk, maxime.coquelin@st.com,
        tglx@linutronix.de
Reply-To: peterz@infradead.org, eric.paire@st.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, maxime.coquelin@st.com, tglx@linutronix.de,
        jsrhbz@kanargh.force9.co.uk, mingo@kernel.org,
        torvalds@linux-foundation.org, tytso@mit.edu, linux@rasmusvillemoes.dk
In-Reply-To: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com>
References: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] bitops: Fix shift overflow in GENMASK macros
Git-Commit-ID: 00b4d9a14125f1e51874def2b9de6092e007412d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00b4d9a14125f1e51874def2b9de6092e007412d
Gitweb:     http://git.kernel.org/tip/00b4d9a14125f1e51874def2b9de6092e007412d
Author:     Maxime COQUELIN <maxime.coquelin@st.com>
AuthorDate: Thu, 6 Nov 2014 10:54:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 09:55:39 +0100

bitops: Fix shift overflow in GENMASK macros

On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
instead of the expected ~0UL.

This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).

This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
1 << 64 for GENMASK_ULL.

Reported-by: Eric Paire <eric.paire@st.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # v3.13+
Cc: linux@rasmusvillemoes.dk
Cc: gong.chen@linux.intel.com
Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Fixes: 10ef6b0dffe4 ("bitops: Introduce a more generic BITMASK macro")
Link: http://lkml.kernel.org/r/1415267659-10563-1-git-send-email-maxime.coquelin@st.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/bitops.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index be5fd38..5d858e0 100644
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
