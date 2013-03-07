Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3CGSwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:52:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694Ab3CGSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:51:17 -0500
From: Takashi Iwai <tiwai@suse.de>
To: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/3] blockconsole: Allow to be a module
Date: Thu,  7 Mar 2013 19:51:07 +0100
Message-Id: <1362682267-10188-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362682267-10188-1-git-send-email-tiwai@suse.de>
References: <s5hk3pjm4it.wl%tiwai@suse.de>
 <1362682267-10188-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the partition checker code into blockconsole driver so that it
can be built as a module, too.  linux/blockconsole.h is removed since
all stuff is found locally in drivers/block/blockconsole.c.  Also some
functions are marked as static for the same reason.

A new linked list is added to blockconsole instance for managing the
proper unregistration at unloading the module on the fly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 block/partitions/Makefile       |  1 -
 block/partitions/blockconsole.c | 22 -----------
 block/partitions/check.c        |  3 --
 block/partitions/check.h        |  4 --
 drivers/block/Kconfig           |  2 +-
 drivers/block/blockconsole.c    | 84 +++++++++++++++++++++++++++++++++++++++--
 include/linux/blockconsole.h    |  7 ----
 7 files changed, 81 insertions(+), 42 deletions(-)
 delete mode 100644 block/partitions/blockconsole.c
 delete mode 100644 include/linux/blockconsole.h

diff --git a/block/partitions/Makefile b/block/partitions/Makefile
index bf26d4a..03af8ea 100644
--- a/block/partitions/Makefile
+++ b/block/partitions/Makefile
@@ -18,4 +18,3 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
 obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
-obj-$(CONFIG_BLOCKCONSOLE) += blockconsole.o
diff --git a/block/partitions/blockconsole.c b/block/partitions/blockconsole.c
deleted file mode 100644
index 79796a8..0000000
--- a/block/partitions/blockconsole.c
+++ /dev/null
@@ -1,22 +0,0 @@
-#include <linux/blockconsole.h>
-
-#include "check.h"
-
-int blockconsole_partition(struct parsed_partitions *state)
-{
-	Sector sect;
-	void *data;
-	int err = 0;
-
-	data = read_part_sector(state, 0, &sect);
-	if (!data)
-		return -EIO;
-	if (!bcon_magic_present(data))
-		goto out;
-
-	bcon_add(state->name);
-	err = 1;
-out:
-	put_dev_sector(sect);
-	return err;
-}
diff --git a/block/partitions/check.c b/block/partitions/check.c
index d71cb02..d9e9324 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -43,9 +43,6 @@ static int (*check_part[])(struct parsed_partitions *) = {
 	 * Probe partition formats with tables at disk address 0
 	 * that also have an ADFS boot block at 0xdc0.
 	 */
-#ifdef CONFIG_BLOCKCONSOLE
-	blockconsole_partition,
-#endif
 #ifdef CONFIG_ACORN_PARTITION_ICS
 	adfspart_check_ICS,
 #endif
diff --git a/block/partitions/check.h b/block/partitions/check.h
index 53c8508..886ed32 100644
--- a/block/partitions/check.h
+++ b/block/partitions/check.h
@@ -52,10 +52,6 @@ put_partition(struct parsed_partitions *p, int n, sector_t from, sector_t size)
 
 extern int warn_no_part;
 
-#ifdef CONFIG_BLOCKCONSOLE
-int blockconsole_partition(struct parsed_partitions *state);
-#endif
-
 struct partition_checker {
 	int (*check)(struct parsed_partitions *);
 	struct list_head list;
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 7da1360..2049ad4 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -542,7 +542,7 @@ config BLK_DEV_RSXX
 	  module will be called rsxx.
 
 config BLOCKCONSOLE
-	bool "Block device console logging support"
+	tristate "Block device console logging support"
 	help
 	  This enables logging to block devices.
 	  See <file:Documentation/block/blockconsole.txt> for details.
diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 86744cc..5fc192a 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -4,13 +4,13 @@
  * Copyright (C) 2012  Joern Engel <joern@logfs.org>
  */
 #include <linux/bio.h>
-#include <linux/blockconsole.h>
 #include <linux/console.h>
 #include <linux/fs.h>
 #include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/mm.h>
 #include <linux/mount.h>
+#include <linux/module.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
 #include <linux/ctype.h>
+#include "../../block/partitions/check.h"
 
 #define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"
 #define BCON_UUID_OFS		(32)
@@ -68,8 +69,15 @@ struct blockconsole {
 	struct work_struct release_work;
 	struct task_struct *writeback_thread;
 	struct notifier_block panic_block;
+	struct list_head list;
 };
 
+static DEFINE_SPINLOCK(bc_device_lock);
+static LIST_HEAD(bc_list_head);
+static atomic_t bc_list_count = ATOMIC_INIT(0);
+
+static int bcon_magic_present(const void *data);
+
 static void bcon_get(struct blockconsole *bc)
 {
 	kref_get(&bc->kref);
@@ -85,6 +93,7 @@ static void __bcon_release(struct work_struct *work)
 	invalidate_mapping_pages(bc->bdev->bd_inode->i_mapping, 0, -1);
 	blkdev_put(bc->bdev, FMODE_READ|FMODE_WRITE);
 	kfree(bc);
+	atomic_dec(&bc_list_count);
 }
 
 static void bcon_release(struct kref *kref)
@@ -285,6 +294,11 @@ static void bcon_unregister(struct work_struct *work)
 	del_timer_sync(&bc->pad_timer);
 	kthread_stop(bc->writeback_thread);
 	/* No new io will be scheduled anymore now */
+
+	spin_lock(&bc_device_lock);
+	list_del_init(&bc->list);
+	spin_unlock(&bc_device_lock);
+
 	bcon_put(bc);
 }
 
@@ -515,7 +529,13 @@ static int bcon_create(const char *devname)
 	bc->panic_block.notifier_call = blockconsole_panic;
 	bc->panic_block.priority = INT_MAX;
 	atomic_notifier_chain_register(&panic_notifier_list, &bc->panic_block);
+
+	spin_lock(&bc_device_lock);
+	list_add(&bc->list, &bc_list_head);
+	spin_unlock(&bc_device_lock);
+
 	pr_info("now logging to %s at %llx\n", devname, bc->console_bytes >> 20);
+	atomic_inc(&bc_list_count);
 
 	return 0;
 
@@ -546,13 +566,13 @@ static void bcon_create_fuzzy(const char *name)
 	}
 }
 
