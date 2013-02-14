Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab3BNDH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19981 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3BNDFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/16] zcache: Fix compile warnings due to usage of debugfs_create_size_t
Date: Wed, 13 Feb 2013 22:04:55 -0500
Message-Id: <1360811106-2679-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we compile we get tons of:
include/linux/debugfs.h:80:16: note: expected ‘size_t *’ but argument is
of type ‘long int *’
drivers/staging/zcache/zcache-main.c:279:2: warning: passing argument 4
of ‘debugfs_create_size_t’ from incompatible pointer type [enabled by d
efault]

which is b/c we end up using 'unsigned' or 'unsigned long' instead
of 'ssize_t'. So lets fix this up and use the proper type.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 163 ++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index b71e61b..4bd4107 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -135,23 +135,23 @@ static struct kmem_cache *zcache_obj_cache;
 static DEFINE_PER_CPU(struct zcache_preload, zcache_preloads) = { 0, };
 
 /* we try to keep these statistics SMP-consistent */
-static long zcache_obj_count;
+static ssize_t zcache_obj_count;
 static atomic_t zcache_obj_atomic = ATOMIC_INIT(0);
-static long zcache_obj_count_max;
+static ssize_t zcache_obj_count_max;
 static inline void inc_zcache_obj_count(void)
 {
 	zcache_obj_count = atomic_inc_return(&zcache_obj_atomic);
 	if (zcache_obj_count > zcache_obj_count_max)
 		zcache_obj_count_max = zcache_obj_count;
 }
-static long zcache_objnode_count;
+static ssize_t zcache_objnode_count;
 static inline void dec_zcache_obj_count(void)
 {
 	zcache_obj_count = atomic_dec_return(&zcache_obj_atomic);
 	BUG_ON(zcache_obj_count < 0);
 };
 static atomic_t zcache_objnode_atomic = ATOMIC_INIT(0);
-static long zcache_objnode_count_max;
+static ssize_t zcache_objnode_count_max;
 static inline void inc_zcache_objnode_count(void)
 {
 	zcache_objnode_count = atomic_inc_return(&zcache_objnode_atomic);
@@ -185,64 +185,65 @@ static inline void inc_zcache_pers_zbytes(unsigned clen)
 	if (zcache_pers_zbytes > zcache_pers_zbytes_max)
 		zcache_pers_zbytes_max = zcache_pers_zbytes;
 }
-static long zcache_eph_pageframes;
+static ssize_t zcache_eph_pageframes;
 static inline void dec_zcache_pers_zbytes(unsigned zsize)
 {
 	zcache_pers_zbytes = atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
 }
 static atomic_t zcache_eph_pageframes_atomic = ATOMIC_INIT(0);
-static long zcache_eph_pageframes_max;
+static ssize_t zcache_eph_pageframes_max;
 static inline void inc_zcache_eph_pageframes(void)
 {
 	zcache_eph_pageframes = atomic_inc_return(&zcache_eph_pageframes_atomic);
 	if (zcache_eph_pageframes > zcache_eph_pageframes_max)
 		zcache_eph_pageframes_max = zcache_eph_pageframes;
 };
-static long zcache_pers_pageframes;
+static ssize_t zcache_pers_pageframes;
 static inline void dec_zcache_eph_pageframes(void)
 {
 	zcache_eph_pageframes = atomic_dec_return(&zcache_eph_pageframes_atomic);
 };
 static atomic_t zcache_pers_pageframes_atomic = ATOMIC_INIT(0);
-static long zcache_pers_pageframes_max;
+static ssize_t zcache_pers_pageframes_max;
 static inline void inc_zcache_pers_pageframes(void)
 {
 	zcache_pers_pageframes = atomic_inc_return(&zcache_pers_pageframes_atomic);
 	if (zcache_pers_pageframes > zcache_pers_pageframes_max)
 		zcache_pers_pageframes_max = zcache_pers_pageframes;
 }
-static long zcache_pageframes_alloced;
+static ssize_t zcache_pageframes_alloced;
 static inline void dec_zcache_pers_pageframes(void)
 {
 	zcache_pers_pageframes = atomic_dec_return(&zcache_pers_pageframes_atomic);
 }
 static atomic_t zcache_pageframes_alloced_atomic = ATOMIC_INIT(0);
