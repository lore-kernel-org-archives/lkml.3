Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3LQSO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3LQSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 050/103] dm: fix truncated status strings
Date: Tue, 17 Dec 2013 18:12:39 +0000
Message-Id: <1387304012-23805-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fd7c092e711ebab55b2688d3859d95dfd0301f73 upstream.

Avoid returning a truncated table or status string instead of setting
the DM_BUFFER_FULL_FLAG when the last target of a table fills the
buffer.

When processing a table or status request, the function retrieve_status
calls ti->type->status. If ti->type->status returns non-zero,
retrieve_status assumes that the buffer overflowed and sets
DM_BUFFER_FULL_FLAG.

However, targets don't return non-zero values from their status method
on overflow. Most targets returns always zero.

If a buffer overflow happens in a target that is not the last in the
table, it gets noticed during the next iteration of the loop in
retrieve_status; but if a buffer overflow happens in the last target, it
goes unnoticed and erroneously truncated data is returned.

In the current code, the targets behave in the following way:
* dm-crypt returns -ENOMEM if there is not enough space to store the
  key, but it returns 0 on all other overflows.
* dm-thin returns errors from the status method if a disk error happened.
  This is incorrect because retrieve_status doesn't check the error
  code, it assumes that all non-zero values mean buffer overflow.
* all the other targets always return 0.

This patch changes the ti->type->status function to return void (because
most targets don't use the return code). Overflow is detected in
retrieve_status: if the status method fills up the remaining space
completely, it is assumed that buffer overflow happened.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
[ luis: backported to 3.5: based on Mikulas backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-crypt.c         | 37 +++++-----------------
 drivers/md/dm-delay.c         |  6 ++--
 drivers/md/dm-flakey.c        |  5 ++-
 drivers/md/dm-ioctl.c         | 18 +++++++----
 drivers/md/dm-linear.c        |  5 ++-
 drivers/md/dm-mpath.c         |  6 ++--
 drivers/md/dm-raid.c          |  6 ++--
 drivers/md/dm-raid1.c         |  6 ++--
 drivers/md/dm-snap.c          | 12 +++----
 drivers/md/dm-stripe.c        |  5 ++-
 drivers/md/dm-thin.c          | 74 +++++++++++++++++++++++++++----------------
 drivers/md/dm-verity.c        |  6 ++--
 include/linux/device-mapper.h |  4 +--
 13 files changed, 87 insertions(+), 103 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3f06df5..535c3e2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1262,20 +1262,6 @@ static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
 	return 0;
 }
 
-/*
- * Encode key into its hex representation
- */
-static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++) {
-		sprintf(hex, "%02x", *key);
-		hex += 2;
-		key++;
-	}
-}
-
 static void crypt_free_tfms(struct crypt_config *cc, int cpu)
 {
 	struct crypt_cpu *cpu_cc = per_cpu_ptr(cc->cpu, cpu);
@@ -1741,11 +1727,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int crypt_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned int maxlen)
+static void crypt_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned int maxlen)
 {
 	struct crypt_config *cc = ti->private;
-	unsigned int sz = 0;
+	unsigned i, sz = 0;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1755,17 +1741,11 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s ", cc->cipher_string);
 
-		if (cc->key_size > 0) {
-			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
-				return -ENOMEM;
-
-			crypt_encode_key(result + sz, cc->key, cc->key_size);
-			sz += cc->key_size << 1;
-		} else {
-			if (sz >= maxlen)
-				return -ENOMEM;
-			result[sz++] = '-';
-		}
+		if (cc->key_size > 0)
+			for (i = 0; i < cc->key_size; i++)
+				DMEMIT("%02x", cc->key[i]);
+		else
+			DMEMIT("-");
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
@@ -1775,7 +1755,6 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
-	return 0;
 }
 
 static void crypt_postsuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2dc22dd..ee99912 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -294,8 +294,8 @@ static int delay_map(struct dm_target *ti, struct bio *bio,
 	return delay_bio(dc, dc->read_delay, bio);
 }
 
-static int delay_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned maxlen)
+static void delay_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned maxlen)
 {
 	struct delay_c *dc = ti->private;
 	int sz = 0;
@@ -315,8 +315,6 @@ static int delay_status(struct dm_target *ti, status_type_t type,
 			       dc->write_delay);
 		break;
 	}
-
-	return 0;
 }
 
 static int delay_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index ac49c01..f29d665 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -332,8 +332,8 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	return error;
 }
 
