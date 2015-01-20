Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbbATMIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:08:17 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:51926 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbATMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:08:15 -0500
Subject: [PATCH RESEND] Specify PCI based UART for earlyprintk
From: Alan <gnomes@lxorguk.ukuu.org.uk>
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Tue, 20 Jan 2015 12:07:57 +0000
Message-ID: <20150120120749.28310.51041.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stuart R. Anderson <stuart.r.anderson@intel.com>

Add support for specifying PCI based UARTs for earlyprintk
using a syntax like "earlyprintk=pciserial,00:18.1,115200",
where 00:18.1 is the BDF of a UART device.

[Slightly tidied from Stuart's original patch]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/x86/kernel/early_printk.c |  182 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 166 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 01d1c18..49e071e 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -19,6 +19,7 @@
 #include <linux/usb/ehci_def.h>
 #include <linux/efi.h>
 #include <asm/efi.h>
+#include <asm/pci_x86.h>
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
@@ -76,7 +77,7 @@ static struct console early_vga_console = {
 
 /* Serial functions loosely based on a similar package from Klaus P. Gerlicher */
 
-static int early_serial_base = 0x3f8;  /* ttyS0 */
+static unsigned long early_serial_base = 0x3f8;  /* ttyS0 */
 
 #define XMTRDY          0x20
 
@@ -94,13 +95,40 @@ static int early_serial_base = 0x3f8;  /* ttyS0 */
 #define DLL             0       /*  Divisor Latch Low         */
 #define DLH             1       /*  Divisor latch High        */
 
+static void mem32_serial_out(unsigned long addr, int offset, int value)
+{
+	uint32_t *vaddr = (uint32_t *)addr;
+	/* shift implied by pointer type */
+	writel(value, vaddr + offset);
+}
+
+static unsigned int mem32_serial_in(unsigned long addr, int offset)
+{
+	uint32_t *vaddr = (uint32_t *)addr;
+	/* shift implied by pointer type */
+	return readl(vaddr + offset);
+}
+
+static unsigned int io_serial_in(unsigned long addr, int offset)
+{
+	return inb(addr + offset);
+}
+
+static void io_serial_out(unsigned long addr, int offset, int value)
+{
+	outb(value, addr + offset);
+}
+
+static unsigned int (*serial_in)(unsigned long addr, int offset) = io_serial_in;
+static void (*serial_out)(unsigned long addr, int offset, int value) = io_serial_out;
+
 static int early_serial_putc(unsigned char ch)
 {
 	unsigned timeout = 0xffff;
 
-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((serial_in(early_serial_base, LSR) & XMTRDY) == 0 && --timeout)
 		cpu_relax();
-	outb(ch, early_serial_base + TXR);
+	serial_out(early_serial_base, TXR, ch);
 	return timeout ? 0 : -1;
 }
 
@@ -114,13 +142,28 @@ static void early_serial_write(struct console *con, const char *s, unsigned n)
 	}
 }
 
+static __init void early_serial_hw_init(unsigned divisor)
+{
+	unsigned char c;
+
+	serial_out(early_serial_base, LCR, 0x3);	/* 8n1 */
+	serial_out(early_serial_base, IER, 0);	/* no interrupt */
+	serial_out(early_serial_base, FCR, 0);	/* no fifo */
+	serial_out(early_serial_base, MCR, 0x3);	/* DTR + RTS */
+
+	c = serial_in(early_serial_base, LCR);
+	serial_out(early_serial_base, LCR, c | DLAB);
+	serial_out(early_serial_base, DLL, divisor & 0xff);
+	serial_out(early_serial_base, DLH, (divisor >> 8) & 0xff);
+	serial_out(early_serial_base, LCR, c & ~DLAB);
+}
+
 #define DEFAULT_BAUD 9600
 
 static __init void early_serial_init(char *s)
 {
-	unsigned char c;
 	unsigned divisor;
-	unsigned baud = DEFAULT_BAUD;
+	unsigned long baud = DEFAULT_BAUD;
 	char *e;
 
 	if (*s == ',')
@@ -145,24 +188,124 @@ static __init void early_serial_init(char *s)
 			s++;
 	}
 
