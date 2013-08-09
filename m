Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031551Ab3HIXHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:07:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:20518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031474Ab3HIXEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="360454438"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/13] sched: Inline the need_resched test into the caller for _cond_resched
Date: Fri,  9 Aug 2013 16:04:18 -0700
Message-Id: <1376089460-5459-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

_cond_resched is very common in kernel calls, e.g. it's used in every user
access. Usually it does at least two explicit calls just to decide to do
nothing: _cond_resched and should_resched(). Inline a need_resched()
into the caller to avoid these calls in the common case of no reschedule
being needed.

Previously this would have been very expensive in terms of binary size
because there were a lot of inlined cond_resched()s in copy_*_user()
and put/get_user().  But with the newest changes to x86 uaccess.h
these not inlined anymore, so we can use a slightly bigger, but much
faster fast path version.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index bb7a08a..9e0efa9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2435,7 +2435,7 @@ extern int __cond_resched_softirq(void);
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
-# define might_resched() _cond_resched()
+# define might_resched() (need_resched() ? _cond_resched() : 0)
 #else
 # define might_resched() do { } while (0)
 #endif
-- 
1.8.3.1

