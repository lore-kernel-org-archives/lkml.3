Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaATPls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:41:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaATPlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:41:45 -0500
Date: Mon, 20 Jan 2014 10:41:15 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] x86, perf_p4:  block PMIs on init to prevent a stream of
 unkown NMIs
Message-ID: <20140120154115.GZ25953@redhat.com>
References: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
 <20140120083859.GD30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120083859.GD30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:38:59AM +0100, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 10:41:41AM -0500, Don Zickus wrote:
> > I could have removed the ENABLE bit too, but was worried it would impact
> > BIOS vendors secret ability to monitor cpu states.  I figured the ability to
> > generate a PMI or not is not interesting to them and chose that route instead.
> 
> 
> You worry about the wrong things, just clear the things.

Like this?

Cheers,
Don

----------------------8<-------------
From: Don Zickus <dzickus@redhat.com>
Date: Fri, 17 Jan 2014 10:23:53 -0500
Subject: [PATCH v2] x86, perf_p4:  block PMIs on init to prevent a stream of unkown NMIs

A bunch of unknown NMIs have popped up on a Pentium4 recently when booting
into a kdump kernel.  This was exposed because the watchdog timer went
from 60 seconds down to 10 seconds (increasing the ability to reproduce
this problem).

What is happening is on boot up of the second kernel (the kdump one),
the previous nmi_watchdogs were enabled on thread 0 and thread 1.  The
second kernel only initializes one cpu but the perf counter on thread 1
still counts.

Normally in a kdump scenario, the other cpus are blocking in an NMI loop,
but more importantly their local apics have the performance counters disabled
(iow LVTPC is masked).  So any counters that fire are masked and never get
through to the second kernel.

However, on a P4 the local apic is shared by both threads and thread1's PMI
(despite being configured to only interrupt thread1) will generate an NMI on
thread0.  Because thread0 knows nothing about this NMI, it is seen as an
unknown NMI.

This would be fine because it is a kdump kernel, strange things happen
what is the big deal about a single unknown NMI.

Unfortunately, the P4 comes with another quirk: clearing the overflow bit
to prevent a stream of NMIs.  This is the problem.

The kdump kernel can not execute because of the endless NMIs that happen.

To solve this, I instrumented the p4 perf init code, to walk all the counters
and zero them out (just like a normal reset would).

Now when the counters go off, they do not generate anything and no unknown
NMIs are seen.

I tested this on a P4 we have in our lab.  After two or three crashes, I could
normally reproduce the problem.  Now after 10 crashes, everything continues
to boot correctly.

Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

V2 - zero out the register per Peter's suggestion.

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3486e66..075f18c 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1322,6 +1322,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
+	int i, reg;
 
 	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
@@ -1340,5 +1341,19 @@ __init int p4_pmu_init(void)
 
 	x86_pmu = p4_pmu;
 
+	/*
+	 * Even though the counters are configured to interrupt a particular
+	 * logical processor when an overflow happens, testing has shown that
+	 * on kdump kernels (which uses a single cpu), thread1's counter
+	 * continues to run and will report an NMI on thread0.  Due to the
+	 * overflow bug, this leads to a stream of unknown NMIs.
+	 *
+	 * Solve this by zero'ing out the registers to mimic a reset.
+	 */
+        for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu_config_addr(i);
+		wrmsrl_safe(reg, 0ULL);
+        }
+
 	return 0;
 }
-- 
1.7.1

