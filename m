Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3H0JlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:41:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49294 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3H0JjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:39:15 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367942400"; 
   d="scan'208";a="8317107"
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
Subject: [PATCH 08/11] x86, acpi, memblock: Use __memblock_alloc_base() in acpi_initrd_override()
Date: Tue, 27 Aug 2013 17:37:45 +0800
Message-Id: <1377596268-31552-9-git-send-email-tangchen@cn.fujitsu.com>
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

The current acpi_initrd_override() calls memblock_find_in_range() to allocate
memory, and pass 0 to %start, which will not limited by the current_limit_low.

acpi_initrd_override()
 |->memblock_find_in_range(0, ...)
     |->memblock_find_in_range_node(0, ...)

When we want to allocate memory from the end of kernel image to higher memory,
we need to limit the lowest address to the end of kernel image.

We have modified memblock_alloc_base_nid() to call memblock_find_in_range_node()
with %start = MEMBLOCK_ALLOC_ACCESSIBLE, which means it will be limited by
current_limit_low. And __memblock_alloc_base() calls memblock_alloc_base_nid().

__memblock_alloc_base()
 |->memblock_alloc_base_nid()
     |->memblock_find_in_range_node(MEMBLOCK_ALLOC_ACCESSIBLE, ...)

So use __memblock_alloc_base() to allocate memory in acpi_initrd_override().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/osl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index fece767..1d68fc0 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -629,8 +629,8 @@ void __init acpi_initrd_override(void *data, size_t size)
 		return;
 
 	/* under 4G at first, then above 4G */
-	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
-					all_tables_size, PAGE_SIZE);
+	acpi_tables_addr = __memblock_alloc_base(all_tables_size,
+						 PAGE_SIZE, (1ULL<<32) - 1);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
 		return;
-- 
1.7.1

