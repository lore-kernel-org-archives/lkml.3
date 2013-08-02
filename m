Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3HBJRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:17:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758332Ab3HBJQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:16:26 -0400
X-IronPort-AV: E=Sophos;i="4.89,800,1367942400"; 
   d="scan'208";a="8098128"
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
Subject: [PATCH v2 RESEND 17/18] mem-hotplug: Introduce movablenode boot option to {en|dis}able using SRAT.
Date: Fri, 2 Aug 2013 17:14:36 +0800
Message-Id: <1375434877-20704-18-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:54,
	Serialize complete at 2013/08/02 17:14:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hot-Pluggable fired in SRAT specifies which memory is hotpluggable.
As we mentioned before, if hotpluggable memory is used by the kernel,
it cannot be hot-removed. So memory hotplug users may want to set all
hotpluggable memory in ZONE_MOVABLE so that the kernel won't use it.

Memory hotplug users may also set a node as movable node, which has
ZONE_MOVABLE only, so that the whole node can be hot-removed.

But the kernel cannot use memory in ZONE_MOVABLE. By doing this, the
kernel cannot use memory in movable nodes. This will cause NUMA
performance down. And other users may be unhappy.

So we need a way to allow users to enable and disable this functionality.
In this patch, we introduce movablenode boot option to allow users to
choose to reserve hotpluggable memory and set it as ZONE_MOVABLE or not.

Users can specify "movablenode" in kernel commandline to enable this
functionality. For those who don't use memory hotplug or who don't want
to lose their NUMA performance, just don't specify anything. The kernel
will work as before.

Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |   15 +++++++++++++++
 arch/x86/kernel/setup.c             |   10 ++++++++--
 include/linux/memory_hotplug.h      |    3 +++
 mm/memory_hotplug.c                 |   11 +++++++++++
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 15356ac..7349d1f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1718,6 +1718,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablenode		[KNL,X86] This parameter enables/disables the
+			kernel to arrange hotpluggable memory ranges recorded
+			in ACPI SRAT(System Resource Affinity Table) as
+			ZONE_MOVABLE. And these memory can be hot-removed when
+			the system is up.
+			By specifying this option, all the hotpluggable memory
+			will be in ZONE_MOVABLE, which the kernel cannot use.
+			This will cause NUMA performance down. For users who
+			care about NUMA performance, just don't use it.
+			If all the memory ranges in the system are hotpluggable,
+			then the ones used by the kernel at early time, such as
+			kernel code and data segments, initrd file and so on,
+			won't be set as ZONE_MOVABLE, and won't be hotpluggable.
+			Otherwise the kernel won't have enough memory to boot.
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c23e6a7..08029d4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1058,14 +1058,20 @@ void __init setup_arch(char **cmdline_p)
 	/* Initialize ACPI global root table list. */
 	early_acpi_boot_table_init();
 
-#ifdef CONFIG_ACPI_NUMA
+#if defined(CONFIG_ACPI_NUMA) && defined(CONFIG_MOVABLE_NODE)
 	/*
 	 * Linux kernel cannot migrate kernel pages, as a result, memory used
 	 * by the kernel cannot be hot-removed. Find and mark hotpluggable
 	 * memory in memblock to prevent memblock from allocating hotpluggable
 	 * memory for the kernel.
+	 *
+	 * If all the memory in a node is hotpluggable, then the kernel won't
+	 * be able to use memory on that node. This will cause NUMA performance
+	 * down. So by default, we don't reserve any hotpluggable memory. Users
+	 * may use "movablenode" boot option to enable this functionality.
 	 */
-	find_hotpluggable_memory();
+	if (movablenode_enable_srat)
+		find_hotpluggable_memory();
 #endif
 
 	/*
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 463efa9..43eb373 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -33,6 +33,9 @@ enum {
 	ONLINE_MOVABLE,
 };
 
+/* Enable/disable SRAT in movablenode boot option */
+extern bool movablenode_enable_srat;
+
 /*
  * pgdat resizing functions
  */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 4c6182d..b06d7bc 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -93,6 +93,17 @@ static void release_memory_resource(struct resource *res)
 }
 
 #ifdef CONFIG_ACPI_NUMA
+#ifdef CONFIG_MOVABLE_NODE
+bool __initdata movablenode_enable_srat;
+
+static int __init cmdline_parse_movablenode(char *p)
+{
+	movablenode_enable_srat = true;
+	return 0;
+}
+early_param("movablenode", cmdline_parse_movablenode);
+#endif	/* CONFIG_MOVABLE_NODE */
+
 /**
  * kernel_resides_in_range - Check if kernel resides in a memory region.
  * @base: The base address of the memory region.
-- 
1.7.1

