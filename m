Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbaGOUmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbaGOUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:42:08 -0400
Date: Tue, 15 Jul 2014 13:42:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Ingo Korb <ingo.korb@tu-dortmund.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Jones <davej@redhat.com>, Ning Qu <quning@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] mm: do not call do_fault_around for non-linear fault
Message-Id: <20140715134206.5d4964569fe0c64e39873416@linux-foundation.org>
In-Reply-To: <20140715115832.18997.90349.stgit@buzz>
References: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
	<20140715115832.18997.90349.stgit@buzz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 15:58:32 +0400 Konstantin Khlebnikov <k.khlebnikov@samsung.com> wrote:

> From: Konstantin Khlebnikov <koct9i@gmail.com>
> 
> Faulting around non-linear page-fault has no sense and
> breaks logic in do_fault_around because pgoff is shifted.
> 

Please be a lot more careful with the changelogs?  This one failed to
describe the effects of the bug, failed to adequately describe the bug
itself, failed to describe the offending commits and failed to identify
which kernel versions need the patch.

Sigh.  I went back and assembled the necessary information, below. 
Please check it.



From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: do not call do_fault_around for non-linear fault

Ingo Korb reported that "repeated mapping of the same file on tmpfs using
remap_file_pages sometimes triggers a BUG at mm/filemap.c:202 when the
process exits".  He bisected the bug to d7c1755179b82d ("mm: implement
->map_pages for shmem/tmpfs"), although the bug was actually added by
8c6e50b0290c4 ("mm: introduce vm_ops->map_pages()").

Problem is caused by calling do_fault_around for _non-linear_ faiult.  In
this case pgoff is shifted and might become negative during calculation.

Faulting around non-linear page-fault has no sense and breaks logic in
do_fault_around because pgoff is shifted.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: "Ingo Korb" <ingo.korb@tu-dortmund.de>
Tested-by: "Ingo Korb" <ingo.korb@tu-dortmund.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault mm/memory.c
--- a/mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault
+++ a/mm/memory.c
@@ -2882,7 +2882,8 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
+	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
+	    fault_around_pages() > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
_

