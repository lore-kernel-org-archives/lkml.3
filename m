Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaAOWJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:09:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaAOV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 090/166] sched: numa: skip inaccessible VMAs
Date: Wed, 15 Jan 2014 13:51:44 -0800
Message-Id: <1389822780-4729-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 3c67f474558748b604e247d92b55dfe89654c81d upstream.

Inaccessible VMA should not be trapping NUMA hint faults. Skip them.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6c8930e..843ab0b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -935,6 +935,13 @@ void task_numa_work(struct callback_head *work)
 		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
 			continue;
 
+		/*
+		 * Skip inaccessible VMAs to avoid any confusion between
+		 * PROT_NONE and NUMA hinting ptes
+		 */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
+			continue;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
1.8.3.2

