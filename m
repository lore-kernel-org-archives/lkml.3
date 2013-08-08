Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab3HHJnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:43:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964875Ab3HHJnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:43:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,838,1367942400"; 
   d="scan'208";a="8153674"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: [PATCH part4 4/4] x86, acpi, numa, mem_hotplug: Find hotpluggable memory in SRAT memory affinities.
Date: Thu, 8 Aug 2013 17:41:23 +0800
Message-Id: <1375954883-30225-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 17:41:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 17:41:27,
	Serialize complete at 2013/08/08 17:41:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ACPI SRAT(System Resource Affinity Table), there is a memory affinity for each
memory range in the system. In each memory affinity, there is a field indicating
that if the memory range is hotpluggable.

This patch parses all the memory affinities in SRAT only, and find out all the
hotpluggable memory ranges in the system.

This patch doesn't mark hotpluggable memory in memblock. Memory marked as hotplug
won't be allocated to the kernel. If all the memory in the system is hotpluggable,
then the system won't have enough memory to boot. The basic idea to solve this
problem is making the nodes the kerenl resides in unhotpluggable. So, before we do
this, we don't mark any hotpluggable memory in memory so that to keep memblock
working as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/osl.c   |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |    2 +
 mm/memory_hotplug.c  |   22 ++++++++++++-
 3 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index ec490fe..d01202d 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -780,6 +780,91 @@ phys_addr_t __init early_acpi_firmware_srat(void)
 
 	return table_desc.address;
 }
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hotplug_mem_affinity
+ *
+ * PARAMETERS:  Srat_vaddr         - Virt addr of SRAT
+ *              Base               - The base address of the found hotpluggable
+ *                                   memory region
+ *              Size               - The size of the found hotpluggable memory
+ *                                   region
+ *              Offset             - Offset of the found memory affinity
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This function iterates SRAT affinities list to find memory
+ *              affinities with hotpluggable memory one by one. Return the
+ *              offset of the found memory affinity through @offset. @offset
+ *              can be used to iterate the SRAT affinities list to find all the
+ *              hotpluggable memory affinities. If @offset is 0, it is the first
+ *              time of the iteration.
+ *
+ ******************************************************************************/
+acpi_status __init
+acpi_hotplug_mem_affinity(void *srat_vaddr, u64 *base, u64 *size,
+			  unsigned long *offset)
+{
+	struct acpi_table_header *table_header;
+	struct acpi_subtable_header *entry;
+	struct acpi_srat_mem_affinity *ma;
+	unsigned long table_end, curr;
+
+	if (!offset)
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+
+	table_header = (struct acpi_table_header *)srat_vaddr;
+	table_end = (unsigned long)table_header + table_header->length;
+
+	entry = (struct acpi_subtable_header *)
+		((unsigned long)table_header + *offset);
+
+	if (*offset) {
+		/*
+		 * @offset is the offset of the last affinity found in the
+		 * last call. So need to move to the next affinity.
+		 */
+		entry = (struct acpi_subtable_header *)
+			((unsigned long)entry + entry->length);
+	} else {
+		/*
+		 * Offset of the first affinity is the size of SRAT
+		 * table header.
+		 */
+		entry = (struct acpi_subtable_header *)
+			((unsigned long)entry + sizeof(struct acpi_table_srat));
+	}
+
+	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
+	       table_end) {
+		if (entry->length == 0)
+			break;
+
+		if (entry->type != ACPI_SRAT_TYPE_MEMORY_AFFINITY)
+			goto next;
+
+		ma = (struct acpi_srat_mem_affinity *)entry;
+
+		if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE))
+			goto next;
+
+		if (base)
+			*base = ma->base_address;
+
+		if (size)
+			*size = ma->length;
+
+		*offset = (unsigned long)entry - (unsigned long)srat_vaddr;
+		return_ACPI_STATUS(AE_OK);
+
+next:
+		entry = (struct acpi_subtable_header *)
+			((unsigned long)entry + entry->length);
+	}
+
+	return_ACPI_STATUS(AE_NOT_FOUND);
+}
 #endif	/* CONFIG_ACPI_NUMA */
 
 static void acpi_table_taint(struct acpi_table_header *table)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 280078c..f103e91 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -99,6 +99,8 @@ static inline phys_addr_t early_acpi_override_srat(void)
 
 #ifdef CONFIG_ACPI_NUMA
 phys_addr_t early_acpi_firmware_srat(void);
+acpi_status acpi_hotplug_mem_affinity(void *srat_vaddr, u64 *base,
+				      u64 *size, unsigned long *offset);
 #endif  /* CONFIG_ACPI_NUMA */
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2dfb06f..ef9ccf8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -103,7 +103,11 @@ static void release_memory_resource(struct resource *res)
  */
 void __init find_hotpluggable_memory(void)
 {
-	phys_addr_t srat_paddr;
+	void *srat_vaddr;
+	phys_addr_t srat_paddr, base, size;
+	u32 length;
+	struct acpi_table_header *srat_header;
+	unsigned long offset = 0;
 
 	/* Try to find if SRAT is overridden */
 	srat_paddr = early_acpi_override_srat();
@@ -114,7 +118,21 @@ void __init find_hotpluggable_memory(void)
 			return;
 	}
 
-	/* Will parse SRAT and find out hotpluggable memory here */
+	/* Get the length of SRAT */
+	srat_header = early_ioremap(srat_paddr,
+				    sizeof(struct acpi_table_header));
+	length = srat_header->length;
+	early_iounmap(srat_header, sizeof(struct acpi_table_header));
+
+	/* Find all the hotpluggable memory regions */
+	srat_vaddr = early_ioremap(srat_paddr, length);
+
+	while (ACPI_SUCCESS(acpi_hotplug_mem_affinity(srat_vaddr, &base,
+						      &size, &offset))) {
+		/* Will mark hotpluggable memory regions here */
+	}
+
+	early_iounmap(srat_vaddr, length);
 }
 #endif	/* CONFIG_ACPI_NUMA */
 
-- 
1.7.1

