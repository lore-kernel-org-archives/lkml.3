Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3AZBeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:34:11 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35251 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3AZBbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:35 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 10/14] dlm: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:08 -0800
Message-Id: <1359163872-1949-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.

The conversion isn't completely trivial for recover_idr_clear() as
it's the only place in kernel which makes legitimate use of
idr_remove_all() w/o idr_destroy().  Replace it with idr_remove() call
inside idr_for_each_entry() loop.  It goes on top so that it matches
the operation order in recover_idr_del().

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 fs/dlm/lockspace.c | 1 -
 fs/dlm/recover.c   | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 2e99fb0..3ca79d3 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -796,7 +796,6 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	 */
 
 	idr_for_each(&ls->ls_lkbidr, lkb_idr_free, ls);
-	idr_remove_all(&ls->ls_lkbidr);
 	idr_destroy(&ls->ls_lkbidr);
 
 	/*
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index b2856e7..236d108 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -359,13 +359,13 @@ static void recover_idr_clear(struct dlm_ls *ls)
 	spin_lock(&ls->ls_recover_idr_lock);
 
 	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
+		idr_remove(&ls->ls_recover_idr, id);
 		r->res_id = 0;
 		r->res_recover_locks_count = 0;
 		ls->ls_recover_list_count--;
 
 		dlm_put_rsb(r);
 	}
-	idr_remove_all(&ls->ls_recover_idr);
 
 	if (ls->ls_recover_list_count != 0) {
 		log_error(ls, "warning: recover_list_count %d",
-- 
1.8.1

