Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3ITJ5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:57:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ITJ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:57:44 -0400
Date: Fri, 20 Sep 2013 02:57:11 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-43nl31erfbajwpfj254f6zji@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Remove division from the intel_pmu_drain_pebs_nhm() hot path
Git-Commit-ID: eb8417aa703eff5ff43d0275f19b0a8e591d818d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:57:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb8417aa703eff5ff43d0275f19b0a8e591d818d
Gitweb:     http://git.kernel.org/tip/eb8417aa703eff5ff43d0275f19b0a8e591d818d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 16 Sep 2013 09:23:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 06:53:44 +0200

perf/x86/intel: Remove division from the intel_pmu_drain_pebs_nhm() hot path

Only do the division in case we have to print the result out in a warning.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-43nl31erfbajwpfj254f6zji@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index f364c13..655d591 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -944,7 +944,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	struct perf_event *event = NULL;
 	void *at, *top;
 	u64 status = 0;
-	int bit, n;
+	int bit;
 
 	if (!x86_pmu.pebs_active)
 		return;
@@ -954,16 +954,16 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	n = (top - at) / x86_pmu.pebs_record_size;
-	if (n <= 0)
+	if (unlikely(at > top))
 		return;
 
 	/*
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
+	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,
+		  "Unexpected number of pebs records %ld\n",
+		  (top - at) / x86_pmu.pebs_record_size);
 
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
