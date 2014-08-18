Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaHRLpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHRLpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:45:47 -0400
Subject: [PATCH 1/2] SH: Add missing casts in integer-pointer conversions
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, apkm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Date: Mon, 18 Aug 2014 12:00:55 +0100
Message-ID: <20140818110055.18167.18408.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When casting between ints that aren't long or unsigned longs and pointers,
there needs to be an intermediate cast of long or unsigned long, eg:

	void *p;
	int i = (int)(unsigned long)p;

and:

	unsigned long long i;
	void *p = (void *)(unsigned long)i;

as the compiler only considers pointers to be the same logical size as long -
even if long is physically the same size as int or long long.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/sh/kernel/io.c       |    4 ++--
 arch/sh/kernel/traps_64.c |   16 ++++++++++------
 arch/sh/mm/cache-sh5.c    |    4 ++--
 drivers/sh/clk/core.c     |    2 +-
 drivers/sh/clk/cpg.c      |    6 +++---
 drivers/sh/intc/core.c    |    6 +++---
 6 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/sh/kernel/io.c b/arch/sh/kernel/io.c
index 5c51b794ba2a..ada61e5c1947 100644
--- a/arch/sh/kernel/io.c
+++ b/arch/sh/kernel/io.c
@@ -58,7 +58,7 @@ void memcpy_fromio(void *to, const volatile void __iomem *from, unsigned long co
 	}
 #endif
 
