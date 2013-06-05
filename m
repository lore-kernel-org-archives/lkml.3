Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3FECas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:30:48 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45193 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3FECap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:30:45 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, Simon Glass <sjg@chromium.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: samsung: avoid racy early printk at bootup
Date: Tue,  4 Jun 2013 18:58:59 -0700
Message-Id: <1370397539-21653-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At boot, we've got a stack trace that looks something like this
(exynos5 as example)
* exynos5_map_io
* s3c_init_cpu
* exynos_init_io
* exynos5_dt_map_io
* paging_init
* setup_arch

When paging_init() runs we'll lose any early MMU mappings that we
might have had to allow us access to S3C_VA_UART.  We won't add those
mappings back in until after the SoC-specific map_io() function is
called.  However, we print the CPU ID _right before_ we call the
SoC-specific function.  Oops.

Things happen to work all right most of the time because the mapping
is sticking around in our TLB.  ...but if we get really unlucky (like
me!) or we put an explicit flush_tlb_all() at the start of
exynos_init_io(), then things go boom.

This patch moves the problematic printk() till after the cpu->map_io()
call.  It also switches it over to pr_info().  This patch _doesn't_
remove the questionable printks in the panic case, since we might get
lucky and the TLB might still let us print.  This patch also adds a
few warnings to help others avoid similar headaches.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/mach-exynos/common.c | 7 +++++++
 arch/arm/plat-samsung/init.c  | 8 +++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 027c9e7..8b51b0d 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -386,6 +386,13 @@ int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 
 void __init exynos_init_io(struct map_desc *mach_desc, int size)
 {
+	/*
+	 * WARNING: use of printk in this function or its children can be
+	 * deadly.  We've switched over to new page tables but haven't yet
+	 * added S3C_VA_UART into the mapping.  You might get lucky and see a
+	 * printout work, but if you call flush_tlb_all() it will fail reliably.
+	 */
+
 #ifdef CONFIG_OF
 	if (initial_boot_params)
 		of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
index 79d10fc..494cfbb 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -49,18 +49,20 @@ void __init s3c_init_cpu(unsigned long idcode,
 	cpu = s3c_lookup_cpu(idcode, cputab, cputab_size);
 
 	if (cpu == NULL) {
+		/* Questionable printk; S3C_VA_UART not mapped yet! */
 		printk(KERN_ERR "Unknown CPU type 0x%08lx\n", idcode);
 		panic("Unknown S3C24XX CPU");
 	}
-
-	printk("CPU %s (id 0x%08lx)\n", cpu->name, idcode);
-
 	if (cpu->map_io == NULL || cpu->init == NULL) {
+		/* Questionable printk; S3C_VA_UART not mapped yet! */
 		printk(KERN_ERR "CPU %s support not enabled\n", cpu->name);
 		panic("Unsupported Samsung CPU");
 	}
 
 	cpu->map_io();
+
+	/* IMPORTANT: call this after cpu->map_io() so we can print reliably */
+	pr_info("CPU %s (id 0x%08lx)\n", cpu->name, idcode);
 }
 
 /* s3c24xx_init_clocks
-- 
1.8.3

