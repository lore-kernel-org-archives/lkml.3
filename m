Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaHJGcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 02:32:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3081 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046AbaHJGcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 02:32:06 -0400
X-IronPort-AV: E=Sophos;i="5.04,299,1406563200"; 
   d="scan'208";a="34422969"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <phacht@linux.vnet.ibm.com>,
        <yinghai@kernel.org>, <fabf@skynet.be>, <Emilian.Medve@freescale.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>
Subject: [PATCH 1/1] memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().
Date: Sun, 10 Aug 2014 14:12:03 +0800
Message-ID: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In memblock_find_in_range_node(), we defeind ret as int. But it shoule
be phys_addr_t because it is used to store the return value from
__memblock_find_range_bottom_up().

The bug has not been triggered because when allocating low memory near
the kernel end, the "int ret" won't turn out to be minus. When we started
to allocate memory on other nodes, and the "int ret" could be minus.
Then the kernel will panic.

A simple way to reproduce this: comment out the following code in numa_init(),

        memblock_set_bottom_up(false);

and the kernel won't boot.

Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memblock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6d2f219..70fad0c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -192,8 +192,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid)
 {
-	int ret;
-	phys_addr_t kernel_end;
+	phys_addr_t kernel_end, ret;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-- 
1.8.3.1

