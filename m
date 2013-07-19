Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012Ab3GSIC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:02:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab3GSIBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947438"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 15/21] x86, acpi, numa: Don't reserve memory on nodes the kernel resides in.
Date: Fri, 19 Jul 2013 15:59:28 +0800
Message-Id: <1374220774-29974-16-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:48,
	Serialize complete at 2013/07/19 15:58:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all the memory ranges in SRAT are hotpluggable, we should not reserve all
of them in memblock. Otherwise the kernel won't have enough memory to boot.

And also, memblock will reserve some memory at early time, such initrd file,
kernel code and data segments, and so on. We cannot avoid these anyway.

So we make any node which the kernel resides in un-hotpluggable.

This patch introduces kernel_resides_in_range() to check if the kernel resides
in a memory range. And we can use this function to iterate memblock.reserve[],
and find out which node the kernel resides in. And then, even if the memory in
that node is hotpluggable, we don't reserve it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/osl.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 02a39e2..dfbe6ba 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -774,6 +774,43 @@ phys_addr_t __init early_acpi_firmware_srat()
 }
 
 /*
+ * kernel_resides_in_range - Check if kernel resides in a memory range.
+ * @base: The base address of the memory range.
+ * @length: The length of the memory range.
+ *
+ * memblock reserves some memory for the kernel at very early time, such
+ * as kernel code and data segments, initrd file, and so on. So this
+ * function iterates memblock.reserved[] and check if any memory range with
+ * flag MEMBLK_FLAGS_DEFAULT overlaps [@base, @length). If so, the kernel
+ * resides in this memory range.
+ *
+ * Return true if the kernel resides in the memory range, false otherwise.
+ */
+static bool __init kernel_resides_in_range(phys_addr_t base, u64 length)
+{
+	int i;
+	struct memblock_type *reserved = &memblock.reserved;
+	struct memblock_region *region;
+	phys_addr_t start, end;
+
+	for (i = 0; i < reserved->cnt; i++) {
+		region = &reserved->regions[i];
+
+		if (region->flags != MEMBLK_FLAGS_DEFAULT)
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
+/*
  * acpi_reserve_hotpluggable_memory - Reserve hotpluggable memory in memblock.
  * @srat_vaddr: The virtual address of SRAT.
  *
@@ -817,6 +854,9 @@ void __init acpi_reserve_hotpluggable_memory(void *srat_vaddr)
 		length = ma->length;
 		pxm = ma->proximity_domain;
 
+		if (kernel_resides_in_range(base_address, length))
+			goto next;
+
 		/*
 		 * In such an early time, we don't have nid. We specify pxm
 		 * instead of MAX_NUMNODES to prevent memblock merging regions
-- 
1.7.1