-	if ((((u32)to | (u32)from) & 0x3) == 0) {
+	if ((((u32)(unsigned long)to | (u32)(unsigned long)from) & 0x3) == 0) {
 		for (; count > 3; count -= 4) {
 			*(u32 *)to = *(volatile u32 *)from;
 			to += 4;
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(memcpy_fromio);
  */
 void memcpy_toio(volatile void __iomem *to, const void *from, unsigned long count)
 {
-	if ((((u32)to | (u32)from) & 0x3) == 0) {
+	if ((((u32)(unsigned long)to | (u32)(unsigned long)from) & 0x3) == 0) {
 		for ( ; count > 3; count -= 4) {
 			*(volatile u32 *)to = *(u32 *)from;
 			to += 4;
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 112ea11c030d..eed747fc13c4 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -138,7 +138,7 @@ static void misaligned_kernel_word_load(__u64 address, int do_sign_extend, __u64
 {
 	unsigned short x;
 	unsigned char *p, *q;
-	p = (unsigned char *) (int) address;
+	p = (unsigned char *)(unsigned long)address;
 	q = (unsigned char *) &x;
 	q[0] = p[0];
 	q[1] = p[1];
@@ -154,7 +154,7 @@ static void misaligned_kernel_word_store(__u64 address, __u64 value)
 {
 	unsigned short x;
 	unsigned char *p, *q;
-	p = (unsigned char *) (int) address;
+	p = (unsigned char *)(unsigned long)address;
 	q = (unsigned char *) &x;
 
 	x = (__u16) value;
@@ -186,7 +186,8 @@ static int misaligned_load(struct pt_regs *regs,
 			return -1;
 		}
 
-		if (__copy_user(&buffer, (const void *)(int)address, (1 << width_shift)) > 0) {
+		if (__copy_user(&buffer, (const void *)(unsigned long)address,
+				(1 << width_shift)) > 0) {
 			return -1; /* fault */
 		}
 		switch (width_shift) {
@@ -276,7 +277,8 @@ static int misaligned_store(struct pt_regs *regs,
 			break;
 		}
 
-		if (__copy_user((void *)(int)address, &buffer, (1 << width_shift)) > 0) {
+		if (__copy_user((void *)(unsigned long)address, &buffer,
+				(1 << width_shift)) > 0) {
 			return -1; /* fault */
 		}
 	} else {
@@ -333,7 +335,8 @@ static int misaligned_fpu_load(struct pt_regs *regs,
 			return -1;
 		}
 
-		if (__copy_user(&buffer, (const void *)(int)address, (1 << width_shift)) > 0) {
+		if (__copy_user(&buffer, (const void *)(unsigned long)address,
+				(1 << width_shift)) > 0) {
 			return -1; /* fault */
 		}
 		/* 'current' may be the current owner of the FPU state, so
@@ -443,7 +446,8 @@ static int misaligned_fpu_store(struct pt_regs *regs,
 
 		*(__u32*) &buffer = buflo;
 		*(1 + (__u32*) &buffer) = bufhi;
-		if (__copy_user((void *)(int)address, &buffer, (1 << width_shift)) > 0) {
+		if (__copy_user((void *)(unsigned long)address, &buffer,
+				(1 << width_shift)) > 0) {
 			return -1; /* fault */
 		}
 		return 0;
diff --git a/arch/sh/mm/cache-sh5.c b/arch/sh/mm/cache-sh5.c
index d1bffbcd9d52..0a3aeecbfd62 100644
--- a/arch/sh/mm/cache-sh5.c
+++ b/arch/sh/mm/cache-sh5.c
@@ -245,14 +245,14 @@ static void inline sh64_dcache_purge_sets(int sets_to_purge_base, int n_sets)
 	int j;
 	int set_offset;
 
-	dummy_buffer_base_set = ((int)&dummy_alloco_area &
+	dummy_buffer_base_set = ((unsigned long)&dummy_alloco_area &
 				 cpu_data->dcache.entry_mask) >>
 				 cpu_data->dcache.entry_shift;
 	set_offset = sets_to_purge_base - dummy_buffer_base_set;
 
 	for (j = 0; j < n_sets; j++, set_offset++) {
 		set_offset &= (cpu_data->dcache.sets - 1);
-		eaddr0 = (unsigned long long)dummy_alloco_area +
+		eaddr0 = (unsigned long long)(unsigned long)dummy_alloco_area +
 			(set_offset << cpu_data->dcache.entry_shift);
 
 		/*
diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
index be56b22ca941..1dc9af717cb3 100644
--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -380,7 +380,7 @@ static int clk_establish_mapping(struct clk *clk)
 	clk->mapping = mapping;
 out:
 	clk->mapped_reg = clk->mapping->base;
-	clk->mapped_reg += (phys_addr_t)clk->enable_reg - clk->mapping->phys;
+	clk->mapped_reg += (phys_addr_t)(unsigned long)clk->enable_reg - clk->mapping->phys;
 	return 0;
 }
 
diff --git a/drivers/sh/clk/cpg.c b/drivers/sh/clk/cpg.c
index 7442bc130055..d23de0a9eb6a 100644
--- a/drivers/sh/clk/cpg.c
+++ b/drivers/sh/clk/cpg.c
@@ -57,8 +57,8 @@ static int sh_clk_mstp_enable(struct clk *clk)
 	if (clk->status_reg) {
 		unsigned int (*read)(const void __iomem *addr);
 		int i;
-		void __iomem *mapped_status = (phys_addr_t)clk->status_reg -
-			(phys_addr_t)clk->enable_reg + clk->mapped_reg;
+		void __iomem *mapped_status = (phys_addr_t)(unsigned long)clk->status_reg -
+			(phys_addr_t)(unsigned long)clk->enable_reg + clk->mapped_reg;
 
 		if (clk->flags & CLK_ENABLE_REG_8BIT)
 			read = r8;
@@ -478,7 +478,7 @@ int __init sh_clk_fsidiv_register(struct clk *clks, int nr)
 		}
 
 		/* clks[i].enable_reg came from SH_CLK_FSIDIV() */
-		map->phys		= (phys_addr_t)clks[i].enable_reg;
+		map->phys		= (phys_addr_t)(unsigned long)clks[i].enable_reg;
 		map->len		= 8;
 
 		clks[i].enable_reg	= 0; /* remove .enable_reg */
diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 81f22980b2de..2b2883c350a6 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -67,7 +67,7 @@ void intc_set_prio_level(unsigned int irq, unsigned int level)
 
 static void intc_redirect_irq(unsigned int irq, struct irq_desc *desc)
 {
-	generic_handle_irq((unsigned int)irq_get_handler_data(irq));
+	generic_handle_irq((unsigned long)irq_get_handler_data(irq));
 }
 
 static void __init intc_register_irq(struct intc_desc *desc,
@@ -116,7 +116,7 @@ static void __init intc_register_irq(struct intc_desc *desc,
 	disable_irq_nosync(irq);
 	irq_set_chip_and_handler_name(irq, &d->chip, handle_level_irq,
 				      "level");
-	irq_set_chip_data(irq, (void *)data[primary]);
+	irq_set_chip_data(irq, (void *)(unsigned long)data[primary]);
 
 	/*
 	 * set priority level
@@ -367,7 +367,7 @@ int __init register_intc_controller(struct intc_desc *desc)
 			/* redirect this interrupts to the first one */
 			irq_set_chip(irq2, &dummy_irq_chip);
 			irq_set_chained_handler(irq2, intc_redirect_irq);
-			irq_set_handler_data(irq2, (void *)irq);
+			irq_set_handler_data(irq2, (void *)(unsigned long)irq);
 		}
 	}
 

