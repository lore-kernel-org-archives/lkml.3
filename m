Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaA0KKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:10:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60208 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaA0KKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:10:03 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-1d-52e6307a5778
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/8] mm/swap: fix race on swap_info reuse between swapoff and
 swapon
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000d01cf1b47$f12e11f0$d38a35d0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRuTYzqeM0Z/kS7aK909yUBXOSw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd0qg2dBBkfmclnMWb+GzaLr1FQW
	i4OzlzBZPP3Ux2JxedccNot7a/6zWiz7+p7dYsrDSYwWFw7dZ7L4dPQRm8WCjY8YLZ6c+M/i
	wOOxc9Zddo8Fm0o9Nq3qZPPY9GkSu8eJGb9ZPD4+vcXi8X7fVTaPvi2rGD2ufyvy+LxJLoAr
	issmJTUnsyy1SN8ugStj850bTAW3hSomLNvN1MA4gb+LkZNDQsBEYvqbE+wQtpjEhXvr2UBs
	IYFFjBJ7W1i6GLmA7D+MEg0n94El2AS0Je72b2QFsUUERCTW3FnICFLELPCLSaK//wBQBweH
	sECYxJOz1iA1LAKqEkcPTWcHCfMK2Ek8mqMFEuYVEJT4MfkeWDWzgLrElCm5IGFmAXmJzWve
	MoOEJYDCj/7qQizSk3i2+goLRIm4xMYjt1gmMArMQjJoFsKgWUgGzULSsYCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcFQ9k97BuKrB4hCjAAejEg9vxvWnQUKsiWXFlbmHGCU4mJVE
	eCt0ngUJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYNx2
	9PTd/anaTKXmLKYbWRragjXNTiS0RJqWbk5vdc76dDWMhU3z4KLeKM9iK583xwp+GmW9t7/p
	ns9mevqmdnkK78aC7XNO/V9Q8m/lrK1Lv2r+vLvtno8nw+YpGhUVExJ+ljW82/tuI/Pkh+9a
	7h24fjl6+YRD8kobzE5XV7qps60oqg7q2avEUpyRaKjFXFScCAA4F0Y1pgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swapoff clear swap_info's SWP_USED flag prematurely and free its resources
after that. A concurrent swapon will reuse this swap_info while its previous
resources are not cleared completely.

These late freed resources are:
 - p->percpu_cluster
 - swap_cgroup_ctrl[type]
 - block_device setting
 - inode->i_flags &= ~S_SWAPFILE

This patch clear SWP_USED flag after all its resources freed, so that swapon
can reuse this swap_info by alloc_swap_info() safely.

This patch is just for a rare scenario, aim to correct of code.

Suggested-by: Heesub Shin <heesub.shin@samsung.com>
Suggested-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/swapfile.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0a623a9..4d24158 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1977,7 +1977,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
@@ -2003,6 +2002,15 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	 * clear SWP_USED flag after all resources freed so that
+	 * swapon can reuse this swap_info in alloc_swap_info() safely
+	 * it is ok to not hold any lock after we cleared SWP_WRITEOK flag
+	 */
+	smp_wmb();
+	p->flags = 0;
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -2050,7 +2058,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	for (type = 0; type < nr_swapfiles; type++) {
 		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
 		si = swap_info[type];
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->flags & SWP_WRITEOK))
 			continue;
 		if (!--l)
 			return si;
@@ -2072,7 +2080,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 	for (; type < nr_swapfiles; type++) {
 		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
 		si = swap_info[type];
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->flags & SWP_WRITEOK))
 			continue;
 		++*pos;
 		return si;
-- 
1.7.10.4


