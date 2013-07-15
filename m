Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3GOObA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:31:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62801 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3GOO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:05 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 08/17] staging/lustre: fix build on s390
Date: Mon, 15 Jul 2013 22:27:11 +0800
Message-Id: <1373898440-14208-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Fengguang:
In file included from drivers/staging/lustre/lustre/obdclass/../include/lustre/lustre_idl.h:99:0,
	    from drivers/staging/lustre/lustre/obdclass/../include/lprocfs_status.h:46,
	    from drivers/staging/lustre/lustre/obdclass/../include/obd_support.h:42,
	    from drivers/staging/lustre/lustre/obdclass/../include/obd_class.h:40,
	    from drivers/staging/lustre/lustre/obdclass/lu_object.c:53:
drivers/staging/lustre/lustre/obdclass/../include/lustre/lustre_user.h:356:10: error: field 'lmd_st' has incomplete type
drivers/staging/lustre/lustre/obdclass/../include/lustre/lustre_user.h:361:10: error: field 'lmd_st' has incomplete type

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_user.h      |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_user.h b/drivers/staging/lustre/lustre/include/linux/lustre_user.h
index ebaf929..ea9393c 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_user.h
@@ -53,15 +53,19 @@
 
 #include <linux/string.h>
 
-#if defined(__x86_64__) || defined(__ia64__) || defined(__ppc64__) || \
-    defined(__craynv) || defined (__mips64__) || defined(__powerpc64__)
-typedef struct stat     lstat_t;
-#define lstat_f	 lstat
-#define HAVE_LOV_USER_MDS_DATA
-#else
+/*
+ * We need to always use 64bit version because the structure
+ * is shared across entire cluster where 32bit and 64bit machines
+ * are co-existing.
+ */
+#if __BITS_PER_LONG != 64 || defined(__ARCH_WANT_STAT64)
 typedef struct stat64   lstat_t;
 #define lstat_f	 lstat64
-#define HAVE_LOV_USER_MDS_DATA
+#else
+typedef struct stat     lstat_t;
+#define lstat_f	 lstat
 #endif
 
+#define HAVE_LOV_USER_MDS_DATA
+
 #endif /* _LUSTRE_USER_H */
-- 
1.7.9.5

