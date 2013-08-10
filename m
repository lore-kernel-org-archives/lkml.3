Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3HJG2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:28:54 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37267 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3HJG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:28:52 -0400
From: Ning Qu <quning@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] thp: Fix deadlock situation in vma_adjust with huge page in page cache
Date: Fri, 9 Aug 2013 23:28:49 -0700
Message-Id: <93894D4C-57FA-46B5-9141-4EFADEB7009E@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Ning Qu <quning@google.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vma_adjust, the current code grabs i_mmap_mutex before calling
vma_adjust_trans_huge. This used to be fine until huge page in page
cache comes in. The problem is the underlying function
split_file_huge_page will also grab the i_mmap_mutex before splitting
the huge page in page cache. Obviously this is causing deadlock
situation.

This fix is to move the vma_adjust_trans_huge before grab the lock for
file, the same as what the function is currently doing for anonymous
memory.

Tested, everything works fine so far.

Signed-off-by: Ning Qu <quning@google.com>
---
mm/mmap.c | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 519ce78..accf1b3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -750,6 +750,8 @@ again:			remove_next = 1 + (end > next->vm_end);
		}
	}

+	vma_adjust_trans_huge(vma, start, end, adjust_next);
+
	if (file) {
		mapping = file->f_mapping;
		if (!(vma->vm_flags & VM_NONLINEAR)) {
@@ -773,8 +775,6 @@ again:			remove_next = 1 + (end > next->vm_end);
		}
	}

-	vma_adjust_trans_huge(vma, start, end, adjust_next);
-
	anon_vma = vma->anon_vma;
	if (!anon_vma && adjust_next)
		anon_vma = next->anon_vma;
-- 
1.8.3


