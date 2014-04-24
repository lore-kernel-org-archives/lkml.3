Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaDXIz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:55:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaDXIzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 130/182] dm cache: fix a lock-inversion
Date: Thu, 24 Apr 2014 09:50:55 +0100
Message-Id: <1398329507-5911-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11:
  - version update: 1.1.1 -> 1.1.2 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-metadata.c | 35 +++++++++++++++++------------------
 drivers/md/dm-cache-metadata.h |  9 +--------
 drivers/md/dm-cache-target.c   | 28 ++--------------------------
 3 files changed, 20 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 1d38019..1c53495 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1160,22 +1160,12 @@ static int begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
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
@@ -1185,16 +1175,25 @@ static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
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
index f45cef2..6610c6d 100644
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
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index d00ae6f..8175041 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2294,30 +2294,6 @@ static int write_discard_bitset(struct cache *cache)
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
@@ -2335,7 +2311,7 @@ static bool sync_metadata(struct cache *cache)
 
 	save_stats(cache);
 
-	r3 = write_hints(cache);
+	r3 = dm_cache_write_hints(cache->cmd, cache->policy);
 	if (r3)
 		DMERR("could not write hints");
 
@@ -2613,7 +2589,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {1, 1, 1},
+	.version = {1, 1, 2},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
1.9.1

