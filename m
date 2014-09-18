Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbaIRSdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:33:55 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:55091 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458AbaIRSdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:33:53 -0400
Message-ID: <1411065231.2017.79.camel@x220>
Subject: [PATCH 5/5] MN10300: Remove remnants of gdbstub
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 20:33:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 18:33:52.0477 (UTC) FILETIME=[189C70D0:01CFD36F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mn10300/Kconfig                   |   6 +-
 arch/mn10300/include/asm/exceptions.h  |   7 --
 arch/mn10300/include/asm/gdb-stub.h    | 161 ---------------------------------
 arch/mn10300/kernel/mn10300-serial.c   |  19 +---
 arch/mn10300/kernel/mn10300-serial.h   |   1 -
 arch/mn10300/kernel/mn10300-watchdog.c |   1 -
 arch/mn10300/kernel/process.c          |  11 ---
 arch/mn10300/kernel/profile.c          |   2 -
 arch/mn10300/kernel/traps.c            |   4 +-
 arch/mn10300/mm/fault.c                |   1 -
 arch/mn10300/mm/misalignment.c         |   1 -
 arch/mn10300/unit-asb2303/unit-init.c  |   4 +-
 arch/mn10300/unit-asb2305/unit-init.c  |   4 +-
 arch/mn10300/unit-asb2364/unit-init.c  |   4 +-
 14 files changed, 14 insertions(+), 212 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/gdb-stub.h

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 4434b54e1d87..e1ba277d0349 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -304,7 +304,7 @@ config MN10300_TTYSM0
 	bool "Enable SIF0 (/dev/ttySM0)"
 	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM0
 	help
-	  Enable access to SIF0 through /dev/ttySM0 or gdb-stub
+	  Enable access to SIF0 through /dev/ttySM0
 
 choice
 	prompt "Select the timer to supply the clock for SIF0"
@@ -326,7 +326,7 @@ config MN10300_TTYSM1
 	bool "Enable SIF1 (/dev/ttySM1)"
 	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM1
 	help
-	  Enable access to SIF1 through /dev/ttySM1 or gdb-stub
+	  Enable access to SIF1 through /dev/ttySM1
 
 choice
 	prompt "Select the timer to supply the clock for SIF1"
@@ -357,7 +357,7 @@ config MN10300_TTYSM2
 	bool "Enable SIF2 (/dev/ttySM2)"
 	depends on MN10300_TTYSM && MN10300_PROC_HAS_TTYSM2
 	help
-	  Enable access to SIF2 through /dev/ttySM2 or gdb-stub
+	  Enable access to SIF2 through /dev/ttySM2
 
 choice
 	prompt "Select the timer to supply the clock for SIF2"
diff --git a/arch/mn10300/include/asm/exceptions.h b/arch/mn10300/include/asm/exceptions.h
index 95a4d42c3a06..7b7ad89912d8 100644
--- a/arch/mn10300/include/asm/exceptions.h
+++ b/arch/mn10300/include/asm/exceptions.h
@@ -13,13 +13,6 @@
 
 #include <linux/linkage.h>
 
-/*
- * define the breakpoint instruction opcode to use
- * - note that the JTAG unit steals 0xFF, so you can't use JTAG and GDBSTUB at
- *   the same time.
- */
-#define GDBSTUB_BKPT		0xFF
-
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/mn10300/include/asm/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
deleted file mode 100644
index 8aa71a966d00..000000000000
--- a/arch/mn10300/include/asm/gdb-stub.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/* MN10300 Kernel GDB stub definitions
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from asm-mips/gdb-stub.h (c) 1995 Andreas Busse
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_GDB_STUB_H
-#define _ASM_GDB_STUB_H
-
-#include <asm/exceptions.h>
-
-/*
- * register ID numbers in GDB remote protocol
- */
-
-#define GDB_REGID_PC		9
-#define GDB_REGID_FP		7
-#define GDB_REGID_SP		8
-
-/*
- * virtual stack layout for the GDB exception handler
- */
-#define NUMREGS			64
-
-#define GDB_FR_D0		(0 * 4)
-#define GDB_FR_D1		(1 * 4)
-#define GDB_FR_D2		(2 * 4)
-#define GDB_FR_D3		(3 * 4)
-#define GDB_FR_A0		(4 * 4)
-#define GDB_FR_A1		(5 * 4)
-#define GDB_FR_A2		(6 * 4)
-#define GDB_FR_A3		(7 * 4)
-
-#define GDB_FR_SP		(8 * 4)
-#define GDB_FR_PC		(9 * 4)
-#define GDB_FR_MDR		(10 * 4)
-#define GDB_FR_EPSW		(11 * 4)
-#define GDB_FR_LIR		(12 * 4)
-#define GDB_FR_LAR		(13 * 4)
-#define GDB_FR_MDRQ		(14 * 4)
-
-#define GDB_FR_E0		(15 * 4)
-#define GDB_FR_E1		(16 * 4)
-#define GDB_FR_E2		(17 * 4)
-#define GDB_FR_E3		(18 * 4)
-#define GDB_FR_E4		(19 * 4)
-#define GDB_FR_E5		(20 * 4)
-#define GDB_FR_E6		(21 * 4)
-#define GDB_FR_E7		(22 * 4)
-
-#define GDB_FR_SSP		(23 * 4)
-#define GDB_FR_MSP		(24 * 4)
-#define GDB_FR_USP		(25 * 4)
-#define GDB_FR_MCRH		(26 * 4)
-#define GDB_FR_MCRL		(27 * 4)
-#define GDB_FR_MCVF		(28 * 4)
-
-#define GDB_FR_FPCR		(29 * 4)
-#define GDB_FR_DUMMY0		(30 * 4)
-#define GDB_FR_DUMMY1		(31 * 4)
-
-#define GDB_FR_FS0		(32 * 4)
-
-#define GDB_FR_SIZE		(NUMREGS * 4)
-
-#ifndef __ASSEMBLY__
-
-/*
- * This is the same as above, but for the high-level
- * part of the GDB stub.
- */
-
-struct gdb_regs {
-	/* saved main processor registers */
-	u32	d0, d1, d2, d3, a0, a1, a2, a3;
-	u32	sp, pc, mdr, epsw, lir, lar, mdrq;
-	u32	e0, e1, e2, e3, e4, e5, e6, e7;
-	u32	ssp, msp, usp, mcrh, mcrl, mcvf;
-
-	/* saved floating point registers */
-	u32	fpcr, _dummy0, _dummy1;
-	u32	fs0,  fs1,  fs2,  fs3,  fs4,  fs5,  fs6,  fs7;
-	u32	fs8,  fs9,  fs10, fs11, fs12, fs13, fs14, fs15;
-	u32	fs16, fs17, fs18, fs19, fs20, fs21, fs22, fs23;
-	u32	fs24, fs25, fs26, fs27, fs28, fs29, fs30, fs31;
-};
-
-/*
- * Prototypes
- */
-extern void show_registers_only(struct pt_regs *regs);
-
-extern asmlinkage void gdbstub_init(void);
-extern asmlinkage void gdbstub_exit(int status);
-extern asmlinkage void gdbstub_io_init(void);
-extern asmlinkage void gdbstub_io_set_baud(unsigned baud);
-extern asmlinkage int  gdbstub_io_rx_char(unsigned char *_ch, int nonblock);
-extern asmlinkage void gdbstub_io_tx_char(unsigned char ch);
-extern asmlinkage void gdbstub_io_tx_flush(void);
-
-extern asmlinkage void gdbstub_io_rx_handler(void);
-extern asmlinkage void gdbstub_rx_irq(struct pt_regs *, enum exception_code);
-extern asmlinkage int  gdbstub_intercept(struct pt_regs *, enum exception_code);
-extern asmlinkage void gdbstub_exception(struct pt_regs *, enum exception_code);
-extern asmlinkage void __gdbstub_bug_trap(void);
-extern asmlinkage void __gdbstub_pause(void);
-
-#ifdef CONFIG_MN10300_CACHE_ENABLED
-extern asmlinkage void gdbstub_purge_cache(void);
-#else
-#define gdbstub_purge_cache()	do {} while (0)
-#endif
-
-/* Used to prevent crashes in memory access */
-extern asmlinkage int  gdbstub_read_byte(const u8 *, u8 *);
-extern asmlinkage int  gdbstub_read_word(const u8 *, u8 *);
-extern asmlinkage int  gdbstub_read_dword(const u8 *, u8 *);
-extern asmlinkage int  gdbstub_write_byte(u32, u8 *);
-extern asmlinkage int  gdbstub_write_word(u32, u8 *);
-extern asmlinkage int  gdbstub_write_dword(u32, u8 *);
-
-extern asmlinkage void gdbstub_read_byte_guard(void);
-extern asmlinkage void gdbstub_read_byte_cont(void);
-extern asmlinkage void gdbstub_read_word_guard(void);
-extern asmlinkage void gdbstub_read_word_cont(void);
-extern asmlinkage void gdbstub_read_dword_guard(void);
-extern asmlinkage void gdbstub_read_dword_cont(void);
-extern asmlinkage void gdbstub_write_byte_guard(void);
-extern asmlinkage void gdbstub_write_byte_cont(void);
-extern asmlinkage void gdbstub_write_word_guard(void);
-extern asmlinkage void gdbstub_write_word_cont(void);
-extern asmlinkage void gdbstub_write_dword_guard(void);
-extern asmlinkage void gdbstub_write_dword_cont(void);
-
-extern u8	gdbstub_rx_buffer[PAGE_SIZE];
-extern u32	gdbstub_rx_inp;
-extern u32	gdbstub_rx_outp;
-extern u8	gdbstub_rx_overflow;
-extern u8	gdbstub_busy;
-extern u8	gdbstub_rx_unget;
-
-static inline __attribute__((format(printf, 1, 2)))
-void gdbstub_printk(const char *fmt, ...)
-{
-}
-
-#define gdbstub_entry(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-
-#define gdbstub_proto(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-
-#define gdbstub_io(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-
-#define gdbstub_bkpt(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-
-#endif /* !__ASSEMBLY__ */
-#endif /* _ASM_GDB_STUB_H */
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index bbfccd44b06e..c621351432cc 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -850,18 +850,8 @@ static void mn10300_serial_send_xchar(struct uart_port *_port, char ch)
 {
 	struct mn10300_serial_port *port =
 		container_of(_port, struct mn10300_serial_port, uart);
-	unsigned long flags;
 
 	_enter("%s,%02x", port->name, ch);
-
-	if (likely(port->gdbstub)) {
-		port->tx_xchar = ch;
-		if (ch) {
-			spin_lock_irqsave(&port->uart.lock, flags);
-			mn10300_serial_en_tx_intr(port);
-			spin_unlock_irqrestore(&port->uart.lock, flags);
-		}
-	}
 }
 
 /*
@@ -947,10 +937,7 @@ static int mn10300_serial_startup(struct uart_port *_port)
 		container_of(_port, struct mn10300_serial_port, uart);
 	struct mn10300_serial_int *pint;
 
-	_enter("%s{%d}", port->name, port->gdbstub);
-
-	if (unlikely(port->gdbstub))
-		return -EBUSY;
+	_enter("%s", port->name);
 
 	/* allocate an Rx buffer for the virtual DMA handler */
 	port->rx_buffer = kmalloc(MNSC_BUFFER_SIZE, GFP_KERNEL);
@@ -1520,7 +1507,7 @@ static int __init mn10300_serial_init(void)
 	if (!ret) {
 		for (i = 0 ; i < NR_PORTS ; i++) {
 			port = mn10300_serial_ports[i];
-			if (!port || port->gdbstub)
+			if (!port)
 				continue;
 
 			switch (port->clock_src) {
@@ -1660,7 +1647,7 @@ static int __init mn10300_serial_console_setup(struct console *co,
 
 	for (i = 0 ; i < NR_PORTS ; i++) {
 		port = mn10300_serial_ports[i];
-		if (port && !port->gdbstub && port->uart.line == co->index)
+		if (port && port->uart.line == co->index)
 			goto found_device;
 	}
 
diff --git a/arch/mn10300/kernel/mn10300-serial.h b/arch/mn10300/kernel/mn10300-serial.h
index 990a31c45e9f..db451856d342 100644
--- a/arch/mn10300/kernel/mn10300-serial.h
+++ b/arch/mn10300/kernel/mn10300-serial.h
@@ -70,7 +70,6 @@ struct mn10300_serial_port {
 
 	unsigned short		rx_brk;		/* current break reception status */
 	u16			tx_cts;		/* current CTS status */
-	int			gdbstub;	/* preemptively stolen by GDB stub */
 
 	u8			clock_src;	/* clock source */
 #define MNSCx_CLOCK_SRC_IOCLK	0
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index 8d34d05d91c0..3fc825cad858 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -23,7 +23,6 @@
 #include <asm/rtc-regs.h>
 #include <asm/div64.h>
 #include <asm/smp.h>
-#include <asm/gdb-stub.h>
 #include <proc/clock.h>
 
 static DEFINE_SPINLOCK(watchdog_print_lock);
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 3707da583d05..a46b586ece41 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -33,7 +33,6 @@
 #include <asm/mmu_context.h>
 #include <asm/fpu.h>
 #include <asm/reset-regs.h>
-#include <asm/gdb-stub.h>
 #include "internal.h"
 
 /*
@@ -70,10 +69,6 @@ void release_segments(struct mm_struct *mm)
 
 void machine_restart(char *cmd)
 {
-#ifdef CONFIG_KERNEL_DEBUGGER
-	gdbstub_exit(0);
-#endif
-
 #ifdef mn10300_unit_hard_reset
 	mn10300_unit_hard_reset();
 #else
@@ -83,16 +78,10 @@ void machine_restart(char *cmd)
 
 void machine_halt(void)
 {
-#ifdef CONFIG_KERNEL_DEBUGGER
-	gdbstub_exit(0);
-#endif
 }
 
 void machine_power_off(void)
 {
-#ifdef CONFIG_KERNEL_DEBUGGER
-	gdbstub_exit(0);
-#endif
 }
 
 void show_regs(struct pt_regs *regs)
diff --git a/arch/mn10300/kernel/profile.c b/arch/mn10300/kernel/profile.c
index 4f342f75d00c..c9793ff37f26 100644
--- a/arch/mn10300/kernel/profile.c
+++ b/arch/mn10300/kernel/profile.c
@@ -11,8 +11,6 @@
 
 /*
  * initialise the profiling if enabled
- * - using with gdbstub will give anomalous results
- * - can't be used with gdbstub if running at IRQ priority 0
  */
 static __init int profile_init(void)
 {
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index a7a987c7954f..519a9d946619 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -219,7 +219,7 @@ asmlinkage void handle_exception(struct pt_regs *regs, u32 intcode)
  */
 asmlinkage void nmi(struct pt_regs *regs, enum exception_code code)
 {
-	/* see if gdbstub wants to deal with it */
+	/* see if kgdb wants to deal with it */
 	if (debugger_intercept(code, SIGQUIT, 0, regs))
 		return;
 
@@ -501,7 +501,7 @@ asmlinkage void uninitialised_exception(struct pt_regs *regs,
 					enum exception_code code)
 {
 
-	/* see if gdbstub wants to deal with it */
+	/* see if kgdb wants to deal with it */
 	if (debugger_intercept(code, SIGSYS, 0, regs) == 0)
 		return;
 
diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 549a13de8cee..8678c5d3a8b8 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -29,7 +29,6 @@
 #include <asm/hardirq.h>
 #include <asm/cpu-regs.h>
 #include <asm/debugger.h>
-#include <asm/gdb-stub.h>
 
 /*
  * Unlock any spinlocks which will prevent us from getting the
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index b9920b1edd5a..1424246dde3a 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -31,7 +31,6 @@
 #include <asm/cpu-regs.h>
 #include <asm/busctl-regs.h>
 #include <asm/fpu.h>
-#include <asm/gdb-stub.h>
 #include <asm/asm-offsets.h>
 
 #if 0
diff --git a/arch/mn10300/unit-asb2303/unit-init.c b/arch/mn10300/unit-asb2303/unit-init.c
index 834a76aa551a..c8b8c0338410 100644
--- a/arch/mn10300/unit-asb2303/unit-init.c
+++ b/arch/mn10300/unit-asb2303/unit-init.c
@@ -21,7 +21,7 @@
 #include <asm/intctl-regs.h>
 
 /*
- * initialise some of the unit hardware before gdbstub is set up
+ * initialise some of the unit hardware
  */
 asmlinkage void __init unit_init(void)
 {
@@ -42,7 +42,7 @@ asmlinkage void __init unit_init(void)
 }
 
 /*
- * initialise the rest of the unit hardware after gdbstub is ready
+ * initialise the rest of the unit hardware
  */
 void __init unit_setup(void)
 {
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index 674f3e960cb2..bf0c327e5bf2 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -21,7 +21,7 @@
 #include <unit/serial.h>
 
 /*
- * initialise some of the unit hardware before gdbstub is set up
+ * initialise some of the unit hardware
  */
 asmlinkage void __init unit_init(void)
 {
@@ -32,7 +32,7 @@ asmlinkage void __init unit_init(void)
 }
 
 /*
- * initialise the rest of the unit hardware after gdbstub is ready
+ * initialise the rest of the unit hardware
  */
 void __init unit_setup(void)
 {
diff --git a/arch/mn10300/unit-asb2364/unit-init.c b/arch/mn10300/unit-asb2364/unit-init.c
index 6359b41ce7e9..03bcaa8c907e 100644
--- a/arch/mn10300/unit-asb2364/unit-init.c
+++ b/arch/mn10300/unit-asb2364/unit-init.c
@@ -30,7 +30,7 @@
 #define LAN_INT_EN		__SYSREG(SMSC911X_BASE + 0x5c, u32)
 
 /*
- * initialise some of the unit hardware before gdbstub is set up
+ * initialise some of the unit hardware
  */
 asmlinkage void __init unit_init(void)
 {
@@ -80,7 +80,7 @@ asmlinkage void __init unit_init(void)
 }
 
 /*
- * initialise the rest of the unit hardware after gdbstub is ready
+ * initialise the rest of the unit hardware
  */
 asmlinkage void __init unit_setup(void)
 {
-- 
1.9.3

