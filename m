Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaH3VNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:47 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51530 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbaH3VNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:23 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 05/12] staging/lustre/obdclass: remove lu_ucred.c
Date: Sat, 30 Aug 2014 17:12:44 -0400
Message-Id: <1409433171-23572-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

The functions exported by lustre/obdclass/lu_ucred.c are not used so
remove that file.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/Makefile   |   3 +-
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c | 107 ----------------------
 2 files changed, 1 insertion(+), 109 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lu_ucred.c

diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index 989fb7c..91a5a2b 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -6,5 +6,4 @@ obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      lustre_handles.o lustre_peer.o llog_osd.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
 	      mea.o lu_object.o dt_object.o capa.o cl_object.o   \
-	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o \
-	      lu_ucred.o
+	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_ucred.c b/drivers/staging/lustre/lustre/obdclass/lu_ucred.c
deleted file mode 100644
index 3676563..0000000
--- a/drivers/staging/lustre/lustre/obdclass/lu_ucred.c
+++ /dev/null
@@ -1,107 +0,0 @@
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
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/obdclass/lu_ucred.c
- *
- * Lustre user credentials context infrastructure.
- *
- *   Author: Nikita Danilov <nikita.danilov@sun.com>
- *   Author: Fan Yong <fan.yong@intel.com>
- *   Author: Vitaly Fertman <vitaly_fertman@xyratex.com>
- */
-
-#define DEBUG_SUBSYSTEM S_CLASS
-
-#include "../../include/linux/libcfs/libcfs.h"
-#include "../include/obd_support.h"
-#include "../include/lu_object.h"
-#include "../include/md_object.h"
-
-/* context key constructor/destructor: lu_ucred_key_init, lu_ucred_key_fini */
-LU_KEY_INIT_FINI(lu_ucred, struct lu_ucred);
-
-static struct lu_context_key lu_ucred_key = {
-	.lct_tags = LCT_SESSION,
-	.lct_init = lu_ucred_key_init,
-	.lct_fini = lu_ucred_key_fini
-};
-
-/**
- * Get ucred key if session exists and ucred key is allocated on it.
- * Return NULL otherwise.
- */
-struct lu_ucred *lu_ucred(const struct lu_env *env)
-{
-	if (!env->le_ses)
-		return NULL;
-	return lu_context_key_get(env->le_ses, &lu_ucred_key);
-}
-EXPORT_SYMBOL(lu_ucred);
-
-/**
- * Get ucred key and check if it is properly initialized.
- * Return NULL otherwise.
- */
-struct lu_ucred *lu_ucred_check(const struct lu_env *env)
-{
-	struct lu_ucred *uc = lu_ucred(env);
-	if (uc && uc->uc_valid != UCRED_OLD && uc->uc_valid != UCRED_NEW)
-		return NULL;
-	return uc;
-}
-EXPORT_SYMBOL(lu_ucred_check);
-
-/**
- * Get ucred key, which must exist and must be properly initialized.
- * Assert otherwise.
- */
-struct lu_ucred *lu_ucred_assert(const struct lu_env *env)
-{
-	struct lu_ucred *uc = lu_ucred_check(env);
-	LASSERT(uc != NULL);
-	return uc;
-}
-EXPORT_SYMBOL(lu_ucred_assert);
-
-int lu_ucred_global_init(void)
-{
-	LU_CONTEXT_KEY_INIT(&lu_ucred_key);
-	return lu_context_key_register(&lu_ucred_key);
-}
-
-void lu_ucred_global_fini(void)
-{
-	lu_context_key_degister(&lu_ucred_key);
-}
-- 
1.9.3

