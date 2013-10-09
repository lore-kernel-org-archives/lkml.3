Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3JIR3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:29:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:29:10 -0400
Date: Wed, 9 Oct 2013 10:28:32 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-073b5beea735c7e1970686c94ff1f3aaac790a2a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-29-git-send-email-mgorman@suse.de>
References: <1381141781-10992-29-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Remove check that skips small VMAs
Git-Commit-ID: 073b5beea735c7e1970686c94ff1f3aaac790a2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:28:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  073b5beea735c7e1970686c94ff1f3aaac790a2a
Gitweb:     http://git.kernel.org/tip/073b5beea735c7e1970686c94ff1f3aaac790a2a
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:33 +0200

sched/numa: Remove check that skips small VMAs

task_numa_work skips small VMAs. At the time the logic was to reduce the
scanning overhead which was considerable. It is a dubious hack at best.
It would make much more sense to cache where faults have been observed
and only rescan those regions during subsequent PTE scans. Remove this
hack as motivation to do it properly in the future.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-29-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3383079..862d20d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1127,10 +1127,6 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma))
 			continue;
 
-		/* Skip small VMAs. They are not likely to be of relevance */
-		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
-			continue;
-
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
