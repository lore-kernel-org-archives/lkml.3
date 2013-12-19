Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3LSMJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:09:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3LSL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 182/208] nfsd: when reusing an existing repcache entry, unhash it first
Date: Thu, 19 Dec 2013 11:54:40 +0000
Message-Id: <1387454106-19326-183-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 781c2a5a5f75eacc04663aced0f0f1a648d4f308 upstream.

The DRC code will attempt to reuse an existing, expired cache entry in
preference to allocating a new one. It'll then search the cache, and if
it gets a hit it'll then free the cache entry that it was going to
reuse.

The cache code doesn't unhash the entry that it's going to reuse
however, so it's possible for it end up designating an entry for reuse
and then subsequently freeing the same entry after it finds it.  This
leads it to a later use-after-free situation and usually some list
corruption warnings or an oops.

Fix this by simply unhashing the entry that we intend to reuse. That
will mean that it's not findable via a search and should prevent this
situation from occurring.

Reported-by: Christoph Hellwig <hch@infradead.org>
Reported-by: g. artim <gartim@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfscache.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index e76244e..ec8d97d 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -129,6 +129,13 @@ nfsd_reply_cache_alloc(void)
 }
 
 static void
+nfsd_reply_cache_unhash(struct svc_cacherep *rp)
+{
+	hlist_del_init(&rp->c_hash);
+	list_del_init(&rp->c_lru);
+}
+
+static void
 nfsd_reply_cache_free_locked(struct svc_cacherep *rp)
 {
 	if (rp->c_type == RC_REPLBUFF && rp->c_replvec.iov_base) {
@@ -403,7 +410,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 		rp = list_first_entry(&lru_head, struct svc_cacherep, c_lru);
 		if (nfsd_cache_entry_expired(rp) ||
 		    num_drc_entries >= max_drc_entries) {
-			lru_put_end(rp);
+			nfsd_reply_cache_unhash(rp);
 			prune_cache_entries();
 			goto search_cache;
 		}
-- 
1.8.3.2

