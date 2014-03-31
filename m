Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaCaJNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:13:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33579 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaCaJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:13:29 -0400
Date: Mon, 31 Mar 2014 11:13:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/types change for v3.15
Message-ID: <20140331091325.GA3814@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-types-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-types-for-linus

   # HEAD: c32fa99f0b4252633aa464e28d1cb925bd2a79df bitops: Fix signedness of compile-time hweight implementations

This lone commit makes sure that __const_hweight8() is unsigned, which 
addresses a build warning if code is built with -Wsign-compare.

I hope the type cast in this cleanup is fine - another option would be 
to eliminate the double unary negation and use a construct with more 
obvious integer type characteristics, along the lines of:

	((w) & (1ULL << 1) ? 1U : 0U)

or so.

 Thanks,

	Ingo

------------------>
Paul Walmsley (1):
      bitops: Fix signedness of compile-time hweight implementations


 include/asm-generic/bitops/const_hweight.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..0a7e066 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -5,14 +5,15 @@
  * Compile time versions of __arch_hweightN()
  */
 #define __const_hweight8(w)		\
-      (	(!!((w) & (1ULL << 0))) +	\
-	(!!((w) & (1ULL << 1))) +	\
-	(!!((w) & (1ULL << 2))) +	\
-	(!!((w) & (1ULL << 3))) +	\
-	(!!((w) & (1ULL << 4))) +	\
-	(!!((w) & (1ULL << 5))) +	\
-	(!!((w) & (1ULL << 6))) +	\
-	(!!((w) & (1ULL << 7)))	)
+	((unsigned int)			\
+	 ((!!((w) & (1ULL << 0))) +	\
+	  (!!((w) & (1ULL << 1))) +	\
+	  (!!((w) & (1ULL << 2))) +	\
+	  (!!((w) & (1ULL << 3))) +	\
+	  (!!((w) & (1ULL << 4))) +	\
+	  (!!((w) & (1ULL << 5))) +	\
+	  (!!((w) & (1ULL << 6))) +	\
+	  (!!((w) & (1ULL << 7)))))
 
 #define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
 #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
