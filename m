Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaJIVGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joseph Qi <joseph.qi@huawei.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/163] ocfs2/dlm: do not get resource spinlock if lockres is new
Date: Thu,  9 Oct 2014 14:02:49 -0700
Message-Id: <1412888588-26755-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@huawei.com>

commit 5760a97c7143c208fa3a8f8cad0ed7dd672ebd28 upstream.

There is a deadlock case which reported by Guozhonghua:
  https://oss.oracle.com/pipermail/ocfs2-devel/2014-September/010079.html

This case is caused by &res->spinlock and &dlm->master_lock
misordering in different threads.

It was introduced by commit 8d400b81cc83 ("ocfs2/dlm: Clean up refmap
helpers").  Since lockres is new, it doesn't not require the
&res->spinlock.  So remove it.

Fixes: 8d400b81cc83 ("ocfs2/dlm: Clean up refmap helpers")
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Reported-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..1be3398 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -650,12 +650,9 @@ void dlm_lockres_clear_refmap_bit(struct dlm_ctxt *dlm,
 	clear_bit(bit, res->refmap);
 }
 
-
-void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+static void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
-	assert_spin_locked(&res->spinlock);
-
 	res->inflight_locks++;
 
 	mlog(0, "%s: res %.*s, inflight++: now %u, %ps()\n", dlm->name,
@@ -663,6 +660,13 @@ void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 	     __builtin_return_address(0));
 }
 
+void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	__dlm_lockres_grab_inflight_ref(dlm, res);
+}
+
 void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
@@ -852,10 +856,8 @@ lookup:
 	/* finally add the lockres to its hash bucket */
 	__dlm_insert_lockres(dlm, res);
 
-	/* Grab inflight ref to pin the resource */
-	spin_lock(&res->spinlock);
-	dlm_lockres_grab_inflight_ref(dlm, res);
-	spin_unlock(&res->spinlock);
+	/* since this lockres is new it doesn't not require the spinlock */
+	__dlm_lockres_grab_inflight_ref(dlm, res);
 
 	/* get an extra ref on the mle in case this is a BLOCK
 	 * if so, the creator of the BLOCK may try to put the last
-- 
1.9.1

