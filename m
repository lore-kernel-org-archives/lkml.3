Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaD0RMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:12:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48124 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbaD0RIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:34 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jinshan Xiong <jinshan.xiong@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 39/47] staging/lustre/clio: Solve a race in cl_lock_put
Date: Sun, 27 Apr 2014 13:07:03 -0400
Message-Id: <1398618431-29757-40-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

It's not atomic to check the last reference and state of cl_lock
in cl_lock_put(). This can cause a problem that an using lock is
freed, if the process is preempted between atomic_dec_and_test()
and (lock->cll_state == CLS_FREEING).

This problem can be solved by holding a refcount by coh_locks. In
this case, it can be sure that if the lock refcount reaches zero,
nobody else can have any chance to use it again.

Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-on: http://review.whamcloud.com/9881
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4558
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/cl_lock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index 918f433..f8040a8 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -533,6 +533,7 @@ static struct cl_lock *cl_lock_find(const struct lu_env *env,
 			spin_lock(&head->coh_lock_guard);
 			ghost = cl_lock_lookup(env, obj, io, need);
 			if (ghost == NULL) {
+				cl_lock_get_trust(lock);
 				list_add_tail(&lock->cll_linkage,
 						  &head->coh_locks);
 				spin_unlock(&head->coh_lock_guard);
@@ -791,15 +792,22 @@ static void cl_lock_delete0(const struct lu_env *env, struct cl_lock *lock)
 	LINVRNT(cl_lock_invariant(env, lock));
 
 	if (lock->cll_state < CLS_FREEING) {
+		bool in_cache;
+
 		LASSERT(lock->cll_state != CLS_INTRANSIT);
 		cl_lock_state_set(env, lock, CLS_FREEING);
 
 		head = cl_object_header(lock->cll_descr.cld_obj);
 
 		spin_lock(&head->coh_lock_guard);
-		list_del_init(&lock->cll_linkage);
+		in_cache = !list_empty(&lock->cll_linkage);
+		if (in_cache)
+			list_del_init(&lock->cll_linkage);
 		spin_unlock(&head->coh_lock_guard);
 
+		if (in_cache) /* coh_locks cache holds a refcount. */
+			cl_lock_put(env, lock);
+
 		/*
 		 * From now on, no new references to this lock can be acquired
 		 * by cl_lock_lookup().
-- 
1.8.5.3