-static int flakey_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void flakey_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	unsigned sz = 0;
 	struct flakey_c *fc = ti->private;
@@ -363,7 +363,6 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
-	return 0;
 }
 
 static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f011d4b..d365365 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1066,6 +1066,7 @@ static void retrieve_status(struct dm_table *table,
 	num_targets = dm_table_get_num_targets(table);
 	for (i = 0; i < num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(table, i);
+		size_t l;
 
 		remaining = len - (outptr - outbuf);
 		if (remaining <= sizeof(struct dm_target_spec)) {
@@ -1089,15 +1090,18 @@ static void retrieve_status(struct dm_table *table,
 		}
 
 		/* Get the status/table string from the target driver */
-		if (ti->type->status) {
-			if (ti->type->status(ti, type, outptr, remaining)) {
-				param->flags |= DM_BUFFER_FULL_FLAG;
-				break;
-			}
-		} else
+		if (ti->type->status)
+			ti->type->status(ti, type, outptr, remaining);
+		else
 			outptr[0] = '\0';
 
-		outptr += strlen(outptr) + 1;
+		l = strlen(outptr) + 1;
+		if (l == remaining) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
+
+		outptr += l;
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3639eea..5a5e9c8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -95,8 +95,8 @@ static int linear_map(struct dm_target *ti, struct bio *bio,
 	return DM_MAPIO_REMAPPED;
 }
 
-static int linear_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void linear_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
 
@@ -110,7 +110,6 @@ static int linear_status(struct dm_target *ti, status_type_t type,
 				(unsigned long long)lc->start);
 		break;
 	}
-	return 0;
 }
 
 static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 93b3c2d..86a56d8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1345,8 +1345,8 @@ static void multipath_resume(struct dm_target *ti)
  *     [priority selector-name num_ps_args [ps_args]*
  *      num_paths num_selector_args [path_dev [selector_args]* ]+ ]+
  */
-static int multipath_status(struct dm_target *ti, status_type_t type,
-			    char *result, unsigned int maxlen)
+static void multipath_status(struct dm_target *ti, status_type_t type,
+			     char *result, unsigned int maxlen)
 {
 	int sz = 0;
 	unsigned long flags;
@@ -1449,8 +1449,6 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	return 0;
 }
 
 static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 017c34d..17def2e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1066,8 +1066,8 @@ static int raid_map(struct dm_target *ti, struct bio *bio, union map_info *map_c
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int raid_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void raid_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	struct raid_set *rs = ti->private;
 	unsigned raid_param_cnt = 1; /* at least 1 for chunksize */
@@ -1202,8 +1202,6 @@ static int raid_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" -");
 		}
 	}
-
-	return 0;
 }
 
 static int raid_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b58b7a3..a3cf259 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1362,8 +1362,8 @@ static char device_status_char(struct mirror *m)
 }
 
 
-static int mirror_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void mirror_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
@@ -1398,8 +1398,6 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 		if (ms->features & DM_RAID1_HANDLE_ERRORS)
 			DMEMIT(" 1 handle_errors");
 	}
-
-	return 0;
 }
 
 static int mirror_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 330bfd6..e106267 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1845,8 +1845,8 @@ static void snapshot_merge_resume(struct dm_target *ti)
 	start_merge(s);
 }
 
-static int snapshot_status(struct dm_target *ti, status_type_t type,
-			   char *result, unsigned int maxlen)
+static void snapshot_status(struct dm_target *ti, status_type_t type,
+			    char *result, unsigned int maxlen)
 {
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
@@ -1892,8 +1892,6 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
 					  maxlen - sz);
 		break;
 	}
-
-	return 0;
 }
 
 static int snapshot_iterate_devices(struct dm_target *ti,
@@ -2148,8 +2146,8 @@ static void origin_resume(struct dm_target *ti)
 	ti->split_io = get_origin_minimum_chunksize(dev->bdev);
 }
 
-static int origin_status(struct dm_target *ti, status_type_t type, char *result,
-			 unsigned int maxlen)
+static void origin_status(struct dm_target *ti, status_type_t type, char *result,
+			  unsigned int maxlen)
 {
 	struct dm_dev *dev = ti->private;
 
@@ -2162,8 +2160,6 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 		snprintf(result, maxlen, "%s", dev->name);
 		break;
 	}
