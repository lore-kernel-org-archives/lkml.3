Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaBEUGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:55013 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBEUGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 100/213] mm: fix vma_resv_map() NULL pointer
Date: Wed, 5 Feb 2014 15:00:55 -0500
Message-ID: <1391630568-49251-101-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4523e1458566a0e8ecfaff90f380dd23acc44d27 upstream.

hugetlb_reserve_pages() can be used for either normal file-backed
hugetlbfs mappings, or MAP_HUGETLB.  In the MAP_HUGETLB, semi-anonymous
mode, there is not a VMA around.  The new call to resv_map_put() assumed
that there was, and resulted in a NULL pointer dereference:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
  IP: vma_resv_map+0x9/0x30
  PGD 141453067 PUD 1421e1067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP
  ...
  Pid: 14006, comm: trinity-child6 Not tainted 3.4.0+ #36
  RIP: vma_resv_map+0x9/0x30
  ...
  Process trinity-child6 (pid: 14006, threadinfo ffff8801414e0000, task ffff8801414f26b0)
  Call Trace:
    resv_map_put+0xe/0x40
    hugetlb_reserve_pages+0xa6/0x1d0
    hugetlb_file_setup+0x102/0x2c0
    newseg+0x115/0x360
    ipcget+0x1ce/0x310
    sys_shmget+0x5a/0x60
    system_call_fastpath+0x16/0x1b

This was reported by Dave Jones, but was reproducible with the
libhugetlbfs test cases, so shame on me for not running them in the
first place.

With this, the oops is gone, and the output of libhugetlbfs's
run_tests.py is identical to plain 3.4 again.

[ Marked for stable, since this was introduced by commit c50ac050811d
  ("hugetlb: fix resv_map leak in error path") which was also marked for
  stable ]

Reported-by: Dave Jones <davej@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/hugetlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f7b80540ba95..c80dd852f3a0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2789,7 +2789,8 @@ int hugetlb_reserve_pages(struct inode *inode,
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
 out_err:
-	resv_map_put(vma);
+	if (vma)
+		resv_map_put(vma);
 	return ret;
 }
 
-- 
1.8.5.2

