Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab3CZPet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:34:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325Ab3CZPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 117/150] mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting
Date: Tue, 26 Mar 2013 15:20:16 +0000
Message-Id: <1364311249-14454-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

commit d00285884c0892bb1310df96bce6056e9ce9b9d9 upstream.

hugetlb_total_pages is used for overcommit calculations but the current
implementation considers only the default hugetlb page size (which is
either the first defined hugepage size or the one specified by
default_hugepagesz kernel boot parameter).

If the system is configured for more than one hugepage size, which is
possible since commit a137e1cc6d6e ("hugetlbfs: per mount huge page
sizes") then the overcommit estimation done by __vm_enough_memory()
(resp.  shown by meminfo_proc_show) is not precise - there is an
impression of more available/allowed memory.  This can lead to an
unexpected ENOMEM/EFAULT resp.  SIGSEGV when memory is accounted.

Testcase:
  boot: hugepagesz=1G hugepages=1
  the default overcommit ratio is 50
  before patch:

    egrep 'CommitLimit' /proc/meminfo
    CommitLimit:     55434168 kB

  after patch:

    egrep 'CommitLimit' /proc/meminfo
    CommitLimit:     54909880 kB

[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 33d8b38..f30e463 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2096,8 +2096,12 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	struct hstate *h = &default_hstate;
-	return h->nr_huge_pages * pages_per_huge_page(h);
+	struct hstate *h;
+	unsigned long nr_total_pages = 0;
+
+	for_each_hstate(h)
+		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
+	return nr_total_pages;
 }
 
 static int hugetlb_acct_memory(struct hstate *h, long delta)
-- 
1.8.1.2

