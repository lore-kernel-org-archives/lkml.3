Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbaIRSdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:33:40 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54873 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458AbaIRSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:33:38 -0400
Message-ID: <1411065215.2017.78.camel@x220>
Subject: [PATCH 4/5] MN10300: Remove checks for GDBSTUB related Kconfig
 macros
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 20:33:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 18:33:35.0711 (UTC) FILETIME=[0E9E26F0:01CFD36F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Kconfig symbols (indirectly) depending on GDBSTUB were removed. Now
remove the checks for their macros and all dead code hidden behind them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mn10300/boot/compressed/misc.c             |   9 -
 arch/mn10300/include/asm/gdb-stub.h             |  21 --
 arch/mn10300/kernel/Makefile                    |   2 -
 arch/mn10300/kernel/gdb-io-serial-low.S         |  91 -------
 arch/mn10300/kernel/gdb-io-serial.c             | 174 --------------
 arch/mn10300/kernel/gdb-io-ttysm-low.S          |  93 --------
 arch/mn10300/kernel/gdb-io-ttysm.c              | 303 ------------------------
 arch/mn10300/kernel/mn10300-serial.c            |   9 -
 arch/mn10300/kernel/mn10300-serial.h            |  14 --
 arch/mn10300/unit-asb2303/include/unit/serial.h |  85 -------
 arch/mn10300/unit-asb2305/include/unit/serial.h |  78 ------
 arch/mn10300/unit-asb2305/unit-init.c           |   2 -
 arch/mn10300/unit-asb2364/include/unit/serial.h |  66 ------
 13 files changed, 947 deletions(-)
 delete mode 100644 arch/mn10300/kernel/gdb-io-serial-low.S
 delete mode 100644 arch/mn10300/kernel/gdb-io-serial.c
 delete mode 100644 arch/mn10300/kernel/gdb-io-ttysm-low.S
 delete mode 100644 arch/mn10300/kernel/gdb-io-ttysm.c

diff --git a/arch/mn10300/boot/compressed/misc.c b/arch/mn10300/boot/compressed/misc.c
index 42cbd77bd439..14a1f0b2dbf8 100644
--- a/arch/mn10300/boot/compressed/misc.c
+++ b/arch/mn10300/boot/compressed/misc.c
@@ -14,7 +14,6 @@
 #include <asm/serial-regs.h>
 #include "misc.h"
 
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
 /* display 'Uncompressing Linux... ' messages on ttyS0 or ttyS1 */
 #if 1	/* ttyS0 */
 #define CYG_DEV_BASE	0xA6FB0000
@@ -43,7 +42,6 @@
 	do { CYG_DEV_MCR &= ~SIO_MCR_##LINE; } while (0)
 #define FLOWCTL_SET(LINE) \
 	do { CYG_DEV_MCR |= SIO_MCR_##LINE; } while (0)
-#endif
 
 /*
  * gzip declarations
@@ -211,7 +209,6 @@ static inline void kputchar(unsigned char ch)
 static void kputs(const char *s)
 {
 #ifdef CONFIG_DEBUG_DECOMPRESS_KERNEL
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
 	char ch;
 
 	FLOWCTL_SET(DTR);
@@ -228,12 +225,6 @@ static void kputs(const char *s)
 	}
 
 	FLOWCTL_CLEAR(DTR);
-#else
-
-	for (; *s; s++)
-		kputchar(*s);
-
-#endif
 #endif /* CONFIG_DEBUG_DECOMPRESS_KERNEL */
 }
 
diff --git a/arch/mn10300/include/asm/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
index f5495ad82b77..8aa71a966d00 100644
--- a/arch/mn10300/include/asm/gdb-stub.h
+++ b/arch/mn10300/include/asm/gdb-stub.h
@@ -144,39 +144,18 @@ extern u8	gdbstub_rx_overflow;
 extern u8	gdbstub_busy;
 extern u8	gdbstub_rx_unget;
 
-#ifdef CONFIG_GDBSTUB_DEBUGGING
-extern void gdbstub_printk(const char *fmt, ...)
-	__attribute__((format(printf, 1, 2)));
-#else
 static inline __attribute__((format(printf, 1, 2)))
 void gdbstub_printk(const char *fmt, ...)
 {
 }
-#endif
 
-#ifdef CONFIG_GDBSTUB_DEBUG_ENTRY
-#define gdbstub_entry(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
-#else
 #define gdbstub_entry(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-#endif
 
-#ifdef CONFIG_GDBSTUB_DEBUG_PROTOCOL
-#define gdbstub_proto(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
-#else
 #define gdbstub_proto(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-#endif
 
-#ifdef CONFIG_GDBSTUB_DEBUG_IO
-#define gdbstub_io(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
-#else
 #define gdbstub_io(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-#endif
 
-#ifdef CONFIG_GDBSTUB_DEBUG_BREAKPOINT
-#define gdbstub_bkpt(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
-#else
 #define gdbstub_bkpt(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-#endif
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_GDB_STUB_H */
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index ce9f01778a86..1ddc8e22c628 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -17,8 +17,6 @@ obj-$(CONFIG_MN10300_WD_TIMER) += mn10300-watchdog.o mn10300-watchdog-low.o
 
 obj-$(CONFIG_MN10300_TTYSM) += mn10300-serial.o mn10300-serial-low.o \
 			       mn10300-debug.o
-obj-$(CONFIG_GDBSTUB_ON_TTYSx) += gdb-io-serial.o gdb-io-serial-low.o
-obj-$(CONFIG_GDBSTUB_ON_TTYSMx) += gdb-io-ttysm.o gdb-io-ttysm-low.o
 
 obj-$(CONFIG_MN10300_RTC) += rtc.o
 obj-$(CONFIG_PROFILE) += profile.o profile-low.o
diff --git a/arch/mn10300/kernel/gdb-io-serial-low.S b/arch/mn10300/kernel/gdb-io-serial-low.S
deleted file mode 100644
index b1d0152e96cb..000000000000
--- a/arch/mn10300/kernel/gdb-io-serial-low.S
+++ /dev/null
@@ -1,91 +0,0 @@
-###############################################################################
-#
-# 16550 serial Rx interrupt handler for gdbstub I/O
-#
-# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
-# Written by David Howells (dhowells@redhat.com)
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public Licence
-# as published by the Free Software Foundation; either version
-# 2 of the Licence, or (at your option) any later version.
-#
-###############################################################################
-#include <linux/sys.h>
-#include <linux/linkage.h>
-#include <asm/smp.h>
-#include <asm/cpu-regs.h>
-#include <asm/thread_info.h>
-#include <asm/frame.inc>
-#include <asm/intctl-regs.h>
-#include <asm/irqflags.h>
-#include <unit/serial.h>
-
-	.text
-
-###############################################################################
-#
-# GDB stub serial receive interrupt entry point
-# - intended to run at interrupt priority 0
-#
-###############################################################################
-	.globl	gdbstub_io_rx_handler
-	.type	gdbstub_io_rx_handler,@function
-gdbstub_io_rx_handler:
-	movm	[d2,d3,a2,a3],(sp)
-
-#if 1
-	movbu	(GDBPORT_SERIAL_IIR),d2
-#endif
-
-	mov	(gdbstub_rx_inp),a3
-gdbstub_io_rx_more:
-	mov	a3,a2
-	add	2,a3
-	and	0x00000fff,a3
-	mov	(gdbstub_rx_outp),d3
-	cmp	a3,d3
-	beq	gdbstub_io_rx_overflow
-
-	movbu	(GDBPORT_SERIAL_LSR),d3
-	btst	UART_LSR_DR,d3
-	beq	gdbstub_io_rx_done
-	movbu	(GDBPORT_SERIAL_RX),d2
-	movbu	d3,(gdbstub_rx_buffer+1,a2)
-	movbu	d2,(gdbstub_rx_buffer,a2)
-	mov	a3,(gdbstub_rx_inp)
-	bra	gdbstub_io_rx_more
-
-gdbstub_io_rx_done:
-	mov	GxICR_DETECT,d2
-	movbu	d2,(XIRQxICR(GDBPORT_SERIAL_IRQ))	# ACK the interrupt
-	movhu	(XIRQxICR(GDBPORT_SERIAL_IRQ)),d2	# flush
-	movm	(sp),[d2,d3,a2,a3]
-	bset	0x01,(gdbstub_busy)
-	beq	gdbstub_io_rx_enter
-	rti
-
-gdbstub_io_rx_overflow:
-	bset	0x01,(gdbstub_rx_overflow)
-	bra	gdbstub_io_rx_done
-
-gdbstub_io_rx_enter:
-	LOCAL_CHANGE_INTR_MASK_LEVEL(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL+1))
-	add	-4,sp
-	SAVE_ALL
-
-	mov	0xffffffff,d0
-	mov	d0,(REG_ORIG_D0,fp)
-	mov	0x280,d1
-
-	mov	fp,d0
-	call	gdbstub_rx_irq[],0	# gdbstub_rx_irq(regs,excep)
-
-	LOCAL_CLI
-	bclr	0x01,(gdbstub_busy)
-
-	.globl gdbstub_return
-gdbstub_return:
-	RESTORE_ALL
-
-	.size	gdbstub_io_rx_handler,.-gdbstub_io_rx_handler
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
deleted file mode 100644
index df51242744cc..000000000000
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/* 16550 serial driver for gdbstub I/O
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/nmi.h>
-
-#include <asm/pgtable.h>
-#include <asm/gdb-stub.h>
-#include <asm/exceptions.h>
-#include <asm/serial-regs.h>
-#include <unit/serial.h>
-#include <asm/smp.h>
-
-/*
- * initialise the GDB stub
- */
-void gdbstub_io_init(void)
-{
-	u16 tmp;
-
-	/* set up the serial port */
-	GDBPORT_SERIAL_LCR = UART_LCR_WLEN8; /* 1N8 */
-	GDBPORT_SERIAL_FCR = (UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR |
-			      UART_FCR_CLEAR_XMIT);
-
-	FLOWCTL_CLEAR(DTR);
-	FLOWCTL_SET(RTS);
-
-	gdbstub_io_set_baud(115200);
-
-	/* we want to get serial receive interrupts */
-	XIRQxICR(GDBPORT_SERIAL_IRQ) = 0;
-	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
-
-#if   CONFIG_GDBSTUB_IRQ_LEVEL == 0
-	IVAR0 = EXCEP_IRQ_LEVEL0;
-#elif CONFIG_GDBSTUB_IRQ_LEVEL == 1
-	IVAR1 = EXCEP_IRQ_LEVEL1;
-#elif CONFIG_GDBSTUB_IRQ_LEVEL == 2
-	IVAR2 = EXCEP_IRQ_LEVEL2;
-#elif CONFIG_GDBSTUB_IRQ_LEVEL == 3
-	IVAR3 = EXCEP_IRQ_LEVEL3;
-#elif CONFIG_GDBSTUB_IRQ_LEVEL == 4
-	IVAR4 = EXCEP_IRQ_LEVEL4;
-#elif CONFIG_GDBSTUB_IRQ_LEVEL == 5
-	IVAR5 = EXCEP_IRQ_LEVEL5;
-#else
-#error "Unknown irq level for gdbstub."
-#endif
-
-	set_intr_stub(NUM2EXCEP_IRQ_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL),
-		gdbstub_io_rx_handler);
-
-	XIRQxICR(GDBPORT_SERIAL_IRQ) &= ~GxICR_REQUEST;
-	XIRQxICR(GDBPORT_SERIAL_IRQ) =
-		GxICR_ENABLE | NUM2GxICR_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL);
-	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
-
-	GDBPORT_SERIAL_IER = UART_IER_RDI | UART_IER_RLSI;
-
-	/* permit level 0 IRQs to take place */
-	arch_local_change_intr_mask_level(
-		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
-}
-
-/*
- * set up the GDB stub serial port baud rate timers
- */
-void gdbstub_io_set_baud(unsigned baud)
-{
-	unsigned value;
-	u8 lcr;
-
-	value = 18432000 / 16 / baud;
-
-	lcr = GDBPORT_SERIAL_LCR;
-	GDBPORT_SERIAL_LCR |= UART_LCR_DLAB;
-	GDBPORT_SERIAL_DLL = value & 0xff;
-	GDBPORT_SERIAL_DLM = (value >> 8) & 0xff;
-	GDBPORT_SERIAL_LCR = lcr;
-}
-
-/*
- * wait for a character to come from the debugger
- */
-int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
-{
-	unsigned ix;
-	u8 ch, st;
-#if defined(CONFIG_MN10300_WD_TIMER)
-	int cpu;
-#endif
-
-	*_ch = 0xff;
-
-	if (gdbstub_rx_unget) {
-		*_ch = gdbstub_rx_unget;
-		gdbstub_rx_unget = 0;
-		return 0;
-	}
-
- try_again:
-	/* pull chars out of the buffer */
-	ix = gdbstub_rx_outp;
-	barrier();
-	if (ix == gdbstub_rx_inp) {
-		if (nonblock)
-			return -EAGAIN;
-#ifdef CONFIG_MN10300_WD_TIMER
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
-		watchdog_alert_counter[cpu] = 0;
-#endif
-		goto try_again;
-	}
-
-	ch = gdbstub_rx_buffer[ix++];
-	st = gdbstub_rx_buffer[ix++];
-	barrier();
-	gdbstub_rx_outp = ix & 0x00000fff;
-
-	if (st & UART_LSR_BI) {
-		gdbstub_proto("### GDB Rx Break Detected ###\n");
-		return -EINTR;
-	} else if (st & (UART_LSR_FE | UART_LSR_OE | UART_LSR_PE)) {
-		gdbstub_proto("### GDB Rx Error (st=%02x) ###\n", st);
-		return -EIO;
-	} else {
-		gdbstub_proto("### GDB Rx %02x (st=%02x) ###\n", ch, st);
-		*_ch = ch & 0x7f;
-		return 0;
-	}
-}
-
-/*
- * send a character to the debugger
- */
-void gdbstub_io_tx_char(unsigned char ch)
-{
-	FLOWCTL_SET(DTR);
-	LSR_WAIT_FOR(THRE);
-	/* FLOWCTL_WAIT_FOR(CTS); */
-
-	if (ch == 0x0a) {
-		GDBPORT_SERIAL_TX = 0x0d;
-		LSR_WAIT_FOR(THRE);
-		/* FLOWCTL_WAIT_FOR(CTS); */
-	}
-	GDBPORT_SERIAL_TX = ch;
-
-	FLOWCTL_CLEAR(DTR);
-}
-
-/*
- * send a character to the debugger
- */
-void gdbstub_io_tx_flush(void)
-{
-	LSR_WAIT_FOR(TEMT);
-	LSR_WAIT_FOR(THRE);
-	FLOWCTL_CLEAR(DTR);
-}
diff --git a/arch/mn10300/kernel/gdb-io-ttysm-low.S b/arch/mn10300/kernel/gdb-io-ttysm-low.S
deleted file mode 100644
index 060b7cca735d..000000000000
--- a/arch/mn10300/kernel/gdb-io-ttysm-low.S
+++ /dev/null
@@ -1,93 +0,0 @@
-###############################################################################
-#
-# MN10300 On-chip serial Rx interrupt handler for GDB stub I/O
-#
-# Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
-# Written by David Howells (dhowells@redhat.com)
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public Licence
-# as published by the Free Software Foundation; either version
-# 2 of the Licence, or (at your option) any later version.
-#
-###############################################################################
-#include <linux/sys.h>
-#include <linux/linkage.h>
-#include <asm/smp.h>
-#include <asm/thread_info.h>
-#include <asm/cpu-regs.h>
-#include <asm/frame.inc>
-#include <asm/intctl-regs.h>
-#include <unit/serial.h>
-#include "mn10300-serial.h"
-
-	.text
-
-###############################################################################
-#
-# GDB stub serial receive interrupt entry point
-# - intended to run at interrupt priority 0
-#
-###############################################################################
-	.globl	gdbstub_io_rx_handler
-	.type	gdbstub_io_rx_handler,@function
-gdbstub_io_rx_handler:
-	movm	[d2,d3,a2,a3],(sp)
-
-	mov	(gdbstub_rx_inp),a3
-gdbstub_io_rx_more:
-	mov	a3,a2
-	add	2,a3
-	and	PAGE_SIZE_asm-1,a3
-	mov	(gdbstub_rx_outp),d3
-	cmp	a3,d3
-	beq	gdbstub_io_rx_overflow
-
-	movbu	(SCgSTR),d3
-	btst	SC01STR_RBF,d3
-	beq	gdbstub_io_rx_done
-	movbu	(SCgRXB),d2
-	movbu	d3,(gdbstub_rx_buffer+1,a2)
-	movbu	d2,(gdbstub_rx_buffer,a2)
-	mov	a3,(gdbstub_rx_inp)
-	bra	gdbstub_io_rx_more
-
-gdbstub_io_rx_done:
-	mov	GxICR_DETECT,d2
-	movbu	d2,(GxICR(SCgRXIRQ))	# ACK the interrupt
-	movhu	(GxICR(SCgRXIRQ)),d2	# flush
-
-	movm	(sp),[d2,d3,a2,a3]
-	bset	0x01,(gdbstub_busy)
-	beq	gdbstub_io_rx_enter
-	rti
-
-gdbstub_io_rx_overflow:
-	bset	0x01,(gdbstub_rx_overflow)
-	bra	gdbstub_io_rx_done
-
-###############################################################################
-#
-# debugging interrupt - enter the GDB stub proper
-#
-###############################################################################
-gdbstub_io_rx_enter:
-	or	EPSW_IE|EPSW_IM_1,epsw
-	add	-4,sp
-	SAVE_ALL
-
-	mov	0xffffffff,d0
-	mov	d0,(REG_ORIG_D0,fp)
-	mov	0x280,d1
-
-	mov	fp,d0
-	call	gdbstub_rx_irq[],0	# gdbstub_io_rx_irq(regs,excep)
-
-	and	~EPSW_IE,epsw
-	bclr	0x01,(gdbstub_busy)
-
-	.globl gdbstub_return
-gdbstub_return:
-	RESTORE_ALL
-
-	.size	gdbstub_io_rx_handler,.-gdbstub_io_rx_handler
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
deleted file mode 100644
index caae8cac9db1..000000000000
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ /dev/null
@@ -1,303 +0,0 @@
-/* MN10300 On-chip serial driver for gdbstub I/O
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <asm/pgtable.h>
-#include <asm/gdb-stub.h>
-#include <asm/exceptions.h>
-#include <unit/clock.h>
-#include "mn10300-serial.h"
-
-#if defined(CONFIG_GDBSTUB_ON_TTYSM0)
-struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif0;
-#elif defined(CONFIG_GDBSTUB_ON_TTYSM1)
-struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif1;
-#else
-struct mn10300_serial_port *const gdbstub_port = &mn10300_serial_port_sif2;
-#endif
-
-
-/*
- * initialise the GDB stub I/O routines
- */
-void __init gdbstub_io_init(void)
-{
-	uint16_t scxctr;
-	int tmp;
-
-	switch (gdbstub_port->clock_src) {
-	case MNSCx_CLOCK_SRC_IOCLK:
-		gdbstub_port->ioclk = MN10300_IOCLK;
-		break;
-
-#ifdef MN10300_IOBCLK
-	case MNSCx_CLOCK_SRC_IOBCLK:
-		gdbstub_port->ioclk = MN10300_IOBCLK;
-		break;
-#endif
-	default:
-		BUG();
-	}
-
-	/* set up the serial port */
-	gdbstub_io_set_baud(115200);
-
-	/* we want to get serial receive interrupts */
-	set_intr_level(gdbstub_port->rx_irq,
-		NUM2GxICR_LEVEL(CONFIG_DEBUGGER_IRQ_LEVEL));
-	set_intr_level(gdbstub_port->tx_irq,
-		NUM2GxICR_LEVEL(CONFIG_DEBUGGER_IRQ_LEVEL));
-	set_intr_stub(NUM2EXCEP_IRQ_LEVEL(CONFIG_DEBUGGER_IRQ_LEVEL),
-		gdbstub_io_rx_handler);
-
-	*gdbstub_port->rx_icr |= GxICR_ENABLE;
-	tmp = *gdbstub_port->rx_icr;
-
-	/* enable the device */
-	scxctr = SC01CTR_CLN_8BIT;	/* 1N8 */
-	switch (gdbstub_port->div_timer) {
-	case MNSCx_DIV_TIMER_16BIT:
-		scxctr |= SC0CTR_CK_TM8UFLOW_8; /* == SC1CTR_CK_TM9UFLOW_8
-						   == SC2CTR_CK_TM10UFLOW_8 */
-		break;
-
-	case MNSCx_DIV_TIMER_8BIT:
-		scxctr |= SC0CTR_CK_TM2UFLOW_8;
-		break;
-	}
-
-	scxctr |= SC01CTR_TXE | SC01CTR_RXE;
-
-	*gdbstub_port->_control = scxctr;
-	tmp = *gdbstub_port->_control;
-
-	/* permit level 0 IRQs only */
-	arch_local_change_intr_mask_level(
-		NUM2EPSW_IM(CONFIG_DEBUGGER_IRQ_LEVEL + 1));
-}
-
-/*
- * set up the GDB stub serial port baud rate timers
- */
-void gdbstub_io_set_baud(unsigned baud)
-{
-	const unsigned bits = 10; /* 1 [start] + 8 [data] + 0 [parity] +
-				   * 1 [stop] */
-	unsigned long ioclk = gdbstub_port->ioclk;
-	unsigned xdiv, tmp;
-	uint16_t tmxbr;
-	uint8_t tmxmd;
-
-	if (!baud) {
-		baud = 9600;
-	} else if (baud == 134) {
-		baud = 269;	/* 134 is really 134.5 */
-		xdiv = 2;
-	}
-
-try_alternative:
-	xdiv = 1;
-
-	switch (gdbstub_port->div_timer) {
-	case MNSCx_DIV_TIMER_16BIT:
-		tmxmd = TM8MD_SRC_IOCLK;
-		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 65535)
-			goto timer_okay;
-
-		tmxmd = TM8MD_SRC_IOCLK_8;
-		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 65535)
-			goto timer_okay;
-
-		tmxmd = TM8MD_SRC_IOCLK_32;
-		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 65535)
-			goto timer_okay;
-
-		break;
-
-	case MNSCx_DIV_TIMER_8BIT:
-		tmxmd = TM2MD_SRC_IOCLK;
-		tmxbr = tmp = (ioclk / (baud * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 255)
-			goto timer_okay;
-
-		tmxmd = TM2MD_SRC_IOCLK_8;
-		tmxbr = tmp = (ioclk / (baud * 8 * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 255)
-			goto timer_okay;
-
-		tmxmd = TM2MD_SRC_IOCLK_32;
-		tmxbr = tmp = (ioclk / (baud * 32 * xdiv) + 4) / 8 - 1;
-		if (tmp > 0 && tmp <= 255)
-			goto timer_okay;
-		break;
-	}
-
-	/* as a last resort, if the quotient is zero, default to 9600 bps */
-	baud = 9600;
-	goto try_alternative;
-
-timer_okay:
-	gdbstub_port->uart.timeout = (2 * bits * HZ) / baud;
-	gdbstub_port->uart.timeout += HZ / 50;
-
-	/* set the timer to produce the required baud rate */
-	switch (gdbstub_port->div_timer) {
-	case MNSCx_DIV_TIMER_16BIT:
-		*gdbstub_port->_tmxmd = 0;
-		*gdbstub_port->_tmxbr = tmxbr;
-		*gdbstub_port->_tmxmd = TM8MD_INIT_COUNTER;
-		*gdbstub_port->_tmxmd = tmxmd | TM8MD_COUNT_ENABLE;
-		break;
-
-	case MNSCx_DIV_TIMER_8BIT:
-		*gdbstub_port->_tmxmd = 0;
-		*(volatile u8 *) gdbstub_port->_tmxbr = (u8)tmxbr;
-		*gdbstub_port->_tmxmd = TM2MD_INIT_COUNTER;
-		*gdbstub_port->_tmxmd = tmxmd | TM2MD_COUNT_ENABLE;
-		break;
-	}
-}
-
-/*
- * wait for a character to come from the debugger
- */
-int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
-{
-	unsigned ix;
-	u8 ch, st;
-#if defined(CONFIG_MN10300_WD_TIMER)
-	int cpu;
-#endif
-
-	*_ch = 0xff;
-
-	if (gdbstub_rx_unget) {
-		*_ch = gdbstub_rx_unget;
-		gdbstub_rx_unget = 0;
-		return 0;
-	}
-
-try_again:
-	/* pull chars out of the buffer */
-	ix = gdbstub_rx_outp;
-	barrier();
-	if (ix == gdbstub_rx_inp) {
-		if (nonblock)
-			return -EAGAIN;
-#ifdef CONFIG_MN10300_WD_TIMER
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
-		watchdog_alert_counter[cpu] = 0;
-#endif
-		goto try_again;
-	}
-
-	ch = gdbstub_rx_buffer[ix++];
-	st = gdbstub_rx_buffer[ix++];
-	barrier();
-	gdbstub_rx_outp = ix & (PAGE_SIZE - 1);
-
-	st &= SC01STR_RXF | SC01STR_RBF | SC01STR_FEF | SC01STR_PEF |
-		SC01STR_OEF;
-
-	/* deal with what we've got
-	 * - note that the UART doesn't do BREAK-detection for us
-	 */
-	if (st & SC01STR_FEF && ch == 0) {
-		switch (gdbstub_port->rx_brk) {
-		case 0:	gdbstub_port->rx_brk = 1;	goto try_again;
-		case 1:	gdbstub_port->rx_brk = 2;	goto try_again;
-		case 2:
-			gdbstub_port->rx_brk = 3;
-			gdbstub_proto("### GDB MNSERIAL Rx Break Detected"
-				      " ###\n");
-			return -EINTR;
-		default:
-			goto try_again;
-		}
-	} else if (st & SC01STR_FEF) {
-		if (gdbstub_port->rx_brk)
-			goto try_again;
-
-		gdbstub_proto("### GDB MNSERIAL Framing Error ###\n");
-		return -EIO;
-	} else if (st & SC01STR_OEF) {
-		if (gdbstub_port->rx_brk)
-			goto try_again;
-
-		gdbstub_proto("### GDB MNSERIAL Overrun Error ###\n");
-		return -EIO;
-	} else if (st & SC01STR_PEF) {
-		if (gdbstub_port->rx_brk)
-			goto try_again;
-
-		gdbstub_proto("### GDB MNSERIAL Parity Error ###\n");
-		return -EIO;
-	} else {
-		/* look for the tail-end char on a break run */
-		if (gdbstub_port->rx_brk == 3) {
-			switch (ch) {
-			case 0xFF:
-			case 0xFE:
-			case 0xFC:
-			case 0xF8:
-			case 0xF0:
-			case 0xE0:
-			case 0xC0:
-			case 0x80:
-			case 0x00:
-				gdbstub_port->rx_brk = 0;
-				goto try_again;
-			default:
-				break;
-			}
-		}
-
-		gdbstub_port->rx_brk = 0;
-		gdbstub_io("### GDB Rx %02x (st=%02x) ###\n", ch, st);
-		*_ch = ch & 0x7f;
-		return 0;
-	}
-}
-
-/*
- * send a character to the debugger
- */
-void gdbstub_io_tx_char(unsigned char ch)
-{
-	while (*gdbstub_port->_status & SC01STR_TBF)
-		continue;
-
-	if (ch == 0x0a) {
-		*(u8 *) gdbstub_port->_txb = 0x0d;
-		while (*gdbstub_port->_status & SC01STR_TBF)
-			continue;
-	}
-
-	*(u8 *) gdbstub_port->_txb = ch;
-}
-
-/*
- * flush the transmission buffers
- */
-void gdbstub_io_tx_flush(void)
-{
-	while (*gdbstub_port->_status & (SC01STR_TBF | SC01STR_TXF))
-		continue;
-}
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 7ecf69879e2d..bbfccd44b06e 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -205,9 +205,6 @@ struct mn10300_serial_port mn10300_serial_port_sif0 = {
 	.tx_icr		= &GxICR(SC0TXIRQ),
 	.clock_src	= MNSCx_CLOCK_SRC_IOCLK,
 	.options	= 0,
-#ifdef CONFIG_GDBSTUB_ON_TTYSM0
-	.gdbstub	= 1,
-#endif
 };
 #endif /* CONFIG_MN10300_TTYSM0 */
 
