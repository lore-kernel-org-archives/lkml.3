Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3HAHIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:08:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3HAHIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:08:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,792,1367942400"; 
   d="scan'208";a="8085217"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 13/18] x86, numa, mem_hotplug: Skip all the regions the kernel resides in.
Date: Thu, 1 Aug 2013 15:06:35 +0800
Message-Id: <1375340800-19332-14-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 15:06:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 15:06:55
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At early time, memblock will reserve some memory for the kernel,
such as the kernel code and data segments, initrd file, and so on，
which means the kernel resides in these memory regions.

Even if these memory regions are hotpluggable, we should not
mark them as hotpluggable. Otherwise the kernel won't have enough
memory to boot.

This patch finds out which memory regions the kernel resides in,
and skip them when finding all hotpluggable memory regions.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 326e2f2..b800c9c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -31,6 +31,7 @@
 #include <linux/firmware-map.h>
 #include <linux/stop_machine.h>
 #include <linux/acpi.h>
+#include <linux/memblock.h>
 
 #include <asm/tlbflush.h>
 
@@ -93,6 +94,40 @@ static void release_memory_resource(struct resource *res)
 
 #ifdef CONFIG_ACPI_NUMA
 /**
+ * kernel_resides_in_range - Check if kernel resides in a memory region.
+ * @base: The base address of the memory region.
+ * @length: The length of the memory region.
+ *
+ * This function is used at early time. It iterates memblock.reserved and check
+ * if the kernel has used any memory in [@base, @base + @length).
+ *
+ * Return true if the kernel resides in the memory region, false otherwise.
+ */
+static bool __init kernel_resides_in_region(phys_addr_t base, u64 length)
+{
+	int i;
+	phys_addr_t start, end;
+	struct memblock_region *region;
+	struct memblock_type *reserved = &memblock.reserved;
+
+	for (i = 0; i < reserved->cnt; i++) {
+		region = &reserved->regions[i];
+
+		if (region->flags != MEMBLOCK_HOTPLUG)
+			continue;
+
+		start = region->base;
+		end = region->base + region->size;
+		if (end <= base || start >= base + length)
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
+/**
  * find_hotpluggable_memory - Find out hotpluggable memory from ACPI SRAT.
  *
  * This function did the following:
@@ -129,6 +164,16 @@ void __init find_hotpluggable_memory(void)
 
 	while (ACPI_SUCCESS(acpi_hotplug_mem_affinity(srat_vaddr, &base,
 						      &size, &offset))) {
+		/*
+		 * At early time, memblock will reserve some memory for the
+		 * kernel, such as the kernel code and data segments, initrd
+		 * file, and so on，which means the kernel resides in these
+		 * memory regions. These regions should not be hotpluggable.
+		 * So do not mark them as hotpluggable.
+		 */
+		if (kernel_resides_in_region(base, size))
+			continue;
+
 		/* Will mark hotpluggable memory regions here */
 	}
 
-- 
1.7.1

