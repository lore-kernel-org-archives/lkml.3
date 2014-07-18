Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbaGRKiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761154AbaGRKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/8] GFS2: Fix race in glock lru glock disposal
Date: Fri, 18 Jul 2014 11:37:39 +0100
Message-Id: <1405679865-15728-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not leave items on the LRU list with GLF_LOCK set, since
they can be removed if the glock is brought back into use, which
may then potentially result in a hang, waiting for GLF_LOCK to
clear.

It doesn't happen very often, since it requires a glock that has
not been used for a long time to be brought back into use at the
same moment that the shrinker is part way through disposing of
glocks.

The fix is to set GLF_LOCK at a later time, when we already know
that the other locks can be obtained. Also, we now only release
the lru_lock in case a resched is needed, rather than on every
iteration.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 278fae5..c1e5b12 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1406,12 +1406,16 @@ __acquires(&lru_lock)
 		gl = list_entry(list->next, struct gfs2_glock, gl_lru);
 		list_del_init(&gl->gl_lru);
 		if (!spin_trylock(&gl->gl_spin)) {
+add_back_to_lru:
 			list_add(&gl->gl_lru, &lru_list);
 			atomic_inc(&lru_count);
 			continue;
 		}
+		if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
+			spin_unlock(&gl->gl_spin);
+			goto add_back_to_lru;
+		}
 		clear_bit(GLF_LRU, &gl->gl_flags);
-		spin_unlock(&lru_lock);
 		gl->gl_lockref.count++;
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
@@ -1419,7 +1423,7 @@ __acquires(&lru_lock)
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 			gl->gl_lockref.count--;
 		spin_unlock(&gl->gl_spin);
-		spin_lock(&lru_lock);
+		cond_resched_lock(&lru_lock);
 	}
 }
 
@@ -1444,7 +1448,7 @@ static long gfs2_scan_glock_lru(int nr)
 		gl = list_entry(lru_list.next, struct gfs2_glock, gl_lru);
 
 		/* Test for being demotable */
-		if (!test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
+		if (!test_bit(GLF_LOCK, &gl->gl_flags)) {
 			list_move(&gl->gl_lru, &dispose);
 			atomic_dec(&lru_count);
 			freed++;
-- 
1.8.3.1

