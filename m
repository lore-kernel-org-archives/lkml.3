Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaH1Xgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:35781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaH1Xga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="473631509"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 06/11] staging/lustre: remove linux/lustre_lib.h
Date: Thu, 28 Aug 2014 18:35:14 -0500
Message-ID: <1409268919-16155-7-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Inline the only call to inode_init_lvb(). Move some definitions from
lustre/include/linux/lustre_lib.h to lustre/include/lustre_lib.h and
remove the first header.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_lib.h       |   85 --------------------
 drivers/staging/lustre/lustre/include/lustre_lib.h |   17 +++-
 drivers/staging/lustre/lustre/llite/file.c         |    7 +-
 3 files changed, 22 insertions(+), 87 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_lib.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_lib.h b/drivers/staging/lustre/lustre/include/linux/lustre_lib.h
deleted file mode 100644
index 0a4c65a..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_lib.h
+++ /dev/null
@@ -1,85 +0,0 @@
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
- * Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/linux/lustre_lib.h
- *
- * Basic Lustre library routines.
- */
-
-#ifndef _LINUX_LUSTRE_LIB_H
-#define _LINUX_LUSTRE_LIB_H
-
-#ifndef _LUSTRE_LIB_H
-#error Do not #include this file directly. #include <lustre_lib.h> instead
-#endif
-
-# include <linux/rwsem.h>
-# include <linux/sched.h>
-# include <linux/signal.h>
-# include <linux/types.h>
-#include "lustre_compat25.h"
-#include "lustre_common.h"
-
-#ifndef LP_POISON
-# define LI_POISON 0x5a5a5a5a
-#if BITS_PER_LONG > 32
-# define LL_POISON 0x5a5a5a5a5a5a5a5aL
-#else
-# define LL_POISON 0x5a5a5a5aL
-#endif
-# define LP_POISON ((void *)LL_POISON)
-#endif
-
-/* This macro is only for compatibility reasons with older Linux Lustre user
- * tools. New ioctls should NOT use this macro as the ioctl "size". Instead
- * the ioctl should get a "size" argument which is the actual data type used
- * by the ioctl, to ensure the ioctl interface is versioned correctly. */
-#define OBD_IOC_DATA_TYPE	       long
-
-#define LUSTRE_FATAL_SIGS (sigmask(SIGKILL) | sigmask(SIGINT) |		\
-			   sigmask(SIGTERM) | sigmask(SIGQUIT) |	       \
-			   sigmask(SIGALRM))
-
-/* initialize ost_lvb according to inode */
-static inline void inode_init_lvb(struct inode *inode, struct ost_lvb *lvb)
-{
-	lvb->lvb_size = i_size_read(inode);
-	lvb->lvb_blocks = inode->i_blocks;
-	lvb->lvb_mtime = LTIME_S(inode->i_mtime);
-	lvb->lvb_atime = LTIME_S(inode->i_atime);
-	lvb->lvb_ctime = LTIME_S(inode->i_ctime);
-}
-
-#endif /* _LUSTRE_LIB_H */
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index d455a6d..ca2dbab 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -46,11 +46,13 @@
  * @{
  */
 
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/types.h>
 #include "../../include/linux/libcfs/libcfs.h"
 #include "lustre/lustre_idl.h"
 #include "lustre_ver.h"
 #include "lustre_cfg.h"
-#include "linux/lustre_lib.h"
 
 /* target.c */
 struct kstatfs;
@@ -62,6 +64,13 @@ struct l_wait_info;
 #include "lustre_net.h"
 #include "lvfs.h"
 
+#define LI_POISON 0x5a5a5a5a
+#if BITS_PER_LONG > 32
+# define LL_POISON 0x5a5a5a5a5a5a5a5aL
+#else
+# define LL_POISON 0x5a5a5a5aL
+#endif
+#define LP_POISON ((void *)LL_POISON)
 
 int target_pack_pool_reply(struct ptlrpc_request *req);
 int do_set_info_async(struct obd_import *imp,
@@ -270,6 +279,8 @@ static inline void obd_ioctl_freedata(char *buf, int len)
  * we change _IOR to _IOWR so BSD will copyin obd_ioctl_data
  * for us. Does this change affect Linux?  (XXX Liang)
  */
+#define OBD_IOC_DATA_TYPE long
+
 #define OBD_IOC_CREATE		 _IOWR('f', 101, OBD_IOC_DATA_TYPE)
 #define OBD_IOC_DESTROY		_IOW ('f', 104, OBD_IOC_DATA_TYPE)
 #define OBD_IOC_PREALLOCATE	    _IOWR('f', 105, OBD_IOC_DATA_TYPE)
@@ -509,6 +520,10 @@ struct l_wait_info {
 
 #define LWI_INTR(cb, data)  LWI_TIMEOUT_INTR(0, NULL, cb, data)
 
+#define LUSTRE_FATAL_SIGS (sigmask(SIGKILL) | sigmask(SIGINT) |		\
+			   sigmask(SIGTERM) | sigmask(SIGQUIT) |	\
+			   sigmask(SIGALRM))
+
 
 /*
  * wait for @condition to become true, but no longer than timeout, specified
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 6ffbe7cb..f2e7bcc 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -994,7 +994,12 @@ int ll_merge_lvb(const struct lu_env *env, struct inode *inode)
 	LTIME_S(inode->i_atime) = lli->lli_lvb.lvb_atime;
 	LTIME_S(inode->i_mtime) = lli->lli_lvb.lvb_mtime;
 	LTIME_S(inode->i_ctime) = lli->lli_lvb.lvb_ctime;
-	inode_init_lvb(inode, &lvb);
+
+	lvb.lvb_size = i_size_read(inode);
+        lvb.lvb_blocks = inode->i_blocks;
+        lvb.lvb_mtime = LTIME_S(inode->i_mtime);
+        lvb.lvb_atime = LTIME_S(inode->i_atime);
+        lvb.lvb_ctime = LTIME_S(inode->i_ctime);
 
 	cl_object_attr_lock(obj);
 	rc = cl_object_attr_get(env, obj, attr);
-- 
1.7.9.5

