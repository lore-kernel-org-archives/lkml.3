Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaC1Lnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58718 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaC1Lna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 14/16] hrtimer: replace base by new_base to get resolution: __hrtimer_start_range_ns()
Date: Fri, 28 Mar 2014 17:11:33 +0530
Message-Id: <d4a6c586832d4def039882fb98751ae6327980a2.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was added long back by following commit:

	commit 06027bdd278a32a84b273e41db68a5db8ffd2bb6
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Tue Feb 14 13:53:15 2006 -0800

	    [PATCH] hrtimer: round up relative start time on low-res arches

Don't know if it was a mistake or was intentional. But probably we must use
new_base instead of base here to get resolution. Things might be working
smoothly as resolution might be same for both the bases in most of the cases.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Also commit log of above commit has this: "This will go away with the GTOD
framework". So, should we get this removed?

 kernel/hrtimer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0ae0fbf..5d77f36 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -925,12 +925,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		unsigned long delta_ns, const enum hrtimer_mode mode,
 		int wakeup)
 {
-	struct hrtimer_clock_base *base, *new_base;
+	struct hrtimer_clock_base *new_base;
 	unsigned long flags;
 	int ret;
 
 	lock_hrtimer_base(timer, &flags);
-	base = timer->base;
 
 	/* Remove an active timer from the queue: */
 	ret = remove_hrtimer(timer);
@@ -949,7 +948,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim = ktime_add_safe(tim, base->resolution);
+		tim = ktime_add_safe(tim, new_base->resolution);
 #endif
 	}
 
-- 
1.7.12.rc2.18.g61b472e