+static ssize_t zcache_pageframes_freed;
+static atomic_t zcache_pageframes_freed_atomic = ATOMIC_INIT(0);
+static ssize_t zcache_eph_zpages;
 static inline void inc_zcache_pageframes_alloced(void)
 {
 	zcache_pageframes_alloced = atomic_inc_return(&zcache_pageframes_alloced_atomic);
 };
-static long zcache_pageframes_freed;
-static atomic_t zcache_pageframes_freed_atomic = ATOMIC_INIT(0);
 static inline void inc_zcache_pageframes_freed(void)
 {
 	zcache_pageframes_freed = atomic_inc_return(&zcache_pageframes_freed_atomic);
 }
-static long zcache_eph_zpages;
+static ssize_t zcache_eph_zpages;
 static atomic_t zcache_eph_zpages_atomic = ATOMIC_INIT(0);
-static long zcache_eph_zpages_max;
+static ssize_t zcache_eph_zpages_max;
 static inline void inc_zcache_eph_zpages(void)
 {
 	zcache_eph_zpages = atomic_inc_return(&zcache_eph_zpages_atomic);
 	if (zcache_eph_zpages > zcache_eph_zpages_max)
 		zcache_eph_zpages_max = zcache_eph_zpages;
 }
-static long zcache_pers_zpages;
+static ssize_t zcache_pers_zpages;
 static inline void dec_zcache_eph_zpages(unsigned zpages)
 {
 	zcache_eph_zpages = atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
 }
 static atomic_t zcache_pers_zpages_atomic = ATOMIC_INIT(0);
-static long zcache_pers_zpages_max;
+static ssize_t zcache_pers_zpages_max;
 static inline void inc_zcache_pers_zpages(void)
 {
 	zcache_pers_zpages = atomic_inc_return(&zcache_pers_zpages_atomic);
@@ -262,31 +263,31 @@ static inline unsigned long curr_pageframes_count(void)
 		atomic_read(&zcache_pers_pageframes_atomic);
 };
 /* but for the rest of these, counting races are ok */
