Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaIDUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:31:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbaIDUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:31:00 -0400
Date: Thu, 4 Sep 2014 13:30:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: oleg@redhat.com, riel@redhat.com, kirill.shutemov@linux.intel.com,
        luto@amacapital.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mmap: use pr_emerg when printing BUG related
 information
Message-Id: <20140904133058.37ca7aa2e46a607eed94df3b@linux-foundation.org>
In-Reply-To: <1409855782-15089-1-git-send-email-sasha.levin@oracle.com>
References: <1409855782-15089-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Sep 2014 14:36:22 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Make sure we actually see the output of validate_mm() and browse_rb()
> before triggering a BUG(). pr_info isn't shown by default so the reason
> for the BUG() isn't obvious.
> 

yup, I'll scoot that into 3.17.


That code's actually pretty cruddy.  How does this look?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mmap.c: clean up CONFIG_DEBUG_VM_RB checks

- be consistent in printing the test which failed

- one message was actually wrong (a<b != b>a)

- don't print second bogus warning if browse_rb() failed

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-clean-up-config_debug_vm_rb-checks mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-clean-up-config_debug_vm_rb-checks
+++ a/mm/mmap.c
@@ -369,16 +369,18 @@ static int browse_rb(struct rb_root *roo
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev) {
-			pr_emerg("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			pr_emerg("vm_start %lx < prev %lx\n",
+				  vma->vm_start, prev);
 			bug = 1;
 		}
 		if (vma->vm_start < pend) {
-			pr_emerg("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			pr_emerg("vm_start %lx < pend %lx\n",
+				  vma->vm_start, pend);
 			bug = 1;
 		}
 		if (vma->vm_start > vma->vm_end) {
-			pr_emerg("vm_end %lx < vm_start %lx\n",
-				vma->vm_end, vma->vm_start);
+			pr_emerg("vm_start %lx > vm_end %lx\n",
+				  vma->vm_start, vma->vm_end);
 			bug = 1;
 		}
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
@@ -420,8 +422,10 @@ static void validate_mm(struct mm_struct
 	int i = 0;
 	unsigned long highest_address = 0;
 	struct vm_area_struct *vma = mm->mmap;
+
 	while (vma) {
 		struct anon_vma_chain *avc;
+
 		vma_lock_anon_vma(vma);
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
@@ -436,12 +440,13 @@ static void validate_mm(struct mm_struct
 	}
 	if (highest_address != mm->highest_vm_end) {
 		pr_emerg("mm->highest_vm_end %lx, found %lx\n",
-		       mm->highest_vm_end, highest_address);
+			  mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count) {
-		pr_emerg("map_count %d rb %d\n", mm->map_count, i);
+		if (i != -1)
+			pr_emerg("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	BUG_ON(bug);
_

