Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaCRNHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:12 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54431 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCRNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:08 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 3/5] staging/lustre/libcfs: remove waitq_timedwait
Date: Tue, 18 Mar 2014 21:05:54 +0800
Message-Id: <1395147956-2056-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1395147956-2056-3-git-send-email-bergwolf@gmail.com>
References: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-3-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    5 ++---
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    3 +--
 drivers/staging/lustre/lustre/include/lustre_lib.h |    4 +---
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    7 -------
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    3 +--
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |    3 +--
 8 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index b9251a5..41fad1a 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -51,7 +51,6 @@ void cfs_pause(cfs_duration_t ticks);
 typedef  void (cfs_timer_func_t)(ulong_ptr_t);
 void schedule_timeout_and_set_state(long, int64_t);
 
-int64_t waitq_timedwait(wait_queue_t *, long, int64_t);
 void add_wait_queue_exclusive_head(wait_queue_head_t *, wait_queue_t *);
 
 void cfs_init_timer(struct timer_list *t);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 07b1da2..6173e74 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -3208,7 +3208,7 @@ kiblnd_connd (void *arg)
 		add_wait_queue(&kiblnd_data.kib_connd_waitq, &wait);
 		spin_unlock_irqrestore(&kiblnd_data.kib_connd_lock, flags);
 
-		waitq_timedwait(&wait, TASK_INTERRUPTIBLE, timeout);
+		schedule_timeout(timeout);
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kiblnd_data.kib_connd_waitq, &wait);
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index fdf9101..6150d17 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -2229,7 +2229,7 @@ ksocknal_connd (void *arg)
 		spin_unlock_bh(connd_lock);
 
 		nloops = 0;
-		waitq_timedwait(&wait, TASK_INTERRUPTIBLE, timeout);
+		schedule_timeout(timeout);
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&ksocknal_data.ksnd_connd_waitq, &wait);
@@ -2639,8 +2639,7 @@ ksocknal_reaper (void *arg)
 		if (!ksocknal_data.ksnd_shuttingdown &&
 		    list_empty (&ksocknal_data.ksnd_deathrow_conns) &&
 		    list_empty (&ksocknal_data.ksnd_zombie_conns))
-			waitq_timedwait (&wait, TASK_INTERRUPTIBLE,
-					     timeout);
+			schedule_timeout(timeout);
 
 		set_current_state (TASK_RUNNING);
 		remove_wait_queue (&ksocknal_data.ksnd_reaper_waitq, &wait);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index 65af201..7ce07f6 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -347,8 +347,7 @@ lnet_eq_wait_locked(int *timeout_ms)
 		struct timeval tv;
 
 		now = cfs_time_current();
-		waitq_timedwait(&wl, TASK_INTERRUPTIBLE,
-				    cfs_time_seconds(tms) / 1000);
+		schedule_timeout(cfs_time_seconds(tms) / 1000);
 		cfs_duration_usec(cfs_time_sub(cfs_time_current(), now), &tv);
 		tms -= (int)(tv.tv_sec * 1000 + tv.tv_usec / 1000);
 		if (tms < 0) /* no more wait but may have new event */
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 0695436..0368ca6 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -564,9 +564,7 @@ do {									   \
 					     min_t(cfs_duration_t,	     \
 						 info->lwi_interval,__timeout):\
 					     __timeout;			\
-			cfs_duration_t remaining = waitq_timedwait(&__wait,\
-						   __wstate,		   \
-						   interval);		  \
+			cfs_duration_t remaining = schedule_timeout(interval);\
 			__timeout = cfs_time_sub(__timeout,		    \
 					    cfs_time_sub(interval, remaining));\
 			if (__timeout == 0) {				  \
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index 86475c2..8aa00e5 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -70,13 +70,6 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
-int64_t
-waitq_timedwait(wait_queue_t *link, long state, int64_t timeout)
-{
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(waitq_timedwait);
-
 void
 schedule_timeout_and_set_state(long state, int64_t timeout)
 {
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 32ed879..c8599ee 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -1079,8 +1079,7 @@ end_loop:
 		init_waitqueue_entry(&__wait, current);
 		add_wait_queue(&tctl->tctl_waitq, &__wait);
 		set_current_state(TASK_INTERRUPTIBLE);
-		waitq_timedwait(&__wait, TASK_INTERRUPTIBLE,
-				    cfs_time_seconds(1));
+		schedule_timeout(cfs_time_seconds(1));
 		remove_wait_queue(&tctl->tctl_waitq, &__wait);
 	}
 	complete(&tctl->tctl_stop);
diff --git a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
index 8a3b62d0..8085e32 100644
--- a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
+++ b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
@@ -223,8 +223,7 @@ find_again:
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock(&cache->uc_lock);
 
-		left = waitq_timedwait(&wait, TASK_INTERRUPTIBLE,
-					   expiry);
+		left = schedule_timeout(expiry);
 
 		spin_lock(&cache->uc_lock);
 		remove_wait_queue(&entry->ue_waitq, &wait);
-- 
1.7.7.6

