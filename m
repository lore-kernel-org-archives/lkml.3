Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaL2BRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:17:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.752779291@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 16/27] s390,time: revert direct ktime path for s390
 clockevent device
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 8adbf78ec4839c1dc4ff20c9a1f332a7bc99e6e6 upstream.

Git commit 4f37a68cdaf6dea833cfdded2a3e0c47c0f006da
"s390: Use direct ktime path for s390 clockevent device" makes use
of the CLOCK_EVT_FEAT_KTIME clockevent option to avoid the delta
calculation with ktime_get() in clockevents_program_event and the
get_tod_clock() in s390_next_event. This is based on the assumption
that the difference between the internal ktime and the hardware
clock is reflected in the wall_to_monotonic delta. But this is not
true, the ntp corrections are applied via changes to the tk->mult
multiplier and this is not reflected in wall_to_monotonic.

In theory this could be solved by using the raw monotonic clock
but it is simpler to switch back to the standard clock delta
calculation.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Backported to 3.2: s/get_tod_clock()/get_clock()/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/time.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -110,20 +110,10 @@ static void fixup_clock_comparator(unsig
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
 
-static int s390_next_ktime(ktime_t expires,
+static int s390_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
-	struct timespec ts;
-	u64 nsecs;
-
-	ts.tv_sec = ts.tv_nsec = 0;
-	monotonic_to_bootbased(&ts);
-	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
-	do_div(nsecs, 125);
-	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
-	/* Program the maximum value if we have an overflow (== year 2042) */
-	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
-		S390_lowcore.clock_comparator = -1ULL;
+	S390_lowcore.clock_comparator = get_clock() + delta;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
@@ -148,15 +138,14 @@ void init_cpu_timer(void)
 	cpu = smp_processor_id();
 	cd = &per_cpu(comparators, cpu);
 	cd->name		= "comparator";
-	cd->features		= CLOCK_EVT_FEAT_ONESHOT |
-				  CLOCK_EVT_FEAT_KTIME;
+	cd->features		= CLOCK_EVT_FEAT_ONESHOT;
 	cd->mult		= 16777;
 	cd->shift		= 12;
 	cd->min_delta_ns	= 1;
 	cd->max_delta_ns	= LONG_MAX;
 	cd->rating		= 400;
 	cd->cpumask		= cpumask_of(cpu);
-	cd->set_next_ktime	= s390_next_ktime;
+	cd->set_next_event	= s390_next_event;
 	cd->set_mode		= s390_set_mode;
 
 	clockevents_register_device(cd);

