Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3LRVon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:44:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3LRVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, "g. artim" <gartim@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.12 029/118] nfsd: when reusing an existing repcache entry, unhash it first
Date: Wed, 18 Dec 2013 13:11:06 -0800
Message-Id: <20131218211220.301373851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfscache.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -132,6 +132,13 @@ nfsd_reply_cache_alloc(void)
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
@@ -417,7 +424,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp
 		rp = list_first_entry(&lru_head, struct svc_cacherep, c_lru);
 		if (nfsd_cache_entry_expired(rp) ||
 		    num_drc_entries >= max_drc_entries) {
-			lru_put_end(rp);
+			nfsd_reply_cache_unhash(rp);
 			prune_cache_entries();
 			goto search_cache;
 		}


