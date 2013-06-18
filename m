Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3FRTOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:14:04 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61109 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab3FRTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:13:07 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 4/5] MIPS: OCTEON: Remove custom serial setup code.
Date: Tue, 18 Jun 2013 12:12:54 -0700
Message-Id: <1371582775-12141-5-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We will use 8250_dw instead.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/Makefile |   2 +-
 arch/mips/cavium-octeon/serial.c | 109 ---------------------------------------
 2 files changed, 1 insertion(+), 110 deletions(-)
 delete mode 100644 arch/mips/cavium-octeon/serial.c

diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index e3fd50c..4e95204 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -12,7 +12,7 @@
 CFLAGS_octeon-platform.o = -I$(src)/../../../scripts/dtc/libfdt
 CFLAGS_setup.o = -I$(src)/../../../scripts/dtc/libfdt
 
-obj-y := cpu.o setup.o serial.o octeon-platform.o octeon-irq.o csrc-octeon.o
+obj-y := cpu.o setup.o octeon-platform.o octeon-irq.o csrc-octeon.o
 obj-y += dma-octeon.o
 obj-y += octeon-memcpy.o
 obj-y += executive/
diff --git a/arch/mips/cavium-octeon/serial.c b/arch/mips/cavium-octeon/serial.c
deleted file mode 100644
index f393f65..0000000
--- a/arch/mips/cavium-octeon/serial.c
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2004-2007 Cavium Networks
- */
-#include <linux/console.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/serial.h>
-#include <linux/serial_8250.h>
-#include <linux/serial_reg.h>
-#include <linux/tty.h>
-#include <linux/irq.h>
-
-#include <asm/time.h>
-
-#include <asm/octeon/octeon.h>
-
-#define DEBUG_UART 1
-
-unsigned int octeon_serial_in(struct uart_port *up, int offset)
-{
-	int rv = cvmx_read_csr((uint64_t)(up->membase + (offset << 3)));
-	if (offset == UART_IIR && (rv & 0xf) == 7) {
-		/* Busy interrupt, read the USR (39) and try again. */
-		cvmx_read_csr((uint64_t)(up->membase + (39 << 3)));
-		rv = cvmx_read_csr((uint64_t)(up->membase + (offset << 3)));
-	}
-	return rv;
-}
-
-void octeon_serial_out(struct uart_port *up, int offset, int value)
-{
-	/*
-	 * If bits 6 or 7 of the OCTEON UART's LCR are set, it quits
-	 * working.
-	 */
-	if (offset == UART_LCR)
-		value &= 0x9f;
-	cvmx_write_csr((uint64_t)(up->membase + (offset << 3)), (u8)value);
-}
-
-static int octeon_serial_probe(struct platform_device *pdev)
-{
-	int irq, res;
-	struct resource *res_mem;
-	struct uart_8250_port up;
-
-	/* All adaptors have an irq.  */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	memset(&up, 0, sizeof(up));
-
-	up.port.flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
-	up.port.type = PORT_OCTEON;
-	up.port.iotype = UPIO_MEM;
-	up.port.regshift = 3;
-	up.port.dev = &pdev->dev;
-
-	if (octeon_is_simulation())
-		/* Make simulator output fast*/
-		up.port.uartclk = 115200 * 16;
-	else
-		up.port.uartclk = octeon_get_io_clock_rate();
-
-	up.port.serial_in = octeon_serial_in;
-	up.port.serial_out = octeon_serial_out;
-	up.port.irq = irq;
-
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res_mem == NULL) {
-		dev_err(&pdev->dev, "found no memory resource\n");
-		return -ENXIO;
-	}
-	up.port.mapbase = res_mem->start;
-	up.port.membase = ioremap(res_mem->start, resource_size(res_mem));
-
-	res = serial8250_register_8250_port(&up);
-
-	return res >= 0 ? 0 : res;
-}
-
-static struct of_device_id octeon_serial_match[] = {
-	{
-		.compatible = "cavium,octeon-3860-uart",
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, octeon_serial_match);
-
-static struct platform_driver octeon_serial_driver = {
-	.probe		= octeon_serial_probe,
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "octeon_serial",
-		.of_match_table = octeon_serial_match,
-	},
-};
-
-static int __init octeon_serial_init(void)
-{
-	return platform_driver_register(&octeon_serial_driver);
-}
-late_initcall(octeon_serial_init);
-- 
1.7.11.7

