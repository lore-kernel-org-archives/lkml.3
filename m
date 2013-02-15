Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3BOW4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3BOW4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/10] mm: dont overwrite mm->def_flags in do_mlockall()
Date: Fri, 15 Feb 2013 14:56:35 -0800
Message-Id: <20130215225543.945674212@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 9977f0f164d46613288e0b5778eae500dfe06f31 upstream.

With commit 8e72033f2a48 ("thp: make MADV_HUGEPAGE check for
mm->def_flags") the VM_NOHUGEPAGE flag may be set on s390 in
mm->def_flags for certain processes, to prevent future thp mappings.
This would be overwritten by do_mlockall(), which sets it back to 0 with
an optional VM_LOCKED flag set.

To fix this, instead of overwriting mm->def_flags in do_mlockall(), only
the VM_LOCKED flag should be set or cleared.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mlock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -517,11 +517,11 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
-	unsigned int def_flags = 0;
 
 	if (flags & MCL_FUTURE)
-		def_flags = VM_LOCKED;
-	current->mm->def_flags = def_flags;
+		current->mm->def_flags |= VM_LOCKED;
+	else
+		current->mm->def_flags &= ~VM_LOCKED;
 	if (flags == MCL_FUTURE)
 		goto out;
 


