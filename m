Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3EHOu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:50:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:52872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab3EHOuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:50:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,635,1363158000"; 
   d="scan'208";a="333772199"
Subject: [PATCH] perf: only print PMU state when also WARN()'ing
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 08 May 2013 07:50:54 -0700
Message-Id: <20130508145054.17E5D012@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

First of all, I'm triggering this warning pretty reliably on a
large system.  I'm able to hang my system alsmost immediately
running 'perf top' with 160 online cpus.

If I have fewer CPUs online (about 70), the system will spit out
several of these warnings before hanging.  This patch obviously
doesn't fix the source of these, but it does add some sanity to
the warning spew.  One example warning:

	https://www.sr71.net/~dave/intel/perf-warn-20130508.1.txt

--

intel_pmu_handle_irq() has a warning in it if it does too many
loops inside.  It is a WARN_ONCE(), but the
perf_event_print_debug() call beneath it is unconditional. For
the first warning, you get a nice backtrace and message, but
subsequent ones just dump the PMU state with no leading messages.
I doubt this is what was intended.

This patch will only print the PMU state when paired with the
WARN_ON() text.  It effectively open-codes WARN_ONCE()'s
one-time-only logic.

My suspicion is that the code really just wants to make sure we
do not sit in the loop and spit out a warning for every loop
iteration after the 100th.  From what I've seen, this is very
unlikely to happen since we also clear the PMU state.

After this patch, instead of seeing the PMU state dumped each
time, you will just see:

	[57494.894540] perf_event_intel: clearing PMU state on CPU#129
	[57579.539668] perf_event_intel: clearing PMU state on CPU#10
	[57587.137762] perf_event_intel: clearing PMU state on CPU#134
	[57623.039912] perf_event_intel: clearing PMU state on CPU#114
	[57644.559943] perf_event_intel: clearing PMU state on CPU#118
	...

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/kernel/cpu/perf_event_intel.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel.c~debug-perf-hangs arch/x86/kernel/cpu/perf_event_intel.c
--- linux.git/arch/x86/kernel/cpu/perf_event_intel.c~debug-perf-hangs	2013-05-08 07:18:47.766917821 -0700
+++ linux.git-davehans/arch/x86/kernel/cpu/perf_event_intel.c	2013-05-08 07:18:47.770917997 -0700
@@ -1188,8 +1188,12 @@ static int intel_pmu_handle_irq(struct p
 again:
 	intel_pmu_ack_status(status);
 	if (++loops > 100) {
-		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
-		perf_event_print_debug();
+		static bool warned = false;
+		if (!warned) {
+			WARN(1, "perfevents: irq loop stuck!\n");
+			perf_event_print_debug();
+			warned = true;
+		}
 		intel_pmu_reset();
 		goto done;
 	}
_
