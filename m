Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBJNim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:38:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaBJNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:04 -0500
Date: Mon, 10 Feb 2014 05:30:28 -0800
From: tip-bot for Paul Walmsley <tipbot@zytor.com>
Message-ID: <tip-c32fa99f0b4252633aa464e28d1cb925bd2a79df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, arnd@arndb.de,
        akpm@linux-foundation.org, tglx@linutronix.de, pwalmsley@nvidia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, arnd@arndb.de,
        akpm@linux-foundation.org, tglx@linutronix.de, pwalmsley@nvidia.com
In-Reply-To: <alpine.DEB.2.02.1312180459580.30198@tamien>
References: <alpine.DEB.2.02.1312180459580.30198@tamien>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] bitops:
  Fix signedness of compile-time hweight implementations
Git-Commit-ID: c32fa99f0b4252633aa464e28d1cb925bd2a79df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:30:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c32fa99f0b4252633aa464e28d1cb925bd2a79df
Gitweb:     http://git.kernel.org/tip/c32fa99f0b4252633aa464e28d1cb925bd2a79df
Author:     Paul Walmsley <pwalmsley@nvidia.com>
AuthorDate: Wed, 18 Dec 2013 05:02:14 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:39:26 +0100

bitops: Fix signedness of compile-time hweight implementations

Enabling '-Wsign-compare' compiler warnings on code that includes
include/linux/bitops.h can generate the following warning:

  In file included from include/linux/kernel.h:10:0,
                    from <random filename>:48:
  include/linux/bitops.h: In function 'hweight_long':
  include/linux/bitops.h:77:26: error: signed and unsigned type in conditional expression [-Werror=sign-compare]

(converted to an error with -Werror)

This is due to the use of the logical negation operator '!' in the
__const_hweight8 macro in include/asm-generic/bitops/const_hweight.h.
The use of that operator here results in a signed value.

Fix by explicitly casting the __const_hweight8 macro expansion to
'unsigned int'.  While here, clean up several checkpatch.pl warnings.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1312180459580.30198@tamien
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
