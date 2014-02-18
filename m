Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaBRXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:09:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaBRWqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weijie Yang <weijie.yang@samsung.com>, Hugh Dickins <hughd@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 19/32] mm/swap: fix race on swap_info reuse between swapoff and swapon
Date: Tue, 18 Feb 2014 14:47:19 -0800
Message-Id: <20140218224500.644010849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->swap_map = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	frontswap_map_set(p, NULL);
 	spin_unlock(&p->lock);
@@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __us
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


