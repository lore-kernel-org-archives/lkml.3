Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3CYBeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:34:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab3CYBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:28 -0400
Message-Id: <20130325010534.313135591@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:07:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 101/104] mm/hugetlb: fix total hugetlbfs pages count when using memory
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 overcommit accouting
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2092,8 +2092,12 @@ int hugetlb_report_node_meminfo(int nid,
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


