Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaAFIn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:43:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaAFIn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:43:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,611,1384272000"; 
   d="scan'208";a="9378071"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org,
        rjw@sisk.pl, lenb@kernel.org, toshi.kani@hp.com
Cc: tangchen@cn.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acpi, numa, mem_hotplug: Kill save_add_info().
Date: Mon, 6 Jan 2014 16:46:20 +0800
Message-Id: <1388997980-28099-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/06 16:42:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/06 16:42:55,
	Serialize complete at 2014/01/06 16:42:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save_add_info() is defined as:

        #ifdef CONFIG_MEMORY_HOTPLUG
        static inline int save_add_info(void) {return 1;}
        #else
        static inline int save_add_info(void) {return 0;}
        #endif

which means it is true when memory hotplug is configured.

In acpi_numa_memory_affinity_init(), it checks the memory hotplug
flag in SRAT memory affinity and save_add_info() like this:

	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
	if (hotpluggable && !save_add_info())
		goto out_err;
        ......
        node = setup_node(pxm);
        numa_add_memblk(node, start, end);
        ......

which means if the memory range is hotpluggable, but memory hotplug is not
configured, it won't add these memory to numa_meminfo.

After this, numa_meminfo_cover_memory() will fail, which will finally cause
numa_init() to fail.

numa_init()
 |->numa_register_memblks()
     |->numa_meminfo_cover_memory()

When numa_init() fails, it will fallback to numa_init(dummy_numa_init), and
all numa architecture will not be setup.

This is nonsense. Even if memory hotplug is not configured, we can also use
numa architecture.

Actually, save_add_info() is added by commit 71efa8fdc55e70ec6687c897a30759f0a2c2ad7e
in 2006. And now it is useless.

So this patch kill save_add_info() and the nonsense checking.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/srat.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 266ca91..1df90dd 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -135,12 +135,6 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static inline int save_add_info(void) {return 1;}
-#else
-static inline int save_add_info(void) {return 0;}
-#endif
-
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
@@ -156,8 +150,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		goto out_err;
 	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
-	if (hotpluggable && !save_add_info())
-		goto out_err;
 
 	start = ma->base_address;
 	end = start + ma->length;
-- 
1.7.11.7

