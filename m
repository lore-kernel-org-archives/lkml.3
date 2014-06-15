Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaFOF5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:57:25 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39146 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaFOF5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:57:24 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 15 Jun 2014 02:01:58 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 2/6] blackfin,perf: Use common PMU interrupt disabled code
Message-ID: <alpine.DEB.2.10.1406150200360.16738@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/blackfin/kernel/perf_event.c b/arch/blackfin/kernel/perf_event.c
index 974e554..ea20320 100644
--- a/arch/blackfin/kernel/perf_event.c
+++ b/arch/blackfin/kernel/perf_event.c
@@ -389,14 +389,6 @@ static int bfin_pmu_event_init(struct perf_event *event)
 	if (attr->exclude_hv || attr->exclude_idle)
 		return -EPERM;
 
-	/*
-	 * All of the on-chip counters are "limited", in that they have
-	 * no interrupts, and are therefore unable to do sampling without
-	 * further work and timer assistance.
-	 */
-	if (hwc->sample_period)
-		return -EINVAL;
-
 	ret = 0;
 	switch (attr->type) {
 	case PERF_TYPE_RAW:
@@ -490,6 +482,13 @@ static int __init bfin_pmu_init(void)
 {
 	int ret;
 
+	/*
+	 * All of the on-chip counters are "limited", in that they have
+	 * no interrupts, and are therefore unable to do sampling without
+	 * further work and timer assistance.
+	 */
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	ret = perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	if (!ret)
 		perf_cpu_notifier(bfin_pmu_notifier);
