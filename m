Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaKTHSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:18:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30665 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaKTHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:18:30 -0500
From: Yao Dongdong <yaodongdong@huawei.com>
To: <peterz@infradead.org>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <agk@redhat.com>, <snitzer@redhat.com>,
        <dm-devel@redhat.com>, <lizefan@huawei.com>
Subject: [PATCH] sched, cleanup, dm bufio: Replace dm_bufio_cond_resched with might_resched
Date: Thu, 20 Nov 2014 07:35:40 +0000
Message-ID: <1416468940-8398-1-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The judge of need_resched() before _cond_resched() in dm_bufio_cond_resched()
is no need. Because _cond_resched() itself judges should_resched() which means
need and can resched. In addition, might_resched() can do all these.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
---
 drivers/md/dm-bufio.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index afe7971..3660a24 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -186,19 +186,6 @@ static void dm_bufio_unlock(struct dm_bufio_client *c)
 	mutex_unlock(&c->lock);
 }
 
-/*
- * FIXME Move to sched.h?
- */
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-#  define dm_bufio_cond_resched()		\
-do {						\
-	if (unlikely(need_resched()))		\
-		_cond_resched();		\
-} while (0)
-#else
-#  define dm_bufio_cond_resched()                do { } while (0)
-#endif
-
 /*----------------------------------------------------------------*/
 
 /*
@@ -648,7 +635,7 @@ static void __flush_write_list(struct list_head *write_list)
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
 		submit_io(b, WRITE, b->block, write_endio);
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -687,7 +674,7 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
 			__unlink_buffer(b);
 			return b;
 		}
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 
 	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
@@ -698,7 +685,7 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
 			__unlink_buffer(b);
 			return b;
 		}
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 
 	return NULL;
@@ -830,7 +817,7 @@ static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait,
 			return;
 
 		__write_dirty_buffer(b, write_list);
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 }
 
@@ -880,7 +867,7 @@ static void __check_watermark(struct dm_bufio_client *c,
 			return;
 
 		__free_buffer_wake(b);
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 
 	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
@@ -896,7 +883,7 @@ static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
 
 	hlist_for_each_entry(b, &c->cache_hash[DM_BUFIO_HASH(block)],
 			     hash_list) {
-		dm_bufio_cond_resched();
+		might_resched();
 		if (b->block == block)
 			return b;
 	}
@@ -1090,7 +1077,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 				submit_io(b, READ, b->block, read_endio);
 			dm_bufio_release(b);
 
-			dm_bufio_cond_resched();
+			might_resched();
 
 			if (!n_blocks)
 				goto flush_plug;
@@ -1211,7 +1198,7 @@ again:
 		    !test_bit(B_WRITING, &b->state))
 			__relink_lru(b, LIST_CLEAN);
 
-		dm_bufio_cond_resched();
+		might_resched();
 
 		/*
 		 * If we dropped the lock, the list is no longer consistent,
@@ -1473,7 +1460,7 @@ static long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
 			freed += __cleanup_old_buffer(b, gfp_mask, 0);
 			if (!--nr_to_scan)
 				return freed;
-			dm_bufio_cond_resched();
+			might_resched();
 		}
 	}
 	return freed;
@@ -1704,11 +1691,11 @@ static void cleanup_old_buffers(void)
 				       struct dm_buffer, lru_list);
 			if (!__cleanup_old_buffer(b, 0, max_age * HZ))
 				break;
-			dm_bufio_cond_resched();
+			might_resched();
 		}
 
 		dm_bufio_unlock(c);
-		dm_bufio_cond_resched();
+		might_resched();
 	}
 	mutex_unlock(&dm_bufio_clients_lock);
 }
-- 
1.8.3.4

