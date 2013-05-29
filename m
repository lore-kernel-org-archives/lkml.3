Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365Ab3E2W2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:13728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935302Ab3E2W2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="321585432"
Subject: [v3][PATCH 1/4] perf/x86: only print PMU state when also WARN()'ing
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 May 2013 15:27:58 -0700
References: <20130529222756.25535229@viggo.jf.intel.com>
In-Reply-To: <20130529222756.25535229@viggo.jf.intel.com>
Message-Id: <20130529222758.60A34C05@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

intel_pmu_handle_irq() has a warning in it if it does too many
loops.  It is a WARN_ONCE(), but the perf_event_print_debug()
call beneath it is unconditional. For the first warning, you get
a nice backtrace and message, but subsequent ones just dump the
PMU state with no leading messages.  I doubt this is what was
intended.

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
--- linux.git/arch/x86/kernel/cpu/perf_event_intel.c~debug-perf-hangs	2013-05-29 15:10:18.909649305 -0700
+++ linux.git-davehans/arch/x86/kernel/cpu/perf_event_intel.c	2013-05-29 15:10:18.912649437 -0700
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
