Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab3GLUJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:09:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33258 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336Ab3GLUJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:09:07 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/3] x86, boot: add mmio serial during compressed boot
Date: Fri, 12 Jul 2013 13:07:38 -0700
Message-Id: <1373659660-31123-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows "console=uart[8250],mmio[32],0xADDR[,BAUDn8[,BASE_BAUD]]" to
be recognized during compressed boot early console setup, and during
boot console setup. Replaces defines with common serial defines. Adds
suport for mmio-based serial devices to compressed-boot early console,
and plumbs support for defining the base baud rate for UART clock
calculations (since mmio serial cards may not have the standard rate,
resulting in incorrect baud rates for mmio devices).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/kernel-parameters.txt             |   12 ++-
 arch/x86/boot/boot.h                            |   20 +++-
 arch/x86/boot/compressed/early_serial_console.c |    5 +-
 arch/x86/boot/compressed/misc.c                 |   10 +-
 arch/x86/boot/compressed/misc.h                 |    4 +-
 arch/x86/boot/early_serial_console.c            |  122 +++++++++++++----------
 arch/x86/boot/early_serial_console.h            |   43 ++++++++
 arch/x86/boot/tty.c                             |   12 +--
 drivers/tty/serial/8250/8250_early.c            |   11 +-
 include/uapi/linux/serial_reg.h                 |    5 +-
 10 files changed, 168 insertions(+), 76 deletions(-)
 create mode 100644 arch/x86/boot/early_serial_console.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 15356ac..52ad7d8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -575,11 +575,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			alternative.
 
 		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],mmio,<addr>[,options[,base_baud]]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
+
+			For x86 early boot mmio uart consoles, the base baud
+			rate (for calculating the UART clock) can be defined
+			as well. This is done after the options above, comma
+			separated. For example "...,115200n8,4000000" would
+			use 4000000 as the base baud rate. Once the real uart
+			driver initializes, this value will be ignored, since
+			it will use the known device-specific value instead.
+			The default is 115200.
+
 		hvc<n>	Use the hypervisor console device <n>. This is for
 			both Xen and PowerPC hypervisors.
 
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 5b75319..ae61c19 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -80,6 +80,23 @@ static inline void io_delay(void)
 	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
 }
 
+/* Minimal mmio functions from include/asm/io.h. */
+#define build_mmio_read(name, size, type, reg, barrier) \
+static inline type name(const volatile void __iomem *addr) \
+{ type ret; asm volatile("mov" size " %1,%0":reg (ret) \
+:"m" (*(volatile type __force *)addr) barrier); return ret; }
+
+#define build_mmio_write(name, size, type, reg, barrier) \
+static inline void name(type val, volatile void __iomem *addr) \
+{ asm volatile("mov" size " %0,%1": :reg (val), \
+"m" (*(volatile type __force *)addr) barrier); }
+
+build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
+build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
+
+build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
+build_mmio_write(writel, "l", unsigned int, "r", :"memory")
+
 /* These functions are used to reference data in other segments. */
 
 static inline u16 ds(void)
@@ -319,7 +336,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
 /* early_serial_console.c */
-extern int early_serial_base;
+extern unsigned long early_serial_base;
+extern int early_serial_type;
 void console_init(void);
 
 /* edd.c */
diff --git a/arch/x86/boot/compressed/early_serial_console.c b/arch/x86/boot/compressed/early_serial_console.c
index d3d003c..7b9572a 100644
--- a/arch/x86/boot/compressed/early_serial_console.c
+++ b/arch/x86/boot/compressed/early_serial_console.c
@@ -2,8 +2,9 @@
 
 #ifdef CONFIG_EARLY_PRINTK
 
-int early_serial_base;
-
 #include "../early_serial_console.c"
 
+unsigned long early_serial_base;
+int early_serial_type;
+
 #endif
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 0319c88..3c635f0 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -125,6 +125,8 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
+#include "../early_serial_console.h"
+
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
 #endif
@@ -158,18 +160,14 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }
 
