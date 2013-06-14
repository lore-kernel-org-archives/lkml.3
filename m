Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3FNVdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3FNVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:49 -0400
Date: Fri, 14 Jun 2013 14:33:34 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-ca099f2813b5dccf2383784dbcfb9589110bd846@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-20-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-20-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Parse numa info earlier
Git-Commit-ID: ca099f2813b5dccf2383784dbcfb9589110bd846
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca099f2813b5dccf2383784dbcfb9589110bd846
Gitweb:     http://git.kernel.org/tip/ca099f2813b5dccf2383784dbcfb9589110bd846
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:06 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:13 -0700

x86, mm: Parse numa info earlier

Parsing numa info has been separated into two steps now.

early_initmem_info() only parses info in numa_meminfo and
nodes_parsed. still keep numaq, acpi_numa, amd_numa, dummy
fall back sequence working.

SLIT and numa emulation handling are still left in initmem_init().

Call early_initmem_init before init_mem_mapping() to prepare
to use numa_info with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-20-git-send-email-tangchen@cn.fujitsu.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

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
 
