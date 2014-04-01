Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaDAQjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:39:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDAQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 53/86] ARM: fix noMMU kallsyms symbol filtering
Date: Tue,  1 Apr 2014 09:08:06 -0700
Message-Id: <1396368519-12728-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/Kconfig              | 2 ++
 arch/arm/include/asm/memory.h | 9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5c037b9..4a582ab 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1596,6 +1596,7 @@ config HAVE_ARM_TWD
 
 choice
 	prompt "Memory split"
+	depends on MMU
 	default VMSPLIT_3G
 	help
 	  Select the desired split between kernel and user memory.
@@ -1613,6 +1614,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 1c4df27..179bf0b 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -28,14 +28,15 @@
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
 #define TASK_SIZE		(UL(CONFIG_PAGE_OFFSET) - UL(0x01000000))
 #define TASK_UNMAPPED_BASE	ALIGN(TASK_SIZE / 3, SZ_16M)
 
@@ -106,10 +107,6 @@
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
1.8.3.2

