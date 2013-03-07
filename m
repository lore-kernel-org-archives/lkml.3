Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab3CGSvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:51:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759693Ab3CGSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:51:17 -0500
From: Takashi Iwai <tiwai@suse.de>
To: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/3] block/partitions: Support dynamic addition of partition checkers
Date: Thu,  7 Mar 2013 19:51:06 +0100
Message-Id: <1362682267-10188-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362682267-10188-1-git-send-email-tiwai@suse.de>
References: <s5hk3pjm4it.wl%tiwai@suse.de>
 <1362682267-10188-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper functions to add / remove the partition checker function
dynamically.  This also allows to move the partition checker code into
the driver itself, e.g. the blockconsole partition checker can be in a
part of blockconsole driver (even as a module).

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 block/partitions/check.c | 35 +++++++++++++++++++++++++++++++++++
 block/partitions/check.h |  8 ++++++++
 2 files changed, 43 insertions(+)

diff --git a/block/partitions/check.c b/block/partitions/check.c
index 21786ed..d71cb02 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/export.h>
 
 #include "check.h"
 
@@ -110,6 +111,9 @@ static int (*check_part[])(struct parsed_partitions *) = {
 	NULL
 };
 
+static DEFINE_MUTEX(check_part_mutex);
+static LIST_HEAD(check_part_list);
+
 static struct parsed_partitions *allocate_partitions(struct gendisk *hd)
 {
 	struct parsed_partitions *state;
@@ -172,6 +176,21 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 		}
 
 	}
+
+	if (res <= 0) {
+		struct partition_checker *c;
+		mutex_lock(&check_part_mutex);
+		list_for_each_entry(c, &check_part_list, list) {
+			memset(state->parts, 0, state->limit * sizeof(state->parts[0]));
+			res = c->check(state);
+			if (res < 0) {
+				err = res;
+				res = 0;
+			}
+		}
+		mutex_unlock(&check_part_mutex);
+	}
+
 	if (res > 0) {
 		printk(KERN_INFO "%s", state->pp_buf);
 
@@ -194,3 +213,19 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	free_partitions(state);
 	return ERR_PTR(res);
 }
+
+void append_partition_checker(struct partition_checker *c)
+{
+	mutex_lock(&check_part_mutex);
+	list_add_tail(&c->list, &check_part_list);
+	mutex_unlock(&check_part_mutex);
+}
+EXPORT_SYMBOL_GPL(append_partition_checker);
+
+void remove_partition_checker(struct partition_checker *c)
+{
+	mutex_lock(&check_part_mutex);
+	list_del(&c->list);
+	mutex_unlock(&check_part_mutex);
+}
+EXPORT_SYMBOL_GPL(remove_partition_checker);
diff --git a/block/partitions/check.h b/block/partitions/check.h
index bca9624..53c8508 100644
--- a/block/partitions/check.h
+++ b/block/partitions/check.h
@@ -55,3 +55,11 @@ extern int warn_no_part;
 #ifdef CONFIG_BLOCKCONSOLE
 int blockconsole_partition(struct parsed_partitions *state);
 #endif
+
+struct partition_checker {
+	int (*check)(struct parsed_partitions *);
+	struct list_head list;
+};
+
+void append_partition_checker(struct partition_checker *c);
+void remove_partition_checker(struct partition_checker *c);
-- 
1.8.1.4

