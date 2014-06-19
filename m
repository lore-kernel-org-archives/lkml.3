Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaFSMia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:38:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaFSMiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:38:25 -0400
Date: Thu, 19 Jun 2014 05:37:28 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-6e316f9c19a088586fd9ae058f9ea35b271571f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, realmz6@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, realmz6@gmail.com, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1406150200360.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150200360.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] blackfin, perf:
  Use common PMU interrupt disabled code
Git-Commit-ID: 6e316f9c19a088586fd9ae058f9ea35b271571f3
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

Commit-ID:  6e316f9c19a088586fd9ae058f9ea35b271571f3
Gitweb:     http://git.kernel.org/tip/6e316f9c19a088586fd9ae058f9ea35b271571f3
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:01:58 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:43:45 +0200

blackfin, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150200360.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/blackfin/kernel/perf_event.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

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
