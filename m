Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaLBTb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:31:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46999 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792AbaLBT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 044/121] nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG entry
Date: Tue,  2 Dec 2014 11:18:43 -0800
Message-Id: <1417548000-1794-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Reference: http://bugs.launchpad.net/bugs/1396065
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfscache.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index f8f060f..6040da8 100644
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
-- 
1.9.1