@@ -267,9 +264,6 @@ struct mn10300_serial_port mn10300_serial_port_sif1 = {
 	.tx_icr		= &GxICR(SC1TXIRQ),
 	.clock_src	= MNSCx_CLOCK_SRC_IOCLK,
 	.options	= 0,
-#ifdef CONFIG_GDBSTUB_ON_TTYSM1
-	.gdbstub	= 1,
-#endif
 };
 #endif /* CONFIG_MN10300_TTYSM1 */
 
@@ -344,9 +338,6 @@ struct mn10300_serial_port mn10300_serial_port_sif2 = {
 #else
 	.options	= 0,
 #endif
-#ifdef CONFIG_GDBSTUB_ON_TTYSM2
-	.gdbstub	= 1,
-#endif
 };
 #endif /* CONFIG_MN10300_TTYSM2 */
 
diff --git a/arch/mn10300/kernel/mn10300-serial.h b/arch/mn10300/kernel/mn10300-serial.h
index 01791c68ea1f..990a31c45e9f 100644
--- a/arch/mn10300/kernel/mn10300-serial.h
+++ b/arch/mn10300/kernel/mn10300-serial.h
@@ -113,18 +113,4 @@ extern asmlinkage void mn10300_serial_vdma_tx_handler(void);
 
 #endif /* __ASSEMBLY__ */
 
