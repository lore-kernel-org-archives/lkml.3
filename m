Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315Ab3DKU0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380Ab3DKU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:40 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YF3mRmZm-UsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=V8TitVSzo-UA:10 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=ENpiZwNaThevNlzpct4A:9 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.519774671@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 045/171 ] mm/hugetlb: fix total hugetlbfs pages count when using memory
 overcommit accouting
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0045-mm-hugetlb-fix-total-hugetlbfs-pages-count-when-usin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

[ Upstream commit d00285884c0892bb1310df96bce6056e9ce9b9d9 ]

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
Cc: <stable@vger.kernel.org>		[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3adceaf..651d1ab 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2131,8 +2131,12 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
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
1.7.10.4


