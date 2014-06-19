Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaFSSff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:35:35 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:54908 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaFSSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:35:34 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 19 Jun 2014 14:40:09 -0400 (EDT)
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, cody@linux.vnet.ibm.com,
        peterz@infradead.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        vincent.weaver@maine.edu, tglx@linutronix.de, fengguang.wu@intel.com
Subject: Re: [tip:perf/core] powerpc, perf:  Use common PMU interrupt disabled
 code
In-Reply-To: <tip-703daddffe550121e607c8294176ad2b12661147@git.kernel.org>
Message-ID: <alpine.DEB.2.10.1406191435440.27913@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150203210.16738@vincent-weaver-1.umelst.maine.edu> <tip-703daddffe550121e607c8294176ad2b12661147@git.kernel.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Brown-paper bag time, the patch didn't compile due to missing parenthesis.
I really need to get a new powerpc machine to test on, haven't had one 
since both my g3 and g4 laptops died.

Problem was caught by the kbuild test robot.

The below patch is a corrected version of the original, I could
probably provide an incremental one if that's better.

Vince

---

[PATCH 4/6] powerpc,perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index e0766b8..3de7920 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -387,8 +387,7 @@ static int h_24x7_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest)
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -513,6 +512,9 @@ static int hv_24x7_init(void)
 	if (!hv_page_cache)
 		return -ENOMEM;
 
+	/* sampling not supported */
+	h_24x7_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_24x7_pmu, h_24x7_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index c9d399a..6d9c8e4 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -210,8 +210,7 @@ static int h_gpci_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest)
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -284,6 +283,9 @@ static int hv_gpci_init(void)
 		return -ENODEV;
 	}
 
+	/* sampling not supported */
+	h_gpci_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_gpci_pmu, h_gpci_pmu.name, -1);
 	if (r)
 		return r;
