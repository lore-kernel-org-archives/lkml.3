Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364Ab3GSICj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:02:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965527Ab3GSIBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947439"
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
Subject: [PATCH 14/21] x86, acpi, numa: Reserve hotpluggable memory at early time.
Date: Fri, 19 Jul 2013 15:59:27 +0800
Message-Id: <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com>
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

As mentioned before, in order to prevent the kernel to use hotpluggable
memory, we want to reserve hotpluggable memory in memblock at early time.

As the previous two patches are able to find SRAT in initrd file or
fireware, this patch does the following:
1. Introduces acpi_reserve_hotpluggable_memory() to parse the memory
   affinities in SRAT, find out which memory is hotpluggable.
2. Reserve it in memblock with MEMBLK_HOTPLUGGABLE flag.
3. Since at such an early time, nid has not been mapped, we also reserve
   the PXM of the hotpluggable memory range in memblock. Later we will
   modify it to nid.

In order to setup movable node (a node who has only ZONE_MOVABLE), it
will be very convenient if we can tell which memory range in memblock
is hotpluggable, and belongs to which node. We will see this convenience
in later patches. So we don't want memblock to merge memory ranges in
different nodes together.

PXM is the Proximity num provided by SRAT, used to map nid. At such an
early time, we don't have nid, so we reserve PXM in memblock to prevent
merging of different nodes' memory.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/osl.c   |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |    1 +
 mm/memory_hotplug.c  |   14 ++++++++++-
 3 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index a2e4596..02a39e2 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -772,6 +772,71 @@ phys_addr_t __init early_acpi_firmware_srat()
 
 	return table_desc.address;
 }
+
+/*
+ * acpi_reserve_hotpluggable_memory - Reserve hotpluggable memory in memblock.
+ * @srat_vaddr: The virtual address of SRAT.
+ *
+ * This function parse memory affinities in SRAT, find out which memory is
+ * hotpluggable, and reserve it in memblock with MEMBLK_HOTPLUGGABLE flag.
+ *
+ * NOTE: At such an early time, we don't have nid yet. So use PXM instead of
+ *       nid when reserving in memblock, and modify it when nids are mapped.
+ */
+void __init acpi_reserve_hotpluggable_memory(void *srat_vaddr)
+{
+	struct acpi_table_header *table_header;
+	struct acpi_subtable_header *entry;
+	struct acpi_srat_mem_affinity *ma;
+	unsigned long table_end;
+	unsigned int count = 0;
+	u32 pxm;
+	u64 base_address, length;
+
+	table_header = (struct acpi_table_header *)srat_vaddr;
+	table_end = (unsigned long)table_header + table_header->length;
+
+	entry = (struct acpi_subtable_header *)
+		((unsigned long)table_header + sizeof(struct acpi_table_srat));
+
+	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
+	       table_end) {
+		if (entry->length == 0)
+			break;
+
+		if (entry->type != ACPI_SRAT_TYPE_MEMORY_AFFINITY ||
+		    count++ >= NR_NODE_MEMBLKS)
+			goto next;
+
+		ma = (struct acpi_srat_mem_affinity *)entry;
+
+		if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE))
+			goto next;
+
+		base_address = ma->base_address;
+		length = ma->length;
+		pxm = ma->proximity_domain;
+
+		/*
+		 * In such an early time, we don't have nid. We specify pxm
+		 * instead of MAX_NUMNODES to prevent memblock merging regions
+		 * on different nodes. And later modify pxm to nid when nid is
+		 * mapped so that we can arrange ZONE_MOVABLE on different
+		 * nodes.
+		 */
+		memblock_reserve_hotpluggable(base_address, length, pxm);
+
+next:
+		entry = (struct acpi_subtable_header *)
+			((unsigned long)entry + entry->length);
+	}
+
+	if (count > NR_NODE_MEMBLKS) {
+		pr_warning("[%4.4s:0x%02x] ignored %i entries of %i found\n",
+			   ACPI_SIG_SRAT, ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+			   count - NR_NODE_MEMBLKS, count);
+	}
+}
 #endif	/* CONFIG_ACPI_NUMA */
 
 static void acpi_table_taint(struct acpi_table_header *table)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6fa7543..21d57a8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -99,6 +99,7 @@ static inline phys_addr_t early_acpi_override_srat(void)
 
 #ifdef CONFIG_ACPI_NUMA
 phys_addr_t early_acpi_firmware_srat(void);
+void acpi_reserve_hotpluggable_memory(void *srat_vaddr);
 #endif  /* CONFIG_ACPI_NUMA */
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 15b11d3..ba3efe9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -104,7 +104,10 @@ static void release_memory_resource(struct resource *res)
  */
 void __init reserve_hotpluggable_memory(void)
 {
+	void *srat_vaddr;
 	phys_addr_t srat_paddr;
+	u32 length;
+	struct acpi_table_header *srat_header;
 
 	/* Try to find out if SRAT is overrided */
 	srat_paddr = early_acpi_override_srat();
@@ -115,7 +118,16 @@ void __init reserve_hotpluggable_memory(void)
 			return;
 	}
 
-	/* Will reserve hotpluggable memory here */
+	/* Map the whole SRAT */
+	srat_header = early_ioremap(srat_paddr,
+				    sizeof(struct acpi_table_header));
+	length = srat_header->length;
+	early_iounmap(srat_header, sizeof(struct acpi_table_header));
+
+	/* Reserve hotpluggable memory */
+	srat_vaddr = early_ioremap(srat_paddr, length);
+	acpi_reserve_hotpluggable_memory(srat_vaddr);
+	early_iounmap(srat_vaddr, length);
 }
 #endif	/* CONFIG_ACPI_NUMA */
 
-- 
1.7.1

