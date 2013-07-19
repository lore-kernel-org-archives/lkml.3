Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab3GSIBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:01:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759821Ab3GSIBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947440"
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
Subject: [PATCH 17/21] page_alloc, mem-hotplug: Improve movablecore to {en|dis}able using SRAT.
Date: Fri, 19 Jul 2013 15:59:30 +0800
Message-Id: <1374220774-29974-18-git-send-email-tangchen@cn.fujitsu.com>
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
In this patch, we improve movablecore boot option to allow users to
choose to reserve hotpluggable memory and set it as ZONE_MOVABLE or not.

Users can specify "movablecore=acpi" in kernel commandline to enable this
functionality. For those who don't use memory hotplug or who don't want
to lose their NUMA performance, just don't specify anything. The kernel
will work as before.

Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 arch/x86/kernel/setup.c        |    8 +++++++-
 include/linux/memory_hotplug.h |    3 +++
 mm/page_alloc.c                |   13 +++++++++++++
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9717760..9d08a03 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1083,8 +1083,14 @@ void __init setup_arch(char **cmdline_p)
 	 * Linux kernel cannot migrate kernel pages, as a result, memory used
 	 * by the kernel cannot be hot-removed. Reserve hotpluggable memory to
 	 * prevent memblock from allocating hotpluggable memory for the kernel.
+	 *
+	 * If all the memory in a node is hotpluggable, then the kernel won't
+	 * be able to use memory on that node. This will cause NUMA performance
+	 * down. So by default, we don't reserve any hotpluggable memory. users
+	 * may use "movablecore=acpi" boot option to enable this functionality.
 	 */
-	reserve_hotpluggable_memory();
+	if (movablecore_enable_srat)
+		reserve_hotpluggable_memory();
 #endif
 
 	/*
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 681b97f..9f26e29 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -33,6 +33,9 @@ enum {
 	ONLINE_MOVABLE,
 };
 
+/* Enable/disable SRAT in movablecore boot option */
+extern bool movablecore_enable_srat;
+
 /*
  * pgdat resizing functions
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..6271c36 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -209,6 +209,8 @@ static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
+bool __initdata movablecore_enable_srat;
+
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
 EXPORT_SYMBOL(movable_zone);
@@ -5112,6 +5114,12 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	}
 }
 
+static void __init cmdline_movablecore_srat(char *p)
+{
+	if (p && !strcmp(p, "acpi"))
+		movablecore_enable_srat = true;
+}
+
 static int __init cmdline_parse_core(char *p, unsigned long *core)
 {
 	unsigned long long coremem;
@@ -5142,6 +5150,11 @@ static int __init cmdline_parse_kernelcore(char *p)
  */
 static int __init cmdline_parse_movablecore(char *p)
 {
+	cmdline_movablecore_srat(p);
+
+	if (movablecore_enable_srat)
+		return 0;
+
 	return cmdline_parse_core(p, &required_movablecore);
 }
 
-- 
1.7.1

