Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaBJPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:37:32 -0500
Received: from hofr.at ([212.69.189.236]:43831 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJPh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:37:29 -0500
Date: Mon, 10 Feb 2014 16:37:28 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: [PATCH RT 1/5] allow preemption in add_timer_randomness
Message-ID: <20140210153728.GB20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


allow preemption in add_timer_randomness

This patch replaced the preempt_disable by migrate_disable in 
add_timer_randomness.

Does this really need even migration protection at all ? 
if one would even drop migration protection - what would happen ?

        /* if over the trickle threshold, use only 1 in 4096 samples */
        if (input_pool.entropy_count > trickle_thresh &&
            ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff)) {
                return;
        }

trickle_thresh and input_pool.entropy_count are global, so the only thing
that would happen if this got migrated would be that the 1/4096 could be
a bit less precise locally (the probability of being migrted here is not 
very high this is a window of a few instructions at best) 

If we got migrated away - so what ? that only would mean that it would be
checking the trickle_count on the "wrong" cpu - in sum the cpus would though
still not contribute more bits, the one countdown wouuld speed up only as
much as some other countdown slowed down.

In any case, even for precise 1/4096 when over threshhold we would not need
more than a migration protection.

patch is against 3.12.10-rt15

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/char/random.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ddcbcad..ede5346 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -238,6 +238,7 @@
 #include <linux/utsname.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/major.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
@@ -670,15 +671,15 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	} sample;
 	long delta, delta2, delta3;
 
-	preempt_disable();
+	migrate_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
 	if (input_pool.entropy_count > trickle_thresh &&
 	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff)) {
-		preempt_enable();
+		migrate_enable();
 		return;
 	}
 
-	preempt_enable();
+	migrate_enable();
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-- 
1.7.2.5

