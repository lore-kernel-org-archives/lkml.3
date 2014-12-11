Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaLKM0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKM0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:41 -0500
Date: Thu, 11 Dec 2014 04:26:10 -0800
From: tip-bot for Xishi Qiu <tipbot@zytor.com>
Message-ID: <tip-c072b90c8dfe135072f646cc50b826e30c5aa558@git.kernel.org>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, qiuxishi@huawei.com,
        riel@redhat.com, dave@sr71.net, mingo@kernel.org, hpa@zytor.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Reply-To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dave@sr71.net, qiuxishi@huawei.com, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <5487AB3D.6070306@huawei.com>
References: <5487AB3D.6070306@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Fix zone ranges boot printout
Git-Commit-ID: c072b90c8dfe135072f646cc50b826e30c5aa558
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c072b90c8dfe135072f646cc50b826e30c5aa558
Gitweb:     http://git.kernel.org/tip/c072b90c8dfe135072f646cc50b826e30c5aa558
Author:     Xishi Qiu <qiuxishi@huawei.com>
AuthorDate: Wed, 10 Dec 2014 10:09:01 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:35:02 +0100

x86/mm: Fix zone ranges boot printout

This is the usual physical memory layout boot printout:
	...
	[    0.000000] Zone ranges:
	[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
	[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
	[    0.000000]   Normal   [mem 0x100000000-0xc3fffffff]
	[    0.000000] Movable zone start for each node
	[    0.000000] Early memory node ranges
	[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
	[    0.000000]   node   0: [mem 0x00100000-0xbf78ffff]
	[    0.000000]   node   0: [mem 0x100000000-0x63fffffff]
	[    0.000000]   node   1: [mem 0x640000000-0xc3fffffff]
	...

This is the log when we set "mem=2G" on the boot cmdline:
	...
	[    0.000000] Zone ranges:
	[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
	[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]  // should be 0x7fffffff, right?
	[    0.000000]   Normal   empty
	[    0.000000] Movable zone start for each node
	[    0.000000] Early memory node ranges
	[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
	[    0.000000]   node   0: [mem 0x00100000-0x7fffffff]
	...

This patch fixes the printout, the following log shows the right
ranges:
	...
	[    0.000000] Zone ranges:
	[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
	[    0.000000]   DMA32    [mem 0x01000000-0x7fffffff]
	[    0.000000]   Normal   empty
	[    0.000000] Movable zone start for each node
	[    0.000000] Early memory node ranges
	[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
	[    0.000000]   node   0: [mem 0x00100000-0x7fffffff]
	...

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Linux MM <linux-mm@kvack.org>
Cc: <dave@sr71.net>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/r/5487AB3D.6070306@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/dma.h | 2 +-
 arch/x86/mm/init.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 0bdb0c5..fe884e1 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -70,7 +70,7 @@
 #define MAX_DMA_CHANNELS	8
 
 /* 16MB ISA DMA zone */
-#define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
+#define MAX_DMA_PFN   ((16UL * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
 #define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36..07244aa 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -674,10 +674,10 @@ void __init zone_sizes_init(void)
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
+	max_zone_pfns[ZONE_DMA]		= min(MAX_DMA_PFN, max_low_pfn);
 #endif
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
+	max_zone_pfns[ZONE_DMA32]	= min(MAX_DMA32_PFN, max_low_pfn);
 #endif
 	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
 #ifdef CONFIG_HIGHMEM