-#if defined(CONFIG_GDBSTUB_ON_TTYSM0)
-#define SCgSTR SC0STR
-#define SCgRXB SC0RXB
-#define SCgRXIRQ SC0RXIRQ
-#elif defined(CONFIG_GDBSTUB_ON_TTYSM1)
-#define SCgSTR SC1STR
-#define SCgRXB SC1RXB
-#define SCgRXIRQ SC1RXIRQ
-#elif defined(CONFIG_GDBSTUB_ON_TTYSM2)
-#define SCgSTR SC2STR
-#define SCgRXB SC2RXB
-#define SCgRXIRQ SC2RXIRQ
-#endif
-
 #endif /* _MN10300_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/serial.h b/arch/mn10300/unit-asb2303/include/unit/serial.h
index 991e356bac5f..5ad65e2dc74b 100644
--- a/arch/mn10300/unit-asb2303/include/unit/serial.h
+++ b/arch/mn10300/unit-asb2303/include/unit/serial.h
@@ -29,8 +29,6 @@
 /*
  * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
  */
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
-
 #define SERIAL_PORT_DFNS						\
 	{								\
 	.baud_base		= BASE_BAUD,				\
@@ -50,92 +48,9 @@
 	},
 
 #ifndef __ASSEMBLY__
-
 static inline void __debug_to_serial(const char *p, int n)
 {
 }
