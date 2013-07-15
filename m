Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3GONKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:10:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50122 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3GONKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:10:47 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 01/17] staging/lustre: replace num_physpages with totalram_pages
Date: Mon, 15 Jul 2013 21:07:59 +0800
Message-Id: <1373893695-4094-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

The global variable num_physpages is going away. Replace it
with totalram_pages.

Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |    4 ++--
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   10 +++++-----
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |    2 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    8 ++++----
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    6 +++---
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |    6 +++---
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    2 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 ++--
 10 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
index 042a2bc..63efb7b 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
@@ -63,9 +63,9 @@
 #if BITS_PER_LONG == 32
 /* limit to lowmem on 32-bit systems */
 #define NUM_CACHEPAGES \
-	min(num_physpages, 1UL << (30 - PAGE_CACHE_SHIFT) * 3 / 4)
+	min(totalram_pages, 1UL << (30 - PAGE_CACHE_SHIFT) * 3 / 4)
 #else
-#define NUM_CACHEPAGES num_physpages
+#define NUM_CACHEPAGES totalram_pages
 #endif
 
 /*
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 42df530..aace534 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -339,8 +339,8 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	cli->cl_avail_grant = 0;
 	/* FIXME: Should limit this for the sum of all cl_dirty_max. */
 	cli->cl_dirty_max = OSC_MAX_DIRTY_DEFAULT * 1024 * 1024;
-	if (cli->cl_dirty_max >> PAGE_CACHE_SHIFT > num_physpages / 8)
-		cli->cl_dirty_max = num_physpages << (PAGE_CACHE_SHIFT - 3);
+	if (cli->cl_dirty_max >> PAGE_CACHE_SHIFT > totalram_pages / 8)
+		cli->cl_dirty_max = totalram_pages << (PAGE_CACHE_SHIFT - 3);
 	INIT_LIST_HEAD(&cli->cl_cache_waiters);
 	INIT_LIST_HEAD(&cli->cl_loi_ready_list);
 	INIT_LIST_HEAD(&cli->cl_loi_hp_ready_list);
