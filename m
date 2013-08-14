Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3HNAHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:07:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:1248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3HNAHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="362258052"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 8/8] sched: Inline the need_resched test into the caller for _cond_resched
Date: Tue, 13 Aug 2013 17:07:16 -0700
Message-Id: <1376438836-13339-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
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

