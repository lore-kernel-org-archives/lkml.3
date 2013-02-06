Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3BFPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:49:56 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:41530 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3BFPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:49:55 -0500
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vivek Goyal <vgoyal@redhat.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH] mm: don't overwrite mm->def_flags in do_mlockall()
Date: Wed,  6 Feb 2013 16:49:34 +0100
Message-Id: <1360165774-55458-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.12.4
x-cbid: 13020615-8372-0000-0000-00000518DB6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 8e72033 "thp: make MADV_HUGEPAGE check for mm->def_flags"
the VM_NOHUGEPAGE flag may be set on s390 in mm->def_flags for certain
processes, to prevent future thp mappings. This would be overwritten
by do_mlockall(), which sets it back to 0 with an optional VM_LOCKED
flag set.

To fix this, instead of overwriting mm->def_flags in do_mlockall(),
only the VM_LOCKED flag should be set or cleared.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 mm/mlock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index f0b9ce5..c9bd528 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -517,11 +517,11 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
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
1.7.12.4

