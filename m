Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaDHP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:57:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49413 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbaDHP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:57:09 -0400
Message-ID: <1396972621.16584.13.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] ia64: perfmon: fix a possible file refcnt leak
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Apr 2014 08:57:01 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

get_file() is called before error checks in pfm_smpl_buffer_alloc()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: cb0942b81249 ("make get_file() return its argument")
---
 arch/ia64/kernel/perfmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index d841c4bd6864..a7221393612e 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2297,7 +2297,7 @@ pfm_smpl_buffer_alloc(struct task_struct *task, struct file *filp, pfm_context_t
 	 * partially initialize the vma for the sampling buffer
 	 */
 	vma->vm_mm	     = mm;
-	vma->vm_file	     = get_file(filp);
+	vma->vm_file	     = filp;
 	vma->vm_flags	     = VM_READ|VM_MAYREAD|VM_DONTEXPAND|VM_DONTDUMP;
 	vma->vm_page_prot    = PAGE_READONLY; /* XXX may need to change */
 
@@ -2342,7 +2342,7 @@ pfm_smpl_buffer_alloc(struct task_struct *task, struct file *filp, pfm_context_t
 	 */
 	insert_vm_struct(mm, vma);
 
-	vm_stat_account(vma->vm_mm, vma->vm_flags, vma->vm_file,
+	vm_stat_account(vma->vm_mm, vma->vm_flags, get_file(filp),
 							vma_pages(vma));
 	up_write(&task->mm->mmap_sem);
 