-
 #endif /* !__ASSEMBLY__ */
 
-#else /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#define SERIAL_PORT_DFNS /* both stolen by gdb-stub because they share an IRQ */
-
-#if defined(CONFIG_GDBSTUB_ON_TTYS0)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-
-#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-#endif
-
-#ifndef __ASSEMBLY__
-
-#define LSR_WAIT_FOR(STATE)					\
-do {								\
-	while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE)) {}	\
-} while (0)
-#define FLOWCTL_WAIT_FOR(LINE)					\
-do {								\
-	while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE)) {}	\
-} while (0)
-#define FLOWCTL_CLEAR(LINE)			\
-do {						\
-	GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE;	\
-} while (0)
-#define FLOWCTL_SET(LINE)			\
-do {						\
-	GDBPORT_SERIAL_MCR |= UART_MCR_##LINE;	\
-} while (0)
-#define FLOWCTL_QUERY(LINE)	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-	char ch;
-
-	FLOWCTL_SET(DTR);
-
-	for (; n > 0; n--) {
-		LSR_WAIT_FOR(THRE);
-		FLOWCTL_WAIT_FOR(CTS);
-
-		ch = *p++;
-		if (ch == 0x0a) {
-			GDBPORT_SERIAL_TX = 0x0d;
-			LSR_WAIT_FOR(THRE);
-			FLOWCTL_WAIT_FOR(CTS);
-		}
-		GDBPORT_SERIAL_TX = ch;
-	}
-
-	FLOWCTL_CLEAR(DTR);
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
-
 #endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2305/include/unit/serial.h b/arch/mn10300/unit-asb2305/include/unit/serial.h
