Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBZPFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:05:42 -0500
Received: from relay.parallels.com ([195.214.232.42]:59722 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaBZPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:05:40 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Frederic Weisbecker <fweisbec@redhat.com>
Subject: [PATCH -mm 09/12] fork: do not charge thread_info to kmemcg
Date: Wed, 26 Feb 2014 19:05:14 +0400
Message-ID: <14c6879ed1a974c3fe87d4b4d660bc0ac32f0a1f.1393423762.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1393423762.git.vdavydov@parallels.com>
References: <cover.1393423762.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts 2ad306b17c0a ("fork: protect architectures where
THREAD_SIZE >= PAGE_SIZE against fork bombs").

The reasoning behind this is that charging thread_info is the last piece
that prevents us from reparenting kmemcg on css offline. The point is
that we can't reliably track all thread_info pages accounted to a
particular cgroup, because (a) it is freed in __put_task_struct and (b)
on exit tasks are moved to the root cgroup. That said, given a cgroup
there is no sane way to find all tasks (including zombies) that charged
thread_info to this cgroup. Of course, we could uncharge thread_info on
task exit, but that wouldn't help us against fork bombs. So revert and
forget about this.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
---
 include/linux/thread_info.h |    2 --
 kernel/fork.c               |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index fddbe2023a5d..1807bb194816 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -61,8 +61,6 @@ extern long do_no_restart_syscall(struct restart_block *parm);
 # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
-#define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
-
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
diff --git a/kernel/fork.c b/kernel/fork.c
index b41022f5d307..2431645d4c91 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -148,7 +148,7 @@ void __weak arch_release_thread_info(struct thread_info *ti)
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
+	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
 					     THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
@@ -156,7 +156,7 @@ static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	free_memcg_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
-- 
1.7.10.4

