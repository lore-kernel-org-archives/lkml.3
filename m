Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3HGPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:00:59 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60301 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3HGO6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:34 -0400
Message-ID: <201308071458.r77EwWuV013082@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 14:11:21 -0400
Subject: [PATCH] tile: various console improvements
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change improves and cleans up the tile console.

- We enable HVC_IRQ support on tilegx, with the addition of a new
  Tilera hypervisor API for tilegx to allow a console IPI.  If IPI
  support is not available we fall back to the previous polling mode.

- We simplify the earlyprintk code to use CON_BOOT and eliminate some
  of the other supporting earlyprintk code.

- A new tile_console_write() primitive is used to send output to
  the console and is factored out of the hvc_tile driver.
  This lets us support a "sim_console" boot argument to allow using
  simulator hooks to send output to the "console" as a slightly
  faster alternative to emulating the hardware more directly.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                 |   1 +
 arch/tile/include/asm/setup.h     |   3 +-
 arch/tile/include/hv/hypervisor.h |  29 +++++++-
 arch/tile/kernel/early_printk.c   |  47 +++---------
 arch/tile/kernel/hvglue.lds       |   3 +-
 arch/tile/kernel/reboot.c         |   2 -
 drivers/tty/hvc/hvc_tile.c        | 149 ++++++++++++++++++++++++++++++++++++--
 7 files changed, 186 insertions(+), 48 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e41a381..0576e1d 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -112,6 +112,7 @@ config SMP
 config HVC_TILE
 	depends on TTY
 	select HVC_DRIVER
+	select HVC_IRQ if TILEGX
 	def_bool y
 
 config TILEGX
diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
index d048888..e989090 100644
--- a/arch/tile/include/asm/setup.h
+++ b/arch/tile/include/asm/setup.h
@@ -24,9 +24,8 @@
  */
 #define MAXMEM_PFN	PFN_DOWN(MAXMEM)
 
+int tile_console_write(const char *buf, int count);
 void early_panic(const char *fmt, ...);
-void warn_early_printk(void);
-void __init disable_early_printk(void);
 
 /* Init-time routine to do tile-specific per-cpu setup. */
 void setup_cpu(int boot);
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 837dca5..f882ebc 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -318,8 +318,11 @@
 /** hv_set_pte_super_shift */
 #define HV_DISPATCH_SET_PTE_SUPER_SHIFT           57
 
+/** hv_console_set_ipi */
+#define HV_DISPATCH_CONSOLE_SET_IPI               63
+
 /** One more than the largest dispatch value */
-#define _HV_DISPATCH_END                          58
+#define _HV_DISPATCH_END                          64
 
 
 #ifndef __ASSEMBLER__
@@ -585,6 +588,30 @@ typedef struct
  */
 int hv_get_ipi_pte(HV_Coord tile, int pl, HV_PTE* pte);
 
+/** Configure the console interrupt.
+ *
+ * When the console client interrupt is enabled, the hypervisor will
+ * deliver the specified IPI to the client in the following situations:
+ *
+ * - The console has at least one character available for input.
+ *
+ * - The console can accept new characters for output, and the last call
+ *   to hv_console_write() did not write all of the characters requested
+ *   by the client.
+ *
+ * Note that in some system configurations, console interrupt will not
+ * be available; clients should be prepared for this routine to fail and
+ * to fall back to periodic console polling in that case.
+ *
+ * @param ipi Index of the IPI register which will receive the interrupt.
+ * @param event IPI event number for console interrupt. If less than 0,
+ *        disable the console IPI interrupt.
+ * @param coord Tile to be targeted for console interrupt.
+ * @return 0 on success, otherwise, HV_EINVAL if illegal parameter,
+ *         HV_ENOTSUP if console interrupt are not available.
+ */
+int hv_console_set_ipi(int ipi, int event, HV_Coord coord);
+
 #else /* !CHIP_HAS_IPI() */
 
 /** A set of interrupts. */
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index 34d72a1..b608e00 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -23,19 +23,24 @@
 
 static void early_hv_write(struct console *con, const char *s, unsigned n)
 {
-	hv_console_write((HV_VirtAddr) s, n);
+	tile_console_write(s, n);
+
+	/*
+	 * Convert NL to NLCR (close enough to CRNL) during early boot.
+	 * We assume newlines are at the ends of strings, which turns out
+	 * to be good enough for early boot console output.
+	 */
+	if (n && s[n-1] == '\n')
+		tile_console_write("\r", 1);
 }
 
 static struct console early_hv_console = {
 	.name =		"earlyhv",
 	.write =	early_hv_write,
-	.flags =	CON_PRINTBUFFER,
+	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static int early_console_complete;
-
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
@@ -43,51 +48,21 @@ void early_panic(const char *fmt, ...)
 	va_start(ap, fmt);
 	early_printk("Kernel panic - not syncing: ");
 	early_vprintk(fmt, ap);
-	early_console->write(early_console, "\n", 1);
+	early_printk("\n");
 	va_end(ap);
 	dump_stack();
 	hv_halt();
 }
 
