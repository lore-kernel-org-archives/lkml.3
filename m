Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3HXPfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:35:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54619 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755269Ab3HXPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:35:48 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH v4 2/4] ARM: Add atomic_io_modify optimized routines
Date: Sat, 24 Aug 2013 12:35:30 -0300
Message-Id: <1377358532-23802-3-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement arch-specific atomic_io_modify and atomic_io_modify_relaxed,
which are based on writel/readl_relaxed and writel_relaxed/readl_relaxed,
respectively.
In both cases, by relaxing the readl, perfomance can be improved.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 arch/arm/include/asm/io.h |  4 ++++
 arch/arm/kernel/io.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d070741..53637b6 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -397,5 +397,9 @@ extern int devmem_is_allowed(unsigned long pfn);
 extern void register_isa_ports(unsigned int mmio, unsigned int io,
 			       unsigned int io_shift);
 
+#define __HAVE_ARCH_ATOMIC_IO_MODIFY
+extern void atomic_io_modify(void __iomem *reg, u32 mask, u32 set);
+extern void atomic_io_modify_relaxed(void __iomem *reg, u32 mask, u32 set);
+
 #endif	/* __KERNEL__ */
 #endif	/* __ASM_ARM_IO_H */
diff --git a/arch/arm/kernel/io.c b/arch/arm/kernel/io.c
index dcd5b4d..a8c9c9b 100644
--- a/arch/arm/kernel/io.c
+++ b/arch/arm/kernel/io.c
@@ -1,6 +1,35 @@
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
+
+static DEFINE_RAW_SPINLOCK(__io_lock);
+
+void atomic_io_modify_relaxed(void __iomem *reg, u32 mask, u32 set)
+{
+	unsigned long flags;
+	u32 value;
+
+	raw_spin_lock_irqsave(&__io_lock, flags);
+	value = readl_relaxed(reg) & ~mask;
+	value |= (set & mask);
+	writel_relaxed(value, reg);
+	raw_spin_unlock_irqrestore(&__io_lock, flags);
+}
+EXPORT_SYMBOL(atomic_io_modify_relaxed);
+
+void atomic_io_modify(void __iomem *reg, u32 mask, u32 set)
+{
+	unsigned long flags;
+	u32 value;
+
+	raw_spin_lock_irqsave(&__io_lock, flags);
+	value = readl_relaxed(reg) & ~mask;
+	value |= (set & mask);
+	writel(value, reg);
+	raw_spin_unlock_irqrestore(&__io_lock, flags);
+}
+EXPORT_SYMBOL(atomic_io_modify);
 
 /*
  * Copy data from IO memory space to "real" memory space.
-- 
1.8.1.5

