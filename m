Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3BFUEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:04:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62776 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3BFUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:02:43 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 10/77] dlm: use idr_for_each_entry() in recover_idr_clear() error path
Date: Wed,  6 Feb 2013 11:39:42 -0800
Message-Id: <1360179649-22465-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert recover_idr_clear() to use idr_for_each_entry() instead of
idr_for_each().  It's somewhat less efficient this way but it
shouldn't matter in an error path.  This is to help with deprecation
of idr_remove_all().

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/dlm/recover.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index aedea28..b2856e7 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -351,23 +351,20 @@ static struct dlm_rsb *recover_idr_find(struct dlm_ls *ls, uint64_t id)
 	return r;
 }
 
-static int recover_idr_clear_rsb(int id, void *p, void *data)
+static void recover_idr_clear(struct dlm_ls *ls)
 {
-	struct dlm_ls *ls = data;
-	struct dlm_rsb *r = p;
+	struct dlm_rsb *r;
+	int id;
 
-	r->res_id = 0;
-	r->res_recover_locks_count = 0;
-	ls->ls_recover_list_count--;
+	spin_lock(&ls->ls_recover_idr_lock);
 
-	dlm_put_rsb(r);
-	return 0;
-}
+	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
+		r->res_id = 0;
+		r->res_recover_locks_count = 0;
+		ls->ls_recover_list_count--;
 
-static void recover_idr_clear(struct dlm_ls *ls)
-{
-	spin_lock(&ls->ls_recover_idr_lock);
-	idr_for_each(&ls->ls_recover_idr, recover_idr_clear_rsb, ls);
+		dlm_put_rsb(r);
+	}
 	idr_remove_all(&ls->ls_recover_idr);
 
 	if (ls->ls_recover_list_count != 0) {
-- 
1.8.1

