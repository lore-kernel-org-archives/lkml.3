Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3JAJzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:55:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab3JAJzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:55:04 -0400
X-IronPort-AV: E=Sophos;i="4.90,1013,1371052800"; 
   d="scan'208";a="8662842"
Message-ID: <524A9BBF.3060305@cn.fujitsu.com>
Date: Tue, 01 Oct 2013 17:54:07 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: robert.moore@intel.com, lv.zheng@intel.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, Rik van Riel <riel@redhat.com>,
        prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>, imtangchen@gmail.com,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH -mm 5/8] acpi, numa, mem_hotplug: Mark hotpluggable memory
 in memblock
References: <524A991D.3050005@cn.fujitsu.com>
In-Reply-To: <524A991D.3050005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:53:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:53:09,
	Serialize complete at 2013/10/01 17:53:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

When parsing SRAT, we know that which memory area is hotpluggable.
So we invoke function memblock_mark_hotplug() introduced by previous
patch to mark hotpluggable memory in memblock.

Besides, move setting back to top-down allocation just right after
we mark hotpluggable memory in memblock.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    7 -------
 arch/x86/mm/numa.c      |    2 ++
 arch/x86/mm/srat.c      |   13 +++++++++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b8fefb7..36cfce3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1132,13 +1132,6 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
-
-	/*
-	 * When ACPI SRAT is parsed, which is done in initmem_init(),
-	 * set memblock back to the top-down direction.
-	 */
-	memblock_set_bottom_up(false);
-
 	memblock_find_dma_reserve();
 
 	/*
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ac4ea06..ef9130d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -569,6 +569,8 @@ static int __init numa_init(int (*init_func)(void))
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
 				  MAX_NUMNODES));
+	/* In case that parsing SRAT failed. */
+	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
 	numa_reset_distance();
 
 	ret = init_func();
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 266ca91..246739c 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -181,6 +181,11 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		(unsigned long long) start, (unsigned long long) end - 1,
 		hotpluggable ? " hotplug" : "");
 
+	/* Mark hotplug range in memblock. */
+	if (hotpluggable && memblock_mark_hotplug(start, ma->length))
+		pr_warn("SRAT: Failed to mark hotplug range [mem %#010Lx-%#010Lx] in memblock\n",
+			(unsigned long long) start, (unsigned long long) end - 1);
+
 	return 0;
 out_err_bad_srat:
 	bad_srat();
@@ -197,5 +202,13 @@ int __init x86_acpi_numa_init(void)
 	ret = acpi_numa_init();
 	if (ret < 0)
 		return ret;
+
+	/*
+	 * When ACPI SRAT is parsed, and hotpluggable range in
+	 * memblock is marked, set memblock back to the top-down
+	 * direction.
+	 */
+	memblock_set_bottom_up(false);
+
 	return srat_disabled() ? -EINVAL : 0;
 }
-- 
1.7.1

