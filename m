Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaHDU7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:59:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaHDU7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:59:40 -0400
Date: Mon, 4 Aug 2014 16:58:53 -0400
From: Rik van Riel <riel@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, dcb314@hotmail.com,
        benh@kernel.crashing.org
Subject: mm: change confusing #ifdef use in __access_remote_vm
Message-ID: <20140804165853.696683fd@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes confusing #ifdef use in __access_remote_vm
into merely ugly #ifdef use.

Addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=81651

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 mm/memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b44f76..9613d26 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3591,11 +3591,13 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 		ret = get_user_pages(tsk, mm, addr, 1,
 				write, 1, &page, &vma);
 		if (ret <= 0) {
+#ifndef CONFIG_HAVE_IOREMAP_PROT
+			break;
+#else
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
 			 */
-#ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
 			if (!vma || vma->vm_start > addr)
 				break;
@@ -3603,9 +3605,9 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 				ret = vma->vm_ops->access(vma, addr, buf,
 							  len, write);
 			if (ret <= 0)
-#endif
 				break;
 			bytes = ret;
+#endif
 		} else {
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
