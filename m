Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab3FMNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:32:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758298Ab3FMN2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537700"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [Part1 PATCH v5 19/22] x86, mm: Parse numa info earlier
Date: Thu, 13 Jun 2013 21:03:06 +0800
Message-Id: <1371128589-8953-20-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:28,
	Serialize complete at 2013/06/13 20:58:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Parsing numa info has been separated into two steps now.

early_initmem_info() only parses info in numa_meminfo and
nodes_parsed. still keep numaq, acpi_numa, amd_numa, dummy
fall back sequence working.

SLIT and numa emulation handling are still left in initmem_init().

Call early_initmem_init before init_mem_mapping() to prepare
to use numa_info with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 301165e..fd0d5be 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1125,13 +1125,21 @@ void __init setup_arch(char **cmdline_p)
 	trim_platform_memory_ranges();
 	trim_low_memory_range();
 
+	/*
+	 * Parse the ACPI tables for possible boot-time SMP configuration.
+	 */
+	acpi_initrd_override_copy();
+	acpi_boot_table_init();
+	early_acpi_boot_init();
+	early_initmem_init();
 	init_mem_mapping();
-
+	memblock.current_limit = get_max_mapped();
 	early_trap_pf_init();
 
+	reserve_initrd();
+
 	setup_real_mode();
 
-	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
 	/*
@@ -1145,24 +1153,12 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
-	acpi_initrd_override_copy();
-
-	reserve_initrd();
-
 	reserve_crashkernel();
 
 	vsmp_init();
 
 	io_delay_init();
 
-	/*
-	 * Parse the ACPI tables for possible boot-time SMP configuration.
-	 */
-	acpi_boot_table_init();
-
-	early_acpi_boot_init();
-
-	early_initmem_init();
 	initmem_init();
 	memblock_find_dma_reserve();
 
-- 
1.7.1

