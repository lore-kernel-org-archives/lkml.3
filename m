Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaJGXa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:30:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaJGXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 11/37] hugetlb: ensure hugepage access is denied if hugepages are not supported
Date: Tue,  7 Oct 2014 16:19:28 -0700
Message-Id: <20141007231827.415393957@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hugetlbfs/inode.c    |    5 +++++
 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   13 +++++++++++++
 3 files changed, 28 insertions(+)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1017,6 +1017,11 @@ static int __init init_hugetlbfs_fs(void
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
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -400,6 +400,16 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
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
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2071,6 +2071,9 @@ static int hugetlb_sysctl_handler_common
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2124,6 +2127,9 @@ int hugetlb_overcommit_handler(struct ct
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->nr_overcommit_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2149,6 +2155,8 @@ out:
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return;
 	seq_printf(m,
 			"HugePages_Total:   %5lu\n"
 			"HugePages_Free:    %5lu\n"
@@ -2165,6 +2173,8 @@ void hugetlb_report_meminfo(struct seq_f
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return 0;
 	return sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
@@ -2179,6 +2189,9 @@ void hugetlb_show_meminfo(void)
 	struct hstate *h;
 	int nid;
 
+	if (!hugepages_supported())
+		return;
+
 	for_each_node_state(nid, N_MEMORY)
 		for_each_hstate(h)
 			pr_info("Node %d hugepages_total=%u hugepages_free=%u hugepages_surp=%u hugepages_size=%lukB\n",


