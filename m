Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaICFzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:55:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32018 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaICFzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:55:37 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: david@fromorbit.com, akpm@linux-foundation.org
Cc: xuejiufei@huawei.com, ming.lei@canonical.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
Date: Wed,  3 Sep 2014 13:54:54 +0800
Message-Id: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O during memory allocation")
introduces PF_MEMALLOC_NOIO flag to avoid doing I/O inside memory allocation, __GFP_IO is cleared
when this flag is set, but __GFP_FS implies __GFP_IO, it should also be cleared. Or it may still
run into I/O, like in superblock shrinker.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Ming Lei <ming.lei@canonical.com>
---
 include/linux/sched.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..2fb2c47 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1936,11 +1936,13 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
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
 
-- 
1.7.9.5

