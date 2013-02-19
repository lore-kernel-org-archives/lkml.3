Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab3BSS4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:56:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab3BSSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:55:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 77/81] mm: don't overwrite mm->def_flags in do_mlockall()
Date: Tue, 19 Feb 2013 15:49:40 -0300
Message-Id: <1361299784-8830-78-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/mlock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index ef726e8..3283272 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -524,11 +524,11 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
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
 
-- 
1.7.9.5

