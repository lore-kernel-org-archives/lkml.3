Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaEPVIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:08:20 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:56571 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbaEPVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:08:17 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 16 May 2014 17:12:12 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/3] perf: disable sampled events if no PMU interrupt
In-Reply-To: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add common code to generate ENOTSUPP at event creation time if an 
architecture attempts to create a sampled event and PERF_PMU_NO_INTERRUPT
is set.

This adds a new pmu->capabilities flag.  
Initially we only support PERF_PMU_NO_INTERRUPT (to indicate a PMU
has no support for generating hardware interrupts) but there are 
other capabilities that can be added later.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3356abc..2164763 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -251,9 +251,20 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * various common per-pmu feature flags
+	 */
+	int capabilities;
+
 };
 
 /**
+ * struct pmu->capabilites flags
+ */
+#define PERF_PMU_NO_INTERRUPT		1
+
+/**
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..f5d8554 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7072,6 +7072,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	if (is_sampling_event(event)) {
+		if (event->pmu->capabilities & PERF_PMU_NO_INTERRUPT) {
+			err = -ENOTSUPP;
+			goto err_alloc;
+		}
+	}
+
 	account_event(event);
 
 	/*
