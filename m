Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKBILK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 03:11:10 -0500
Received: from numascale.com ([213.162.240.84]:34765 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaKBIK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 03:10:56 -0500
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v3 5/5] Use 2GB memory block size on large x86-64 systems
Date: Sun,  2 Nov 2014 16:10:13 +0800
Message-Id: <1414915813-2462-5-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414915813-2462-1-git-send-email-daniel@numascale.com>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com>
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

On larger x64-64 systems, use a 2GB memory block size to reduce sysfs
entry creation time by 16x. Large is defined as 64GB or more memory.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/mm/init_64.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763..6002e80 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -52,7 +52,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <asm/uv/uv.h>
 #include <asm/setup.h>
 
 #include "mm_internal.h"
@@ -1247,9 +1246,9 @@ static unsigned long probe_memory_block_size(void)
 	/* start from 2g */
 	unsigned long bz = 1UL<<31;
 
-#ifdef CONFIG_X86_UV
-	if (is_uv_system()) {
-		printk(KERN_INFO "UV: memory block size 2GB\n");
+#ifdef CONFIG_X86_64
+	if (totalram_pages >= (64ULL << (30 - PAGE_SHIFT))) {
+		pr_info("Using 2GB memory block size for large-memory system\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
 #endif