-	outb(0x3, early_serial_base + LCR);	/* 8n1 */
-	outb(0, early_serial_base + IER);	/* no interrupt */
-	outb(0, early_serial_base + FCR);	/* no fifo */
-	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
+	if (*s) {
+		if (kstrtoul(s, 0, &baud) < 0 || baud == 0)
+			baud = DEFAULT_BAUD;
+	}
+
+	/* Convert from baud to divisor value */
+	divisor = 115200 / baud;
+
+	/* These will always be IO based ports */
+	serial_in = io_serial_in;
+	serial_out = io_serial_out;
+
+	/* Set up the HW */
+	early_serial_hw_init(divisor);
+}
+
+#ifdef CONFIG_PCI
+/*
+ * early_pci_serial_init()
+ *
+ * This function is invoked when the early_printk param starts with "pciserial"
+ * The rest of the param should be ",B:D.F,baud" where B, D & F describe the
+ * location of a PCI device that must be a UART device.
+ */
+static __init void early_pci_serial_init(char *s)
+{
+	unsigned divisor;
+	unsigned long baud = DEFAULT_BAUD;
+	u8 bus, slot, func;
+	uint32_t classcode, bar0;
+	uint16_t cmdreg;
+	char *e;
+
+
+	/*
+	 * First, part the param to get the BDF values
+	 */
+	if (*s == ',')
+		++s;
+
+	if (*s == 0)
+		return;
+
+	bus = (u8)simple_strtoul(s, &e, 16);
+	s = e;
+	if (*s != ':')
+		return;
+	++s;
+	slot = (u8)simple_strtoul(s, &e, 16);
+	s = e;
+	if (*s != '.')
+		return;
+	++s;
+	func = (u8)simple_strtoul(s, &e, 16);
+	s = e;
 
+	/* A baud might be following */
+	if (*s == ',')
+		s++;
+
+	/*
+	 * Second, find the device from the BDF
+	 */
+	cmdreg = read_pci_config(bus, slot, func, PCI_COMMAND);
+	classcode = read_pci_config(bus, slot, func, PCI_CLASS_REVISION);
+	bar0 = read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_0);
+
+	/*
+	 * Verify it is a UART type device
+	 */
+	if (((classcode >> 16 != PCI_CLASS_COMMUNICATION_MODEM) &&
+	     (classcode >> 16 != PCI_CLASS_COMMUNICATION_SERIAL)) ||
+	   (((classcode >> 8) & 0xff) != 0x02)) /* 16550 I/F at BAR0 */
+		return;
+
+	/*
+	 * Determine if it is IO or memory mapped
+	 */
+	if (bar0 & 0x01) {
+		/* it is IO mapped */
+		serial_in = io_serial_in;
+		serial_out = io_serial_out;
+		early_serial_base = bar0&0xfffffffc;
+		write_pci_config(bus, slot, func, PCI_COMMAND,
+						cmdreg|PCI_COMMAND_IO);
+	} else {
+		/* It is memory mapped - assume 32-bit alignment */
+		serial_in = mem32_serial_in;
+		serial_out = mem32_serial_out;
+		/* WARNING! assuming the address is always in the first 4G */
+		early_serial_base =
+			(unsigned long)early_ioremap(bar0 & 0xfffffff0, 0x10);
+		write_pci_config(bus, slot, func, PCI_COMMAND,
+						cmdreg|PCI_COMMAND_MEMORY);
+	}
+
+	/*
+	 * Lastly, initalize the hardware
+	 */
 	if (*s) {
-		baud = simple_strtoul(s, &e, 0);
-		if (baud == 0 || s == e)
+		if (strcmp(s, "nocfg") == 0)
+			/* Sometimes, we want to leave the UART alone
+			 * and assume the BIOS has set it up correctly.
+			 * "nocfg" tells us this is the case, and we
+			 * should do no more setup.
+			 */
+			return;
+		if (kstrtoul(s, 0, &baud) < 0 || baud == 0)
 			baud = DEFAULT_BAUD;
 	}
 
+	/* Convert from baud to divisor value */
 	divisor = 115200 / baud;
-	c = inb(early_serial_base + LCR);
-	outb(c | DLAB, early_serial_base + LCR);
-	outb(divisor & 0xff, early_serial_base + DLL);
-	outb((divisor >> 8) & 0xff, early_serial_base + DLH);
-	outb(c & ~DLAB, early_serial_base + LCR);
+
+	/* Set up the HW */
+	early_serial_hw_init(divisor);
 }
+#endif
 
 static struct console early_serial_console = {
 	.name =		"earlyser",
@@ -210,6 +353,13 @@ static int __init setup_early_printk(char *buf)
 			early_serial_init(buf + 4);
 			early_console_register(&early_serial_console, keep);
 		}
+#ifdef CONFIG_PCI
+		if (!strncmp(buf, "pciserial", 9)) {
+			early_pci_serial_init(buf + 9);
+			early_console_register(&early_serial_console, keep);
+			buf += 9; /* Keep from match the above "serial" */
+		}
+#endif
 		if (!strncmp(buf, "vga", 3) &&
 		    boot_params.screen_info.orig_video_isVGA == 1) {
 			max_xpos = boot_params.screen_info.orig_video_cols;

