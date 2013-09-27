Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3I0Pa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:30:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3I0PaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:30:07 -0400
Date: Fri, 27 Sep 2013 17:30:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: [PATCH] sched: Revert need_resched() to look at TIF_NEED_RESCHED
Message-ID: <20130927153003.GF15690@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927091427.GE24743@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Revert need_resched() to look at TIF_NEED_RESCHED
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Sep 27 17:20:30 CEST 2013

Yuanhan reported a serious throughput regression in his pigz
benchmark. Using the ftrace patch I found that several idle paths
need more TLC before we can switch the generic need_resched() over to
preempt_need_resched.

The preemption paths benefit most from preempt_need_resched and do
indeed use it; all other need_resched() users don't really care that
much so reverting need_resched() back to tif_need_resched() is the
simple and safe solution.

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/preempt.h |    8 --------
 include/asm-generic/preempt.h  |    8 --------
 include/linux/sched.h          |    5 +++++
 3 files changed, 5 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -80,14 +80,6 @@ static __always_inline bool __preempt_co
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
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -85,14 +85,6 @@ static __always_inline bool __preempt_co
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
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2577,6 +2577,11 @@ static inline bool __must_check current_
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
