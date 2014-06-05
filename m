Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaFEFKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:10:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaFEEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 038/214] mm: make fixup_user_fault() check the vma access rights too
Date: Wed,  4 Jun 2014 21:16:41 -0700
Message-Id: <20140605041644.886594517@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1872,12 +1872,17 @@ int fixup_user_fault(struct task_struct
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


