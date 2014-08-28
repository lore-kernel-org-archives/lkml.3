Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaH1SgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaH1Sfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 06/97] hugetlb: ensure hugepage access is denied if hugepages are not supported
Date: Thu, 28 Aug 2014 19:34:14 +0100
Message-Id: <1409250945-30874-7-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

commit 457c1b27ed56ec472d202731b12417bff023594a upstream.

Currently, I am seeing the following when I `mount -t hugetlbfs /none
/dev/hugetlbfs`, and then simply do a `ls /dev/hugetlbfs`.  I think it's
related to the fact that hugetlbfs is properly not correctly setting
itself up in this state?:

  Unable to handle kernel paging request for data at address 0x00000031
  Faulting instruction address: 0xc000000000245710
  Oops: Kernel access of bad area, sig: 11 [#1]
  SMP NR_CPUS=2048 NUMA pSeries
  ....

In KVM guests on Power, in a guest not backed by hugepages, we see the
following:

  AnonHugePages:         0 kB
  HugePages_Total:       0
  HugePages_Free:        0
  HugePages_Rsvd:        0
  HugePages_Surp:        0
  Hugepagesize:         64 kB

HPAGE_SHIFT == 0 in this configuration, which indicates that hugepages
are not supported at boot-time, but this is only checked in
hugetlb_init().  Extract the check to a helper function, and use it in a
few relevant places.

This does make hugetlbfs not supported (not registered at all) in this
environment.  I believe this is fine, as there are no valid hugepages
and that won't change at runtime.

[akpm@linux-foundation.org: use pr_info(), per Mel]
[akpm@linux-foundation.org: fix build when HPAGE_SHIFT is undefined]
Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/hugetlbfs/inode.c    |  5 +++++
 include/linux/hugetlb.h | 10 ++++++++++
 mm/hugetlb.c            | 13 +++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index d19b30a..a4a8ed5 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1017,6 +1017,11 @@ static int __init init_hugetlbfs_fs(void)
 	int error;
 	int i;
 
+	if (!hugepages_supported()) {
+		pr_info("hugetlbfs: disabling because there are no supported hugepage sizes\n");
+		return -ENOTSUPP;
+	}
+
 	error = bdi_init(&hugetlbfs_backing_dev_info);
 	if (error)
 		return error;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5214ff6..511b1a0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -396,6 +396,16 @@ static inline int hugepage_migration_support(struct hstate *h)
 #endif
 }
 
+static inline bool hugepages_supported(void)
+{
+	/*
+	 * Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	return HPAGE_SHIFT != 0;
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 92e103b..2814ca8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2114,6 +2114,9 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2167,6 +2170,9 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->nr_overcommit_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2192,6 +2198,8 @@ out:
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return;
 	seq_printf(m,
 			"HugePages_Total:   %5lu\n"
 			"HugePages_Free:    %5lu\n"
@@ -2208,6 +2216,8 @@ void hugetlb_report_meminfo(struct seq_file *m)
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return 0;
 	return sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
@@ -2222,6 +2232,9 @@ void hugetlb_show_meminfo(void)
 	struct hstate *h;
 	int nid;
 
+	if (!hugepages_supported())
+		return;
+
 	for_each_node_state(nid, N_MEMORY)
 		for_each_hstate(h)
 			pr_info("Node %d hugepages_total=%u hugepages_free=%u hugepages_surp=%u hugepages_size=%lukB\n",
-- 
1.8.4.5

