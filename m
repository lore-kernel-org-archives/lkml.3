Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaG3Bve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:51:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaG3BuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Ingo Korb <ingo.korb@tu-dortmund.de>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Ning Qu <quning@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 35/37] mm: do not call do_fault_around for non-linear fault
Date: Tue, 29 Jul 2014 18:49:11 -0700
Message-Id: <20140730014829.452894556@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <koct9i@gmail.com>

commit c118678bc79e8241f9d3434d9324c6400d72f48a upstream.

Ingo Korb reported that "repeated mapping of the same file on tmpfs
using remap_file_pages sometimes triggers a BUG at mm/filemap.c:202 when
the process exits".

He bisected the bug to d7c1755179b8 ("mm: implement ->map_pages for
shmem/tmpfs"), although the bug was actually added by commit
8c6e50b0290c ("mm: introduce vm_ops->map_pages()").

The problem is caused by calling do_fault_around for a _non-linear_
fault.  In this case pgoff is shifted and might become negative during
calculation.

Faulting around non-linear page-fault makes no sense and breaks the
logic in do_fault_around because pgoff is shifted.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Tested-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3515,7 +3515,7 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages) {
+	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR)) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))


