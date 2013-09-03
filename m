Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3ICIrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:47:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60257 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab3ICIrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:47:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8390260"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, joe@perches.com, toshi.kani@hp.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/4] acpi, numa, mem_hotplug: Kill save_add_info().
Date: Tue, 3 Sep 2013 16:45:38 +0800
Message-Id: <1378197941-26479-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:52,
	Serialize complete at 2013/09/03 16:44:52
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

	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
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
 arch/x86/mm/srat.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..1613c02 100644
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
@@ -154,8 +148,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		goto out_err;
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		goto out_err;
 
 	start = ma->base_address;
 	end = start + ma->length;
-- 
1.7.1

