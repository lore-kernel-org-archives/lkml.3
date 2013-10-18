Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3JRTwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3JRTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [ 11/11] mm: do not grow the stack vma just because of an overrun on preceding vma
Date: Fri, 18 Oct 2013 12:53:40 -0700
Message-Id: <20131018195049.836387681@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 09884964335e85e897876d17783c2ad33cf8a2e0 upstream.

The stack vma is designed to grow automatically (marked with VM_GROWSUP
or VM_GROWSDOWN depending on architecture) when an access is made beyond
the existing boundary.  However, particularly if you have not limited
your stack at all ("ulimit -s unlimited"), this can cause the stack to
grow even if the access was really just one past *another* segment.

And that's wrong, especially since we first grow the segment, but then
immediately later enforce the stack guard page on the last page of the
segment.  So _despite_ first growing the stack segment as a result of
the access, the kernel will then make the access cause a SIGSEGV anyway!

So do the same logic as the guard page check does, and consider an
access to within one page of the next segment to be a bad access, rather
than growing the stack to abut the next segment.

Reported-and-tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1875,9 +1875,28 @@ int expand_downwards(struct vm_area_stru
 	return error;
 }
 
+/*
+ * Note how expand_stack() refuses to expand the stack all the way to
+ * abut the next virtual mapping, *unless* that mapping itself is also
+ * a stack mapping. We want to leave room for a guard page, after all
+ * (the guard page itself is not added here, that is done by the
+ * actual page faulting logic)
+ *
+ * This matches the behavior of the guard page logic (see mm/memory.c:
+ * check_stack_guard_page()), which only allows the guard page to be
+ * removed under these circumstances.
+ */
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
+	struct vm_area_struct *next;
+
+	address &= PAGE_MASK;
+	next = vma->vm_next;
+	if (next && next->vm_start == address + PAGE_SIZE) {
+		if (!(next->vm_flags & VM_GROWSUP))
+			return -ENOMEM;
+	}
 	return expand_upwards(vma, address);
 }
 
@@ -1900,6 +1919,14 @@ find_extend_vma(struct mm_struct *mm, un
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
+	struct vm_area_struct *prev;
+
+	address &= PAGE_MASK;
+	prev = vma->vm_prev;
+	if (prev && prev->vm_end == address) {
+		if (!(prev->vm_flags & VM_GROWSDOWN))
+			return -ENOMEM;
+	}
 	return expand_downwards(vma, address);
 }
 