-static unsigned long zcache_flush_total;
-static unsigned long zcache_flush_found;
-static unsigned long zcache_flobj_total;
-static unsigned long zcache_flobj_found;
-static unsigned long zcache_failed_eph_puts;
-static unsigned long zcache_failed_pers_puts;
-static unsigned long zcache_failed_getfreepages;
-static unsigned long zcache_failed_alloc;
-static unsigned long zcache_put_to_flush;
-static unsigned long zcache_compress_poor;
-static unsigned long zcache_mean_compress_poor;
-static unsigned long zcache_eph_ate_tail;
-static unsigned long zcache_eph_ate_tail_failed;
-static unsigned long zcache_pers_ate_eph;
-static unsigned long zcache_pers_ate_eph_failed;
-static unsigned long zcache_evicted_eph_zpages;
-static unsigned long zcache_evicted_eph_pageframes;
-static unsigned long zcache_last_active_file_pageframes;
-static unsigned long zcache_last_inactive_file_pageframes;
-static unsigned long zcache_last_active_anon_pageframes;
-static unsigned long zcache_last_inactive_anon_pageframes;
-static unsigned long zcache_eph_nonactive_puts_ignored;
-static unsigned long zcache_pers_nonactive_puts_ignored;
-static unsigned long zcache_writtenback_pages;
-static long zcache_outstanding_writeback_pages;
+static ssize_t zcache_flush_total;
+static ssize_t zcache_flush_found;
+static ssize_t zcache_flobj_total;
+static ssize_t zcache_flobj_found;
+static ssize_t zcache_failed_eph_puts;
+static ssize_t zcache_failed_pers_puts;
+static ssize_t zcache_failed_getfreepages;
+static ssize_t zcache_failed_alloc;
+static ssize_t zcache_put_to_flush;
+static ssize_t zcache_compress_poor;
+static ssize_t zcache_mean_compress_poor;
+static ssize_t zcache_eph_ate_tail;
+static ssize_t zcache_eph_ate_tail_failed;
+static ssize_t zcache_pers_ate_eph;
+static ssize_t zcache_pers_ate_eph_failed;
+static ssize_t zcache_evicted_eph_zpages;
+static ssize_t zcache_evicted_eph_pageframes;
+static ssize_t zcache_last_active_file_pageframes;
+static ssize_t zcache_last_inactive_file_pageframes;
+static ssize_t zcache_last_active_anon_pageframes;
+static ssize_t zcache_last_inactive_anon_pageframes;
+static ssize_t zcache_eph_nonactive_puts_ignored;
+static ssize_t zcache_pers_nonactive_puts_ignored;
+static ssize_t zcache_writtenback_pages;
+static ssize_t zcache_outstanding_writeback_pages;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -359,64 +360,64 @@ static int zcache_debugfs_init(void)
 /* developers can call this in case of ooms, e.g. to find memory leaks */
 void zcache_dump(void)
 {
-	pr_info("zcache: obj_count=%lu\n", zcache_obj_count);
-	pr_info("zcache: obj_count_max=%lu\n", zcache_obj_count_max);
-	pr_info("zcache: objnode_count=%lu\n", zcache_objnode_count);
-	pr_info("zcache: objnode_count_max=%lu\n", zcache_objnode_count_max);
-	pr_info("zcache: flush_total=%lu\n", zcache_flush_total);
-	pr_info("zcache: flush_found=%lu\n", zcache_flush_found);
-	pr_info("zcache: flobj_total=%lu\n", zcache_flobj_total);
-	pr_info("zcache: flobj_found=%lu\n", zcache_flobj_found);
-	pr_info("zcache: failed_eph_puts=%lu\n", zcache_failed_eph_puts);
-	pr_info("zcache: failed_pers_puts=%lu\n", zcache_failed_pers_puts);
-	pr_info("zcache: failed_get_free_pages=%lu\n",
+	pr_info("zcache: obj_count=%zd\n", zcache_obj_count);
+	pr_info("zcache: obj_count_max=%zd\n", zcache_obj_count_max);
+	pr_info("zcache: objnode_count=%zd\n", zcache_objnode_count);
+	pr_info("zcache: objnode_count_max=%zd\n", zcache_objnode_count_max);
+	pr_info("zcache: flush_total=%zd\n", zcache_flush_total);
+	pr_info("zcache: flush_found=%zd\n", zcache_flush_found);
+	pr_info("zcache: flobj_total=%zd\n", zcache_flobj_total);
+	pr_info("zcache: flobj_found=%zd\n", zcache_flobj_found);
+	pr_info("zcache: failed_eph_puts=%zd\n", zcache_failed_eph_puts);
+	pr_info("zcache: failed_pers_puts=%zd\n", zcache_failed_pers_puts);
+	pr_info("zcache: failed_get_free_pages=%zd\n",
 				zcache_failed_getfreepages);
-	pr_info("zcache: failed_alloc=%lu\n", zcache_failed_alloc);
-	pr_info("zcache: put_to_flush=%lu\n", zcache_put_to_flush);
-	pr_info("zcache: compress_poor=%lu\n", zcache_compress_poor);
-	pr_info("zcache: mean_compress_poor=%lu\n",
+	pr_info("zcache: failed_alloc=%zd\n", zcache_failed_alloc);
+	pr_info("zcache: put_to_flush=%zd\n", zcache_put_to_flush);
+	pr_info("zcache: compress_poor=%zd\n", zcache_compress_poor);
+	pr_info("zcache: mean_compress_poor=%zd\n",
 				zcache_mean_compress_poor);
-	pr_info("zcache: eph_ate_tail=%lu\n", zcache_eph_ate_tail);
-	pr_info("zcache: eph_ate_tail_failed=%lu\n",
+	pr_info("zcache: eph_ate_tail=%zd\n", zcache_eph_ate_tail);
+	pr_info("zcache: eph_ate_tail_failed=%zd\n",
 				zcache_eph_ate_tail_failed);
-	pr_info("zcache: pers_ate_eph=%lu\n", zcache_pers_ate_eph);
-	pr_info("zcache: pers_ate_eph_failed=%lu\n",
+	pr_info("zcache: pers_ate_eph=%zd\n", zcache_pers_ate_eph);
+	pr_info("zcache: pers_ate_eph_failed=%zd\n",
 				zcache_pers_ate_eph_failed);
-	pr_info("zcache: evicted_eph_zpages=%lu\n", zcache_evicted_eph_zpages);
-	pr_info("zcache: evicted_eph_pageframes=%lu\n",
+	pr_info("zcache: evicted_eph_zpages=%zd\n", zcache_evicted_eph_zpages);
+	pr_info("zcache: evicted_eph_pageframes=%zd\n",
 				zcache_evicted_eph_pageframes);
-	pr_info("zcache: eph_pageframes=%lu\n", zcache_eph_pageframes);
-	pr_info("zcache: eph_pageframes_max=%lu\n", zcache_eph_pageframes_max);
-	pr_info("zcache: pers_pageframes=%lu\n", zcache_pers_pageframes);
-	pr_info("zcache: pers_pageframes_max=%lu\n",
+	pr_info("zcache: eph_pageframes=%zd\n", zcache_eph_pageframes);
+	pr_info("zcache: eph_pageframes_max=%zd\n", zcache_eph_pageframes_max);
+	pr_info("zcache: pers_pageframes=%zd\n", zcache_pers_pageframes);
+	pr_info("zcache: pers_pageframes_max=%zd\n",
 				zcache_pers_pageframes_max);
-	pr_info("zcache: eph_zpages=%lu\n", zcache_eph_zpages);
-	pr_info("zcache: eph_zpages_max=%lu\n", zcache_eph_zpages_max);
-	pr_info("zcache: pers_zpages=%lu\n", zcache_pers_zpages);
-	pr_info("zcache: pers_zpages_max=%lu\n", zcache_pers_zpages_max);
-	pr_info("zcache: last_active_file_pageframes=%lu\n",
+	pr_info("zcache: eph_zpages=%zd\n", zcache_eph_zpages);
+	pr_info("zcache: eph_zpages_max=%zd\n", zcache_eph_zpages_max);
+	pr_info("zcache: pers_zpages=%zd\n", zcache_pers_zpages);
+	pr_info("zcache: pers_zpages_max=%zd\n", zcache_pers_zpages_max);
+	pr_info("zcache: last_active_file_pageframes=%zd\n",
 				zcache_last_active_file_pageframes);
-	pr_info("zcache: last_inactive_file_pageframes=%lu\n",
+	pr_info("zcache: last_inactive_file_pageframes=%zd\n",
 				zcache_last_inactive_file_pageframes);
-	pr_info("zcache: last_active_anon_pageframes=%lu\n",
+	pr_info("zcache: last_active_anon_pageframes=%zd\n",
 				zcache_last_active_anon_pageframes);
-	pr_info("zcache: last_inactive_anon_pageframes=%lu\n",
+	pr_info("zcache: last_inactive_anon_pageframes=%zd\n",
 				zcache_last_inactive_anon_pageframes);
-	pr_info("zcache: eph_nonactive_puts_ignored=%lu\n",
+	pr_info("zcache: eph_nonactive_puts_ignored=%zd\n",
 				zcache_eph_nonactive_puts_ignored);
-	pr_info("zcache: pers_nonactive_puts_ignored=%lu\n",
+	pr_info("zcache: pers_nonactive_puts_ignored=%zd\n",
 				zcache_pers_nonactive_puts_ignored);
 	pr_info("zcache: eph_zbytes=%llu\n",
-				(unsigned long long)zcache_eph_zbytes);
+				zcache_eph_zbytes);
 	pr_info("zcache: eph_zbytes_max=%llu\n",
-				(unsigned long long)zcache_eph_zbytes_max);
+				zcache_eph_zbytes_max);
 	pr_info("zcache: pers_zbytes=%llu\n",
-				(unsigned long long)zcache_pers_zbytes);
+				zcache_pers_zbytes);
 	pr_info("zcache: pers_zbytes_max=%llu\n",
-				(unsigned long long)zcache_pers_zbytes_max);
-	pr_info("zcache: outstanding_writeback_pages=%lu\n",
+				zcache_pers_zbytes_max);
+	pr_info("zcache: outstanding_writeback_pages=%zd\n",
 				zcache_outstanding_writeback_pages);
-	pr_info("zcache: writtenback_pages=%lu\n", zcache_writtenback_pages);
+	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
 }
 #endif
 
-- 
1.8.0.2

