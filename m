Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaKDIbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:31:21 -0500
Received: from numascale.com ([213.162.240.84]:50545 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbaKDIbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:31:17 -0500
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v4 4/4] Use 2GB memory block size on large-memory x86-64 systems
Date: Tue,  4 Nov 2014 16:29:44 +0800
Message-Id: <1415089784-28779-4-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415089784-28779-1-git-send-email-daniel@numascale.com>
References: <1415089784-28779-1-git-send-email-daniel@numascale.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large-memory x86-64 systems of 64GB or more with memory hot-plug
enabled, use a 2GB memory block size. Eg with 64GB memory, this reduces
the number of directories in /sys/devices/system/memory from 512 to 32,
making it more manageable, and reducing the creation time accordingly.

This caveat is that the memory can't be offlined (for hotplug or otherwise)
with finer 128MB granularity, but this is unimportant due to the high
memory densities generally used with such large-memory systems, where
eg a single DIMM is the order of 16GB. 

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 init_64.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df1a992..9622ab2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -52,7 +52,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <asm/uv/uv.h>
 #include <asm/setup.h>
 
 #include "mm_internal.h"
@@ -1234,12 +1233,10 @@ static unsigned long probe_memory_block_size(void)
 	/* start from 2g */
 	unsigned long bz = 1UL<<31;
 
-#ifdef CONFIG_X86_UV
-	if (is_uv_system()) {
-		printk(KERN_INFO "UV: memory block size 2GB\n");
+	if (totalram_pages >= (64ULL << (30 - PAGE_SHIFT))) {
+		pr_info("Using 2GB memory block size for large-memory system\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
-#endif
 
 	/* less than 64g installed */
 	if ((max_pfn << PAGE_SHIFT) < (16UL << 32))
