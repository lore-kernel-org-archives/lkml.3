Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbaJ1DxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:53:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991AbaJ1Dw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junxiao Bi <junxiao.bi@oracle.com>, Dave Chinner <david@fromorbit.com>,
        "joyce.xue" <xuejiufei@huawei.com>, Ming Lei <ming.lei@canonical.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 34/43] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
Date: Tue, 28 Oct 2014 11:36:32 +0800
Message-Id: <20141028033524.862803434@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 934f3072c17cc8886f4c043b47eeeb1b12f8de33 upstream.

commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O
during memory allocation") introduces PF_MEMALLOC_NOIO flag to avoid doing
I/O inside memory allocation, __GFP_IO is cleared when this flag is set,
but __GFP_FS implies __GFP_IO, it should also be cleared.  Or it may still
run into I/O, like in superblock shrinker.  And this will make the kernel
run into the deadlock case described in that commit.

See Dave Chinner's comment about io in superblock shrinker:

Filesystem shrinkers do indeed perform IO from the superblock shrinker and
have for years.  Even clean inodes can require IO before they can be freed
- e.g.  on an orphan list, need truncation of post-eof blocks, need to
wait for ordered operations to complete before it can be freed, etc.

IOWs, Ext4, btrfs and XFS all can issue and/or block on arbitrary amounts
of IO in the superblock shrinker context.  XFS, in particular, has been
doing transactions and IO from the VFS inode cache shrinker since it was
first introduced....

Fix this by clearing __GFP_FS in memalloc_noio_flags(), this function has
masked all the gfp_mask that will be passed into fs for the processes
setting PF_MEMALLOC_NOIO in the direct reclaim path.

v1 thread at: https://lkml.org/lkml/2014/9/3/32

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1670,11 +1670,13 @@ extern void thread_group_cputime_adjuste
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
-/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
+/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags
+ * __GFP_FS is also cleared as it implies __GFP_IO.
+ */
 static inline gfp_t memalloc_noio_flags(gfp_t flags)
 {
 	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
-		flags &= ~__GFP_IO;
+		flags &= ~(__GFP_IO | __GFP_FS);
 	return flags;
 }
 


