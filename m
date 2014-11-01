Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaKAWp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60229 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "joyce.xue" <xuejiufei@huawei.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@huawei.com>,
        "Guozhonghua" <guozhonghua@h3c.com>, "Mark Fasheh" <mfasheh@suse.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.134850266@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 073/102] ocfs2/dlm: do not get resource spinlock if
 lockres is new
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/dlm/dlmmaster.c | 18 ++++++++++--------
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

