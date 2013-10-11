Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3JKJym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:54:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20712 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3JKJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:54:40 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-1b-5257cade7096
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Weijie Yang <weijie.yang.kh@gmail.com>, Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] swap: fix set_blocksize race during swapon/swapoff
Date: Fri, 11 Oct 2013 11:54:22 +0200
Message-id: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xq7r3ToUHGaz+ImkxZ/0aNouuU1NZ
	LF6/MLRYtvgpo8XlXXPYLO6t+c9qsezre3aLU8s5LJ6c+M/iwOnxpOkns8fOWXfZPTat6mTz
	2PRpErvHiRm/WTw+Pr3F4tG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZb8/dZyp4z1nx4sBV
	5gbGbo4uRk4OCQETiRsXJrBA2GISF+6tZ+ti5OIQEljKKNE78zgzSEJIoI9J4sByRhCbTcBY
	YvPyJWwgtohAokTjoflgDcwC7xkler5tAUsICzhLbJhyB8jm4GARUJVYd8oIJMwr4C6xfOFz
	FpCwhICCxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmoLzsYFx+zOsQo
	wMGoxMNrwRAeJMSaWFZcmXuIUYKDWUmEV/AkUIg3JbGyKrUoP76oNCe1+BAjEwenVAPj3I82
	3UZaXOvYPZ5vuha8asK5hWyrNd9dZPLQ2OfDZbd8tdXyYL4dogmna3RcNB+q/AqMSDpYZ3dZ
	0b9zcmX4x6ORE5I4NEpNzBMmrr/0QDVTP9BK3un2UbP1iuIVHu1rMswl3NRPNd946lA15dts
	7nW1s54obvmz0EVe8sQBh8IXi/5stjilxFKckWioxVxUnAgAcsjGPQYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swapoff used old_block_size from swap_info which could be overwritten by
concurrent swapon.

Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3963fc2..de7c904 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1824,6 +1824,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct filename *pathname;
 	int i, type, prev;
 	int err;
+	unsigned int old_block_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1914,6 +1915,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	}
 
 	swap_file = p->swap_file;
+	old_block_size = p->old_block_size;
 	p->swap_file = NULL;
 	p->max = 0;
 	swap_map = p->swap_map;
@@ -1938,7 +1940,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
-		set_blocksize(bdev, p->old_block_size);
+		set_blocksize(bdev, old_block_size);
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	} else {
 		mutex_lock(&inode->i_mutex);
-- 
1.7.9.5

