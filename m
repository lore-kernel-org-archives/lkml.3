Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3BADID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:08:03 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50362 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BADIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:08:00 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@ti.com>,
        Ming Lei <ming.lei@canonical.com>, stable@vger.kernel.org
Subject: [PATCH] block: partition: optimize memory allocation in check_partition
Date: Fri,  1 Feb 2013 11:07:40 +0800
Message-Id: <1359688060-12964-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sizeof(struct parsed_partitions) may be 64KB in 32bit arch,
so it is easy to trigger page allocation failure by check_partition,
especially in hotplug block device situation(such as, USB mass storage,
MMC card, ...), and Felipe Balbi has observed the failure.

This patch does below optimizations on the allocation of struct
parsed_partitions to try to address the issue:

- make parsed_partitions.parts as pointer so that the pointed memory
can fit in 32KB buffer, then approximate 32KB memory can be saved

- vmalloc the buffer pointed by parsed_partitions.parts because
32KB is still a bit big for kmalloc

- given that many devices have the partition count limit, so only
allocate disk_max_parts() partitions instead of 256 partitions

Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/partition-generic.c |    2 +-
 block/partitions/check.c  |   35 ++++++++++++++++++++++++++++++-----
 block/partitions/check.h  |    4 +++-
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index f1d1451..043d0bd 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -525,7 +525,7 @@ rescan:
 			md_autodetect_dev(part_to_dev(part)->devt);
 #endif
 	}
-	kfree(state);
+	release_partitions(state);
 	return 0;
 }
 
diff --git a/block/partitions/check.c b/block/partitions/check.c
index bc90867..86c9450 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
 
@@ -106,18 +107,43 @@ static int (*check_part[])(struct parsed_partitions *) = {
 	NULL
 };
 
+static struct parsed_partitions *allocate_partitions(int nr)
+{
+	struct parsed_partitions *state;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->parts = vzalloc(nr * sizeof(state->parts[0]));
+	if (!state->parts) {
+		kfree(state);
+		return NULL;
+	}
+
+	return state;
+}
+
+void release_partitions(struct parsed_partitions *state)
+{
+	vfree(state->parts);
+	kfree(state);
+}
+
 struct parsed_partitions *
 check_partition(struct gendisk *hd, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
 	int i, res, err;
 
-	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
+	i = disk_max_parts(hd);
+	state = allocate_partitions(i);
 	if (!state)
 		return NULL;
+	state->limit = i;
 	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!state->pp_buf) {
-		kfree(state);
+		release_partitions(state);
 		return NULL;
 	}
 	state->pp_buf[0] = '\0';
@@ -128,10 +154,9 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
-	state->limit = disk_max_parts(hd);
 	i = res = err = 0;
 	while (!res && check_part[i]) {
-		memset(&state->parts, 0, sizeof(state->parts));
+		memset(state->parts, 0, state->limit * sizeof(state->parts[0]));
 		res = check_part[i++](state);
 		if (res < 0) {
 			/* We have hit an I/O error which we don't report now.
@@ -161,6 +186,6 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	printk(KERN_INFO "%s", state->pp_buf);
 
 	free_page((unsigned long)state->pp_buf);
-	kfree(state);
+	release_partitions(state);
 	return ERR_PTR(res);
 }
diff --git a/block/partitions/check.h b/block/partitions/check.h
index 52b1003..4fefdbb 100644
--- a/block/partitions/check.h
+++ b/block/partitions/check.h
@@ -15,13 +15,15 @@ struct parsed_partitions {
 		int flags;
 		bool has_info;
 		struct partition_meta_info info;
-	} parts[DISK_MAX_PARTS];
+	} *parts;
 	int next;
 	int limit;
 	bool access_beyond_eod;
 	char *pp_buf;
 };
 
+void release_partitions(struct parsed_partitions *state);
+
 struct parsed_partitions *
 check_partition(struct gendisk *, struct block_device *);
 
-- 
1.7.9.5

