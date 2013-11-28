Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3K1EGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:06:16 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37629 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3K1EGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:06:09 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] staging/lustre: fix build error when CONFIG_FS_POSIX_ACL is off
Date: Thu, 28 Nov 2013 12:00:55 +0800
Message-Id: <1385611255-9108-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to include <linux/posix_acl_xattr.h> regardless of
CONFIG_FS_POSIX_ACL is set or not. Otherwise build fails as
reported by kbuild robot:

>> drivers/staging/lustre/lustre/llite/file.c:2965:2: error: implicit declaration of function 'posix_acl_dup' [-Werror=implicit-function-declaration]
     acl = posix_acl_dup(lli->lli_posix_acl);
<many similar errors omitted>

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/include/linux/lustre_acl.h       |   18 +++++++++---------
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    9 +++------
 .../staging/lustre/lustre/llite/llite_internal.h   |    1 +
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    6 ++----
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_acl.h b/drivers/staging/lustre/lustre/include/linux/lustre_acl.h
index ff4fc4f..778b123 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_acl.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_acl.h
@@ -47,17 +47,17 @@
 #error	Shoud not include direectly. use #include <lustre_acl.h> instead
 #endif
 
-# include <linux/fs.h>
-# include <linux/dcache.h>
-# ifdef CONFIG_FS_POSIX_ACL
-#  include <linux/posix_acl_xattr.h>
-#  define LUSTRE_POSIX_ACL_MAX_ENTRIES	32
-#  define LUSTRE_POSIX_ACL_MAX_SIZE					\
+#include <linux/fs.h>
+#include <linux/dcache.h>
+
+#include <linux/posix_acl_xattr.h>
+#define LUSTRE_POSIX_ACL_MAX_ENTRIES	32
+#define LUSTRE_POSIX_ACL_MAX_SIZE					\
 	(sizeof(posix_acl_xattr_header) +				\
 	 LUSTRE_POSIX_ACL_MAX_ENTRIES * sizeof(posix_acl_xattr_entry))
-# endif /* CONFIG_FS_POSIX_ACL */
-# include <linux/lustre_intent.h>
-# include <linux/xattr.h> /* XATTR_{REPLACE,CREATE} */
+
+#include <linux/lustre_intent.h>
+#include <linux/xattr.h> /* XATTR_{REPLACE,CREATE} */
 
 #ifndef LUSTRE_POSIX_ACL_MAX_SIZE
 # define LUSTRE_POSIX_ACL_MAX_SIZE   0
diff --git a/drivers/staging/lustre/lustre/include/lustre_mdc.h b/drivers/staging/lustre/lustre/include/lustre_mdc.h
index 1900025..c1e0270 100644
--- a/drivers/staging/lustre/lustre/include/lustre_mdc.h
+++ b/drivers/staging/lustre/lustre/include/lustre_mdc.h
@@ -48,12 +48,9 @@
  * @{
  */
 
-# include <linux/fs.h>
-# include <linux/dcache.h>
-# ifdef CONFIG_FS_POSIX_ACL
-#  include <linux/posix_acl_xattr.h>
-# endif /* CONFIG_FS_POSIX_ACL */
-# include <linux/lustre_intent.h>
+#include <linux/fs.h>
+#include <linux/dcache.h>
+#include <linux/lustre_intent.h>
 #include <lustre_handles.h>
 #include <linux/libcfs/libcfs.h>
 #include <obd_class.h>
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index c326ff2..6d15e5c 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -47,6 +47,7 @@
 #include <lustre_mdc.h>
 #include <linux/lustre_intent.h>
 #include <linux/compat.h>
+#include <linux/posix_acl_xattr.h>
 
 #ifndef FMODE_EXEC
 #define FMODE_EXEC 0
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index e3f02c7..6cc0d6e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -36,10 +36,8 @@
 
 #define DEBUG_SUBSYSTEM S_RPC
 
-# ifdef CONFIG_FS_POSIX_ACL
-#  include <linux/fs.h>
-#  include <linux/posix_acl_xattr.h>
-# endif
+#include <linux/fs.h>
+#include <linux/posix_acl_xattr.h>
 
 #include <obd_support.h>
 #include <obd_class.h>
-- 
1.7.9.5

