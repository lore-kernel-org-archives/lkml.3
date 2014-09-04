Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaIDSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:36:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49138 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaIDSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:36:44 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linuxfoundation.org
Cc: oleg@redhat.com, riel@redhat.com, kirill.shutemov@linux.intel.com,
        luto@amacapital.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: mmap: use pr_emerg when printing BUG related information
Date: Thu,  4 Sep 2014 14:36:22 -0400
Message-Id: <1409855782-15089-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we actually see the output of validate_mm() and browse_rb()
before triggering a BUG(). pr_info isn't shown by default so the reason
for the BUG() isn't obvious.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9351482..4f49894 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -368,20 +368,20 @@ static int browse_rb(struct rb_root *root)
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev) {
-			pr_info("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			pr_emerg("vm_start %lx prev %lx\n", vma->vm_start, prev);
 			bug = 1;
 		}
 		if (vma->vm_start < pend) {
-			pr_info("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			pr_emerg("vm_start %lx pend %lx\n", vma->vm_start, pend);
 			bug = 1;
 		}
 		if (vma->vm_start > vma->vm_end) {
-			pr_info("vm_end %lx < vm_start %lx\n",
+			pr_emerg("vm_end %lx < vm_start %lx\n",
 				vma->vm_end, vma->vm_start);
 			bug = 1;
 		}
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
-			pr_info("free gap %lx, correct %lx\n",
+			pr_emerg("free gap %lx, correct %lx\n",
 			       vma->rb_subtree_gap,
 			       vma_compute_subtree_gap(vma));
 			bug = 1;
@@ -395,7 +395,7 @@ static int browse_rb(struct rb_root *root)
 	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
 	if (i != j) {
-		pr_info("backwards %d, forwards %d\n", j, i);
+		pr_emerg("backwards %d, forwards %d\n", j, i);
 		bug = 1;
 	}
 	return bug ? -1 : i;
@@ -430,17 +430,17 @@ static void validate_mm(struct mm_struct *mm)
 		i++;
 	}
 	if (i != mm->map_count) {
-		pr_info("map_count %d vm_next %d\n", mm->map_count, i);
+		pr_emerg("map_count %d vm_next %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	if (highest_address != mm->highest_vm_end) {
-		pr_info("mm->highest_vm_end %lx, found %lx\n",
+		pr_emerg("mm->highest_vm_end %lx, found %lx\n",
 		       mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count) {
-		pr_info("map_count %d rb %d\n", mm->map_count, i);
+		pr_emerg("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	BUG_ON(bug);
-- 
1.7.10.4

