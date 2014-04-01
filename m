Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaDAL6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:58:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaDALRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 062/144] ARM: fix noMMU kallsyms symbol filtering
Date: Tue,  1 Apr 2014 12:14:26 +0100
Message-Id: <1396350948-29910-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 006fa2599bf0daf107cbb7a8a99fcfb9a998a169 upstream.

With noMMU, CONFIG_PAGE_OFFSET was not being set correctly.  As there's
no MMU, PAGE_OFFSET should be equal to PHYS_OFFSET in all cases.  This
commit makes that explicit.

Since we do this, we don't need to mess around in asm/memory.h with
ifdefs to sort this out, so let's get rid of that, and there's no point
offering the "Memory split" option for noMMU as that's meaningless
there.

Fixes: b9b32bf70f2f ("ARM: use linker magic for vectors and vector stubs")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/Kconfig              | 2 ++
 arch/arm/include/asm/memory.h | 9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..170ac09 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1540,6 +1540,7 @@ config MCPM
 
 choice
 	prompt "Memory split"
+	depends on MMU
 	default VMSPLIT_3G
 	help
 	  Select the desired split between kernel and user memory.
@@ -1557,6 +1558,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index e750a93..bcc49dc 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -30,14 +30,15 @@
  */
 #define UL(x) _AC(x, UL)
 
+/* PAGE_OFFSET - the virtual address of the start of the kernel image */
+#define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
+
 #ifdef CONFIG_MMU
 
 /*
- * PAGE_OFFSET - the virtual address of the start of the kernel image
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
  */
-#define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
 #define TASK_SIZE		(UL(CONFIG_PAGE_OFFSET) - UL(SZ_16M))
 #define TASK_UNMAPPED_BASE	ALIGN(TASK_SIZE / 3, SZ_16M)
 
@@ -108,10 +109,6 @@
 #define END_MEM     		(UL(CONFIG_DRAM_BASE) + CONFIG_DRAM_SIZE)
 #endif
 
-#ifndef PAGE_OFFSET
-#define PAGE_OFFSET		(PHYS_OFFSET)
-#endif
-
 /*
  * The module can be at any place in ram in nommu mode.
  */
-- 
1.9.1

