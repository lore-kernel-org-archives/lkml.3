Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbbA2JJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:09:01 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44939 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757992AbbA2JIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:53 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jay Foad <jay.foad@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/176] mm: Don't count the stack guard page towards RLIMIT_STACK
Date: Wed, 28 Jan 2015 15:28:06 +0100
Message-Id: <3e89bd360a7c6be943ee771481edc6dfef22f68d.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 690eac53daff34169a4d74fc7bfbd388c4896abb upstream.

Commit fee7e49d4514 ("mm: propagate error from stack expansion even for
guard page") made sure that we return the error properly for stack
growth conditions.  It also theorized that counting the guard page
towards the stack limit might break something, but also said "Let's see
if anybody notices".

Somebody did notice.  Apparently android-x86 sets the stack limit very
close to the limit indeed, and including the guard page in the rlimit
check causes the android 'zygote' process problems.

So this adds the (fairly trivial) code to make the stack rlimit check be
against the actual real stack size, rather than the size of the vma that
includes the guard page.

Reported-and-tested-by: Chih-Wei Huang <cwhuang@android-x86.org>
Cc: Jay Foad <jay.foad@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/mmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 15e07d5a75cb..441602d7259a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2049,14 +2049,17 @@ static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, uns
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
-	unsigned long new_start;
+	unsigned long new_start, actual_size;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
 		return -ENOMEM;
 
 	/* Stack limit test */
-	if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur))
+	actual_size = size;
+	if (size && (vma->vm_flags & (VM_GROWSUP | VM_GROWSDOWN)))
+		actual_size -= PAGE_SIZE;
+	if (actual_size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur))
 		return -ENOMEM;
 
 	/* mlock limit tests */
-- 
2.2.2

