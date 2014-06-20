Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966831AbaFTTco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:32:44 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:51977 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966614AbaFTTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:32 -0400
Message-Id: <20140620193128.096959328@linux.com>
Date: Fri, 20 Jun 2014 14:31:42 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 27/31] tile: Use this_cpu_ptr() for hardware counters
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=tile_fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/tile/kernel/perf_event.c
===================================================================
--- linux.orig/arch/tile/kernel/perf_event.c	2014-04-08 09:21:18.820542381 -0500
+++ linux/arch/tile/kernel/perf_event.c	2014-04-14 13:41:29.866074474 -0500
@@ -590,7 +590,7 @@
  */
 static void tile_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -616,7 +616,7 @@
  */
 static void tile_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = event->hw.idx;
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
@@ -650,7 +650,7 @@
  */
 static int tile_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc;
 	unsigned long mask;
 	int b, max_cnt;
@@ -706,7 +706,7 @@
  */
 static void tile_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	/*
@@ -880,14 +880,14 @@
 int tile_pmu_handle_irq(struct pt_regs *regs, int fault)
 {
 	struct perf_sample_data data;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	u64 val;
 	unsigned long status;
 	int bit;
 
-	__get_cpu_var(perf_irqs)++;
+	__this_cpu_inc(perf_irqs);
 
 	if (!atomic_read(&tile_active_events))
 		return 0;

