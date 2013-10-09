Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3JIRaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3JIRa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:30:27 -0400
Date: Wed, 9 Oct 2013 10:29:43 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-4591ce4f2d22dc9de7a6719161ce409b5fd1caac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-36-git-send-email-mgorman@suse.de>
References: <1381141781-10992-36-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Do not trap hinting faults for shared libraries
Git-Commit-ID: 4591ce4f2d22dc9de7a6719161ce409b5fd1caac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:29:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4591ce4f2d22dc9de7a6719161ce409b5fd1caac
Gitweb:     http://git.kernel.org/tip/4591ce4f2d22dc9de7a6719161ce409b5fd1caac
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:42 +0200

sched/numa: Do not trap hinting faults for shared libraries

NUMA hinting faults will not migrate a shared executable page mapped by
multiple processes on the grounds that the data is probably in the CPU
cache already and the page may just bounce between tasks running on multipl
nodes. Even if the migration is avoided, there is still the overhead of
trapping the fault, updating the statistics, making scheduler placement
decisions based on the information etc. If we are never going to migrate
the page, it is overhead for no gain and worse a process may be placed on
a sub-optimal node for shared executable pages. This patch avoids trapping
faults for shared libraries entirely.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-36-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de9b4d8..fbc0c84 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1231,6 +1231,16 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
 			continue;
 
+		/*
+		 * Shared library pages mapped by multiple processes are not
+		 * migrated as it is expected they are cache replicated. Avoid
+		 * hinting faults in read-only file-backed mappings or the vdso
+		 * as migrating the pages will be of marginal benefit.
+		 */
+		if (!vma->vm_mm ||
+		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)))
+			continue;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
