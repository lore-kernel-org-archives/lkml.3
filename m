Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbaFSRky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:40:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60448 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaFSRkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:40:52 -0400
Date: Thu, 19 Jun 2014 10:39:54 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-a10d60c08cc3bbea9195e2b36440f557373623eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1406150205300.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150205300.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] sh, perf: Use common PMU interrupt disabled code
Git-Commit-ID: a10d60c08cc3bbea9195e2b36440f557373623eb
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

Commit-ID:  a10d60c08cc3bbea9195e2b36440f557373623eb
Gitweb:     http://git.kernel.org/tip/a10d60c08cc3bbea9195e2b36440f557373623eb
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:06:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 19 Jun 2014 19:37:51 +0200

sh, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-sh@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150205300.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/kernel/perf_event.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 0233167..7cfd7f1 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -129,14 +129,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 		return -ENODEV;
 
 	/*
-	 * All of the on-chip counters are "limited", in that they have
-	 * no interrupts, and are therefore unable to do sampling without
-	 * further work and timer assistance.
-	 */
-	if (hwc->sample_period)
-		return -EINVAL;
-
-	/*
 	 * See if we need to reserve the counter.
 	 *
 	 * If no events are currently in use, then we have to take a
@@ -392,6 +384,13 @@ int register_sh_pmu(struct sh_pmu *_pmu)
 
 	pr_info("Performance Events: %s support registered\n", _pmu->name);
 
+	/*
+	 * All of the on-chip counters are "limited", in that they have
+	 * no interrupts, and are therefore unable to do sampling without
+	 * further work and timer assistance.
+	 */
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