-static int __initdata keep_early;
-
 static int __init setup_early_printk(char *str)
 {
 	if (early_console)
 		return 1;
 
-	if (str != NULL && strncmp(str, "keep", 4) == 0)
-		keep_early = 1;
-
 	early_console = &early_hv_console;
 	register_console(early_console);
 
 	return 0;
 }
 
-void __init disable_early_printk(void)
-{
-	early_console_complete = 1;
-	if (!early_console)
-		return;
-	if (!keep_early) {
-		early_printk("disabling early console\n");
-		unregister_console(early_console);
-		early_console = NULL;
-	} else {
-		early_printk("keeping early console\n");
-	}
-}
-
-void warn_early_printk(void)
-{
-	if (early_console_complete || early_console)
-		return;
-	early_printk("\
-Machine shutting down before console output is fully initialized.\n\
-You may wish to reboot and add the option 'earlyprintk' to your\n\
-boot command line to see any diagnostic early console output.\n\
-");
-}
-
 early_param("earlyprintk", setup_early_printk);
diff --git a/arch/tile/kernel/hvglue.lds b/arch/tile/kernel/hvglue.lds
index d44c5a6..ef52290 100644
--- a/arch/tile/kernel/hvglue.lds
+++ b/arch/tile/kernel/hvglue.lds
@@ -56,4 +56,5 @@ hv_inquire_realpa = TEXT_OFFSET + 0x106c0;
 hv_flush_all = TEXT_OFFSET + 0x106e0;
 hv_get_ipi_pte = TEXT_OFFSET + 0x10700;
 hv_set_pte_super_shift = TEXT_OFFSET + 0x10720;
-hv_glue_internals = TEXT_OFFSET + 0x10740;
+hv_console_set_ipi = TEXT_OFFSET + 0x107e0;
+hv_glue_internals = TEXT_OFFSET + 0x10800;
diff --git a/arch/tile/kernel/reboot.c b/arch/tile/kernel/reboot.c
index d1b5c91..6c5d2c0 100644
--- a/arch/tile/kernel/reboot.c
+++ b/arch/tile/kernel/reboot.c
@@ -27,7 +27,6 @@
 
 void machine_halt(void)
 {
-	warn_early_printk();
 	arch_local_irq_disable_all();
 	smp_send_stop();
 	hv_halt();
@@ -35,7 +34,6 @@ void machine_halt(void)
 
 void machine_power_off(void)
 {
-	warn_early_printk();
 	arch_local_irq_disable_all();
 	smp_send_stop();
 	hv_power_off();
diff --git a/drivers/tty/hvc/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
index 7a84a05..af8cdaa 100644
--- a/drivers/tty/hvc/hvc_tile.c
+++ b/drivers/tty/hvc/hvc_tile.c
@@ -18,16 +18,46 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/moduleparam.h>
+#include <linux/platform_device.h>
 #include <linux/types.h>
 
+#include <asm/setup.h>
+#include <arch/sim_def.h>
+
 #include <hv/hypervisor.h>
 
 #include "hvc_console.h"
 
+static int use_sim_console;
+static int __init sim_console(char *str)
+{
+	use_sim_console = 1;
+	return 0;
+}
+early_param("sim_console", sim_console);
+
+int tile_console_write(const char *buf, int count)
+{
+	if (unlikely(use_sim_console)) {
+		int i;
+		for (i = 0; i < count; ++i)
+			__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
+				     (buf[i] << _SIM_CONTROL_OPERATOR_BITS));
+		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
+			     (SIM_PUTC_FLUSH_BINARY <<
+			      _SIM_CONTROL_OPERATOR_BITS));
+		return 0;
+	} else {
+		return hv_console_write((HV_VirtAddr)buf, count);
+	}
+}
+
 static int hvc_tile_put_chars(uint32_t vt, const char *buf, int count)
 {
-	return hv_console_write((HV_VirtAddr)buf, count);
+	return tile_console_write(buf, count);
 }
 
 static int hvc_tile_get_chars(uint32_t vt, char *buf, int count)
@@ -44,25 +74,132 @@ static int hvc_tile_get_chars(uint32_t vt, char *buf, int count)
 	return i;
 }
 