@@ -388,11 +388,11 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 
 	if (!strcmp(name, LUSTRE_MDC_NAME)) {
 		cli->cl_max_rpcs_in_flight = MDC_MAX_RIF_DEFAULT;
-	} else if (num_physpages >> (20 - PAGE_CACHE_SHIFT) <= 128 /* MB */) {
+	} else if (totalram_pages >> (20 - PAGE_CACHE_SHIFT) <= 128 /* MB */) {
 		cli->cl_max_rpcs_in_flight = 2;
-	} else if (num_physpages >> (20 - PAGE_CACHE_SHIFT) <= 256 /* MB */) {
+	} else if (totalram_pages >> (20 - PAGE_CACHE_SHIFT) <= 256 /* MB */) {
 		cli->cl_max_rpcs_in_flight = 3;
-	} else if (num_physpages >> (20 - PAGE_CACHE_SHIFT) <= 512 /* MB */) {
+	} else if (totalram_pages >> (20 - PAGE_CACHE_SHIFT) <= 512 /* MB */) {
 		cli->cl_max_rpcs_in_flight = 4;
 	} else {
 		if (osc_on_mdt(obddev->obd_name))
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
index 6f56343..a500a0b 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
@@ -269,7 +269,7 @@ void cfs_print_to_console(struct ptldebug_header *hdr, int mask,
 
 int cfs_trace_max_debug_mb(void)
 {
-	int  total_mb = (num_physpages >> (20 - PAGE_SHIFT));
+	int  total_mb = (totalram_pages >> (20 - PAGE_SHIFT));
 
 	return MAX(512, (total_mb * 80)/100);
 }
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 6a82505..a30c411 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -243,9 +243,9 @@ static ssize_t ll_max_readahead_mb_seq_write(struct file *file, const char *buff
 	if (rc)
 		return rc;
 
-	if (pages_number < 0 || pages_number > num_physpages / 2) {
+	if (pages_number < 0 || pages_number > totalram_pages / 2) {
 		CERROR("can't set file readahead more than %lu MB\n",
-		       num_physpages >> (20 - PAGE_CACHE_SHIFT + 1)); /*1/2 of RAM*/
+		       totalram_pages >> (20 - PAGE_CACHE_SHIFT + 1)); /*1/2 of RAM*/
 		return -ERANGE;
 	}
 
@@ -388,10 +388,10 @@ static ssize_t ll_max_cached_mb_seq_write(struct file *file, const char *buffer,
 	if (rc)
 		RETURN(rc);
 
-	if (pages_number < 0 || pages_number > num_physpages) {
+	if (pages_number < 0 || pages_number > totalram_pages) {
 		CERROR("%s: can't set max cache more than %lu MB\n",
 		       ll_get_fsname(sb, NULL, 0),
-		       num_physpages >> (20 - PAGE_CACHE_SHIFT));
+		       totalram_pages >> (20 - PAGE_CACHE_SHIFT));
 		RETURN(-ERANGE);
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index af1c2d0..0715cf2 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -558,10 +558,10 @@ static int __init init_obdclass(void)
 	/* Default the dirty page cache cap to 1/2 of system memory.
 	 * For clients with less memory, a larger fraction is needed
 	 * for other purposes (mostly for BGL). */
-	if (num_physpages <= 512 << (20 - PAGE_CACHE_SHIFT))
-		obd_max_dirty_pages = num_physpages / 4;
+	if (totalram_pages <= 512 << (20 - PAGE_CACHE_SHIFT))
+		obd_max_dirty_pages = totalram_pages / 4;
 	else
-		obd_max_dirty_pages = num_physpages / 2;
+		obd_max_dirty_pages = totalram_pages / 2;
 
 	err = obd_init_caches();
 	if (err)
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index 46aad68..7b94cb7 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -202,12 +202,12 @@ int LL_PROC_PROTO(proc_max_dirty_pages_in_mb)
 					       1 << (20 - PAGE_CACHE_SHIFT));
 		/* Don't allow them to let dirty pages exceed 90% of system
 		 * memory and set a hard minimum of 4MB. */
-		if (obd_max_dirty_pages > ((num_physpages / 10) * 9)) {
+		if (obd_max_dirty_pages > ((totalram_pages / 10) * 9)) {
 			CERROR("Refusing to set max dirty pages to %u, which "
 			       "is more than 90%% of available RAM; setting "
 			       "to %lu\n", obd_max_dirty_pages,
-			       ((num_physpages / 10) * 9));
-			obd_max_dirty_pages = ((num_physpages / 10) * 9);
+			       ((totalram_pages / 10) * 9));
+			obd_max_dirty_pages = ((totalram_pages / 10) * 9);
 		} else if (obd_max_dirty_pages < 4 << (20 - PAGE_CACHE_SHIFT)) {
 			obd_max_dirty_pages = 4 << (20 - PAGE_CACHE_SHIFT);
 		}
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index fdf0ed3..fdaf4f8 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -849,7 +849,7 @@ static int lu_htable_order(void)
 	 *
 	 * Size of lu_object is (arbitrary) taken as 1K (together with inode).
 	 */
-	cache_size = num_physpages;
+	cache_size = totalram_pages;
 
 #if BITS_PER_LONG == 32
 	/* limit hashtable size for lowmem systems to low RAM */
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 198cf3b..d2f2198 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -146,7 +146,7 @@ static ssize_t osc_max_dirty_mb_seq_write(struct file *file, const char *buffer,
 
 	if (pages_number <= 0 ||
 	    pages_number > OSC_MAX_DIRTY_MB_MAX << (20 - PAGE_CACHE_SHIFT) ||
-	    pages_number > num_physpages / 4) /* 1/4 of RAM */
+	    pages_number > totalram_pages / 4) /* 1/4 of RAM */
 		return -ERANGE;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 3e73254..2bd0d98 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -302,7 +302,7 @@ ptlrpc_lprocfs_req_history_max_seq_write(struct file *file, const char *buffer,
 	 * hose a kernel by allowing the request history to grow too
 	 * far. */
 	bufpages = (svc->srv_buf_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (val > num_physpages/(2 * bufpages))
+	if (val > totalram_pages / (2 * bufpages))
 		return -ERANGE;
 
 	spin_lock(&svc->srv_lock);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index bf53f1b..9013745 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -156,7 +156,7 @@ int sptlrpc_proc_enc_pool_seq_show(struct seq_file *m, void *v)
 		      "max waitqueue depth:     %u\n"
 		      "max wait time:	   "CFS_TIME_T"/%u\n"
 		      ,
-		      num_physpages,
+		      totalram_pages,
 		      PAGES_PER_POOL,
 		      page_pools.epp_max_pages,
 		      page_pools.epp_max_pools,
@@ -705,7 +705,7 @@ int sptlrpc_enc_pool_init(void)
 	 * maximum capacity is 1/8 of total physical memory.
 	 * is the 1/8 a good number?
 	 */
-	page_pools.epp_max_pages = num_physpages / 8;
+	page_pools.epp_max_pages = totalram_pages / 8;
 	page_pools.epp_max_pools = npages_to_npools(page_pools.epp_max_pages);
 
 	init_waitqueue_head(&page_pools.epp_waitq);
-- 
1.7.9.5

