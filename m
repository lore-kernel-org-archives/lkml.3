Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaDAFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:09:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47616 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAFJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:09:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4] x86, mm: Probe memory block size for generic x86 64bit
Date: Mon, 31 Mar 2014 22:10:46 -0700
Message-Id: <1396329046-19675-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On system with 2TiB ram, current x86_64 have 128M as section size, and one
memory_block only include one section. So will have 16400 entries under
/sys/devices/system/memory/.

Current code try to use block id to find block pointer in /sys
for any section, and reuse that block pointer. that finding will take some time
even after
| commit 7c243c7168dcc1bc2081fc0494923cd7cc808fb6
| Author: Russ Anderson <rja@sgi.com>
| Date:   Mon Apr 29 15:07:59 2013 -0700
|    mm: speedup in __early_pfn_to_nid
that will skip the search in that case during booting up.

So solution could be increase block size just like SGI UV system did.
(harded code to 2g).

This patch is trying to probe the block size to make it match mmio remap size.
for example, Intel Nehalem later system will have memory range
[0, TOML), [4g, TOMH]. If the memory hole is 2g and total is 128g, TOM
will be 2g, and TOM2 will be 130g.
We could use 2g as block size instead of default 128M.
That will reduce number of entries in /sys/devices/system/memory/

On system 6TiB system will reduce boot time 35 seconds.

-v2: don't probe it every time when /sys/../block_size_byte is showed...
-v3: update changelog.
-v4: use pr_info instead of printk(KERN_DEBUG...) to address
     warning from checkpatch.pl that is pointed out by Andrew.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -1230,17 +1230,43 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_X86_UV
-unsigned long memory_block_size_bytes(void)
+static unsigned long probe_memory_block_size(void)
 {
+	/* start from 2g */
+	unsigned long bz = 1UL<<31;
+
+#ifdef CONFIG_X86_UV
 	if (is_uv_system()) {
 		printk(KERN_INFO "UV: memory block size 2GB\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
-	return MIN_MEMORY_BLOCK_SIZE;
-}
 #endif
 
+	/* less than 64g installed */
+	if ((max_pfn << PAGE_SHIFT) < (16UL << 32))
+		return MIN_MEMORY_BLOCK_SIZE;
+
+	/* get the tail size */
+	while (bz > MIN_MEMORY_BLOCK_SIZE) {
+		if (!((max_pfn << PAGE_SHIFT) & (bz - 1)))
+			break;
+		bz >>= 1;
+	}
+
+	pr_info("memory block size : %ldMB\n", bz >> 20);
+
+	return bz;
+}
+
+static unsigned long memory_block_size_probed;
+unsigned long memory_block_size_bytes(void)
+{
+	if (!memory_block_size_probed)
+		memory_block_size_probed = probe_memory_block_size();
+
+	return memory_block_size_probed;
+}
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