-#define XMTRDY          0x20
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define LSR             5       /*  Line Status               */
 static void serial_putchar(int ch)
 {
 	unsigned timeout = 0xffff;
 
-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((early_serial_in(UART_LSR) & UART_LSR_THRE) == 0 && --timeout)
 		cpu_relax();
 
-	outb(ch, early_serial_base + TXR);
+	early_serial_out(UART_TX, ch);
 }
 
 void __putstr(const char *s)
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 674019d..da0b0bc 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -46,13 +46,13 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 
 /* early_serial_console.c */
-extern int early_serial_base;
+extern unsigned long early_serial_base;
 void console_init(void);
 
 #else
 
 /* early_serial_console.c */
-static const int early_serial_base;
+static const unsigned long early_serial_base;
 static inline void console_init(void)
 { }
 
diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..3483b0b7 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -1,43 +1,26 @@
 #include "boot.h"
+#include "early_serial_console.h"
 
-#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
-
-#define XMTRDY          0x20
-
-#define DLAB		0x80
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
-#define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
-#define FCR             2       /*  FIFO control              */
-#define LCR             3       /*  Line control              */
-#define MCR             4       /*  Modem control             */
-#define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
-#define DLL             0       /*  Divisor Latch Low         */
-#define DLH             1       /*  Divisor latch High        */
-
-#define DEFAULT_BAUD 9600
-
-static void early_serial_init(int port, int baud)
+static void early_serial_init(int type, unsigned long port, int baud,
+			      int base_baud)
 {
 	unsigned char c;
 	unsigned divisor;
 
-	outb(0x3, port + LCR);	/* 8n1 */
-	outb(0, port + IER);	/* no interrupt */
-	outb(0, port + FCR);	/* no fifo */
-	outb(0x3, port + MCR);	/* DTR + RTS */
-
-	divisor	= 115200 / baud;
-	c = inb(port + LCR);
-	outb(c | DLAB, port + LCR);
-	outb(divisor & 0xff, port + DLL);
-	outb((divisor >> 8) & 0xff, port + DLH);
-	outb(c & ~DLAB, port + LCR);
-
+	early_serial_type = type;
 	early_serial_base = port;
+
+	early_serial_out(UART_LCR, UART_LCR_WLEN8);	/* 8n1 */
+	early_serial_out(UART_IER, 0);			/* no interrupts */
+	early_serial_out(UART_FCR, 0);			/* no fifo */
+	early_serial_out(UART_MCR, UART_MCR_DTR | UART_MCR_RTS);
+
+	divisor	= base_baud / baud;
+	c = early_serial_in(UART_LCR);
+	early_serial_out(UART_LCR, c | UART_LCR_DLAB);
+	early_serial_out(UART_DLL, divisor & 0xff);
+	early_serial_out(UART_DLM, (divisor >> 8) & 0xff);
+	early_serial_out(UART_LCR, c & ~UART_LCR_DLAB);
 }
 
 static void parse_earlyprintk(void)
@@ -45,7 +28,7 @@ static void parse_earlyprintk(void)
 	int baud = DEFAULT_BAUD;
 	char arg[32];
 	int pos = 0;
-	int port = 0;
+	unsigned long port = 0;
 
 	if (cmdline_find_option("earlyprintk", arg, sizeof arg) > 0) {
 		char *e;
@@ -92,33 +75,47 @@ static void parse_earlyprintk(void)
 	}
 
 	if (port)
-		early_serial_init(port, baud);
+		early_serial_init(EARLY_SERIAL_IO, port, baud,
+				  SERIAL_BAUD_BASE);
 }
 
