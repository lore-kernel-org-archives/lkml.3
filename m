Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3DQAgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:36:51 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41674 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3DQAgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:36:46 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 0/6] mm/hugetlb: gigantic hugetlb page pools shrink supporting
Date: Wed, 17 Apr 2013 08:36:28 +0800
Message-Id: <1366158995-3116-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041700-7014-0000-0000-000002DDC223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 * add comments from Andi which indicate shrink gigantic hugetlb page pools make 
   sense to patchset description.

order >= MAX_ORDER pages are only allocated at boot stage using the 
bootmem allocator with the "hugepages=xxx" option. These pages are never 
free after boot by default since it would be a one-way street(>= MAX_ORDER
pages cannot be allocated later), but if administrator confirm not to 
use these gigantic pages any more, these pinned pages will waste memory
since other users can't grab free pages from gigantic hugetlb pool even
if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
shrink supporting. Administrator can enable knob exported in sysctl to
permit to shrink gigantic hugetlb pool.

http://marc.info/?l=linux-mm&m=136578016214512&w=2 
Andi thinks this idea make sense since he is working on a new patchkit to 
allocate GB pages from CMA. With that freeing actually makes sense, as the 
pages can be reallocated.

Testcase:
boot: hugepagesz=1G hugepages=10

[root@localhost hugepages]# free -m
             total       used       free     shared    buffers     cached
Mem:         36269      10836      25432          0         11        288
-/+ buffers/cache:      10537      25732
Swap:        35999          0      35999
[root@localhost hugepages]# echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
-bash: echo: write error: Invalid argument
[root@localhost hugepages]# echo 1 > /proc/sys/vm/hugetlb_shrink_gigantic_pool
[root@localhost hugepages]# echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
[root@localhost hugepages]# free -m
             total       used       free     shared    buffers     cached
Mem:         36269        597      35672          0         11        288
-/+ buffers/cache:        297      35972
Swap:        35999          0      35999

Wanpeng Li (6):
  introduce new sysctl knob which control gigantic page pools shrinking
  update_and_free_page gigantic pages awareness
  enable gigantic hugetlb page pools shrinking
  use already exist huge_page_order() instead of h->order
  remove redundant hugetlb_prefault 
  use already exist interface huge_page_shift

 Documentation/sysctl/vm.txt |   13 +++++++
 include/linux/hugetlb.h     |    5 +--
 kernel/sysctl.c             |    7 ++++
 mm/hugetlb.c                |   83 +++++++++++++++++++++++++++++--------------
 mm/internal.h               |    1 +
 mm/page_alloc.c             |    2 +-
 6 files changed, 82 insertions(+), 29 deletions(-)

-- 
1.7.10.4

