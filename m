Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbbANHwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:52:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbbANHg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jay Foad <jay.foad@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 77/77] mm: Dont count the stack guard page towards RLIMIT_STACK
Date: Tue, 13 Jan 2015 23:23:57 -0800
Message-Id: <20150114072228.613515286@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2058,14 +2058,17 @@ static int acct_stack_growth(struct vm_a
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


