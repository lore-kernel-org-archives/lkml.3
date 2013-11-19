Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3KSTT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:19:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:19:25 -0500
Date: Tue, 19 Nov 2013 11:18:56 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-06db0b21712f878b808480ef31097637013bbf0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130913111447.GN31370@twins.programming.kicks-ass.net>
References: <20130913111447.GN31370@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Remove fragile swevent hlist optimization
Git-Commit-ID: 06db0b21712f878b808480ef31097637013bbf0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:19:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06db0b21712f878b808480ef31097637013bbf0f
Gitweb:     http://git.kernel.org/tip/06db0b21712f878b808480ef31097637013bbf0f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 13 Sep 2013 13:14:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 16:57:42 +0100

perf: Remove fragile swevent hlist optimization

Currently we only allocate a single cpu hashtable for per-cpu
swevents; do away with this optimization for it is fragile in the face
of things like perf_pmu_migrate_context().

The easiest thing is to make sure all CPUs are consistent wrt state.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130913111447.GN31370@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d724e77..72348dc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5680,11 +5680,6 @@ static void swevent_hlist_put(struct perf_event *event)
 {
 	int cpu;
 
-	if (event->cpu != -1) {
-		swevent_hlist_put_cpu(event, event->cpu);
-		return;
-	}
-
 	for_each_possible_cpu(cpu)
 		swevent_hlist_put_cpu(event, cpu);
 }
@@ -5718,9 +5713,6 @@ static int swevent_hlist_get(struct perf_event *event)
 	int err;
 	int cpu, failed_cpu;
 
-	if (event->cpu != -1)
-		return swevent_hlist_get_cpu(event, event->cpu);
-
 	get_online_cpus();
 	for_each_possible_cpu(cpu) {
 		err = swevent_hlist_get_cpu(event, cpu);
