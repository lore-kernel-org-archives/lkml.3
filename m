Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIOOfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:35:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:40198 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaIOOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:35:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="386286117"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <uja.ornl@gmail.com>, <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH] staging: lustre: fix undefined references to obd_memory
Date: Mon, 15 Sep 2014 09:34:53 -0500
Message-ID: <1410791693-3729-1-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

If CONFIG_PROC_FS=n then obd_memory is not defined. So put the setup
and cleanup of this variable within #ifdef CONFIG_PROC_FS guards.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../staging/lustre/lustre/include/obd_support.h    |    2 ++
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 2991d2e..408ce7f 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -43,12 +43,14 @@
 #include "lprocfs_status.h"
 
 /* global variables */
+#ifdef CONFIG_PROC_FS
 extern struct lprocfs_stats *obd_memory;
 enum {
 	OBD_MEMORY_STAT = 0,
 	OBD_MEMORY_PAGES_STAT = 1,
 	OBD_STATS_NUM,
 };
+#endif /* CONFIG_PROC_FS */
 
 extern unsigned int obd_debug_peer_on_timeout;
 extern unsigned int obd_dump_on_timeout;
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 8b8d338..2939f0c 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -534,6 +534,7 @@ static int __init init_obdclass(void)
 	spin_lock_init(&obd_types_lock);
 	obd_zombie_impexp_init();
 
+#ifdef CONFIG_PROC_FS
 	obd_memory = lprocfs_alloc_stats(OBD_STATS_NUM,
 					 LPROCFS_STATS_FLAG_NONE |
 					 LPROCFS_STATS_FLAG_IRQ_SAFE);
@@ -548,6 +549,7 @@ static int __init init_obdclass(void)
 	lprocfs_counter_init(obd_memory, OBD_MEMORY_PAGES_STAT,
 			     LPROCFS_CNTR_AVGMINMAX,
 			     "pagesused", "pages");
+#endif /* CONFIG_PROC_FS */
 
 	err = obd_init_checks();
 	if (err == -EOVERFLOW)
@@ -688,7 +690,10 @@ static void cleanup_obdclass(void)
 	memory_max = obd_memory_max();
 	pages_max = obd_pages_max();
 
+#ifdef CONFIG_PROC_FS
 	lprocfs_free_stats(&obd_memory);
+#endif /* CONFIG_PROC_FS */
+
 	CDEBUG((memory_leaked) ? D_ERROR : D_INFO,
 	       "obd_memory max: %llu, leaked: %llu\n",
 	       memory_max, memory_leaked);
-- 
1.7.9.5

