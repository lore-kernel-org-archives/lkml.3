Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab3FSSwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:52:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab3FSSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:00 -0400
Date: Wed, 19 Jun 2013 11:39:07 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-ae0def05ed856343181bf1eca4fab3e09056df6d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dave.hansen@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dave.hansen@linux.intel.com
In-Reply-To: <20130530174559.0DB049F4@viggo.jf.intel.com>
References: <20130530174559.0DB049F4@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Only print PMU state when also WARN()'
 ing
Git-Commit-ID: ae0def05ed856343181bf1eca4fab3e09056df6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:39:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae0def05ed856343181bf1eca4fab3e09056df6d
Gitweb:     http://git.kernel.org/tip/ae0def05ed856343181bf1eca4fab3e09056df6d
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 30 May 2013 10:45:59 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:50:47 +0200

perf/x86: Only print PMU state when also WARN()'ing

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130530174559.0DB049F4@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a9e2207..1321cf8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1188,8 +1188,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
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
