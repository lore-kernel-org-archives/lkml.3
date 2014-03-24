Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaCXJXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:23:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28888 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaCXJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:23:10 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <nicolas.pitre@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH RFC] ARM: extend fixmap mapping region to support 30 CPUs
Date: Mon, 24 Mar 2014 17:12:47 +0800
Message-ID: <1395652367-12308-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 32-bit ARM systems, the fixmap mapping region can support
no more than 14 CPUs(total: 896k; one CPU: 64K). And we can
configure NR_CPUS up to 32. So there is a mismatch.

This patch extends the fixmapping region downwards to boundary
of DMA mapping region(0xffe00000-0xfffe0000). Then the fixmap
mapping region can support up to 30 CPUs.

There seems to be no easy way to support 32 CPUs by simply 
changing memory layout on ARM Linux. So I also limit the 
maximal CPU number one can configure.


Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 Documentation/arm/memory.txt  | 4 ++--
 arch/arm/Kconfig              | 4 ++--
 arch/arm/include/asm/fixmap.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/arm/memory.txt b/Documentation/arm/memory.txt
index 4bfb9ff..cc31560 100644
--- a/Documentation/arm/memory.txt
+++ b/Documentation/arm/memory.txt
@@ -41,10 +41,10 @@ fffe8000	fffeffff	DTCM mapping area for platforms with
 fffe0000	fffe7fff	ITCM mapping area for platforms with
 				ITCM mounted inside the CPU.
 
-fff00000	fffdffff	Fixmap mapping region.  Addresses provided
+ffe00000	fffdffff	Fixmap mapping region.  Addresses provided
 				by fix_to_virt() will be located here.
 
-ffc00000	ffefffff	DMA memory mapping region.  Memory returned
+ffc00000	ffdfffff	DMA memory mapping region.  Memory returned
 				by the dma_alloc_xxx functions will be
 				dynamically mapped here.
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..f599040 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1600,8 +1600,8 @@ config PAGE_OFFSET
 	default 0xC0000000
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-32)"
-	range 2 32
+	int "Maximum number of CPUs (2-30)"
+	range 2 30
 	depends on SMP
 	default "4"
 
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..38c9ffd 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -13,7 +13,7 @@
  * 0xfffe0000 and 0xfffeffff.
  */
 
-#define FIXADDR_START		0xfff00000UL
+#define FIXADDR_START		0xffe00000UL
 #define FIXADDR_TOP		0xfffe0000UL
 #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
 
-- 
1.9.0

