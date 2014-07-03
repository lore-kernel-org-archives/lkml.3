Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030426AbaGCJYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52426 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030404AbaGCJYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 157/198] nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG entry
Date: Thu,  3 Jul 2014 10:20:00 +0100
Message-Id: <1404379241-8590-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfscache.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 02e8e9ad5750..e5e4675b7e75 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -221,13 +221,6 @@ hash_refile(struct svc_cacherep *rp)
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
@@ -238,8 +231,14 @@ prune_cache_entries(void)
 	struct svc_cacherep *rp, *tmp;
 
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
 	}
-- 
1.9.1