-static DEFINE_SPINLOCK(bc_device_lock);
 static char scanned_devices[80];
 
 static void bcon_do_add(struct work_struct *work)
 {
 	char local_devices[80], *name, *remainder = local_devices;
 
+	atomic_inc(&bc_list_count);
 	spin_lock(&bc_device_lock);
 	memcpy(local_devices, scanned_devices, sizeof(local_devices));
 	memset(scanned_devices, 0, sizeof(scanned_devices));
@@ -562,11 +582,12 @@ static void bcon_do_add(struct work_struct *work)
 		name = strsep(&remainder, ",");
 		bcon_create_fuzzy(name);
 	}
+	atomic_dec(&bc_list_count);
 }
 
 static DECLARE_WORK(bcon_add_work, bcon_do_add);
 
-void bcon_add(const char *name)
+static void bcon_add(const char *name)
 {
 	/*
 	 * We add each name to a small static buffer and ask for a workqueue
@@ -602,7 +623,7 @@ static bool is_four_byte_hex(const void *data)
 	return true;
 }
 
-int bcon_magic_present(const void *data)
+static int bcon_magic_present(const void *data)
 {
 	size_t len = strlen(BLOCKCONSOLE_MAGIC);
 
@@ -616,3 +637,58 @@ int bcon_magic_present(const void *data)
 		return 0;
 	return 11;
 }
+
+static int blockconsole_partition(struct parsed_partitions *state)
+{
+	Sector sect;
+	void *data;
+	int err = 0;
+
+	data = read_part_sector(state, 0, &sect);
+	if (!data)
+		return -EIO;
+	if (!bcon_magic_present(data))
+		goto out;
+
+	bcon_add(state->name);
+	err = 1;
+out:
+	put_dev_sector(sect);
+	return err;
+}
+
+static struct partition_checker bc_part_checker = {
+	.check = blockconsole_partition
+};
+
+static int __init bcon_module_init(void)
+{
+	append_partition_checker(&bc_part_checker);
+	return 0;
+}
+
+static void __exit bcon_module_exit(void)
+{
+	remove_partition_checker(&bc_part_checker);
+	cancel_work_sync(&bcon_add_work);
+
+	/* unregister all pending consoles */
+	spin_lock(&bc_device_lock);
+	while (!list_empty(&bc_list_head)) {
+		struct blockconsole *bc;
+		bc = list_first_entry(&bc_list_head, struct blockconsole, list);
+		schedule_work(&bc->unregister_work);
+		list_del_init(&bc->list);
+	}
+	spin_unlock(&bc_device_lock);
+
+	while (atomic_read(&bc_list_count)) {
+		flush_scheduled_work();
+		schedule_timeout(1);
+	}
+}
+
+MODULE_LICENSE("GPL");
+
+module_init(bcon_module_init);
+module_exit(bcon_module_exit);
diff --git a/include/linux/blockconsole.h b/include/linux/blockconsole.h
deleted file mode 100644
index 114f7c5..0000000
--- a/include/linux/blockconsole.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef LINUX_BLOCKCONSOLE_H
-#define LINUX_BLOCKCONSOLE_H
-
-int bcon_magic_present(const void *data);
-void bcon_add(const char *name);
-
-#endif
-- 
1.8.1.4