+#ifdef __tilegx__
+/*
+ * IRQ based callbacks.
+ */
+static int hvc_tile_notifier_add_irq(struct hvc_struct *hp, int irq)
+{
+	int rc;
+	int cpu = raw_smp_processor_id();  /* Choose an arbitrary cpu */
+	HV_Coord coord = { .x = cpu_x(cpu), .y = cpu_y(cpu) };
+
+	rc = notifier_add_irq(hp, irq);
+	if (rc)
+		return rc;
+
+	/*
+	 * Request that the hypervisor start sending us interrupts.
+	 * If the hypervisor returns an error, we still return 0, so that
+	 * we can fall back to polling.
+	 */
+	if (hv_console_set_ipi(KERNEL_PL, irq, coord) < 0)
+		notifier_del_irq(hp, irq);
+
+	return 0;
+}
+
+static void hvc_tile_notifier_del_irq(struct hvc_struct *hp, int irq)
+{
+	HV_Coord coord = { 0, 0 };
+
+	/* Tell the hypervisor to stop sending us interrupts. */
+	hv_console_set_ipi(KERNEL_PL, -1, coord);
+
+	notifier_del_irq(hp, irq);
+}
+
+static void hvc_tile_notifier_hangup_irq(struct hvc_struct *hp, int irq)
+{
+	hvc_tile_notifier_del_irq(hp, irq);
+}
+#endif
+
 static const struct hv_ops hvc_tile_get_put_ops = {
 	.get_chars = hvc_tile_get_chars,
 	.put_chars = hvc_tile_put_chars,
+#ifdef __tilegx__
+	.notifier_add = hvc_tile_notifier_add_irq,
+	.notifier_del = hvc_tile_notifier_del_irq,
+	.notifier_hangup = hvc_tile_notifier_hangup_irq,
+#endif
+};
+
+
+#ifdef __tilegx__
+static int hvc_tile_probe(struct platform_device *pdev)
+{
+	struct hvc_struct *hp;
+	int tile_hvc_irq;
+
+	/* Create our IRQ and register it. */
+	tile_hvc_irq = create_irq();
+	if (tile_hvc_irq < 0)
+		return -ENXIO;
+
+	tile_irq_activate(tile_hvc_irq, TILE_IRQ_PERCPU);
+	hp = hvc_alloc(0, tile_hvc_irq, &hvc_tile_get_put_ops, 128);
+	if (IS_ERR(hp)) {
+		destroy_irq(tile_hvc_irq);
+		return PTR_ERR(hp);
+	}
+	dev_set_drvdata(&pdev->dev, hp);
+
+	return 0;
+}
+
+static int hvc_tile_remove(struct platform_device *pdev)
+{
+	int rc;
+	struct hvc_struct *hp = dev_get_drvdata(&pdev->dev);
+
+	rc = hvc_remove(hp);
+	if (rc == 0)
+		destroy_irq(hp->data);
+
+	return rc;
+}
+
+static void hvc_tile_shutdown(struct platform_device *pdev)
+{
+	struct hvc_struct *hp = dev_get_drvdata(&pdev->dev);
+
+	hvc_tile_notifier_del_irq(hp, hp->data);
+}
+
+static struct platform_device hvc_tile_pdev = {
+	.name           = "hvc-tile",
+	.id             = 0,
+};
+
+static struct platform_driver hvc_tile_driver = {
+	.probe          = hvc_tile_probe,
+	.remove         = hvc_tile_remove,
+	.shutdown	= hvc_tile_shutdown,
+	.driver         = {
+		.name   = "hvc-tile",
+		.owner  = THIS_MODULE,
+	}
 };
+#endif
 
 static int __init hvc_tile_console_init(void)
 {
-	extern void disable_early_printk(void);
 	hvc_instantiate(0, 0, &hvc_tile_get_put_ops);
 	add_preferred_console("hvc", 0, NULL);
-	disable_early_printk();
 	return 0;
 }
 console_initcall(hvc_tile_console_init);
 
 static int __init hvc_tile_init(void)
 {
-	struct hvc_struct *s;
-	s = hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
-	return IS_ERR(s) ? PTR_ERR(s) : 0;
+#ifndef __tilegx__
+	struct hvc_struct *hp;
+	hp = hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
+	return IS_ERR(hp) ? PTR_ERR(hp) : 0;
+#else
+	platform_device_register(&hvc_tile_pdev);
+	return platform_driver_register(&hvc_tile_driver);
+#endif
 }
 device_initcall(hvc_tile_init);
-- 
1.8.3.1

