Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaLEXDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:03:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaLEW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [PATCH 3.14 63/73] nfsd: dont halt scanning the DRC LRU list when theres an RC_INPROG entry
Date: Fri,  5 Dec 2014 14:45:09 -0800
Message-Id: <20141205224435.816947395@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@primarydata.com>

commit 1b19453d1c6abcfa7c312ba6c9f11a277568fc94 upstream.

Currently, the DRC cache pruner will stop scanning the list when it
hits an entry that is RC_INPROG. It's possible however for a call to
take a *very* long time. In that case, we don't want it to block other
entries from being pruned if they are expired or we need to trim the
cache to get back under the limit.

Fix the DRC cache pruner to just ignore RC_INPROG entries.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfscache.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -224,13 +224,6 @@ hash_refile(struct svc_cacherep *rp)
 	hlist_add_head(&rp->c_hash, cache_hash + hash_32(rp->c_xid, maskbits));
 }
 
-static inline bool
-nfsd_cache_entry_expired(struct svc_cacherep *rp)
-{
-	return rp->c_state != RC_INPROG &&
-	       time_after(jiffies, rp->c_timestamp + RC_EXPIRE);
-}
-
 /*
  * Walk the LRU list and prune off entries that are older than RC_EXPIRE.
  * Also prune the oldest ones when the total exceeds the max number of entries.
@@ -242,8 +235,14 @@ prune_cache_entries(void)
 	long freed = 0;
 
 	list_for_each_entry_safe(rp, tmp, &lru_head, c_lru) {
-		if (!nfsd_cache_entry_expired(rp) &&
-		    num_drc_entries <= max_drc_entries)
+		/*
+		 * Don't free entries attached to calls that are still
+		 * in-progress, but do keep scanning the list.
+		 */
+		if (rp->c_state == RC_INPROG)
+			continue;
+		if (num_drc_entries <= max_drc_entries &&
+		    time_before(jiffies, rp->c_timestamp + RC_EXPIRE))
 			break;
 		nfsd_reply_cache_free_locked(rp);
 		freed++;


