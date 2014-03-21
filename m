Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967060AbaCUBUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760433AbaCUADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 058/149] ARM: fix noMMU kallsyms symbol filtering
Date: Thu, 20 Mar 2014 17:03:41 -0700
Message-Id: <20140321000438.971755143@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig              |    2 ++
 arch/arm/include/asm/memory.h |    9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1543,6 +1543,7 @@ config BL_SWITCHER_DUMMY_IF
 
 choice
 	prompt "Memory split"
+	depends on MMU
 	default VMSPLIT_3G
 	help
 	  Select the desired split between kernel and user memory.
@@ -1560,6 +1561,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000
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
 
@@ -104,10 +105,6 @@
 #define END_MEM     		(UL(CONFIG_DRAM_BASE) + CONFIG_DRAM_SIZE)
 #endif
 
-#ifndef PAGE_OFFSET
-#define PAGE_OFFSET		PLAT_PHYS_OFFSET
-#endif
-
 /*
  * The module can be at any place in ram in nommu mode.
  */


