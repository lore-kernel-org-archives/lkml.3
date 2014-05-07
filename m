Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaEGNbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:31:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45442 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbaEGNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 21/70] mm: make fixup_user_fault() check the vma access rights too
Date: Wed,  7 May 2014 14:12:24 +0100
Message-Id: <1399468393-10140-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 1b17844b29ae042576bea588164f2f1e9590a8bc upstream.

fixup_user_fault() is used by the futex code when the direct user access
fails, and the futex code wants it to either map in the page in a usable
form or return an error.  It relied on handle_mm_fault() to map the
page, and correctly checked the error return from that, but while that
does map the page, it doesn't actually guarantee that the page will be
mapped with sufficient permissions to be then accessed.

So do the appropriate tests of the vma access rights by hand.

[ Side note: arguably handle_mm_fault() could just do that itself, but
  we have traditionally done it in the caller, because some callers -
  notably get_user_pages() - have been able to access pages even when
  they are mapped with PROT_NONE.  Maybe we should re-visit that design
  decision, but in the meantime this is the minimal patch. ]

Found by Dave Jones running his trinity tool.

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 168a090..3d64ffa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1940,12 +1940,17 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags)
 {
 	struct vm_area_struct *vma;
+	vm_flags_t vm_flags;
 	int ret;
 
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
 
+	vm_flags = (fault_flags & FAULT_FLAG_WRITE) ? VM_WRITE : VM_READ;
+	if (!(vm_flags & vma->vm_flags))
+		return -EFAULT;
+
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
-- 
1.9.1

