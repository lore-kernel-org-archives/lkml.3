Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3JIRaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:30:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIRaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:30:18 -0400
Date: Wed, 9 Oct 2013 10:29:33 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-06ea5e035b4e66cc77790457a89fc7e368060c4b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-35-git-send-email-mgorman@suse.de>
References: <1381141781-10992-35-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Increment numa_migrate_seq when task runs in correct location
Git-Commit-ID: 06ea5e035b4e66cc77790457a89fc7e368060c4b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:29:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06ea5e035b4e66cc77790457a89fc7e368060c4b
Gitweb:     http://git.kernel.org/tip/06ea5e035b4e66cc77790457a89fc7e368060c4b
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:41 +0200

sched/numa: Increment numa_migrate_seq when task runs in correct location

When a task is already running on its preferred node, increment
numa_migrate_seq to indicate that the task is settled if migration is
temporarily disabled, and memory should migrate towards it.

Signed-off-by: Rik van Riel <riel@redhat.com>
[ Only increment migrate_seq if migration temporarily disabled. ]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-35-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f84ac3f..de9b4d8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1016,8 +1016,16 @@ static void numa_migrate_preferred(struct task_struct *p)
 {
 	/* Success if task is already running on preferred CPU */
 	p->numa_migrate_retry = 0;
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid) {
+		/*
+		 * If migration is temporarily disabled due to a task migration
+		 * then re-enable it now as the task is running on its
+		 * preferred node and memory should migrate locally
+		 */
+		if (!p->numa_migrate_seq)
+			p->numa_migrate_seq++;
 		return;
+	}
 
 	/* This task has no NUMA fault statistics yet */
 	if (unlikely(p->numa_preferred_nid == -1))
