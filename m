Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbaLBTdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:33:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730AbaLBT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:45 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 043/121] nfsd: don't try to reuse an expired DRC entry off the list
Date: Tue,  2 Dec 2014 11:18:42 -0800
Message-Id: <1417548000-1794-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit a0ef5e19684f0447da9ff0654a12019c484f57ca upstream.

Currently when we are processing a request, we try to scrape an expired
or over-limit entry off the list in preference to allocating a new one
from the slab.

This is unnecessarily complicated. Just use the slab layer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Reference: http://bugs.launchpad.net/bugs/1396065
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfscache.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index b6af150..f8f060f 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -132,13 +132,6 @@ nfsd_reply_cache_alloc(void)
 }
 
 static void
-nfsd_reply_cache_unhash(struct svc_cacherep *rp)
-{
-	hlist_del_init(&rp->c_hash);
-	list_del_init(&rp->c_lru);
-}
-
-static void
 nfsd_reply_cache_free_locked(struct svc_cacherep *rp)
 {
 	if (rp->c_type == RC_REPLBUFF && rp->c_replvec.iov_base) {
@@ -416,22 +409,8 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 
 	/*
 	 * Since the common case is a cache miss followed by an insert,
-	 * preallocate an entry. First, try to reuse the first entry on the LRU
-	 * if it works, then go ahead and prune the LRU list.
+	 * preallocate an entry.
 	 */
-	spin_lock(&cache_lock);
-	if (!list_empty(&lru_head)) {
-		rp = list_first_entry(&lru_head, struct svc_cacherep, c_lru);
-		if (nfsd_cache_entry_expired(rp) ||
-		    num_drc_entries >= max_drc_entries) {
-			nfsd_reply_cache_unhash(rp);
-			prune_cache_entries();
-			goto search_cache;
-		}
-	}
-
-	/* No expired ones available, allocate a new one. */
-	spin_unlock(&cache_lock);
 	rp = nfsd_reply_cache_alloc();
 	spin_lock(&cache_lock);
 	if (likely(rp)) {
@@ -439,7 +418,9 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 		drc_mem_usage += sizeof(*rp);
 	}
 
-search_cache:
+	/* go ahead and prune the cache */
+	prune_cache_entries();
+
 	found = nfsd_cache_search(rqstp, csum);
 	if (found) {
 		if (likely(rp))
@@ -453,15 +434,6 @@ search_cache:
 		goto out;
 	}
 
-	/*
-	 * We're keeping the one we just allocated. Are we now over the
-	 * limit? Prune one off the tip of the LRU in trade for the one we
-	 * just allocated if so.
-	 */
-	if (num_drc_entries >= max_drc_entries)
-		nfsd_reply_cache_free_locked(list_first_entry(&lru_head,
-						struct svc_cacherep, c_lru));
-
 	nfsdstats.rcmisses++;
 	rqstp->rq_cacherep = rp;
 	rp->c_state = RC_INPROG;
-- 
1.9.1

