Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3DDJL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:11:58 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35682 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3DDJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:09:34 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/6] mm/hugetlb: introduce new sysctl knob which control gigantic page pools shrinking
Date: Thu,  4 Apr 2013 17:09:09 +0800
Message-Id: <1365066554-29195-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040409-8256-0000-0000-000006EE6EF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new sysctl knob to support gigantic hugetlb page
pools shrinking. The default value is 0 since gigantic page pools
aren't permitted shrinked by default, administrator can echo 1 to knob
to enable gigantic page pools shrinking after they confirm they won't
use them any more.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 Documentation/sysctl/vm.txt |   13 +++++++++++++
 include/linux/hugetlb.h     |    3 +++
 kernel/sysctl.c             |    7 +++++++
 mm/hugetlb.c                |    9 +++++++++
 4 files changed, 32 insertions(+)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 21ad181..3baf332 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -30,6 +30,7 @@ Currently, these files are in /proc/sys/vm:
 - extfrag_threshold
 - hugepages_treat_as_movable
 - hugetlb_shm_group
+- hugetlb_shrink_gigantic_pool
 - laptop_mode
 - legacy_va_layout
 - lowmem_reserve_ratio
@@ -211,6 +212,18 @@ shared memory segment using hugetlb page.
 
 ==============================================================
 
+hugetlb_shrink_gigantic_pool
+
+order >= MAX_ORDER pages are only allocated at boot stage using the bootmem
+allocator with the "hugepages=xxx" option. These pages are never free'd
+by default since it would be a one-way street(>= MAX_ORDER pages cannot
+be allocated later), but if administrator confirm not to use these gigantic
+pages any more, these pinned pages will waste memory since other users
+can't grab free pages from gigantic hugetlb pool even OOM. Administrator
+can enable this parameter to permit to shrink gigantic hugetlb pool
+
+==============================================================
+
 laptop_mode
 
 laptop_mode is a knob that controls "laptop mode". All the things that are
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3a62df3..b7e4106 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -36,6 +36,8 @@ void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
+int hugetlb_shrink_gigantic_pool_handler(struct ctl_table *,
+				int, void __user *, size_t *, loff_t *);
 
 #ifdef CONFIG_NUMA
 int hugetlb_mempolicy_sysctl_handler(struct ctl_table *, int,
@@ -73,6 +75,7 @@ extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
+extern int hugetlb_shrink_gigantic_pool;
 
 /* arch callbacks */
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3dadde5..25eb85f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1187,6 +1187,13 @@ static struct ctl_table vm_table[] = {
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
 	},
+	{
+		.procname       = "hugetlb_shrink_gigantic_pool",
+		.data           = &hugetlb_shrink_gigantic_pool,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = hugetlb_shrink_gigantic_pool_handler,
+	},
 #ifdef CONFIG_NUMA
 	{
 		.procname       = "nr_hugepages_mempolicy",
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bacdf38..4a0c270 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -35,6 +35,7 @@
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
+int hugetlb_shrink_gigantic_pool;
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -671,6 +672,14 @@ static void prep_compound_gigantic_page(struct page *page, unsigned long order)
 	}
 }
 
+int hugetlb_shrink_gigantic_pool_handler(struct ctl_table *table, int write,
+			void __user *buffer,
+			size_t *length, loff_t *ppos)
+{
+	proc_dointvec(table, write, buffer, length, ppos);
+	return 0;
+}
+
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for normal or
  * transparent huge pages.  See the PageTransHuge() documentation for more
-- 
1.7.10.4

