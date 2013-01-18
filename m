Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3ARWb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:31:26 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:32896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:31:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        johannes@sipsolutions.net, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] lockdep: make lockdep_assert_held() not have a return value
Date: Fri, 18 Jan 2013 23:31:43 +0100
Message-Id: <1358548303-21732-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

I recently made the mistake of writing:

foo = lockdep_dereference_protected(..., lockdep_assert_held(...));

which is clearly bogus. If lockdep is disabled in the
config this would cause a compile failure, if it is
enabled then it compiles and causes a puzzling warning
about dereferencing without the correct protection.

Wrap the macro in "do { ... } while (0)" to also fail
compile for this when lockdep is enabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/lockdep.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 00e4637..6d2fba2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -359,7 +359,9 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
-#define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
+#define lockdep_assert_held(l)	do {				\
+		WARN_ON(debug_locks && !lockdep_is_held(l));	\
+	} while (0)
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
-- 
1.8.0

