Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3JIR2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:28:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab3JIR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:28:52 -0400
Date: Wed, 9 Oct 2013 10:28:12 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-9ff1d9ff3c2c8ab3feaeb2e8056a07ca293f7bde@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-27-git-send-email-mgorman@suse.de>
References: <1381141781-10992-27-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Check current->
 mm before allocating NUMA faults
Git-Commit-ID: 9ff1d9ff3c2c8ab3feaeb2e8056a07ca293f7bde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:28:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ff1d9ff3c2c8ab3feaeb2e8056a07ca293f7bde
Gitweb:     http://git.kernel.org/tip/9ff1d9ff3c2c8ab3feaeb2e8056a07ca293f7bde
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:31 +0200

sched/numa: Check current->mm before allocating NUMA faults

task_numa_placement checks current->mm but after buffers for faults
have already been uselessly allocated. Move the check earlier.

[peterz@infradead.org: Identified the problem]

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-27-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 89eeb89..3383079 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -930,8 +930,6 @@ static void task_numa_placement(struct task_struct *p)
 	int seq, nid, max_nid = -1;
 	unsigned long max_faults = 0;
 
-	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
-		return;
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
 		return;
@@ -998,6 +996,10 @@ void task_numa_fault(int last_nid, int node, int pages, bool migrated)
 	if (!numabalancing_enabled)
 		return;
 
+	/* for example, ksmd faulting in a user's mm */
+	if (!p->mm)
+		return;
+
 	/* For now, do not attempt to detect private/shared accesses */
 	priv = 1;
 
