Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbbA0MRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372AbbA0MRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Foad <jay.foad@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 031/126] mm: Don't count the stack guard page towards RLIMIT_STACK
Date: Tue, 27 Jan 2015 12:15:36 +0000
Message-Id: <1422361031-19364-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4813ecec5a94..9f7b97613ca4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2060,14 +2060,17 @@ static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, uns
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
2.1.4