-
-	return 0;
 }
 
 static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 35c94ff..58ffcda 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -302,8 +302,8 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
  *
  */
 
-static int stripe_status(struct dm_target *ti,
-			 status_type_t type, char *result, unsigned int maxlen)
+static void stripe_status(struct dm_target *ti,
+			  status_type_t type, char *result, unsigned int maxlen)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
 	char buffer[sc->stripes + 1];
@@ -330,7 +330,6 @@ static int stripe_status(struct dm_target *ti,
 			    (unsigned long long)sc->stripe[i].physical_start);
 		break;
 	}
-	return 0;
 }
 
 static int stripe_end_io(struct dm_target *ti, struct bio *bio,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1307ba8..7ef83d9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2378,8 +2378,8 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
  *    <transaction id> <used metadata sectors>/<total metadata sectors>
  *    <used data sectors>/<total data sectors> <held metadata root>
  */
-static int pool_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void pool_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r, count;
 	unsigned sz = 0;
@@ -2396,32 +2396,41 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		r = dm_pool_get_metadata_transaction_id(pool->pmd,
-							&transaction_id);
-		if (r)
-			return r;
+		r = dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
+		if (r) {
+			DMERR("dm_pool_get_metadata_transaction_id returned %d", r);
+			goto err;
+		}
 
-		r = dm_pool_get_free_metadata_block_count(pool->pmd,
-							  &nr_free_blocks_metadata);
-		if (r)
-			return r;
+		r = dm_pool_get_free_metadata_block_count(pool->pmd, &nr_free_blocks_metadata);
+		if (r) {
+			DMERR("dm_pool_get_free_metadata_block_count returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_metadata_dev_size(pool->pmd, &nr_blocks_metadata);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_metadata_dev_size returned %d", r);
+			goto err;
+		}
 
-		r = dm_pool_get_free_block_count(pool->pmd,
-						 &nr_free_blocks_data);
-		if (r)
-			return r;
+		r = dm_pool_get_free_block_count(pool->pmd, &nr_free_blocks_data);
+		if (r) {
+			DMERR("dm_pool_get_free_block_count returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_data_dev_size(pool->pmd, &nr_blocks_data);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_data_dev_size returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_metadata_snap(pool->pmd, &held_root);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_metadata_snap returned %d", r);
+			goto err;
+		}
 
 		DMEMIT("%llu %llu/%llu %llu/%llu ",
 		       (unsigned long long)transaction_id,
@@ -2459,8 +2468,10 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
+	return;
 
-	return 0;
+err:
+	DMEMIT("Error");
 }
 
 static int pool_iterate_devices(struct dm_target *ti,
@@ -2712,8 +2723,8 @@ static void thin_postsuspend(struct dm_target *ti)
 /*
  * <nr mapped sectors> <highest mapped sector>
  */
-static int thin_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void thin_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r;
 	ssize_t sz = 0;
@@ -2727,12 +2738,16 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 		switch (type) {
 		case STATUSTYPE_INFO:
 			r = dm_thin_get_mapped_count(tc->td, &mapped);
-			if (r)
-				return r;
+			if (r) {
+				DMERR("dm_thin_get_mapped_count returned %d", r);
+				goto err;
+			}
 
 			r = dm_thin_get_highest_mapped_block(tc->td, &highest);
-			if (r < 0)
-				return r;
+			if (r < 0) {
+				DMERR("dm_thin_get_highest_mapped_block returned %d", r);
+				goto err;
+			}
 
 			DMEMIT("%llu ", mapped * tc->pool->sectors_per_block);
 			if (r)
@@ -2752,7 +2767,10 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 		}
 	}
 
-	return 0;
+	return;
+
+err:
+	DMEMIT("Error");
 }
 
 static int thin_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 157007d..ca36692 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -543,8 +543,8 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 /*
  * Status: V (valid) or C (corruption found)
  */
-static int verity_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned maxlen)
+static void verity_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	struct dm_verity *v = ti->private;
 	unsigned sz = 0;
@@ -575,8 +575,6 @@ static int verity_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("%02x", v->salt[x]);
 		break;
 	}
-
-	return 0;
 }
 
 static int verity_ioctl(struct dm_target *ti, unsigned cmd,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 98f34b8..fa09b57 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -72,8 +72,8 @@ typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
 
-typedef int (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
-			     char *result, unsigned int maxlen);
+typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
+			      char *result, unsigned int maxlen);
 
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
-- 
1.8.3.2

