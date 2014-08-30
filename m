Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaH3VNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:48 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51531 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaH3VNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:23 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 06/12] staging/lustre/obdclass: remove mea.c
Date: Sat, 30 Aug 2014 17:12:45 -0400
Message-Id: <1409433171-23572-7-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

The functions exported by lustre/obdclass/mea.c are not used so remove
them.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/obd_class.h |   4 -
 drivers/staging/lustre/lustre/obdclass/Makefile   |   2 +-
 drivers/staging/lustre/lustre/obdclass/mea.c      | 112 ----------------------
 3 files changed, 1 insertion(+), 117 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/mea.c

diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 4c64471..65143ab 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -2182,10 +2182,6 @@ int class_check_uuid(struct obd_uuid *uuid, __u64 nid);
 void class_init_uuidlist(void);
 void class_exit_uuidlist(void);
 
-/* mea.c */
-int mea_name2idx(struct lmv_stripe_md *mea, const char *name, int namelen);
-int raw_name2idx(int hashtype, int count, const char *name, int namelen);
-
 /* class_obd.c */
 extern char obd_jobid_node[];
 
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index 91a5a2b..f1dcf8e 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -5,5 +5,5 @@ obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      genops.o uuid.o llog_ioctl.o lprocfs_status.o		   \
 	      lustre_handles.o lustre_peer.o llog_osd.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
-	      mea.o lu_object.o dt_object.o capa.o cl_object.o   \
+	      lu_object.o dt_object.o capa.o cl_object.o   \
 	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o
diff --git a/drivers/staging/lustre/lustre/obdclass/mea.c b/drivers/staging/lustre/lustre/obdclass/mea.c
deleted file mode 100644
index d6ce084..0000000
--- a/drivers/staging/lustre/lustre/obdclass/mea.c
+++ /dev/null
@@ -1,112 +0,0 @@
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
- * Copyright (c) 2004, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#define DEBUG_SUBSYSTEM S_CLASS
-#include "../include/obd_class.h"
-#include <linux/kmod.h>   /* for request_module() */
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/pagemap.h>
-#include "../include/lprocfs_status.h"
-#include "../include/lustre/lustre_idl.h"
-
-static int mea_last_char_hash(int count, char *name, int namelen)
-{
-	unsigned int c;
-
-	c = name[namelen - 1];
-	if (c == 0)
-		CWARN("looks like wrong len is passed\n");
-	c = c % count;
-	return c;
-}
-
-static int mea_all_chars_hash(int count, char *name, int namelen)
-{
-	unsigned int c = 0;
-
-	while (--namelen >= 0)
-		c += name[namelen];
-	c = c % count;
-	return c;
-}
-
-int raw_name2idx(int hashtype, int count, const char *name, int namelen)
-{
-	unsigned int	c = 0;
-	int		idx;
-
-	LASSERT(namelen > 0);
-
-	if (filename_is_volatile(name, namelen, &idx)) {
-		if ((idx >= 0) && (idx < count))
-			return idx;
-		goto hashchoice;
-	}
-
-	if (count <= 1)
-		return 0;
-
-hashchoice:
-	switch (hashtype) {
-	case MEA_MAGIC_LAST_CHAR:
-		c = mea_last_char_hash(count, (char *)name, namelen);
-		break;
-	case MEA_MAGIC_ALL_CHARS:
-		c = mea_all_chars_hash(count, (char *)name, namelen);
-		break;
-	case MEA_MAGIC_HASH_SEGMENT:
-		CERROR("Unsupported hash type MEA_MAGIC_HASH_SEGMENT\n");
-		break;
-	default:
-		CERROR("Unknown hash type 0x%x\n", hashtype);
-	}
-
-	LASSERT(c < count);
-	return c;
-}
-EXPORT_SYMBOL(raw_name2idx);
-
-int mea_name2idx(struct lmv_stripe_md *mea, const char *name, int namelen)
-{
-	unsigned int c;
-
-	LASSERT(mea && mea->mea_count);
-
-	c = raw_name2idx(mea->mea_magic, mea->mea_count, name, namelen);
-
-	LASSERT(c < mea->mea_count);
-	return c;
-}
-EXPORT_SYMBOL(mea_name2idx);
-- 
1.9.3

