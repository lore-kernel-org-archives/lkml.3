Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaDIDuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 23:50:15 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61014 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaDIDuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 23:50:13 -0400
Message-ID: <1397015410.5212.13.camel@marge.simpson.net>
Subject: [PATCH] sched/cpupri: fix cpupri_find() for high priority tasks
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 09 Apr 2014 05:50:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Seems c92211d9b7727 introduced a buglet.

--snip--

Bail on task_pri >= MAX_RT_PRIO excludes userspace prio 98 and 99 tasks,
which map to 100 and 101 respectively.

A user reported that given two SCHED_RR tasks, one hog, one light, the light
task may be stacked on top of the hog iff prio >= 98, latency hit follows.

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: <stable@vger.kernel.org>
Fixes: c92211d9b7727 sched/cpupri: Remove the vec->lock
---
 kernel/sched/cpupri.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -70,9 +70,6 @@ int cpupri_find(struct cpupri *cp, struc
 	int idx = 0;
 	int task_pri = convert_prio(p->prio);
 
-	if (task_pri >= MAX_RT_PRIO)
-		return 0;
-
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
 		int skip = 0;