-#define BASE_BAUD (1843200/16)
-static unsigned int probe_baud(int port)
+static unsigned int probe_baud(int type, unsigned long port)
 {
 	unsigned char lcr, dll, dlh;
 	unsigned int quot;
+	int saved_type;
+	unsigned long saved_port;
 
-	lcr = inb(port + LCR);
-	outb(lcr | DLAB, port + LCR);
-	dll = inb(port + DLL);
-	dlh = inb(port + DLH);
-	outb(lcr, port + LCR);
+	saved_type = early_serial_type;
+	saved_port = early_serial_base;
+	early_serial_type = type;
+	early_serial_base = port;
+
+	lcr = early_serial_in(UART_LCR);
+	early_serial_out(UART_LCR, lcr | UART_LCR_DLAB);
+	dll = early_serial_in(UART_DLL);
+	dlh = early_serial_in(UART_DLM);
+	early_serial_out(UART_LCR, lcr);
 	quot = (dlh << 8) | dll;
 
-	return BASE_BAUD / quot;
+	early_serial_type = saved_type;
+	early_serial_base = saved_port;
+
+	return SERIAL_BAUD_BASE / quot;
 }
 
 static void parse_console_uart8250(void)
 {
 	char optstr[64], *options;
 	int baud = DEFAULT_BAUD;
-	int port = 0;
+	int base_baud = SERIAL_BAUD_BASE;
+	int type = EARLY_SERIAL_IO;
+	unsigned long port = 0;
 
 	/*
 	 * console=uart8250,io,0x3f8,115200n8
+	 * console=uart,mmio,0xe080100,115200n8
+	 * console=uart,mmio32,0xe0801000,115200n8
 	 * need to make sure it is last one console !
 	 */
 	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
@@ -126,20 +123,41 @@ static void parse_console_uart8250(void)
 
 	options = optstr;
 
-	if (!strncmp(options, "uart8250,io,", 12))
-		port = simple_strtoull(options + 12, &options, 0);
-	else if (!strncmp(options, "uart,io,", 8))
-		port = simple_strtoull(options + 8, &options, 0);
-	else
+	if (strncmp(options, "uart", 4))
+		return;
+	options += 4;
+	if (!strncmp(options, "8250", 4))
+		options += 4;
+	if (*options++ != ',')
 		return;
 
-	if (options && (options[0] == ','))
+	if (!strncmp(options, "io,", 3))
+		port = simple_strtoull(options + 3, &options, 0);
+	else if (!strncmp(options, "mmio", 4)) {
+		options += 4;
+		type = EARLY_SERIAL_MMIO;
+		if (!strncmp(options, "32", 2)) {
+			options += 2;
+			type = EARLY_SERIAL_MMIO32;
+		}
+		if (*options++ != ',')
+			return;
+		port = simple_strtoull(options, &options, 0);
+	} else
+		return;
+
+	if (options && (options[0] == ',')) {
 		baud = simple_strtoull(options + 1, &options, 0);
+		while (*options != ' ' && *options != ',' && *options != '\0')
+			options++;
+		if (*options == ',')
+			base_baud = simple_strtoull(options + 1, &options, 0);
+	}
 	else
-		baud = probe_baud(port);
+		baud = probe_baud(type, port);
 
 	if (port)
-		early_serial_init(port, baud);
+		early_serial_init(type, port, baud, base_baud);
 }
 
 void console_init(void)
diff --git a/arch/x86/boot/early_serial_console.h b/arch/x86/boot/early_serial_console.h
new file mode 100644
index 0000000..3f7ff34
--- /dev/null
+++ b/arch/x86/boot/early_serial_console.h
@@ -0,0 +1,43 @@
+#include <linux/serial_reg.h>
+
+#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
+#define DEFAULT_BAUD 9600
+
+#define EARLY_SERIAL_IO		0
+#define EARLY_SERIAL_MMIO	1
+#define EARLY_SERIAL_MMIO32	2
+
+extern unsigned long early_serial_base;
+extern int early_serial_type;
+
+static inline unsigned int early_serial_in(int offset)
+{
+	switch (early_serial_type) {
+	case EARLY_SERIAL_IO:
+		return inb(early_serial_base + offset);
+	case EARLY_SERIAL_MMIO:
+		return readb((const volatile void *)early_serial_base +
+				offset);
+	case EARLY_SERIAL_MMIO32:
+		return readl((const volatile void *)early_serial_base +
+				(offset << 2));
+	default:
+		return 0;
+	}
+}
+
+static inline void early_serial_out(int offset, int value)
+{
+	switch (early_serial_type) {
+	case EARLY_SERIAL_IO:
+		outb(value, early_serial_base + offset);
+		break;
+	case EARLY_SERIAL_MMIO:
+		writeb(value, (volatile void *)early_serial_base + offset);
+		break;
+	case EARLY_SERIAL_MMIO32:
+		writel(value, (volatile void *)early_serial_base +
+				(offset << 2));
+		break;
+	}
+}
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index def2451..60dede2 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -15,12 +15,10 @@
 
 #include "boot.h"
 
