Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaA2Tjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaA2Tje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:39:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] x86, perf, p4: Counter corruption when using lots of perf groups
Date: Wed, 29 Jan 2014 14:37:50 -0500
Message-Id: <1391024270-19469-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a P4 box stressing perf with

./perf record -o perf.data ./perf stat -v ./perf bench all

it was noticed that a slew of unknown NMIs would pop out rather quickly.

Painfully debugging this ancient platform, led me to notice cross cpu counter
corruption.

The P4 machine is special in that it has 18 counters, half are used for cpu0
and the other half is for cpu1 (or all 18 if hyperthreading is disabled).  But
the splitting of the counters has to be actively managed by the software.

In this particular bug, one of the cpu0 specific counters was being used by
cpu1 and caused all sorts of random unknown nmis.

I am not entirely sure on the corruption path, but what happens is:

o perf schedules a group with p4_pmu_schedule_events()
o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
  but for a different cpu, so it 'swaps' the config bits and returns the
  updated 'assign' array with a _new_ index.
o perf schedules another group with p4_pmu_schedule_events()
o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
  (the same one as above) but for the _same_ cpu [BUG!!], so it updates the
  'assign' array to use the _old_ (wrong cpu) index because the _new_ index is in
  an earlier part of the 'assign' array (and hasn't been committed yet).
o perf commits the transaction using the wrong index and corrupts the other cpu

The [BUG!!] is because the 'hwc->config' is updated but not the 'hwc->idx'.  So
the check for 'p4_should_swap_ts()' is correct the first time around but
incorrect the second time around (because hwc->config was updated in between).

I think the spirit of perf was to not modify anything until all the
transactions had a chance to 'test' if they would succeed, and if so, commit
atomically.  However, P4 breaks this spirit by touching the hwc->config
element.

So my fix is to continue the un-perf like breakage, by assigning hwc->idx to -1
on swap to tell follow up group scheduling to find a new index.

Of course if the transaction fails rolling this back will be difficult, but
that is not different than how the current code works. :-)  And I wasn't sure
how much effort to cleanup the code I should do for a platform that is almost
10 years old by now.

Hence the lazy fix.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 075f18c..dda02a1 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1257,7 +1257,24 @@ again:
 			pass++;
 			goto again;
 		}
-
+		/*
+		 * Perf does test runs to see if a whole group can be assigned
+		 * together succesfully.  There can be multiple rounds of this.
+		 * Unfortunately, p4_pmu_swap_config_ts touches the hwc->config
+		 * bits, such that the next round of group assignments will
+		 * cause the above p4_should_swap_ts to pass instead of fail.
+		 * This leads to counters exclusive to thread0 being used by
+		 * thread1.
+		 *
+		 * Solve this with a cheap hack, reset the idx back to -1 to
+		 * force a new lookup (p4_next_cntr) to get the right counter
+		 * for the right thread.
+		 *
+		 * This probably doesn't comply with the general spirit of how
+		 * perf wants to work, but P4 is special. :-(
+		 */
+		if (p4_should_swap_ts(hwc->config, cpu))
+			hwc->idx = -1;
 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
 			assign[i] = cntr_idx;
-- 
1.7.1

