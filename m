Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3LXBTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:19:15 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45124 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3LXBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:19:12 -0500
X-AuditID: 9c930197-b7c4aae000003d84-88-52b8e10d9289
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'Russell King'" <linux@arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, "HyoJun Im" <hyojun.im@lge.com>
Subject: [PATCH] [RFC] ARM: mm: add configuration for the size of module space
Date: Tue, 24 Dec 2013 10:19:09 +0900
Message-ID: <000c01cf0046$25eb1db0$71c15910$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac8ARCKFasVy/dJwSae3K4WrLM5AUQ==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I run out of module space because I have several big driver modules.
I know I can strip the modules to decrease size but I need debug info now.

The default size of module is 16MB and the size is statically 
defined in the header file. But a description for the module space 
size tell that it can be configurable at most 32MB.

I have changed the module space size to 18MB and tested my platform.
It have been looking good.

I am not sure my patch is proper solution.
Anyway, could I configure the module space size?



Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 arch/arm/Kconfig              |    4 ++++
 arch/arm/include/asm/memory.h |   10 +++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..cf1fb55 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2257,6 +2257,10 @@ config ARM_CPU_SUSPEND

 endmenu

+config MODULES_AREA_SIZE
+       int
+       default 0x1000000
+
 source "net/Kconfig"

 source "drivers/Kconfig"
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 6976b03..3396758 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -32,13 +32,17 @@

 #ifdef CONFIG_MMU

+#if CONFIG_MODULES_AREA_SIZE > SZ_32M
+#error Too much space for modules
+#endif
+
 /*
  * PAGE_OFFSET - the virtual address of the start of the kernel image
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
  */
-#define PAGE_OFFSET            UL(CONFIG_PAGE_OFFSET)
-#define TASK_SIZE              (UL(CONFIG_PAGE_OFFSET) - UL(SZ_16M))
+#define PAGE_OFFSET    UL(CONFIG_PAGE_OFFSET)
+#define TASK_SIZE      (UL(CONFIG_PAGE_OFFSET) -
UL(CONFIG_MODULES_AREA_SIZE))
 #define TASK_UNMAPPED_BASE     ALIGN(TASK_SIZE / 3, SZ_16M)

 /*
@@ -51,7 +55,7 @@
  * and PAGE_OFFSET - it must be within 32MB of the kernel text.
  */
 #ifndef CONFIG_THUMB2_KERNEL
-#define MODULES_VADDR          (PAGE_OFFSET - SZ_16M)
+#define MODULES_VADDR          (PAGE_OFFSET - CONFIG_MODULES_AREA_SIZE)
 #else
 /* smaller range for Thumb-2 symbols relocation (2^24)*/
 #define MODULES_VADDR          (PAGE_OFFSET - SZ_8M)
--
1.7.9.5



