Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaBUVOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:14:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaBUVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:50 -0500
Date: Fri, 21 Feb 2014 13:14:19 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c9b08884c9c98929ec2d8abafd78e89062d01ee7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mst@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        ehabkost@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        ehabkost@redhat.com
In-Reply-To: <20140203132903.GI8874@twins.programming.kicks-ass.net>
References: <20140203132903.GI8874@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Correctly use FEATURE_PDCM
Git-Commit-ID: c9b08884c9c98929ec2d8abafd78e89062d01ee7
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

Commit-ID:  c9b08884c9c98929ec2d8abafd78e89062d01ee7
Gitweb:     http://git.kernel.org/tip/c9b08884c9c98929ec2d8abafd78e89062d01ee7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 3 Feb 2014 14:29:03 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 22:09:01 +0100

perf/x86: Correctly use FEATURE_PDCM

The current code simply assumes Intel Arch PerfMon v2+ to have
the IA32_PERF_CAPABILITIES MSR; the SDM specifies that we should check
CPUID[1].ECX[15] (aka, FEATURE_PDCM) instead.

This was found by KVM which implements v2+ but didn't provide the
capabilities MSR. Change the code to DTRT; KVM will also implement the
MSR and return 0.

Cc: pbonzini@redhat.com
Reported-by: "Michael S. Tsirkin" <mst@redhat.com>
Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140203132903.GI8874@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 698ae77..aa333d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2308,10 +2308,7 @@ __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
 
-	/*
-	 * v2 and above have a perf capabilities MSR
-	 */
-	if (version > 1) {
+	if (boot_cpu_has(X86_FEATURE_PDCM)) {
 		u64 capabilities;
 
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
