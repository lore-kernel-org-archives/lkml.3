Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaGIG40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:56:26 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:41856 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIG4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:56:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [RFC 5/7] futex: don't check for active hrtimer after adding it
Date: Wed,  9 Jul 2014 12:25:37 +0530
Message-Id: <e64bf28d15929bdafcc0970644b6d880650c1cd8.1404888801.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
only special case is when the hrtimer was in past. If it is getting enqueued to
local CPUs's clock-base, we raise a softirq and exit, else we handle that on
next interrupt on remote CPU.

At several places in the kernel, we try to make sure if hrtimer was added
properly or not by calling hrtimer_active(), like:

	hrtimer_start(timer, expires, mode);
	if (hrtimer_active(timer)) {
		/* Added successfully */
	} else {
		/* Was added in the past */
	}

As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
So, there is no point calling hrtimer_active().

This patch updates futex core to get this fixed.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/futex.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b632b5f..4847efc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2083,11 +2083,8 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 	queue_me(q, hb);
 
 	/* Arm the timer */
-	if (timeout) {
+	if (timeout)
 		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
-		if (!hrtimer_active(&timeout->timer))
-			timeout->task = NULL;
-	}
 
 	/*
 	 * If we have been removed from the hash list, then another task
-- 
2.0.0.rc2

