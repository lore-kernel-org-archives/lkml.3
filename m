Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaDTC1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:27:49 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57905 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDTC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:45 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH 1/6] blackfin/ptrace: call find_vma with the mmap_sem held
Date: Sat, 19 Apr 2014 19:26:26 -0700
Message-Id: <1397960791-16320-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can be
modified or even removed before returning to the caller. Take the
lock (shared) in order to avoid races while iterating through the
vmacache and/or rbtree.

This patch is completely *untested*.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net
---
 arch/blackfin/kernel/ptrace.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index e1f88e0..8b8fe67 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -117,6 +117,7 @@ put_reg(struct task_struct *task, unsigned long regno, unsigned long data)
 int
 is_user_addr_valid(struct task_struct *child, unsigned long start, unsigned long len)
 {
+	bool valid;
 	struct vm_area_struct *vma;
 	struct sram_list_struct *sraml;
 
@@ -124,9 +125,12 @@ is_user_addr_valid(struct task_struct *child, unsigned long start, unsigned long
 	if (start + len < start)
 		return -EIO;
 
+	down_read(&child->mm->mmap_sem);
 	vma = find_vma(child->mm, start);
-	if (vma && start >= vma->vm_start && start + len <= vma->vm_end)
-			return 0;
+	valid = vma && start >= vma->vm_start && start + len <= vma->vm_end;
+	up_read(&child->mm->mmap_sem);
+	if (valid)
+		return 0;
 
 	for (sraml = child->mm->context.sram_list; sraml; sraml = sraml->next)
 		if (start >= (unsigned long)sraml->addr
-- 
1.8.1.4

