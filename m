Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaI3V5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:57:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaI3Vhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/103] memblock, memhotplug: fix wrong type in memblock_find_in_range_node().
Date: Tue, 30 Sep 2014 14:31:21 -0700
Message-Id: <1412112708-27356-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Chen <tangchen@cn.fujitsu.com>

commit 0cfb8f0c3e21e36d4a6e472e4c419d58ba848698 upstream.

In memblock_find_in_range_node(), we defined ret as int.  But it should
be phys_addr_t because it is used to store the return value from
__memblock_find_range_bottom_up().

The bug has not been triggered because when allocating low memory near
the kernel end, the "int ret" won't turn out to be negative.  When we
started to allocate memory on other nodes, and the "int ret" could be
minus.  Then the kernel will panic.

A simple way to reproduce this: comment out the following code in
numa_init(),

        memblock_set_bottom_up(false);

and the kernel won't boot.

Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memblock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 53e477b..4ae6835 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -177,8 +177,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align, int nid)
 {
-	int ret;
-	phys_addr_t kernel_end;
+	phys_addr_t kernel_end, ret;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-- 
1.9.1

