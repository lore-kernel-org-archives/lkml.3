Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaIISki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:15599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaIISkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725069"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, James Simmons <uja.ornl@gmail.com>,
        Mikhail Pershin <mike.pershin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 1/7] staging/lustre/lvfs: remove the lvfs layer
Date: Tue, 9 Sep 2014 13:39:02 -0500
Message-ID: <1410287948-13168-2-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

The lvfs layer is obsolete and unused by Lustre clients. So remove it
and integrate the last of the procfs code into the obdclass layer.

Signed-off-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/5512
Reviewed-by: Jian Yu <jian.yu@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/Makefile             |    2 +-
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |  172 ------------
 .../lustre/lustre/include/linux/lvfs_linux.h       |    2 -
 .../staging/lustre/lustre/include/lustre_fsfilt.h  |   48 ----
 drivers/staging/lustre/lustre/include/lustre_lib.h |    1 -
 drivers/staging/lustre/lustre/include/lvfs.h       |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |    1 -
 drivers/staging/lustre/lustre/lvfs/Makefile        |    4 -
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |  139 ---------
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |  170 -----------
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |  297 --------------------
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +
 .../lustre/lustre/obdclass/lprocfs_counters.c      |  139 +++++++++
 .../lustre/lustre/obdclass/lprocfs_status.c        |   79 ++++++
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |    1 -
 15 files changed, 222 insertions(+), 839 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/Makefile
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_counters.c

diff --git a/drivers/staging/lustre/lustre/Makefile b/drivers/staging/lustre/lustre/Makefile
index d1eb0bd..35d8b0b 100644
--- a/drivers/staging/lustre/lustre/Makefile
+++ b/drivers/staging/lustre/lustre/Makefile
@@ -1,2 +1,2 @@
-obj-$(CONFIG_LUSTRE_FS) += libcfs/ lvfs/ obdclass/ ptlrpc/ fld/ osc/ mgc/ \
+obj-$(CONFIG_LUSTRE_FS) += libcfs/ obdclass/ ptlrpc/ fld/ osc/ mgc/ \
 			   fid/ lov/ mdc/ lmv/ llite/ obdecho/
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h b/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
deleted file mode 100644
index 18c06fb..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
+++ /dev/null
@@ -1,172 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/linux/lustre_fsfilt.h
- *
- * Filesystem interface helper.
- */
-
-#ifndef _LINUX_LUSTRE_FSFILT_H
-#define _LINUX_LUSTRE_FSFILT_H
-
-#ifndef _LUSTRE_FSFILT_H
-#error Do not #include this file directly. #include <lustre_fsfilt.h> instead
-#endif
-
-
-#include "../obd.h"
-#include "../obd_class.h"
-
-typedef void (*fsfilt_cb_t)(struct obd_device *obd, __u64 last_rcvd,
-			    void *data, int error);
-
-struct fsfilt_operations {
-	struct list_head fs_list;
-	struct module *fs_owner;
-	char   *fs_type;
-	char   *(* fs_getlabel)(struct super_block *sb);
-	void   *(* fs_start)(struct inode *inode, int op, void *desc_private,
-			     int logs);
-	int     (*fs_commit)(struct inode *inode, void *handle, int force_sync);
-	int     (* fs_map_inode_pages)(struct inode *inode, struct page **page,
-				       int pages, unsigned long *blocks,
-				       int create, struct mutex *sem);
-	int     (* fs_write_record)(struct file *, void *, int size, loff_t *,
-				    int force_sync);
-	int     (* fs_read_record)(struct file *, void *, int size, loff_t *);
-	int     (* fs_setup)(struct super_block *sb);
-};
-
-extern int fsfilt_register_ops(struct fsfilt_operations *fs_ops);
-extern void fsfilt_unregister_ops(struct fsfilt_operations *fs_ops);
-extern struct fsfilt_operations *fsfilt_get_ops(const char *type);
-extern void fsfilt_put_ops(struct fsfilt_operations *fs_ops);
-
-static inline char *fsfilt_get_label(struct obd_device *obd,
-				     struct super_block *sb)
-{
-	if (obd->obd_fsops->fs_getlabel == NULL)
-		return NULL;
-	if (obd->obd_fsops->fs_getlabel(sb)[0] == '\0')
-		return NULL;
-
-	return obd->obd_fsops->fs_getlabel(sb);
-}
-
-#define FSFILT_OP_UNLINK		1
-#define FSFILT_OP_CANCEL_UNLINK	 10
-
-#define __fsfilt_check_slow(obd, start, msg)			      \
-do {								      \
-	if (time_before(jiffies, start + 15 * HZ))		\
-		break;						    \
-	else if (time_before(jiffies, start + 30 * HZ))	   \
-		CDEBUG(D_VFSTRACE, "%s: slow %s %lus\n", obd->obd_name,   \
-		       msg, (jiffies-start) / HZ);		    \
-	else if (time_before(jiffies, start + DISK_TIMEOUT * HZ)) \
-		CWARN("%s: slow %s %lus\n", obd->obd_name, msg,	   \
-		      (jiffies - start) / HZ);			\
-	else							      \
-		CERROR("%s: slow %s %lus\n", obd->obd_name, msg,	  \
-		       (jiffies - start) / HZ);		       \
-} while (0)
-
-#define fsfilt_check_slow(obd, start, msg)	      \
-do {						    \
-	__fsfilt_check_slow(obd, start, msg);	   \
-	start = jiffies;				\
-} while (0)
-
-static inline void *fsfilt_start_log(struct obd_device *obd,
-				     struct inode *inode, int op,
-				     struct obd_trans_info *oti, int logs)
-{
-	unsigned long now = jiffies;
-	void *parent_handle = oti ? oti->oti_handle : NULL;
-	void *handle;
-
-	handle = obd->obd_fsops->fs_start(inode, op, parent_handle, logs);
-	CDEBUG(D_INFO, "started handle %p (%p)\n", handle, parent_handle);
-
-	if (oti != NULL) {
-		if (parent_handle == NULL) {
-			oti->oti_handle = handle;
-		} else if (handle != parent_handle) {
-			CERROR("mismatch: parent %p, handle %p, oti %p\n",
-			       parent_handle, handle, oti);
-			LBUG();
-		}
-	}
-	fsfilt_check_slow(obd, now, "journal start");
-	return handle;
-}
-
-static inline int fsfilt_commit(struct obd_device *obd, struct inode *inode,
-				void *handle, int force_sync)
-{
-	unsigned long now = jiffies;
-	int rc = obd->obd_fsops->fs_commit(inode, handle, force_sync);
-	CDEBUG(D_INFO, "committing handle %p\n", handle);
-
-	fsfilt_check_slow(obd, now, "journal start");
-
-	return rc;
-}
-
-static inline int fsfilt_read_record(struct obd_device *obd, struct file *file,
-				     void *buf, loff_t size, loff_t *offs)
-{
-	return obd->obd_fsops->fs_read_record(file, buf, size, offs);
-}
-
-static inline int fsfilt_write_record(struct obd_device *obd, struct file *file,
-				      void *buf, loff_t size, loff_t *offs,
-				      int force_sync)
-{
-	return obd->obd_fsops->fs_write_record(file, buf, size, offs,
-					       force_sync);
-}
-
-static inline int fsfilt_setup(struct obd_device *obd, struct super_block *fs)
-{
-	if (obd->obd_fsops->fs_setup)
-		return obd->obd_fsops->fs_setup(fs);
-	return 0;
-}
-
-
-
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h b/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
index fff22ec..01e01ad 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
@@ -44,8 +44,6 @@
 #include "../lvfs.h"
 
 struct lvfs_run_ctxt;
