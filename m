Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3H0Jlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:41:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab3H0JjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:39:15 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367942400"; 
   d="scan'208";a="8317106"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 07/11] x86, memblock: Set lowest limit for memblock_alloc_base_nid().
Date: Tue, 27 Aug 2013 17:37:44 +0800
Message-Id: <1377596268-31552-8-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:14,
	Serialize complete at 2013/08/27 17:37:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_alloc_base_nid() is a common API of memblock. And it calls
memblock_find_in_range_node() with %start = 0, which means it has no
limit for the lowest address by default.

	memblock_find_in_range_node(0, max_addr, size, align, nid);

Since we introduced current_limit_low to memblock, if we have no limit
for the lowest address or we are not sure, we should pass
MEMBLOCK_ALLOC_ACCESSIBLE to %start so that it will be limited by the
default low limit.

dma_contiguous_reserve() and setup_log_buf() will eventually call
memblock_alloc_base_nid() to allocate memory. So if the allocation order
is from low to high, they will allocate memory from the lowest limit
to higher memory.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/memblock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 961d4a5..be8c4d1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -851,7 +851,8 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
-	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
+	found = memblock_find_in_range_node(MEMBLOCK_ALLOC_ACCESSIBLE,
+					    max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
-- 
1.7.1

