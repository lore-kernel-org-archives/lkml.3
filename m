Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3LCR55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:57:57 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64336 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3LCR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:57:30 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 3/4] staging/lustre: fix undefined reference if CONFIG_PROC_FS is off
Date: Wed,  4 Dec 2013 01:54:58 +0800
Message-Id: <1386093299-8837-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386093299-8837-1-git-send-email-bergwolf@gmail.com>
References: <1386093299-8837-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building Lustre with CONFIG_PROC_FS off, we'll get many errors like:

drivers/staging/lustre/lustre/obdclass/llog_test.c:1053: error: implicit declaration of function ‘lprocfs_llog_test_init_vars’
make[3]: *** [drivers/staging/lustre/lustre/obdclass/llog_test.o] Error 1
make[2]: *** [drivers/staging/lustre/lustre/obdclass] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC [M]  drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.o
drivers/staging/lustre/lustre/ptlrpc/pinger.c: In function ‘ptlrpc_pinger_main’:
drivers/staging/lustre/lustre/ptlrpc/pinger.c:331: error: implicit declaration of function ‘obd_update_maxusage’

The patch defines following symbols when CONFIG_PROC_FS is off:
fld_type_proc_dir, obd_update_maxusage(), obd_max_pages, obd_max_alloc, obd_alloc,
obd_pages, lprocfs_llog_test_init_vars().

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    2 +-
 .../staging/lustre/lustre/include/obd_support.h    |    3 ++-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    6 ++++++
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    4 ++++
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_internal.h b/drivers/staging/lustre/lustre/fld/fld_internal.h
index 56686b1..5f3935c 100644
--- a/drivers/staging/lustre/lustre/fld/fld_internal.h
+++ b/drivers/staging/lustre/lustre/fld/fld_internal.h
@@ -190,5 +190,4 @@ fld_target_name(struct lu_fld_target *tar)
 	return (const char *)tar->ft_exp->exp_obd->obd_name;
 }
 
-extern struct proc_dir_entry *fld_type_proc_dir;
 #endif /* __FLD_INTERNAL_H */
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 3191a39..896f9fe 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -274,9 +274,9 @@ int fld_client_del_target(struct lu_client_fld *fld, __u64 idx)
 }
 EXPORT_SYMBOL(fld_client_del_target);
 
-#ifdef LPROCFS
 struct proc_dir_entry *fld_type_proc_dir = NULL;
 
+#ifdef LPROCFS
 static int fld_client_proc_init(struct lu_client_fld *fld)
 {
 	int rc;
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 2dc95de..977bc23 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -507,6 +507,8 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 
 extern atomic_t libcfs_kmemory;
 
+extern void obd_update_maxusage(void);
+
 #ifdef LPROCFS
 #define obd_memory_add(size)						  \
 	lprocfs_counter_add(obd_memory, OBD_MEMORY_STAT, (long)(size))
@@ -525,7 +527,6 @@ extern atomic_t libcfs_kmemory;
 	lprocfs_stats_collector(obd_memory, OBD_MEMORY_PAGES_STAT,	    \
 				LPROCFS_FIELDS_FLAGS_SUM)
 
-extern void obd_update_maxusage(void);
 extern __u64 obd_memory_max(void);
 extern __u64 obd_pages_max(void);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 7b1d1b6..5f8d9f2 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -54,7 +54,13 @@ struct list_head obd_types;
 DEFINE_RWLOCK(obd_dev_lock);
 
 __u64 obd_max_pages = 0;
+EXPORT_SYMBOL(obd_max_pages);
 __u64 obd_max_alloc = 0;
+EXPORT_SYMBOL(obd_max_alloc);
+__u64 obd_alloc;
+EXPORT_SYMBOL(obd_alloc);
+__u64 obd_pages;
+EXPORT_SYMBOL(obd_pages);
 DEFINE_SPINLOCK(obd_updatemax_lock);
 
 /* The following are visible and mutable through /proc/sys/lustre/. */
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_test.c b/drivers/staging/lustre/lustre/obdclass/llog_test.c
index 7427c12..764068f 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_test.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_test.c
@@ -947,6 +947,10 @@ static void lprocfs_llog_test_init_vars(struct lprocfs_static_vars *lvars)
     lvars->module_vars  = lprocfs_llog_test_module_vars;
     lvars->obd_vars     = lprocfs_llog_test_obd_vars;
 }
+#else
+static void lprocfs_llog_test_init_vars(struct lprocfs_static_vars *lvars)
+{
+}
 #endif
 
 static int llog_test_cleanup(struct obd_device *obd)
-- 
1.7.9.5

