Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3H0JkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:40:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49294 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3H0JjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:39:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367942400"; 
   d="scan'208";a="8317110"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 11/11] x86, mem_hotplug: Allocate memory near kernel image before SRAT is parsed.
Date: Tue, 27 Aug 2013 17:37:48 +0800
Message-Id: <1377596268-31552-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:15,
	Serialize complete at 2013/08/27 17:37:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After memblock is ready, before SRAT is parsed, we should allocate memory
near the kernel image. So this patch does the following:

1. After memblock is ready, make memblock allocate memory from low address
   to high, and set the lowest limit to the end of kernel image.
2. After SRAT is parsed, make memblock behave as default, allocate memory
   from high address to low, and reset the lowest limit to 0.

This behavior is controlled by movablenode boot option.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fa7b5f0..0b35bbd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1087,6 +1087,31 @@ void __init setup_arch(char **cmdline_p)
 	trim_platform_memory_ranges();
 	trim_low_memory_range();
 
+#ifdef CONFIG_MOVABLE_NODE
+	if (movablenode_enable_srat) {
+		/*
+		 * Memory used by the kernel cannot be hot-removed because Linux cannot
+		 * migrate the kernel pages. When memory hotplug is enabled, we should
+		 * prevent memblock from allocating memory for the kernel.
+		 *
+		 * ACPI SRAT records all hotpluggable memory ranges. But before SRAT is
+		 * parsed, we don't know about it.
+		 *
+		 * The kernel image is loaded into memory at very early time. We cannot
+		 * prevent this anyway. So on NUMA system, we set any node the kernel
+		 * resides in as un-hotpluggable.
+		 *
+		 * Since on modern servers, one node could have double-digit gigabytes
+		 * memory, we can assume the memory around the kernel image is also
+		 * un-hotpluggable. So before SRAT is parsed, just allocate memory near
+		 * the kernel image to try the best to keep the kernel away from
+		 * hotpluggable memory.
+		 */
+		memblock_set_current_order(MEMBLOCK_ORDER_LOW_TO_HIGH);
+		memblock_set_current_limit_low(__pa_symbol(_end));
+	}
+#endif /* CONFIG_MOVABLE_NODE */
+
 	init_mem_mapping();
 
 	early_trap_pf_init();
@@ -1127,6 +1152,18 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
+
+#ifdef CONFIG_MOVABLE_NODE
+	if (movablenode_enable_srat) {
+		/*
+		 * When ACPI SRAT is parsed, which is done in initmem_init(), set
+		 * memblock back to the default behavior.
+		 */
+		memblock_set_current_order(MEMBLOCK_ORDER_DEFAULT);
+		memblock_set_current_limit_low(0);
+	}
+#endif /* CONFIG_MOVABLE_NODE */
+
 	memblock_find_dma_reserve();
 
 #ifdef CONFIG_KVM_GUEST
-- 
1.7.1

