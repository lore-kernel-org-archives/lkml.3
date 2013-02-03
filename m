Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3BCB0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:26:16 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58745 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3BCBW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:57 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 51/62] dlm: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:52 -0800
Message-Id: <1359854463-2538-52-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.  Error return values from
recover_idr_add() mix -1 and -errno.  The conversion doesn't change
that but it looks iffy.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 fs/dlm/lock.c    | 18 ++++++------------
 fs/dlm/recover.c | 27 +++++++++++++--------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index a579f30..353942f 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1182,7 +1182,7 @@ static void detach_lkb(struct dlm_lkb *lkb)
 static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 {
 	struct dlm_lkb *lkb;
-	int rv, id;
+	int rv;
 
 	lkb = dlm_allocate_lkb(ls);
 	if (!lkb)
@@ -1198,19 +1198,13 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	mutex_init(&lkb->lkb_cb_mutex);
 	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
 
- retry:
-	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
-
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_lkbidr_spin);
-	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
-	if (!rv)
-		lkb->lkb_id = id;
+	rv = idr_alloc(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);
+	if (rv >= 0)
+		lkb->lkb_id = rv;
 	spin_unlock(&ls->ls_lkbidr_spin);
-
-	if (rv == -EAGAIN)
-		goto retry;
+	idr_preload_end();
 
 	if (rv < 0) {
 		log_error(ls, "create_lkb idr error %d", rv);
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 236d108..a6bc63f 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -305,27 +305,26 @@ static int recover_idr_empty(struct dlm_ls *ls)
 static int recover_idr_add(struct dlm_rsb *r)
 {
 	struct dlm_ls *ls = r->res_ls;
-	int rv, id;
-
-	rv = idr_pre_get(&ls->ls_recover_idr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
+	int rv;
 
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_recover_idr_lock);
 	if (r->res_id) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return -1;
-	}
-	rv = idr_get_new_above(&ls->ls_recover_idr, r, 1, &id);
-	if (rv) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return rv;
+		rv = -1;
+		goto out_unlock;
 	}
-	r->res_id = id;
+	rv = idr_alloc(&ls->ls_recover_idr, r, 1, 0, GFP_NOWAIT);
+	if (rv < 0)
+		goto out_unlock;
+
+	r->res_id = rv;
 	ls->ls_recover_list_count++;
 	dlm_hold_rsb(r);
+	rv = 0;
+out_unlock:
 	spin_unlock(&ls->ls_recover_idr_lock);
-	return 0;
+	idr_preload_end();
+	return rv;
 }
 
 static void recover_idr_del(struct dlm_rsb *r)
-- 
1.8.1

