Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaD0RIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:34 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48107 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaD0RI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:29 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Li Xi <lixi@ddn.com>, James Simmons <uja.ornl@gmail.com>
Subject: [PATCH 34/47] staging/lustre/libcfs: add CPU table functions for uniprocessor
Date: Sun, 27 Apr 2014 13:06:58 -0400
Message-Id: <1398618431-29757-35-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <lixi@ddn.com>

Some CPU table functions for uniprocessor architecture is
missing.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-on: http://review.whamcloud.com/8873
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4199
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_cpu.h        |  5 +++++
 .../lustre/include/linux/libcfs/linux/linux-mem.h   |  5 +++++
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c   | 21 +++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
index d116fdf..a140e5d 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
@@ -203,6 +203,11 @@ void cfs_cpt_clear(struct cfs_cpt_table *cptab, int cpt);
 int cfs_cpt_spread_node(struct cfs_cpt_table *cptab, int cpt);
 
 /**
+ * return number of HTs in the same core of \a cpu
+ */
+int cfs_cpu_ht_nsiblings(int cpu);
+
+/**
  * iterate over all CPU partitions in \a cptab
  */
 #define cfs_cpt_for_each(i, cptab)	\
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
index 2af15d4..72c76ad 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
@@ -53,6 +53,11 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 
+#ifndef HAVE_LIBCFS_CPT
+/* Need this for cfs_cpt_table */
+#include <libcfs/libcfs_cpu.h>
+#endif
+
 #define CFS_PAGE_MASK		   (~((__u64)PAGE_CACHE_SIZE-1))
 #define page_index(p)       ((p)->index)
 
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
index 1fb3700..d985e83 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
@@ -75,6 +75,20 @@ cfs_cpt_table_free(struct cfs_cpt_table *cptab)
 EXPORT_SYMBOL(cfs_cpt_table_free);
 
 int
+cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len)
+{
+	int	rc = 0;
+
+	rc = snprintf(buf, len, "%d\t: %d\n", 0, 0);
+	len -= rc;
+	if (len <= 0)
+		return -EFBIG;
+
+	return rc;
+}
+EXPORT_SYMBOL(cfs_cpt_table_print);
+
+int
 cfs_cpt_number(struct cfs_cpt_table *cptab)
 {
 	return 1;
@@ -161,6 +175,13 @@ cfs_cpt_spread_node(struct cfs_cpt_table *cptab, int cpt)
 EXPORT_SYMBOL(cfs_cpt_spread_node);
 
 int
+cfs_cpu_ht_nsiblings(int cpu)
+{
+	return 1;
+}
+EXPORT_SYMBOL(cfs_cpu_ht_nsiblings);
+
+int
 cfs_cpt_current(struct cfs_cpt_table *cptab, int remap)
 {
 	return 0;
-- 
1.8.5.3

