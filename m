Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3DDJJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:09:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58204 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3DDJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:09:29 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink supporting
Date: Thu,  4 Apr 2013 17:09:08 +0800
Message-Id: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040409-8878-0000-0000-0000069250EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

order >= MAX_ORDER pages are only allocated at boot stage using the 
bootmem allocator with the "hugepages=xxx" option. These pages are never 
free after boot by default since it would be a one-way street(>= MAX_ORDER
pages cannot be allocated later), but if administrator confirm not to 
use these gigantic pages any more, these pinned pages will waste memory
since other users can't grab free pages from gigantic hugetlb pool even
if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
shrink supporting. Administrator can enable knob exported in sysctl to
permit to shrink gigantic hugetlb pool.

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

