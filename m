Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaEHGjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:39:35 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:46919 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaEHGje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:39:34 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 02:39:34 EDT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] compiler.h: don't use temporary variable in __compiletime_assert()
Date: Thu,  8 May 2014 08:31:25 +0200
Message-Id: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Usually, BUG_ON and friends aren't even evaluated in sparse, but
recently compiletime_assert_atomic_type() was added, and that now
results in a sparse warning every time it is used.

The reason turns out to be the temporary variable, after it sparse
no longer considers the value to be a constant, and results in a
warning and an error. The error is the more annoying part of this
as it suppresses any further warnings in the same file, hiding
other problems.

Since this is all about compile time and the condition should be
side-effect free to start with, there's no downside (apart maybe
from a slight compilation time penalty?) to just duplicating it,
leaving sparse able to evaluate it at check time, getting rid of
the warning and error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compiler.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 2472740d7ab2..38c0e00ddef8 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -324,11 +324,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
-		bool __cond = !(condition);				\
 		extern void prefix ## suffix(void) __compiletime_error(msg); \
-		if (__cond)						\
+		if (!(condition))					\
 			prefix ## suffix();				\
-		__compiletime_error_fallback(__cond);			\
+		__compiletime_error_fallback(!(condition));		\
 	} while (0)
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
-- 
2.0.0.rc0

