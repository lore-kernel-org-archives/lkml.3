Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab3GVQNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:50 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53234 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162Ab3GVQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:44 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 47/48] staging/lustre/scrub: purge inconsistenct objects after OI scrub
Date: Tue, 23 Jul 2013 00:07:08 +0800
Message-Id: <1374509230-3324-48-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

When OI scrub repaired the found inconsistency, it needs to purge the
old object out of cache; otherwise, others may still use those cached
stale information.

Original patch adds functions in obdclass that is only used by server.
Drop that part. Only merge in error handling change.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3335
Lustre-change: http://review.whamcloud.com/6697
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 2fb65f6..896f24a 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -538,7 +538,7 @@ static struct lu_object *htable_lookup(struct lu_site *s,
 	__u64  ver = cfs_hash_bd_version_get(bd);
 
 	if (*version == ver)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	*version = ver;
 	bkt = cfs_hash_bd_extra_get(s->ls_obj_hash, bd);
@@ -547,7 +547,7 @@ static struct lu_object *htable_lookup(struct lu_site *s,
 	hnode = cfs_hash_bd_peek_locked(s->ls_obj_hash, bd, (void *)f);
 	if (hnode == NULL) {
 		lprocfs_counter_incr(s->ls_stats, LU_SS_CACHE_MISS);
-		return NULL;
+		return ERR_PTR(-ENOENT);
 	}
 
 	h = container_of0(hnode, struct lu_object_header, loh_hash);
@@ -651,7 +651,7 @@ static struct lu_object *lu_object_find_try(const struct lu_env *env,
 	cfs_hash_bd_get_and_lock(hs, (void *)f, &bd, 1);
 	o = htable_lookup(s, &bd, f, waiter, &version);
 	cfs_hash_bd_unlock(hs, &bd, 1);
-	if (o != NULL)
+	if (!IS_ERR(o) || PTR_ERR(o) != -ENOENT)
 		return o;
 
 	/*
@@ -667,7 +667,7 @@ static struct lu_object *lu_object_find_try(const struct lu_env *env,
 	cfs_hash_bd_lock(hs, &bd, 1);
 
 	shadow = htable_lookup(s, &bd, f, waiter, &version);
-	if (likely(shadow == NULL)) {
+	if (likely(IS_ERR(shadow) && PTR_ERR(shadow) == -ENOENT)) {
 		struct lu_site_bkt_data *bkt;
 
 		bkt = cfs_hash_bd_extra_get(hs, &bd);
@@ -2077,7 +2077,7 @@ void lu_object_assign_fid(const struct lu_env *env, struct lu_object *o,
 	cfs_hash_bd_get_and_lock(hs, (void *)fid, &bd, 1);
 	shadow = htable_lookup(s, &bd, fid, &waiter, &version);
 	/* supposed to be unique */
-	LASSERT(shadow == NULL);
+	LASSERT(IS_ERR(shadow) && PTR_ERR(shadow) == -ENOENT);
 	*old = *fid;
 	bkt = cfs_hash_bd_extra_get(hs, &bd);
 	cfs_hash_bd_add_locked(hs, &bd, &o->lo_header->loh_hash);
-- 
1.7.9.5

