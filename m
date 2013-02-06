Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3BFULv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:11:51 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:55866 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab3BFTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:39 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 11/77] dlm: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:43 -0800
Message-Id: <1360179649-22465-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
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

