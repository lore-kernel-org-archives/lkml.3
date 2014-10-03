Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbaJCW0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbaJCW0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Qi <joseph.qi@huawei.com>, "joyce.xue" <xuejiufei@huawei.com>,
        Guozhonghua <guozhonghua@h3c.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 117/143] ocfs2/dlm: do not get resource spinlock if lockres is new
Date: Fri,  3 Oct 2014 14:35:12 -0700
Message-Id: <20141003213318.004687121@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/dlm/dlmmaster.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -653,12 +653,9 @@ void dlm_lockres_clear_refmap_bit(struct
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
@@ -666,6 +663,13 @@ void dlm_lockres_grab_inflight_ref(struc
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
@@ -855,10 +859,8 @@ lookup:
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


