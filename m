Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaEBQXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:23:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaEBPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 133/151] dm cache: fix a lock-inversion
Date: Fri,  2 May 2014 08:38:41 -0700
Message-Id: <1399045139-4531-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 0596661f0a16d9d69bf1033320e70b6ff52b5e81 upstream.

When suspending a cache the policy is walked and the individual policy
hints written to the metadata via sync_metadata().  This led to this
lock order:

      policy->lock
        cache_metadata->root_lock

When loading the cache target the policy is populated while the metadata
lock is held:

      cache_metadata->root_lock
         policy->lock

Fix this potential lock-inversion (ABBA) deadlock in sync_metadata() by
ensuring the cache_metadata root_lock is held whilst all the hints are
written, rather than being repeatedly locked while policy->lock is held
(as was the case with each callout that policy_walk_mappings() made to
the old save_hint() method).

Found by turning on the CONFIG_PROVE_LOCKING ("Lock debugging: prove
locking correctness") build option.  However, it is not clear how the
LOCKDEP reported paths can lead to a deadlock since the two paths,
suspending a target and loading a target, never occur at the same time.
But that doesn't mean the same lock-inversion couldn't have occurred
elsewhere.

Reported-by: Marian Csontos <mcsontos@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ kamal: backport to 3.13: omitted cache_target version string change ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-metadata.c | 35 +++++++++++++++++------------------
 drivers/md/dm-cache-metadata.h |  9 +--------
 drivers/md/dm-cache-target.c   | 26 +-------------------------
 3 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 53ab31e..5320332 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1245,22 +1245,12 @@ static int begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
 	return 0;
 }
 
-int dm_cache_begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *policy)
+static int save_hint(void *context, dm_cblock_t cblock, dm_oblock_t oblock, uint32_t hint)
 {
+	struct dm_cache_metadata *cmd = context;
+	__le32 value = cpu_to_le32(hint);
 	int r;
 
-	down_write(&cmd->root_lock);
-	r = begin_hints(cmd, policy);
-	up_write(&cmd->root_lock);
-
-	return r;
-}
-
-static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
-		     uint32_t hint)
-{
-	int r;
-	__le32 value = cpu_to_le32(hint);
 	__dm_bless_for_disk(&value);
 
 	r = dm_array_set_value(&cmd->hint_info, cmd->hint_root,
@@ -1270,16 +1260,25 @@ static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
 	return r;
 }
 
-int dm_cache_save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
-		       uint32_t hint)
+static int write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *policy)
 {
 	int r;
 
-	if (!hints_array_initialized(cmd))
-		return 0;
+	r = begin_hints(cmd, policy);
+	if (r) {
+		DMERR("begin_hints failed");
+		return r;
+	}
+
+	return policy_walk_mappings(policy, save_hint, cmd);
+}
+
+int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *policy)
+{
+	int r;
 
 	down_write(&cmd->root_lock);
-	r = save_hint(cmd, cblock, hint);
+	r = write_hints(cmd, policy);
 	up_write(&cmd->root_lock);
 
 	return r;
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index cd906f1..f0fb1dd 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -128,14 +128,7 @@ void dm_cache_dump(struct dm_cache_metadata *cmd);
  * rather than querying the policy for each cblock, we let it walk its data
  * structures and fill in the hints in whatever order it wishes.
  */
-
-int dm_cache_begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *p);
-
-/*
- * requests hints for every cblock and stores in the metadata device.
- */
-int dm_cache_save_hint(struct dm_cache_metadata *cmd,
-		       dm_cblock_t cblock, uint32_t hint);
+int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *p);
 
 /*
  * Query method.  Are all the blocks in the cache clean?
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0411e9f..0826650 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2589,30 +2589,6 @@ static int write_discard_bitset(struct cache *cache)
 	return 0;
 }
 
-static int save_hint(void *context, dm_cblock_t cblock, dm_oblock_t oblock,
-		     uint32_t hint)
-{
-	struct cache *cache = context;
-	return dm_cache_save_hint(cache->cmd, cblock, hint);
-}
-
-static int write_hints(struct cache *cache)
-{
-	int r;
-
-	r = dm_cache_begin_hints(cache->cmd, cache->policy);
-	if (r) {
-		DMERR("dm_cache_begin_hints failed");
-		return r;
-	}
-
-	r = policy_walk_mappings(cache->policy, save_hint, cache);
-	if (r)
-		DMERR("policy_walk_mappings failed");
-
-	return r;
-}
-
 /*
  * returns true on success
  */
@@ -2630,7 +2606,7 @@ static bool sync_metadata(struct cache *cache)
 
 	save_stats(cache);
 
-	r3 = write_hints(cache);
+	r3 = dm_cache_write_hints(cache->cmd, cache->policy);
 	if (r3)
 		DMERR("could not write hints");
 
-- 
1.9.1

