Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaAIFlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:41:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:58143 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIFlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:41:23 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-61-52ce36819630
From: Weijie Yang <weijie.yang@samsung.com>
To: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, hughd@google.com,
        "'Minchan Kim'" <minchan@kernel.org>, shli@fusionio.com,
        "'Bob Liu'" <bob.liu@oracle.com>, k.kozlowski@samsung.com,
        stable@vger.kernel.org, weijie.yang.kh@gmail.com
Subject: [PATCH] mm/swap: fix race on swap_info reuse between swapoff and swapon
Date: Thu, 09 Jan 2014 13:39:55 +0800
Message-id: <000001cf0cfd$6d251640$476f42c0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8M/Tn+1dLqR8lZQaiFMg+p92yQWA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoG6j2bkgg9uL1S3mrF/DZtF1aiqL
	xdNPfSwWr18YWlzeNYfN4t6a/6wWy76+Z7c4tZzDYsHGR4wWT078Z3Hg8njS9JPZY+esu+we
	CzaVemxa1cnmsenTJHaPEzN+s3h8fHqLxaNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyVi2V
	K+jiqVhxYxZzA+MPzi5GTg4JAROJ3d0v2CFsMYkL99azdTFycQgJTGeUOPt5JSOE84dRYnHj
	VkaQKjYBbYm7/RtZQWwRgRCJc6tns4MUMQu8ZJTYveYzWEJYIEBicttDFhCbRUBVYsu6I2wg
	Nq+AncSSHduZIGxBiR+T74HVMAuoS0yat4gZwpaX2LzmLZDNAXSSusSjv7oQu/Qkphx7xwhR
	Ii6x8cgtlgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	ep5J72Bc1WBxiFGAg1GJh3dF8dkgIdbEsuLK3EOMEhzMSiK8wibngoR4UxIrq1KL8uOLSnNS
	iw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw1k1zv+50d6IWV65UX6yjrOf7ug3q
	K+LYv+/9G9CvtV9xWiMTl9OZz1PCWSNDLJi/L+Y45LPL9yhDubnFhKL2K68yA2vTnXNXi0+d
	NoHtfb+f352Fk4J9d7vYnnJ/OulH+dSZMh5mr3XLNed/29uv86jLy3z5jx7TjVVKZpNbY5kK
	DH7fcA9XYinOSDTUYi4qTgQArvzuSpoCAAA=
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

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 612a7c9..89071c3
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
@@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	* clear SWP_USED flag after all resources freed
+	* so that swapon can reuse this swap_info in alloc_swap_info() safely
+	* it is ok to not hold p->lock after we cleared its SWP_WRITEOK
+	*/
+	spin_lock(&swap_lock);
+	p->flags = 0;
+	spin_unlock(&swap_lock);
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
-- 
1.7.10.4


