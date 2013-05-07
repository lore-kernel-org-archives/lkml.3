Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3EGOl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:41:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755130Ab3EGOkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:40:39 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Russ Anderson <rja@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v8 09/11] arm, prepare reboot_mode for moving to generic kernel code.
Date: Tue,  7 May 2013 09:39:53 -0500
Message-Id: <1367937595-32241-10-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367937595-32241-1-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for the moving the parsing of reboot= to the generic
kernel code by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
---
 arch/arm/include/asm/mach/arch.h   | 3 ++-
 arch/arm/kernel/process.c          | 8 ++++----
 arch/arm/kernel/setup.c            | 6 +++---
 arch/arm/mach-footbridge/cats-hw.c | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 308ad7d..e2b551e 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -9,6 +9,7 @@
  */
 
 #ifndef __ASSEMBLY__
+#include <linux/reboot.h>
 
 struct tag;
 struct meminfo;
@@ -39,7 +40,7 @@ struct machine_desc {
 	unsigned char		reserve_lp0 :1;	/* never has lp0	*/
 	unsigned char		reserve_lp1 :1;	/* never has lp1	*/
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
-	char			restart_mode;	/* default restart mode	*/
+	enum reboot_mode	reboot_mode;	/* default restart mode	*/
 	struct smp_operations	*smp;		/* SMP operations	*/
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index f219703..161e66c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -174,14 +174,14 @@ void arch_cpu_idle(void)
 		default_idle();
 }
 
-static char reboot_mode = 'h';
+enum reboot_mode reboot_mode;
 
-int __init reboot_setup(char *str)
+static int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_WARM;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 void machine_shutdown(void)
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 728007c..465e878 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -72,7 +72,7 @@ __setup("fpe=", fpe_setup);
 
 extern void paging_init(struct machine_desc *desc);
 extern void sanity_check_meminfo(void);
-extern void reboot_setup(char *str);
+extern enum reboot_mode reboot_mode;
 extern void setup_dma_zone(struct machine_desc *desc);
 
 unsigned int processor_id;
@@ -758,8 +758,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_dma_zone(mdesc);
 
-	if (mdesc->restart_mode)
-		reboot_setup(&mdesc->restart_mode);
+	if (mdesc->reboot_mode != REBOOT_COLD)
+		reboot_mode = mdesc->reboot_mode;
 
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
diff --git a/arch/arm/mach-footbridge/cats-hw.c b/arch/arm/mach-footbridge/cats-hw.c
index 6987a09..14c9cb9 100644
--- a/arch/arm/mach-footbridge/cats-hw.c
+++ b/arch/arm/mach-footbridge/cats-hw.c
@@ -86,7 +86,7 @@ fixup_cats(struct tag *tags, char **cmdline, struct meminfo *mi)
 MACHINE_START(CATS, "Chalice-CATS")
 	/* Maintainer: Philip Blundell */
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
+	.reboot_mode	= REBOOT_WARM,
 	.fixup		= fixup_cats,
 	.map_io		= footbridge_map_io,
 	.init_irq	= footbridge_init_irq,
-- 
1.8.2.1

