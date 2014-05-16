Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaEPMxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49565 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hugh Dickins" <hughd@google.com>,
        "Dave Jones" <davej@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.859581880@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/34] mm: make fixup_user_fault() check the vma
 access rights too
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1852,12 +1852,17 @@ int fixup_user_fault(struct task_struct
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

