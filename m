Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaFOFzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:55:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51106 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaFOFzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:55:45 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 15 Jun 2014 02:00:18 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 1/6] arc,perf: Use common PMU interrupt disabled code
Message-ID: <alpine.DEB.2.10.1406150159280.16738@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 63177e4..b9a5685 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -99,10 +99,6 @@ static int arc_pmu_event_init(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int ret;
 
-	/* ARC 700 PMU does not support sampling events */
-	if (is_sampling_event(event))
-		return -ENOENT;
-
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		if (event->attr.config >= PERF_COUNT_HW_MAX)
@@ -298,6 +294,9 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
 		.read		= arc_pmu_read,
 	};
 
+	/* ARC 700 PMU does not support sampling events */
+	arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	ret = perf_pmu_register(&arc_pmu->pmu, pdev->name, PERF_TYPE_RAW);
 
 	return ret;