-struct file *l_dentry_open(struct lvfs_run_ctxt *, struct dentry *,
-			     int flags);
 
 struct l_linux_dirent {
 	struct list_head      lld_list;
diff --git a/drivers/staging/lustre/lustre/include/lustre_fsfilt.h b/drivers/staging/lustre/lustre/include/lustre_fsfilt.h
deleted file mode 100644
index 9749c3f..0000000
--- a/drivers/staging/lustre/lustre/include/lustre_fsfilt.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2005, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/lustre_fsfilt.h
- *
- * Filesystem interface helper.
- */
-
-#ifndef _LUSTRE_FSFILT_H
-#define _LUSTRE_FSFILT_H
-
-#include "../include/linux/lustre_fsfilt.h"
-
-#define LU221_BAD_TIME (0x80000000U + 24 * 3600)
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index ca2dbab..12c7590 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -62,7 +62,6 @@ struct lu_target;
 struct l_wait_info;
 #include "lustre_ha.h"
 #include "lustre_net.h"
-#include "lvfs.h"
 
 #define LI_POISON 0x5a5a5a5a
 #if BITS_PER_LONG > 32
diff --git a/drivers/staging/lustre/lustre/include/lvfs.h b/drivers/staging/lustre/lustre/include/lvfs.h
index 32dcd57..f91907c 100644
--- a/drivers/staging/lustre/lustre/include/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/lvfs.h
@@ -47,9 +47,7 @@
 #include "../../include/linux/libcfs/lucache.h"
 
 
-/* lvfs_common.c */
-struct dentry *lvfs_fid2dentry(struct lvfs_run_ctxt *, __u64, __u32, __u64 ,void *data);
-
+/* lvfs_linux.c */
 void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
 	       struct lvfs_ucred *cred);
 void pop_ctxt(struct lvfs_run_ctxt *saved, struct lvfs_run_ctxt *new_ctx,
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 66fc457..b29f7fc 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -883,7 +883,6 @@ struct obd_device {
 	spinlock_t		obd_dev_lock; /* protect OBD bitfield above */
 	struct mutex		obd_dev_mutex;
 	__u64			obd_last_committed;
-	struct fsfilt_operations *obd_fsops;
 	spinlock_t		obd_osfs_lock;
 	struct obd_statfs	obd_osfs;       /* locked by obd_osfs_lock */
 	__u64			obd_osfs_age;
diff --git a/drivers/staging/lustre/lustre/lvfs/Makefile b/drivers/staging/lustre/lustre/lvfs/Makefile
deleted file mode 100644
index 387eee3..0000000
--- a/drivers/staging/lustre/lustre/lvfs/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-obj-$(CONFIG_LUSTRE_FS) += lvfs.o
-
-lvfs-y := lvfs_linux.o fsfilt.o
-lvfs-$(CONFIG_PROC_FS) += lvfs_lib.o
diff --git a/drivers/staging/lustre/lustre/lvfs/fsfilt.c b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
deleted file mode 100644
index a4df056..0000000
--- a/drivers/staging/lustre/lustre/lvfs/fsfilt.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#define DEBUG_SUBSYSTEM S_FILTER
-
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/kmod.h>
-#include <linux/slab.h>
-#include "../../include/linux/libcfs/libcfs.h"
-#include "../include/lustre_fsfilt.h"
-
-LIST_HEAD(fsfilt_types);
-
-static struct fsfilt_operations *fsfilt_search_type(const char *type)
-{
-	struct fsfilt_operations *found;
-	struct list_head *p;
-
-	list_for_each(p, &fsfilt_types) {
-		found = list_entry(p, struct fsfilt_operations, fs_list);
-		if (!strcmp(found->fs_type, type))
-			return found;
-	}
-	return NULL;
-}
-
-int fsfilt_register_ops(struct fsfilt_operations *fs_ops)
-{
-	struct fsfilt_operations *found;
-
-	/* lock fsfilt_types list */
-	found = fsfilt_search_type(fs_ops->fs_type);
-	if (found) {
-		if (found != fs_ops) {
-			CERROR("different operations for type %s\n",
-			       fs_ops->fs_type);
-			/* unlock fsfilt_types list */
-			return -EEXIST;
-		}
-	} else {
-		try_module_get(THIS_MODULE);
-		list_add(&fs_ops->fs_list, &fsfilt_types);
-	}
-
-	/* unlock fsfilt_types list */
-	return 0;
-}
-EXPORT_SYMBOL(fsfilt_register_ops);
-
-void fsfilt_unregister_ops(struct fsfilt_operations *fs_ops)
-{
-	struct list_head *p;
-
-	/* lock fsfilt_types list */
-	list_for_each(p, &fsfilt_types) {
-		struct fsfilt_operations *found;
-
-		found = list_entry(p, typeof(*found), fs_list);
-		if (found == fs_ops) {
-			list_del(p);
-			module_put(THIS_MODULE);
-			break;
-		}
-	}
-	/* unlock fsfilt_types list */
-}
-EXPORT_SYMBOL(fsfilt_unregister_ops);
-
-struct fsfilt_operations *fsfilt_get_ops(const char *type)
-{
-	struct fsfilt_operations *fs_ops;
-
-	/* lock fsfilt_types list */
-	fs_ops = fsfilt_search_type(type);
-	if (!fs_ops) {
-		char name[32];
-		int rc;
-
-		snprintf(name, sizeof(name) - 1, "fsfilt_%s", type);
-		name[sizeof(name) - 1] = '\0';
-
-		rc = request_module("%s", name);
-		if (!rc) {
-			fs_ops = fsfilt_search_type(type);
-			CDEBUG(D_INFO, "Loaded module '%s'\n", name);
-			if (!fs_ops)
-				rc = -ENOENT;
-		}
-
-		if (rc) {
-			CERROR("Can't find %s interface\n", name);
-			return ERR_PTR(rc < 0 ? rc : -rc);
-			/* unlock fsfilt_types list */
-		}
-	}
-	try_module_get(fs_ops->fs_owner);
-	/* unlock fsfilt_types list */
-
-	return fs_ops;
-}
-EXPORT_SYMBOL(fsfilt_get_ops);
-
-void fsfilt_put_ops(struct fsfilt_operations *fs_ops)
-{
-	module_put(fs_ops->fs_owner);
-}
-EXPORT_SYMBOL(fsfilt_put_ops);
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
deleted file mode 100644
index cfc4f89..0000000
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/lvfs/lvfs_lib.c
- *
- * Lustre filesystem abstraction routines
- *
- * Author: Andreas Dilger <adilger@clusterfs.com>
- */
-#include <linux/module.h>
-#include "../include/lustre_lib.h"
-#include "../include/lprocfs_status.h"
-
-void lprocfs_counter_add(struct lprocfs_stats *stats, int idx, long amount)
-{
-	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*header;
-	int				smp_id;
-	unsigned long			flags = 0;
-
-	if (stats == NULL)
-		return;
-
-	/* With per-client stats, statistics are allocated only for
-	 * single CPU area, so the smp_id should be 0 always. */
-	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
-	if (smp_id < 0)
-		return;
-
-	header = &stats->ls_cnt_header[idx];
-	percpu_cntr = lprocfs_stats_counter_get(stats, smp_id, idx);
-	percpu_cntr->lc_count++;
-
-	if (header->lc_config & LPROCFS_CNTR_AVGMINMAX) {
-		/*
-		 * lprocfs_counter_add() can be called in interrupt context,
-		 * as memory allocation could trigger memory shrinker call
-		 * ldlm_pool_shrink(), which calls lprocfs_counter_add().
-		 * LU-1727.
-		 *
-		 * Only obd_memory uses LPROCFS_STATS_FLAG_IRQ_SAFE
-		 * flag, because it needs accurate counting lest memory leak
-		 * check reports error.
-		 */
-		if (in_interrupt() &&
-		    (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
-			percpu_cntr->lc_sum_irq += amount;
-		else
-			percpu_cntr->lc_sum += amount;
-
-		if (header->lc_config & LPROCFS_CNTR_STDDEV)
-			percpu_cntr->lc_sumsquare += (__s64)amount * amount;
-		if (amount < percpu_cntr->lc_min)
-			percpu_cntr->lc_min = amount;
-		if (amount > percpu_cntr->lc_max)
-			percpu_cntr->lc_max = amount;
-	}
-	lprocfs_stats_unlock(stats, LPROCFS_GET_SMP_ID, &flags);
-}
-EXPORT_SYMBOL(lprocfs_counter_add);
-
-void lprocfs_counter_sub(struct lprocfs_stats *stats, int idx, long amount)
-{
-	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*header;
-	int				smp_id;
-	unsigned long			flags = 0;
-
-	if (stats == NULL)
-		return;
-
-	/* With per-client stats, statistics are allocated only for
-	 * single CPU area, so the smp_id should be 0 always. */
-	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
-	if (smp_id < 0)
-		return;
-
-	header = &stats->ls_cnt_header[idx];
-	percpu_cntr = lprocfs_stats_counter_get(stats, smp_id, idx);
-	if (header->lc_config & LPROCFS_CNTR_AVGMINMAX) {
-		/*
-		 * Sometimes we use RCU callbacks to free memory which calls
-		 * lprocfs_counter_sub(), and RCU callbacks may execute in
-		 * softirq context - right now that's the only case we're in
-		 * softirq context here, use separate counter for that.
-		 * bz20650.
-		 *
-		 * Only obd_memory uses LPROCFS_STATS_FLAG_IRQ_SAFE
-		 * flag, because it needs accurate counting lest memory leak
-		 * check reports error.
-		 */
-		if (in_interrupt() &&
-		    (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
-			percpu_cntr->lc_sum_irq -= amount;
-		else
-			percpu_cntr->lc_sum -= amount;
-	}
-	lprocfs_stats_unlock(stats, LPROCFS_GET_SMP_ID, &flags);
-}
-EXPORT_SYMBOL(lprocfs_counter_sub);
-
-int lprocfs_stats_alloc_one(struct lprocfs_stats *stats, unsigned int cpuid)
-{
-	struct lprocfs_counter	*cntr;
-	unsigned int		percpusize;
-	int			rc = -ENOMEM;
-	unsigned long		flags = 0;
-	int			i;
-
-	LASSERT(stats->ls_percpu[cpuid] == NULL);
-	LASSERT((stats->ls_flags & LPROCFS_STATS_FLAG_NOPERCPU) == 0);
-
-	percpusize = lprocfs_stats_counter_size(stats);
-	LIBCFS_ALLOC_ATOMIC(stats->ls_percpu[cpuid], percpusize);
-	if (stats->ls_percpu[cpuid] != NULL) {
-		rc = 0;
-		if (unlikely(stats->ls_biggest_alloc_num <= cpuid)) {
-			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE)
-				spin_lock_irqsave(&stats->ls_lock, flags);
-			else
-				spin_lock(&stats->ls_lock);
-			if (stats->ls_biggest_alloc_num <= cpuid)
-				stats->ls_biggest_alloc_num = cpuid + 1;
-			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE)
-				spin_unlock_irqrestore(&stats->ls_lock, flags);
-			else
-				spin_unlock(&stats->ls_lock);
-		}
-		/* initialize the ls_percpu[cpuid] non-zero counter */
-		for (i = 0; i < stats->ls_num; ++i) {
-			cntr = lprocfs_stats_counter_get(stats, cpuid, i);
-			cntr->lc_min = LC_MIN_INIT;
-		}
-	}
-
-	return rc;
-}
-EXPORT_SYMBOL(lprocfs_stats_alloc_one);
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
deleted file mode 100644
index d9209b9..0000000
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ /dev/null
@@ -1,297 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/lvfs/lvfs_linux.c
- *
- * Author: Andreas Dilger <adilger@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_FILTER
-
-#include <linux/fs.h>
-#include <asm/unistd.h>
-#include <linux/slab.h>
-#include <linux/pagemap.h>
-#include <linux/quotaops.h>
-#include <linux/module.h>
-#include "../../include/linux/libcfs/libcfs.h"
-#include "../include/linux/lustre_compat25.h"
-#include "../include/lvfs.h"
-
-#include "../include/obd.h"
-#include "../include/lustre_lib.h"
-
-struct lprocfs_stats *obd_memory = NULL;
-EXPORT_SYMBOL(obd_memory);
-/* refine later and change to seqlock or similar from libcfs */
-
-/* Debugging check only needed during development */
-#ifdef OBD_CTXT_DEBUG
-# define ASSERT_CTXT_MAGIC(magic) LASSERT((magic) == OBD_RUN_CTXT_MAGIC)
-# define ASSERT_NOT_KERNEL_CTXT(msg) LASSERTF(!segment_eq(get_fs(), get_ds()),\
-					      msg)
-# define ASSERT_KERNEL_CTXT(msg) LASSERTF(segment_eq(get_fs(), get_ds()), msg)
-#else
-# define ASSERT_CTXT_MAGIC(magic) do {} while (0)
-# define ASSERT_NOT_KERNEL_CTXT(msg) do {} while (0)
-# define ASSERT_KERNEL_CTXT(msg) do {} while (0)
-#endif
-
-static void push_group_info(struct lvfs_run_ctxt *save,
-			    struct group_info *ginfo)
-{
-	if (!ginfo) {
-		save->ngroups = current_ngroups;
-		current_ngroups = 0;
-	} else {
-		struct cred *cred;
-		task_lock(current);
-		save->group_info = current_cred()->group_info;
-		cred = prepare_creds();
-		if (cred) {
-			cred->group_info = ginfo;
-			commit_creds(cred);
-		}
-		task_unlock(current);
-	}
-}
-
-static void pop_group_info(struct lvfs_run_ctxt *save,
-			   struct group_info *ginfo)
-{
-	if (!ginfo) {
-		current_ngroups = save->ngroups;
-	} else {
-		struct cred *cred;
-		task_lock(current);
-		cred = prepare_creds();
-		if (cred) {
-			cred->group_info = save->group_info;
-			commit_creds(cred);
-		}
-		task_unlock(current);
-	}
-}
-
-/* push / pop to root of obd store */
-void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
-	       struct lvfs_ucred *uc)
-{
-	/* if there is underlaying dt_device then push_ctxt is not needed */
-	if (new_ctx->dt != NULL)
-		return;
-
-	/* ASSERT_NOT_KERNEL_CTXT("already in kernel context!\n"); */
-	ASSERT_CTXT_MAGIC(new_ctx->magic);
-	OBD_SET_CTXT_MAGIC(save);
-
-	save->fs = get_fs();
-	LASSERT(d_count(cfs_fs_pwd(current->fs)));
-	LASSERT(d_count(new_ctx->pwd));
-	save->pwd = dget(cfs_fs_pwd(current->fs));
-	save->pwdmnt = mntget(cfs_fs_mnt(current->fs));
-	save->luc.luc_umask = current_umask();
-	save->ngroups = current_cred()->group_info->ngroups;
-
-	LASSERT(save->pwd);
-	LASSERT(save->pwdmnt);
-	LASSERT(new_ctx->pwd);
-	LASSERT(new_ctx->pwdmnt);
-
-	if (uc) {
-		struct cred *cred;
-		save->luc.luc_uid = current_uid();
-		save->luc.luc_gid = current_gid();
-		save->luc.luc_fsuid = current_fsuid();
-		save->luc.luc_fsgid = current_fsgid();
-		save->luc.luc_cap = current_cap();
-
-		cred = prepare_creds();
-		if (cred) {
-			cred->uid = uc->luc_uid;
-			cred->gid = uc->luc_gid;
-			cred->fsuid = uc->luc_fsuid;
-			cred->fsgid = uc->luc_fsgid;
-			cred->cap_effective = uc->luc_cap;
-			commit_creds(cred);
-		}
-
-		push_group_info(save,
-				uc->luc_ginfo ?:
-				uc->luc_identity ? uc->luc_identity->mi_ginfo :
-						   NULL);
-	}
-	current->fs->umask = 0; /* umask already applied on client */
-	set_fs(new_ctx->fs);
-	ll_set_fs_pwd(current->fs, new_ctx->pwdmnt, new_ctx->pwd);
-}
-EXPORT_SYMBOL(push_ctxt);
-
-void pop_ctxt(struct lvfs_run_ctxt *saved, struct lvfs_run_ctxt *new_ctx,
-	      struct lvfs_ucred *uc)
-{
-	/* if there is underlaying dt_device then pop_ctxt is not needed */
-	if (new_ctx->dt != NULL)
-		return;
-
-	ASSERT_CTXT_MAGIC(saved->magic);
-	ASSERT_KERNEL_CTXT("popping non-kernel context!\n");
-
-	LASSERTF(cfs_fs_pwd(current->fs) == new_ctx->pwd, "%p != %p\n",
-		 cfs_fs_pwd(current->fs), new_ctx->pwd);
-	LASSERTF(cfs_fs_mnt(current->fs) == new_ctx->pwdmnt, "%p != %p\n",
-		 cfs_fs_mnt(current->fs), new_ctx->pwdmnt);
-
-	set_fs(saved->fs);
-	ll_set_fs_pwd(current->fs, saved->pwdmnt, saved->pwd);
-
-	dput(saved->pwd);
-	mntput(saved->pwdmnt);
-	current->fs->umask = saved->luc.luc_umask;
-	if (uc) {
-		struct cred *cred;
-		cred = prepare_creds();
-		if (cred) {
-			cred->uid = saved->luc.luc_uid;
-			cred->gid = saved->luc.luc_gid;
-			cred->fsuid = saved->luc.luc_fsuid;
-			cred->fsgid = saved->luc.luc_fsgid;
-			cred->cap_effective = saved->luc.luc_cap;
-			commit_creds(cred);
-		}
-
-		pop_group_info(saved,
-			       uc->luc_ginfo ?:
-			       uc->luc_identity ? uc->luc_identity->mi_ginfo :
-						  NULL);
-	}
-}
-EXPORT_SYMBOL(pop_ctxt);
-
-/* utility to rename a file */
-int lustre_rename(struct dentry *dir, struct vfsmount *mnt,
-		  char *oldname, char *newname)
-{
-	struct dentry *dchild_old, *dchild_new;
-	int err = 0;
-
-	ASSERT_KERNEL_CTXT("kernel doing rename outside kernel context\n");
-	CDEBUG(D_INODE, "renaming file %.*s to %.*s\n",
-	       (int)strlen(oldname), oldname, (int)strlen(newname), newname);
-
-	dchild_old = ll_lookup_one_len(oldname, dir, strlen(oldname));
-	if (IS_ERR(dchild_old))
-		return PTR_ERR(dchild_old);
-
-	if (!dchild_old->d_inode) {
-		err = -ENOENT;
-		goto put_old;
-	}
-
-	dchild_new = ll_lookup_one_len(newname, dir, strlen(newname));
-	if (IS_ERR(dchild_new)) {
-		err = PTR_ERR(dchild_new);
-		goto put_old;
-	}
-
-	err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
-			    dir->d_inode, dchild_new, mnt);
-
-	dput(dchild_new);
-put_old:
-	dput(dchild_old);
-	return err;
-}
-EXPORT_SYMBOL(lustre_rename);
-
-/* Note: dput(dchild) will *not* be called if there is an error */
-struct file *l_dentry_open(struct lvfs_run_ctxt *ctxt, struct dentry *de,
-			   int flags)
-{
-	struct path path = {
-		.dentry = de,
-		.mnt = ctxt->pwdmnt,
-	};
-	return dentry_open(&path, flags, current_cred());
-}
-EXPORT_SYMBOL(l_dentry_open);
-
-#if defined (CONFIG_PROC_FS)
-__s64 lprocfs_read_helper(struct lprocfs_counter *lc,
-			  struct lprocfs_counter_header *header,
-			  enum lprocfs_stats_flags flags,
-			  enum lprocfs_fields_flags field)
-{
-	__s64 ret = 0;
-
-	if (lc == NULL || header == NULL)
-		return 0;
-
-	switch (field) {
-	case LPROCFS_FIELDS_FLAGS_CONFIG:
-		ret = header->lc_config;
-		break;
-	case LPROCFS_FIELDS_FLAGS_SUM:
-		ret = lc->lc_sum;
-		if ((flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
-			ret += lc->lc_sum_irq;
-		break;
-	case LPROCFS_FIELDS_FLAGS_MIN:
-		ret = lc->lc_min;
-		break;
-	case LPROCFS_FIELDS_FLAGS_MAX:
-		ret = lc->lc_max;
-		break;
-	case LPROCFS_FIELDS_FLAGS_AVG:
-		ret = (lc->lc_max - lc->lc_min) / 2;
-		break;
-	case LPROCFS_FIELDS_FLAGS_SUMSQUARE:
-		ret = lc->lc_sumsquare;
-		break;
-	case LPROCFS_FIELDS_FLAGS_COUNT:
-		ret = lc->lc_count;
-		break;
-	default:
-		break;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(lprocfs_read_helper);
-#endif /* CONFIG_PROC_FS*/
-
-MODULE_AUTHOR("Sun Microsystems, Inc. <http://www.lustre.org/>");
-MODULE_DESCRIPTION("Lustre VFS Filesystem Helper v0.1");
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index bf77532..e894681 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -7,3 +7,5 @@ obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      statfs_pack.o obdo.o obd_config.o obd_mount.o \
 	      lu_object.o dt_object.o capa.o cl_object.o   \
 	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o
+
+obdclass-$(CONFIG_PROC_FS) += lprocfs_counters.o
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_counters.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_counters.c
new file mode 100644
index 0000000..c49dfe5
--- /dev/null
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_counters.c
@@ -0,0 +1,139 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ *
+ * http://www.gnu.org/licenses/gpl-2.0.html
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
+ * Use is subject to license terms.
+ *
+ * Copyright (c) 2012, 2013, Intel Corporation.
+ */
+/*
+ * This file is part of Lustre, http://www.lustre.org/
+ * Lustre is a trademark of Sun Microsystems, Inc.
+ *
+ * lustre/obdclass/lprocfs_counters.c
+ *
+ * Lustre lprocfs counter routines
+ *
+ * Author: Andreas Dilger <andreas.dilger@intel.com>
+ */
+
+#include <linux/module.h>
+#include "../include/lprocfs_status.h"
+#include "../include/obd_support.h"
+
+struct lprocfs_stats *obd_memory = NULL;
+EXPORT_SYMBOL(obd_memory);
+
+void lprocfs_counter_add(struct lprocfs_stats *stats, int idx, long amount)
+{
+	struct lprocfs_counter		*percpu_cntr;
+	struct lprocfs_counter_header	*header;
+	int				smp_id;
+	unsigned long			flags = 0;
+
+	if (stats == NULL)
+		return;
+
+	LASSERTF(0 <= idx && idx < stats->ls_num,
+		 "idx %d, ls_num %hu\n", idx, stats->ls_num);
+
+	/* With per-client stats, statistics are allocated only for
+	 * single CPU area, so the smp_id should be 0 always. */
+	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
+	if (smp_id < 0)
+		return;
+
+	header = &stats->ls_cnt_header[idx];
+	percpu_cntr = lprocfs_stats_counter_get(stats, smp_id, idx);
+	percpu_cntr->lc_count++;
+
+	if (header->lc_config & LPROCFS_CNTR_AVGMINMAX) {
+		/*
+		 * lprocfs_counter_add() can be called in interrupt context,
+		 * as memory allocation could trigger memory shrinker call
+		 * ldlm_pool_shrink(), which calls lprocfs_counter_add().
+		 * LU-1727.
+		 *
+		 * Only obd_memory uses LPROCFS_STATS_FLAG_IRQ_SAFE
+		 * flag, because it needs accurate counting lest memory leak
+		 * check reports error.
+		 */
+		if (in_interrupt() &&
+		    (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
+			percpu_cntr->lc_sum_irq += amount;
+		else
+			percpu_cntr->lc_sum += amount;
+
+		if (header->lc_config & LPROCFS_CNTR_STDDEV)
+			percpu_cntr->lc_sumsquare += (__s64)amount * amount;
+		if (amount < percpu_cntr->lc_min)
+			percpu_cntr->lc_min = amount;
+		if (amount > percpu_cntr->lc_max)
+			percpu_cntr->lc_max = amount;
+	}
+	lprocfs_stats_unlock(stats, LPROCFS_GET_SMP_ID, &flags);
+}
+EXPORT_SYMBOL(lprocfs_counter_add);
+
+void lprocfs_counter_sub(struct lprocfs_stats *stats, int idx, long amount)
+{
+	struct lprocfs_counter		*percpu_cntr;
+	struct lprocfs_counter_header	*header;
+	int				smp_id;
+	unsigned long			flags = 0;
+
+	if (stats == NULL)
+		return;
+
+	LASSERTF(0 <= idx && idx < stats->ls_num,
+		 "idx %d, ls_num %hu\n", idx, stats->ls_num);
+
+	/* With per-client stats, statistics are allocated only for
+	 * single CPU area, so the smp_id should be 0 always. */
+	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
+	if (smp_id < 0)
+		return;
+
+	header = &stats->ls_cnt_header[idx];
+	percpu_cntr = lprocfs_stats_counter_get(stats, smp_id, idx);
+	if (header->lc_config & LPROCFS_CNTR_AVGMINMAX) {
+		/*
+		 * Sometimes we use RCU callbacks to free memory which calls
+		 * lprocfs_counter_sub(), and RCU callbacks may execute in
+		 * softirq context - right now that's the only case we're in
+		 * softirq context here, use separate counter for that.
+		 * bz20650.
+		 *
+		 * Only obd_memory uses LPROCFS_STATS_FLAG_IRQ_SAFE
+		 * flag, because it needs accurate counting lest memory leak
+		 * check reports error.
+		 */
+		if (in_interrupt() &&
+		    (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
+			percpu_cntr->lc_sum_irq -= amount;
+		else
+			percpu_cntr->lc_sum -= amount;
+	}
+	lprocfs_stats_unlock(stats, LPROCFS_GET_SMP_ID, &flags);
+}
+EXPORT_SYMBOL(lprocfs_counter_sub);
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 0327bc1..61e04af 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1014,6 +1014,43 @@ void lprocfs_free_per_client_stats(struct obd_device *obd)
 }
 EXPORT_SYMBOL(lprocfs_free_per_client_stats);
 
+int lprocfs_stats_alloc_one(struct lprocfs_stats *stats, unsigned int cpuid)
+{
+	struct lprocfs_counter  *cntr;
+	unsigned int            percpusize;
+	int                     rc = -ENOMEM;
+	unsigned long           flags = 0;
+	int                     i;
+
+	LASSERT(stats->ls_percpu[cpuid] == NULL);
+	LASSERT((stats->ls_flags & LPROCFS_STATS_FLAG_NOPERCPU) == 0);
+
+	percpusize = lprocfs_stats_counter_size(stats);
+	LIBCFS_ALLOC_ATOMIC(stats->ls_percpu[cpuid], percpusize);
+	if (stats->ls_percpu[cpuid] != NULL) {
+		rc = 0;
+		if (unlikely(stats->ls_biggest_alloc_num <= cpuid)) {
+			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE)
+				spin_lock_irqsave(&stats->ls_lock, flags);
+			else
+				spin_lock(&stats->ls_lock);
+			if (stats->ls_biggest_alloc_num <= cpuid)
+				stats->ls_biggest_alloc_num = cpuid + 1;
+			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE)
+				spin_unlock_irqrestore(&stats->ls_lock, flags);
+			else
+				spin_unlock(&stats->ls_lock);
+		}
+		/* initialize the ls_percpu[cpuid] non-zero counter */
+		for (i = 0; i < stats->ls_num; ++i) {
+			cntr = lprocfs_stats_counter_get(stats, cpuid, i);
+			cntr->lc_min = LC_MIN_INIT;
+		}
+	}
+	return rc;
+}
+EXPORT_SYMBOL(lprocfs_stats_alloc_one);
+
 struct lprocfs_stats *lprocfs_alloc_stats(unsigned int num,
 					  enum lprocfs_stats_flags flags)
 {
@@ -1740,6 +1777,48 @@ int lprocfs_exp_cleanup(struct obd_export *exp)
 }
 EXPORT_SYMBOL(lprocfs_exp_cleanup);
 
+__s64 lprocfs_read_helper(struct lprocfs_counter *lc,
+			  struct lprocfs_counter_header *header,
+			  enum lprocfs_stats_flags flags,
+			  enum lprocfs_fields_flags field)
+{
+	__s64 ret = 0;
+
+	if (lc == NULL || header == NULL)
+		return 0;
+
+	switch (field) {
+	case LPROCFS_FIELDS_FLAGS_CONFIG:
+		ret = header->lc_config;
+		break;
+	case LPROCFS_FIELDS_FLAGS_SUM:
+		ret = lc->lc_sum;
+		if ((flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
+			ret += lc->lc_sum_irq;
+		break;
+	case LPROCFS_FIELDS_FLAGS_MIN:
+		ret = lc->lc_min;
+		break;
+	case LPROCFS_FIELDS_FLAGS_MAX:
+		ret = lc->lc_max;
+		break;
+	case LPROCFS_FIELDS_FLAGS_AVG:
+		ret = (lc->lc_max - lc->lc_min) / 2;
+		break;
+	case LPROCFS_FIELDS_FLAGS_SUMSQUARE:
+		ret = lc->lc_sumsquare;
+		break;
+	case LPROCFS_FIELDS_FLAGS_COUNT:
+		ret = lc->lc_count;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(lprocfs_read_helper);
+
 int lprocfs_write_helper(const char *buffer, unsigned long count,
 			 int *val)
 {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_net.c b/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
index e9052bb..1d996ca 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
@@ -52,7 +52,6 @@
 #include "../include/lustre_log.h"
 #include <linux/list.h>
 #include "../include/lvfs.h"
-#include "../include/lustre_fsfilt.h"
 
 int llog_initiator_connect(struct llog_ctxt *ctxt)
 {
-- 
1.7.9.5

