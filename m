Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaFOGAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:00:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64120 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaFOGAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:00:49 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 15 Jun 2014 02:05:23 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 5/6] s390,perf: Use common PMU interrupt disabled code
Message-ID: <alpine.DEB.2.10.1406150204290.16738@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index ea75d01..d3194de 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -411,12 +411,6 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
 	case PERF_TYPE_RAW:
-		/* The CPU measurement counter facility does not have overflow
-		 * interrupts to do sampling.  Sampling must be provided by
-		 * external means, for example, by timers.
-		 */
-		if (is_sampling_event(event))
-			return -ENOENT;
 		err = __hw_perf_event_init(event);
 		break;
 	default:
@@ -681,6 +675,12 @@ static int __init cpumf_pmu_init(void)
 		goto out;
 	}
 
+	/* The CPU measurement counter facility does not have overflow
+	 * interrupts to do sampling.  Sampling must be provided by
+	 * external means, for example, by timers.
+	 */
+	cpumf_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	cpumf_pmu.attr_groups = cpumf_cf_event_group();
 	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
 	if (rc) {
