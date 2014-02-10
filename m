Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaBJNap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:30:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaBJNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:30:40 -0500
Date: Mon, 10 Feb 2014 05:29:40 -0800
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-90ed5b0fa5eb96e1cbb34aebf6a9ed96ee1587ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, peterz@infradead.org, dyoung@redhat.com,
        vgoyal@redhat.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, peterz@infradead.org, dyoung@redhat.com,
        vgoyal@redhat.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20140120154115.GZ25953@redhat.com>
References: <20140120154115.GZ25953@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/p4:
  Block PMIs on init to prevent a stream of unkown NMIs
Git-Commit-ID: 90ed5b0fa5eb96e1cbb34aebf6a9ed96ee1587ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:29:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90ed5b0fa5eb96e1cbb34aebf6a9ed96ee1587ec
Gitweb:     http://git.kernel.org/tip/90ed5b0fa5eb96e1cbb34aebf6a9ed96ee1587ec
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Sun, 9 Feb 2014 13:20:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:20:35 +0100

perf/x86/p4: Block PMIs on init to prevent a stream of unkown NMIs

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

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140120154115.GZ25953@redhat.com
[ Fixed a stylistic detail. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index f44c34d..5d466b7 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1339,6 +1339,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
+	int i, reg;
 
 	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
@@ -1357,5 +1358,19 @@ __init int p4_pmu_init(void)
 
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
+	for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu_config_addr(i);
+		wrmsrl_safe(reg, 0ULL);
+	}
+
 	return 0;
 }
