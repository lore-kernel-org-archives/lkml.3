Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaH1Xgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:34943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaH1Xgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="565065784"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 04/11] staging/lustre: remove linux/lustre_handles.h
Date: Thu, 28 Aug 2014 18:35:12 -0500
Message-ID: <1409268919-16155-5-git-send-email-john.hammond@intel.com>
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

Remove lustre/include/linux/lustre_acl.h and kill the cfs_rcu_head_t
typedef.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_handles.h   |   52 --------------------
 .../staging/lustre/lustre/include/lustre_handles.h |   10 ++--
 .../lustre/lustre/obdclass/lustre_handles.c        |    2 +-
 3 files changed, 8 insertions(+), 56 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_handles.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_handles.h b/drivers/staging/lustre/lustre/include/linux/lustre_handles.h
deleted file mode 100644
index 459b238..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_handles.h
+++ /dev/null
@@ -1,52 +0,0 @@
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
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef __LINUX_LUSTRE_HANDLES_H_
-#define __LINUX_LUSTRE_HANDLES_H_
-
-#ifndef __LUSTRE_HANDLES_H_
-#error Do not #include this file directly. #include <lustre_handles.h> instead
-#endif
-
-#include <asm/types.h>
-#include <asm/atomic.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/types.h>
-
-#include <linux/rcupdate.h> /* for rcu_head{} */
-typedef struct rcu_head cfs_rcu_head_t;
-
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_handles.h b/drivers/staging/lustre/lustre/include/lustre_handles.h
index 94989c5..726bbd3 100644
--- a/drivers/staging/lustre/lustre/include/lustre_handles.h
+++ b/drivers/staging/lustre/lustre/include/lustre_handles.h
@@ -42,7 +42,11 @@
  * @{
  */
 
-#include "linux/lustre_handles.h"
+#include <linux/atomic.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
 
 #include "../../include/linux/libcfs/libcfs.h"
 
@@ -69,7 +73,7 @@ struct portals_handle {
 	struct portals_handle_ops	*h_ops;
 
 	/* newly added fields to handle the RCU issue. -jxiong */
-	cfs_rcu_head_t			h_rcu;
+	struct rcu_head			h_rcu;
 	spinlock_t			h_lock;
 	unsigned int			h_size:31;
 	unsigned int			h_in:1;
@@ -84,7 +88,7 @@ void class_handle_hash(struct portals_handle *,
 void class_handle_unhash(struct portals_handle *);
 void class_handle_hash_back(struct portals_handle *);
 void *class_handle2object(__u64 cookie);
-void class_handle_free_cb(cfs_rcu_head_t *);
+void class_handle_free_cb(struct rcu_head *rcu);
 int class_handle_init(void);
 void class_handle_cleanup(void);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/lustre_handles.c b/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
index 2010463..f720e31 100644
--- a/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
+++ b/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
@@ -178,7 +178,7 @@ void *class_handle2object(__u64 cookie)
 }
 EXPORT_SYMBOL(class_handle2object);
 
-void class_handle_free_cb(cfs_rcu_head_t *rcu)
+void class_handle_free_cb(struct rcu_head *rcu)
 {
 	struct portals_handle *h = RCU2HANDLE(rcu);
 	void *ptr = (void *)(unsigned long)h->h_cookie;
-- 
1.7.9.5

