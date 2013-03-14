Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3CNLbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:31:05 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51396 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab3CNLbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:31:03 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3] mm/hugetlb: fix total hugetlbfs pages count when memory overcommit accouting
Date: Thu, 14 Mar 2013 19:30:46 +0800
Message-Id: <1363260646-26896-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031411-8256-0000-0000-0000069D3100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v2 -> v3:
  * update patch description, spotted by Michal
 v1 -> v2:
  * update patch description, spotted by Michal

"hugetlb_total_pages is used for overcommit calculations but the
current implementation considers only default hugetlb page size (which
is either the first defined hugepage size or the one specified by
default_hugepagesz kernel boot parameter).

If the system is configured for more than one hugepage size (which is
possible since a137e1cc hugetlbfs: per mount huge page sizes) then
the overcommit estimation done by __vm_enough_memory (resp. shown by
meminfo_proc_show) is not precise - there is an impression of more
available/allowed memory. This can lead to an unexpected ENOMEM/EFAULT
resp. SIGSEGV when memory is accounted."

The patch should also push to 2.6.27 stable tree.

Testcase:
boot: hugepagesz=1G hugepages=1
the default overcommit ratio is 50
before patch:
egrep 'CommitLimit' /proc/meminfo
CommitLimit:     55434168 kB
after patch:
egrep 'CommitLimit' /proc/meminfo
CommitLimit:     54909880 kB

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hugetlb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cdb64e4..9e25040 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2124,8 +2124,11 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	struct hstate *h = &default_hstate;
-	return h->nr_huge_pages * pages_per_huge_page(h);
+	struct hstate *h;
+	unsigned long nr_total_pages = 0;
+	for_each_hstate(h)
+		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
+	return nr_total_pages;
 }
 
 static int hugetlb_acct_memory(struct hstate *h, long delta)
-- 
1.7.11.7