index 88c08219315f..20636f771b3d 100644
--- a/arch/mn10300/unit-asb2305/include/unit/serial.h
+++ b/arch/mn10300/unit-asb2305/include/unit/serial.h
@@ -28,8 +28,6 @@
 /*
  * dispose of the /dev/ttyS0 serial port
  */
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
-
 #define SERIAL_PORT_DFNS						\
 	{								\
 	.baud_base		= BASE_BAUD,				\
@@ -41,85 +39,9 @@
 	},
 
 #ifndef __ASSEMBLY__
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#else /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
-
-#if defined(CONFIG_GDBSTUB_ON_TTYS0)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-
-#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
-#error The ASB2305 doesnt have a /dev/ttyS1
-#endif
-
-#ifndef __ASSEMBLY__
-
-#define TTYS0_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define TTYS0_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define TTYS0_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define TTYS0_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-
-#define LSR_WAIT_FOR(STATE)				\
-do {							\
-	while (!(TTYS0_LSR & UART_LSR_##STATE)) {}	\
-} while (0)
-#define FLOWCTL_WAIT_FOR(LINE)				\
-do {							\
-	while (!(TTYS0_MSR & UART_MSR_##LINE)) {}	\
-} while (0)
-#define FLOWCTL_CLEAR(LINE)			\
-do {						\
-	TTYS0_MCR &= ~UART_MCR_##LINE;		\
-} while (0)
-#define FLOWCTL_SET(LINE)			\
-do {						\
-	TTYS0_MCR |= UART_MCR_##LINE;		\
-} while (0)
-#define FLOWCTL_QUERY(LINE)	({ TTYS0_MSR & UART_MSR_##LINE; })
-
 static inline void __debug_to_serial(const char *p, int n)
 {
-	char ch;
-
-	FLOWCTL_SET(DTR);
-
-	for (; n > 0; n--) {
-		LSR_WAIT_FOR(THRE);
-		FLOWCTL_WAIT_FOR(CTS);
-
-		ch = *p++;
-		if (ch == 0x0a) {
-			TTYS0_TX = 0x0d;
-			LSR_WAIT_FOR(THRE);
-			FLOWCTL_WAIT_FOR(CTS);
-		}
-		TTYS0_TX = ch;
-	}
-
-	FLOWCTL_CLEAR(DTR);
 }
-
 #endif /* !__ASSEMBLY__ */
 
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
-
 #endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index bc4adfaf815c..674f3e960cb2 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -25,12 +25,10 @@
  */
 asmlinkage void __init unit_init(void)
 {
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
 	/* set the 16550 interrupt line to level 3 if not being used for GDB */
 #ifdef CONFIG_EXT_SERIAL_IRQ_LEVEL
 	set_intr_level(XIRQ0, NUM2GxICR_LEVEL(CONFIG_EXT_SERIAL_IRQ_LEVEL));
 #endif
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
 }
 
 /*
diff --git a/arch/mn10300/unit-asb2364/include/unit/serial.h b/arch/mn10300/unit-asb2364/include/unit/serial.h
index 92f224a97efc..79934d645d04 100644
--- a/arch/mn10300/unit-asb2364/include/unit/serial.h
+++ b/arch/mn10300/unit-asb2364/include/unit/serial.h
@@ -34,8 +34,6 @@
 /*
  * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
  */
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
-
 #define SERIAL_PORT_DFNS						\
 	{								\
 		.baud_base	= BASE_BAUD,				\
@@ -47,75 +45,11 @@
 	},
 
 #ifndef __ASSEMBLY__
-
 static inline void __debug_to_serial(const char *p, int n)
 {
 }
-
 #endif /* !__ASSEMBLY__ */
 
-#else /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
-
-#if defined(CONFIG_GDBSTUB_ON_TTYS0)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 2, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 2, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 2, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 2, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 2, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 2, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 2, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 2, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 2, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 2, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 2, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 2, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-
-#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
-#error The ASB2364 does not have a /dev/ttyS1
-#endif
-
-#ifndef __ASSEMBLY__
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-	char ch;
-
-#define LSR_WAIT_FOR(STATE)	\
-	do {} while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE))
-#define FLOWCTL_QUERY(LINE)	\
-	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
-#define FLOWCTL_WAIT_FOR(LINE)	\
-	do {} while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE))
-#define FLOWCTL_CLEAR(LINE)	\
-	do { GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE; } while (0)
-#define FLOWCTL_SET(LINE)	\
-	do { GDBPORT_SERIAL_MCR |= UART_MCR_##LINE; } while (0)
-
-	FLOWCTL_SET(DTR);
-
-	for (; n > 0; n--) {
-		LSR_WAIT_FOR(THRE);
-		FLOWCTL_WAIT_FOR(CTS);
-
-		ch = *p++;
-		if (ch == 0x0a) {
-			GDBPORT_SERIAL_TX = 0x0d;
-			LSR_WAIT_FOR(THRE);
-			FLOWCTL_WAIT_FOR(CTS);
-		}
-		GDBPORT_SERIAL_TX = ch;
-	}
-
-	FLOWCTL_CLEAR(DTR);
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
-
 #define SERIAL_INITIALIZE					\
 do {								\
 	/* release reset */					\
-- 
1.9.3

