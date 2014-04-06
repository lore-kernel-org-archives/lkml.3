Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaDFPeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:34:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:33518 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaDFPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:34:03 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH -mm 2/3] lockdep: mark rwsem_acquire_read as recursive
Date: Sun, 6 Apr 2014 19:33:51 +0400
Message-ID: <8c6473e959a4557d8622a6d7ff24888cb3f7512d.1396779337.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1396779337.git.vdavydov@parallels.com>
References: <cover.1396779337.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rw_semaphore implementation allows recursing calls to down_read, but
lockdep thinks that it doesn't. As a result, it will complain
false-positively, e.g. if we do not observe some predefined locking
order when taking an rw semaphore for reading and a mutex.

This patch makes lockdep think rw semaphore is read-recursive, just like
rw spin lock.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/lockdep.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f920d7..4b95fe85375e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -500,7 +500,7 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
-#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
+#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
 #define rwsem_release(l, n, i)			lock_release(l, n, i)
 
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
-- 
1.7.10.4

