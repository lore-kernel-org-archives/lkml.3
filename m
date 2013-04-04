Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544Ab3DDXsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:48:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43439 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765497Ab3DDXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:48:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH v3 19/22] x86, mm: Parse numa info early
Date: Thu,  4 Apr 2013 16:46:23 -0700
Message-Id: <1365119186-23487-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parsing numa info has been separated to two functions now.

early_initmem_info() only parse info in numa_meminfo and
nodes_parsed. still keep numaq, acpi_numa, amd_numa, dummy
fall back sequence working.

SLIT and numa emulation handling are still left in initmem_init().

Call early_initmem_init before init_mem_mapping() to prepare
to use numa_info with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/setup.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d40e16e..6ef3fa2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1098,13 +1098,21 @@ void __init setup_arch(char **cmdline_p)
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
@@ -1118,24 +1126,12 @@ void __init setup_arch(char **cmdline_p)
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
1.8.1.4

