Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaEDQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:28:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaEDPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 138/158] mm: hugetlb: fix softlockup when a large number of hugepages are freed.
Date: Sun,  4 May 2014 11:40:47 -0400
Message-Id: <20140504154048.774400525@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>

commit 55f67141a8927b2be3e51840da37b8a2320143ed upstream.

When I decrease the value of nr_hugepage in procfs a lot, softlockup
happens.  It is because there is no chance of context switch during this
process.

On the other hand, when I allocate a large number of hugepages, there is
some chance of context switch.  Hence softlockup doesn't happen during
this process.  So it's necessary to add the context switch in the
freeing process as same as allocating process to avoid softlockup.

When I freed 12 TB hugapages with kernel-2.6.32-358.el6, the freeing
process occupied a CPU over 150 seconds and following softlockup message
appeared twice or more.

$ echo 6000000 > /proc/sys/vm/nr_hugepages
$ cat /proc/sys/vm/nr_hugepages
6000000
$ grep ^Huge /proc/meminfo
HugePages_Total:   6000000
HugePages_Free:    6000000
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
$ echo 0 > /proc/sys/vm/nr_hugepages

BUG: soft lockup - CPU#16 stuck for 67s! [sh:12883] ...
Pid: 12883, comm: sh Not tainted 2.6.32-358.el6.x86_64 #1
Call Trace:
  free_pool_huge_page+0xb8/0xd0
  set_max_huge_pages+0x128/0x190
  hugetlb_sysctl_handler_common+0x113/0x140
  hugetlb_sysctl_handler+0x1e/0x20
  proc_sys_call_handler+0x97/0xd0
  proc_sys_write+0x14/0x20
  vfs_write+0xb8/0x1a0
  sys_write+0x51/0x90
  __audit_syscall_exit+0x265/0x290
  system_call_fastpath+0x16/0x1b

I have not confirmed this problem with upstream kernels because I am not
able to prepare the machine equipped with 12TB memory now.  However I
confirmed that the amount of decreasing hugepages was directly
proportional to the amount of required time.

I measured required times on a smaller machine.  It showed 130-145
hugepages decreased in a millisecond.

  Amount of decreasing     Required time      Decreasing rate
  hugepages                     (msec)         (pages/msec)
  ------------------------------------------------------------
  10,000 pages == 20GB         70 -  74          135-142
  30,000 pages == 60GB        208 - 229          131-144

It means decrement of 6TB hugepages will trigger softlockup with the
default threshold 20sec, in this decreasing rate.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1509,6 +1509,7 @@ static unsigned long set_max_huge_pages(
 	while (min_count < persistent_huge_pages(h)) {
 		if (!free_pool_huge_page(h, nodes_allowed, 0))
 			break;
+		cond_resched_lock(&hugetlb_lock);
 	}
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, nodes_allowed, 1))


