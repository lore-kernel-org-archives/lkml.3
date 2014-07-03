Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaGCJjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:39:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030391AbaGCJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 156/198] nfsd: don't try to reuse an expired DRC entry off the list
Date: Thu,  3 Jul 2014 10:19:59 +0100
Message-Id: <1404379241-8590-157-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit a0ef5e19684f0447da9ff0654a12019c484f57ca upstream.

Currently when we are processing a request, we try to scrape an expired
or over-limit entry off the list in preference to allocating a new one
from the slab.

This is unnecessarily complicated. Just use the slab layer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfscache.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index ec8d97ddc635..02e8e9ad5750 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -129,13 +129,6 @@ nfsd_reply_cache_alloc(void)
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
@@ -402,22 +395,8 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 
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
@@ -425,7 +404,9 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 		drc_mem_usage += sizeof(*rp);
 	}
 
-search_cache:
+	/* go ahead and prune the cache */
+	prune_cache_entries();
+
 	found = nfsd_cache_search(rqstp, csum);
 	if (found) {
 		if (likely(rp))
@@ -439,15 +420,6 @@ search_cache:
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

