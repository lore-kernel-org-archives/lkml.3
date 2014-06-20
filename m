Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966848AbaFTLK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:10:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57342 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966703AbaFTLKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:10:55 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Jiang Liu <liuj97@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Wang Nan <wangnan0@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] mem-hotplug: improve zone_movable_is_highmem logic
Date: Fri, 20 Jun 2014 18:54:14 +0800
Message-ID: <1403261654-11259-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original code, zone_movable_is_highmem() assumes ZONE_MOVABLE not
highmem if CONFIG_HAVE_MEMBLOCK_NODE_MAP is not set. In online_pages, it
extracts pages from the previous zone before ZONE_MOVABLE. Which is
logically inconsistent:

If HAVE_MEMBLOCK_NODE_MAP is turned off but HIGHMEM is on,
zone_movable_is_highmem() makes movable zone not highmem, but
online_pages() extracts pages from ZONE_HIGHMEM.

This inconsistency doesn't cause real problem currently, because all
architectures support online_pages also have HAVE_MEMBLOCK_NODE_MAP.
However, fixing it makes code clear, and also helps futher coding.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Zhen <zhangzhen@huawei.com>
---
 include/linux/mmzone.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6cbd1b6..559e659 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -872,6 +872,8 @@ static inline int zone_movable_is_highmem(void)
 {
 #if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
+#elif defined(CONFIG_HIGHMEM)
+	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
 #else
 	return 0;
 #endif
-- 
1.8.4