-int early_serial_base;
+unsigned long early_serial_base;
+int early_serial_type;
 
-#define XMTRDY          0x20
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define LSR             5       /*  Line Status               */
+#include "early_serial_console.h"
 
 /*
  * These functions are in .inittext so they can be used to signal
@@ -31,10 +29,10 @@ static void __attribute__((section(".inittext"))) serial_putchar(int ch)
 {
 	unsigned timeout = 0xffff;
 
-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((early_serial_in(UART_LSR) & UART_LSR_THRE) == 0 && --timeout)
 		cpu_relax();
 
-	outb(ch, early_serial_base + TXR);
+	early_serial_out(UART_TX, ch);
 }
 
 static void __attribute__((section(".inittext"))) bios_putchar(int ch)
diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index 721904f..9526dd0 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -42,7 +42,7 @@
 
 struct early_serial8250_device {
 	struct uart_port port;
-	char options[16];		/* e.g., 115200n8 */
+	char options[32];		/* e.g., 115200n8 */
 	unsigned int baud;
 };
 
@@ -153,12 +153,11 @@ static int __init parse_options(struct early_serial8250_device *device,
 {
 	struct uart_port *port = &device->port;
 	int mmio, mmio32, length;
+	int base_baud = BASE_BAUD;
 
 	if (!options)
 		return -ENODEV;
 
-	port->uartclk = BASE_BAUD * 16;
-
 	mmio = !strncmp(options, "mmio,", 5);
 	mmio32 = !strncmp(options, "mmio32,", 7);
 	if (mmio || mmio32) {
@@ -195,12 +194,18 @@ static int __init parse_options(struct early_serial8250_device *device,
 		device->baud = simple_strtoul(options, NULL, 0);
 		length = min(strcspn(options, " "), sizeof(device->options));
 		strlcpy(device->options, options, length);
+		while (*options != ' ' && *options != '\0' && *options != ',')
+			options++;
+		if (*options == ',')
+			base_baud = simple_strtoul(options + 1, NULL, 0);
 	} else {
 		device->baud = probe_baud(port);
 		snprintf(device->options, sizeof(device->options), "%u",
 			device->baud);
 	}
 
+	port->uartclk = base_baud * 16;
+
 	if (mmio || mmio32)
 		printk(KERN_INFO
 		       "Early serial console at MMIO%s 0x%llx (options '%s')\n",
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index e632260..bdeaf5a 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -333,12 +333,13 @@
 
 #define UART_RSA_TCR_SWITCH (1 << 0) /* Timer on */
 
+#define SERIAL_BAUD_BASE (1843200/16)
 /*
  * The RSA DSV/II board has two fixed clock frequencies.  One is the
  * standard rate, and the other is 8 times faster.
  */
-#define SERIAL_RSA_BAUD_BASE (921600)
-#define SERIAL_RSA_BAUD_BASE_LO (SERIAL_RSA_BAUD_BASE / 8)
+#define SERIAL_RSA_BAUD_BASE_LO SERIAL_BAUD_BASE
+#define SERIAL_RSA_BAUD_BASE (SERIAL_RSA_BAUD_BASE * 8)
 
 /*
  * Extra serial register definitions for the internal UARTs
-- 
1.7.9.5

