Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3JIR1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:27:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3JIR1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:27:10 -0400
Date: Wed, 9 Oct 2013 10:26:32 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-7e8d16b6cbccb2f5da579f5085479fb82ba851b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-17-git-send-email-mgorman@suse.de>
References: <1381141781-10992-17-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Initialise numa_next_scan properly
Git-Commit-ID: 7e8d16b6cbccb2f5da579f5085479fb82ba851b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:26:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e8d16b6cbccb2f5da579f5085479fb82ba851b8
Gitweb:     http://git.kernel.org/tip/7e8d16b6cbccb2f5da579f5085479fb82ba851b8
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:54 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:19 +0200

sched/numa: Initialise numa_next_scan properly

Scan delay logic and resets are currently initialised to start scanning
immediately instead of delaying properly. Initialise them properly at
fork time and catch when a new mm has been allocated.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-17-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 kernel/sched/fair.c | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f575d5b..aee7e4d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1624,8 +1624,8 @@ static void __sched_fork(struct task_struct *p)
 
 #ifdef CONFIG_NUMA_BALANCING
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
-		p->mm->numa_next_scan = jiffies;
-		p->mm->numa_next_reset = jiffies;
+		p->mm->numa_next_scan = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
+		p->mm->numa_next_reset = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
 		p->mm->numa_scan_seq = 0;
 	}
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 49b11fa..0966f0c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -900,6 +900,13 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
+	if (!mm->numa_next_reset || !mm->numa_next_scan) {
+		mm->numa_next_scan = now +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
+		mm->numa_next_reset = now +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
+	}
+
 	/*
 	 * Reset the scan period if enough time has gone by. Objective is that
 	 * scanning will be reduced if pages are properly placed. As tasks
