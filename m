Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaJCFaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:30:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaJCF3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:29:01 -0400
Date: Thu, 2 Oct 2014 22:28:33 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-4f971248bc6ad2bb2a89a25a072ebfec5757d298@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1411424826-15629-1-git-send-email-andi@firstfloor.org>
References: <1411424826-15629-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Fix minor race in box set up
Git-Commit-ID: 4f971248bc6ad2bb2a89a25a072ebfec5757d298
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f971248bc6ad2bb2a89a25a072ebfec5757d298
Gitweb:     http://git.kernel.org/tip/4f971248bc6ad2bb2a89a25a072ebfec5757d298
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 22 Sep 2014 15:27:06 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 06:02:49 +0200

perf/x86/intel/uncore: Fix minor race in box set up

I was looking for the trinity oops cause in the uncore driver.
(so far didn't found it)

However I found this tiny race: when a box is set up two threads on the
same CPU, they may be setting up the box in parallel (e.g. with kernel
preemption). This could lead to the reference count being increasing
too much. Always recheck there is no existing cpu reference inside the lock.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1411424826-15629-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 42d00e5..9762dbd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -42,6 +42,9 @@ struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu
 		return box;
 
 	raw_spin_lock(&uncore_box_lock);
+	/* Recheck in lock to handle races. */
+	if (*per_cpu_ptr(pmu->box, cpu))
+		goto out;
 	list_for_each_entry(box, &pmu->box_list, list) {
 		if (box->phys_id == topology_physical_package_id(cpu)) {
 			atomic_inc(&box->refcnt);
@@ -49,6 +52,7 @@ struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu
 			break;
 		}
 	}
+out:
 	raw_spin_unlock(&uncore_box_lock);
 
 	return *per_cpu_ptr(pmu->box, cpu);
