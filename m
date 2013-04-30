Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012Ab3D3QLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:11:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39427 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995Ab3D3QLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:11:46 -0400
Message-ID: <517FED3E.1040801@parallels.com>
Date: Tue, 30 Apr 2013 20:11:42 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH 2/5] clear_refs: introduce private struct for mm_walk
References: <517FED13.8090806@parallels.com>
In-Reply-To: <517FED13.8090806@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next patch the clear-refs-type will be required in
clear_refs_pte_range funciton, so prepare the walk->private to carry this
info.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
---
 fs/proc/task_mmu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dad0809..ef6f6c6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -695,10 +695,15 @@ enum clear_refs_types {
 	CLEAR_REFS_LAST,
 };
 
+struct clear_refs_private {
+	struct vm_area_struct *vma;
+};
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = cp->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -753,13 +758,16 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
+		struct clear_refs_private cp = {
+		};
 		struct mm_walk clear_refs_walk = {
 			.pmd_entry = clear_refs_pte_range,
 			.mm = mm,
+			.private = &cp,
 		};
 		down_read(&mm->mmap_sem);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			clear_refs_walk.private = vma;
+			cp.vma = vma;
 			if (is_vm_hugetlb_page(vma))
 				continue;
 			/*
-- 
1.7.6.5
