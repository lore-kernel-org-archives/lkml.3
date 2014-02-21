Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaBUNuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:50:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46857 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaBUMt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/121] mm/swap: fix race on swap_info reuse between swapoff and swapon
Date: Fri, 21 Feb 2014 12:47:38 +0000
Message-Id: <1392986945-9693-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit f893ab41e4dae2fe8991faf5d86d029068d1ef3a upstream.

swapoff clear swap_info's SWP_USED flag prematurely and free its
resources after that.  A concurrent swapon will reuse this swap_info
while its previous resources are not cleared completely.

These late freed resources are:
 - p->percpu_cluster
 - swap_cgroup_ctrl[type]
 - block_device setting
 - inode->i_flags &= ~S_SWAPFILE

This patch clears the SWP_USED flag after all its resources are freed,
so that swapon can reuse this swap_info by alloc_swap_info() safely.

[akpm@linux-foundation.org: tidy up code comment]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/swapfile.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6cf2e60..d58fe88 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1675,7 +1675,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	frontswap_map_set(p, NULL);
 	spin_unlock(&p->lock);
@@ -1698,6 +1697,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so that swapon
+	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
+	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 */
+	spin_lock(&swap_lock);
+	p->flags = 0;
+	spin_unlock(&swap_lock);
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
-- 
1.9.0

