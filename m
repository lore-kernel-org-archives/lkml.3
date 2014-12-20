Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaLTNzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 08:55:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaLTNzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 08:55:07 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, oleg@redhat.com, dave.hansen@linux.intel.com,
        rientjes@google.com, linux-mm@kvack.org
Subject: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
Date: Sat, 20 Dec 2014 08:54:45 -0500
Message-Id: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 'pagesize' line element to /proc/<pid>/numa_maps
report file in order to help disambiguating the size of pages that are
backing memory areas mapped by a task. When the VMA backing page size
is observed different from kernel's default PAGE_SIZE, the new element 
is printed out to complement report output. This is specially useful to
help differentiating between HUGE and GIGANTIC page VMAs.

This patch is based on Dave Hansen's proposal and reviewer's follow ups 
taken from this dicussion: https://lkml.org/lkml/2011/9/21/454

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
 fs/proc/task_mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 246eae8..9f2e2c8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1479,6 +1479,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
+	unsigned long page_size;
 	char buffer[64];
 	int nid;
 
@@ -1533,6 +1534,10 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	if (!md->pages)
 		goto out;
 
+	page_size = vma_kernel_pagesize(vma);
+	if (page_size != PAGE_SIZE)
+		seq_printf(m, " pagesize=%lu", page_size);
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
-- 
1.9.3

