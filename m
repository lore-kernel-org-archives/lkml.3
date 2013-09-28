Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3I1I3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:29:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3I1I3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:29:13 -0400
Date: Sat, 28 Sep 2013 01:28:30 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-75f93fed50c2abadbab6ef546b265f51ca975b27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        ying.huang@intel.com, yuanhan.liu@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        ying.huang@intel.com, yuanhan.liu@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <20130927153003.GF15690@laptop.programming.kicks-ass.net>
References: <20130927153003.GF15690@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Revert need_resched()
  to look at TIF_NEED_RESCHED
Git-Commit-ID: 75f93fed50c2abadbab6ef546b265f51ca975b27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 28 Sep 2013 01:28:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75f93fed50c2abadbab6ef546b265f51ca975b27
Gitweb:     http://git.kernel.org/tip/75f93fed50c2abadbab6ef546b265f51ca975b27
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 27 Sep 2013 17:30:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 28 Sep 2013 10:04:47 +0200

sched: Revert need_resched() to look at TIF_NEED_RESCHED

Yuanhan reported a serious throughput regression in his pigz
benchmark. Using the ftrace patch I found that several idle
paths need more TLC before we can switch the generic
need_resched() over to preempt_need_resched.

The preemption paths benefit most from preempt_need_resched and
do indeed use it; all other need_resched() users don't really
care that much so reverting need_resched() back to
tif_need_resched() is the simple and safe solution.

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: lkp@linux.intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130927153003.GF15690@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/preempt.h | 8 --------
 include/asm-generic/preempt.h  | 8 --------
 include/linux/sched.h          | 5 +++++
 3 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 1de41690..8729723 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -80,14 +80,6 @@ static __always_inline bool __preempt_count_dec_and_test(void)
 }
 
 /*
- * Returns true when we need to resched -- even if we can not.
- */
-static __always_inline bool need_resched(void)
-{
-	return unlikely(test_preempt_need_resched());
-}
-
-/*
  * Returns true when we need to resched and can (barring IRQ state).
  */
 static __always_inline bool should_resched(void)
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 5dc14ed..ddf2b42 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -85,14 +85,6 @@ static __always_inline bool __preempt_count_dec_and_test(void)
 }
 
 /*
- * Returns true when we need to resched -- even if we can not.
- */
-static __always_inline bool need_resched(void)
-{
-	return unlikely(test_preempt_need_resched());
-}
-
-/*
  * Returns true when we need to resched and can (barring IRQ state).
  */
 static __always_inline bool should_resched(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b09798b..2ac5285 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2577,6 +2577,11 @@ static inline bool __must_check current_clr_polling_and_test(void)
 }
 #endif
 
+static __always_inline bool need_resched(void)
+{
+	return unlikely(tif_need_resched());
+}
+
 /*
  * Thread group CPU time accounting.
  */
