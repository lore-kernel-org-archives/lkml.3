Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaFEOje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:39:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEOjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:32 -0400
Date: Thu, 5 Jun 2014 07:38:21 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-53b25335dd60981ad608da7890420898a34469a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Disable sampled events if no PMU interrupt
Git-Commit-ID: 53b25335dd60981ad608da7890420898a34469a6
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

Commit-ID:  53b25335dd60981ad608da7890420898a34469a6
Gitweb:     http://git.kernel.org/tip/53b25335dd60981ad608da7890420898a34469a6
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 16 May 2014 17:12:12 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:29:55 +0200

perf: Disable sampled events if no PMU interrupt

Add common code to generate -ENOTSUPP at event creation time if an
architecture attempts to create a sampled event and
PERF_PMU_NO_INTERRUPT is set.

This adds a new pmu->capabilities flag.  Initially we only support
PERF_PMU_NO_INTERRUPT (to indicate a PMU has no support for generating
hardware interrupts) but there are other capabilities that can be
added later.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Will Deacon <will.deacon@arm.com>
[peterz: rename to PERF_PMU_CAP_* and moved the pmu::capabilities word into a hole]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h | 10 ++++++++++
 kernel/events/core.c       |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index af6dcf1..267c8f3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -167,6 +167,11 @@ struct perf_event;
 #define PERF_EVENT_TXN 0x1
 
 /**
+ * pmu::capabilities flags
+ */
+#define PERF_PMU_CAP_NO_INTERRUPT		0x01
+
+/**
  * struct pmu - generic performance monitoring unit
  */
 struct pmu {
@@ -178,6 +183,11 @@ struct pmu {
 	const char			*name;
 	int				type;
 
+	/*
+	 * various common per-pmu feature flags
+	 */
+	int				capabilities;
+
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a62d142..e9ef0c6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7120,6 +7120,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	if (is_sampling_event(event)) {
+		if (event->pmu->capabilities & PERF_PMU_CAP_NO_INTERRUPT) {
+			err = -ENOTSUPP;
+			goto err_alloc;
+		}
+	}
+
 	account_event(event);
 
 	/*
