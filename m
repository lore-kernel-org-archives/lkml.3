Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JDRdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3JDRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:32:20 -0400
Date: Fri, 4 Oct 2013 10:31:47 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
Git-Commit-ID: d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:31:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
Gitweb:     http://git.kernel.org/tip/d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 3 Oct 2013 16:00:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 09:58:55 +0200

perf/x86: Clean up cap_user_time* setting

Currently the cap_user_time_zero capability has different tests than
cap_user_time; even though they expose the exact same data.

Switch from CONSTANT && NONSTOP to sched_clock_stable to also deal
with multi cabinet machines and drop the tsc_disabled() check.. non of
this will work sanely without tsc anyway.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 897783b..9d84491 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1888,10 +1888,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		return;
-
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+	if (!sched_clock_stable)
 		return;
 
 	userpg->cap_user_time = 1;
@@ -1899,10 +1896,8 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
-	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_user_time_zero = 1;
-		userpg->time_zero = this_cpu_read(cyc2ns_offset);
-	}
+	userpg->cap_user_time_zero = 1;
+	userpg->time_zero = this_cpu_read(cyc2ns_offset);
 }
 
 /*
