Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaFEUsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:48:40 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50205 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaFEUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:48:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/5] staging: lirc: remove sa1100 support
Date: Thu,  5 Jun 2014 22:48:11 +0200
Message-Id: <1402001295-1980118-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:H3mBWF2Ykt8ELoYWq8rAxYVyTB8k6GkDxqDnmLG6BWk
 2pgoF2FtgkC2iDfP6l+7S3uqoaYDQOCYvpxrmo4zaLbfutJXlv
 /ivLcvt84bs7UsATFtIoJ1A4fa2irWCZB9Rnwa1huCOpmZO/z3
 aJ7QApXIjc/8K0Kvj5jewdnsJmxfwtRjNfCSqGrLwRroPSFFy6
 72sKhlj5viPxpwkf6x00+ObibFEb/QTcxFmq3S7SVSA+sC7Q/D
 XqyFsYV90uFA5NfWr8ZbFToB3rgMNKn3BMNMPgfDGMmFhUGrgJ
 nLGwHrux7C04C0Mg9JrJNtKSRzEGasej9IV7X1XcRCHNHws1zm
 HiACJxoYujCV4MKG8ABUb43Ng5zfWSqjjLci0WOhC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LIRC support for sa1100 appears to have never worked
because it relies on header files that have never been
present in git history. Actually trying to build the
driver on an ARM sa1100 kernel fails, so let's just remove
the broken support.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: linux-media@vger.kernel.org
---
 drivers/staging/media/lirc/lirc_sir.c | 301 +---------------------------------
 1 file changed, 2 insertions(+), 299 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index e31cbb8..79da3ad 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -55,13 +55,6 @@
 #include <asm/irq.h>
 #include <linux/fcntl.h>
 #include <linux/platform_device.h>
-#ifdef LIRC_ON_SA1100
-#include <asm/hardware.h>
-#ifdef CONFIG_SA1100_COLLIE
-#include <asm/arch/tc35143.h>
-#include <asm/ucb1200.h>
-#endif
-#endif
 
 #include <linux/timer.h>
 
@@ -94,35 +87,6 @@ static void init_act200(void);
 static void init_act220(void);
 #endif
 
-/*** SA1100 ***/
-#ifdef LIRC_ON_SA1100
-struct sa1100_ser2_registers {
-	/* HSSP control register */
-	unsigned char hscr0;
-	/* UART registers */
-	unsigned char utcr0;
-	unsigned char utcr1;
-	unsigned char utcr2;
-	unsigned char utcr3;
-	unsigned char utcr4;
-	unsigned char utdr;
-	unsigned char utsr0;
-	unsigned char utsr1;
-} sr;
-
-static int irq = IRQ_Ser2ICP;
-
-#define LIRC_ON_SA1100_TRANSMITTER_LATENCY 0
-
-/* pulse/space ratio of 50/50 */
-static unsigned long pulse_width = (13-LIRC_ON_SA1100_TRANSMITTER_LATENCY);
-/* 1000000/freq-pulse_width */
-static unsigned long space_width = (13-LIRC_ON_SA1100_TRANSMITTER_LATENCY);
-static unsigned int freq = 38000;      /* modulation frequency */
-static unsigned int duty_cycle = 50;   /* duty cycle of 50% */
-
-#endif
-
 #define RBUF_LEN 1024
 #define WBUF_LEN 1024
 
@@ -205,17 +169,6 @@ static void drop_hardware(void);
 static int init_port(void);
 static void drop_port(void);
 
-#ifdef LIRC_ON_SA1100
-static void on(void)
-{
-	PPSR |= PPC_TXD2;
-}
-
-static void off(void)
-{
-	PPSR &= ~PPC_TXD2;
-}
-#else
 static inline unsigned int sinp(int offset)
 {
 	return inb(io + offset);
@@ -225,7 +178,6 @@ static inline void soutp(int offset, int value)
 {
 	outb(value, io + offset);
 }
-#endif
 
 #ifndef MAX_UDELAY_MS
 #define MAX_UDELAY_US 5000
@@ -305,10 +257,6 @@ static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
 	if (IS_ERR(tx_buf))
 		return PTR_ERR(tx_buf);
 	i = 0;
-#ifdef LIRC_ON_SA1100
-	/* disable receiver */
-	Ser2UTCR3 = 0;
-#endif
 	local_irq_save(flags);
 	while (1) {
 		if (i >= count)
@@ -323,15 +271,6 @@ static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
 		i++;
 	}
 	local_irq_restore(flags);
-#ifdef LIRC_ON_SA1100
-	off();
-	udelay(1000); /* wait 1ms for IR diode to recover */
-	Ser2UTCR3 = 0;
-	/* clear status register to prevent unwanted interrupts */
-	Ser2UTSR0 &= (UTSR0_RID | UTSR0_RBB | UTSR0_REB);
-	/* enable receiver */
-	Ser2UTCR3 = UTCR3_RXE|UTCR3_RIE;
-#endif
 	kfree(tx_buf);
 	return count;
 }
@@ -341,25 +280,12 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	u32 __user *uptr = (u32 __user *)arg;
 	int retval = 0;
 	u32 value = 0;
-#ifdef LIRC_ON_SA1100
-
-	if (cmd == LIRC_GET_FEATURES)
-		value = LIRC_CAN_SEND_PULSE |
-			LIRC_CAN_SET_SEND_DUTY_CYCLE |
-			LIRC_CAN_SET_SEND_CARRIER |
-			LIRC_CAN_REC_MODE2;
-	else if (cmd == LIRC_GET_SEND_MODE)
-		value = LIRC_MODE_PULSE;
-	else if (cmd == LIRC_GET_REC_MODE)
-		value = LIRC_MODE_MODE2;
-#else
 	if (cmd == LIRC_GET_FEATURES)
 		value = LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
 	else if (cmd == LIRC_GET_SEND_MODE)
 		value = LIRC_MODE_PULSE;
 	else if (cmd == LIRC_GET_REC_MODE)
 		value = LIRC_MODE_MODE2;
-#endif
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
@@ -372,37 +298,6 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case LIRC_SET_REC_MODE:
 		retval = get_user(value, uptr);
 		break;
-#ifdef LIRC_ON_SA1100
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		retval = get_user(value, uptr);
-		if (retval)
-			return retval;
-		if (value <= 0 || value > 100)
-			return -EINVAL;
-		/* (value/100)*(1000000/freq) */
-		duty_cycle = value;
-		pulse_width = (unsigned long) duty_cycle*10000/freq;
-		space_width = (unsigned long) 1000000L/freq-pulse_width;
-		if (pulse_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
-			pulse_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
-		if (space_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
-			space_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
-		break;
-	case LIRC_SET_SEND_CARRIER:
-		retval = get_user(value, uptr);
-		if (retval)
-			return retval;
-		if (value > 500000 || value < 20000)
-			return -EINVAL;
-		freq = value;
-		pulse_width = (unsigned long) duty_cycle*10000/freq;
-		space_width = (unsigned long) 1000000L/freq-pulse_width;
-		if (pulse_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
-			pulse_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
-		if (space_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
-			space_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
-		break;
-#endif
 	default:
 		retval = -ENOIOCTLCMD;
 
@@ -539,10 +434,8 @@ static void sir_timeout(unsigned long data)
 	/* avoid interference with interrupt */
 	spin_lock_irqsave(&timer_lock, flags);
 	if (last_value) {
-#ifndef LIRC_ON_SA1100
 		/* clear unread bits in UART and restart */
 		outb(UART_FCR_CLEAR_RCVR, io + UART_FCR);
-#endif
 		/* determine 'virtual' pulse end: */
 		pulse_end = delta(&last_tv, &last_intr_tv);
 		dprintk("timeout add %d for %lu usec\n", last_value, pulse_end);
@@ -558,62 +451,6 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 	unsigned char data;
 	struct timeval curr_tv;
 	static unsigned long deltv;
-#ifdef LIRC_ON_SA1100
-	int status;
-	static int n;
-
-	status = Ser2UTSR0;
-	/*
-	 * Deal with any receive errors first.  The bytes in error may be
-	 * the only bytes in the receive FIFO, so we do this first.
-	 */
-	while (status & UTSR0_EIF) {
-		int bstat;
-
-		if (debug) {
-			dprintk("EIF\n");
-			bstat = Ser2UTSR1;
-
-			if (bstat & UTSR1_FRE)
-				dprintk("frame error\n");
-			if (bstat & UTSR1_ROR)
-				dprintk("receive fifo overrun\n");
-			if (bstat & UTSR1_PRE)
-				dprintk("parity error\n");
-		}
-
-		bstat = Ser2UTDR;
-		n++;
-		status = Ser2UTSR0;
-	}
-
-	if (status & (UTSR0_RFS | UTSR0_RID)) {
-		do_gettimeofday(&curr_tv);
-		deltv = delta(&last_tv, &curr_tv);
-		do {
-			data = Ser2UTDR;
-			dprintk("%d data: %u\n", n, (unsigned int) data);
-			n++;
-		} while (status & UTSR0_RID && /* do not empty fifo in order to
-						* get UTSR0_RID in any case */
-		      Ser2UTSR1 & UTSR1_RNE); /* data ready */
-
-		if (status&UTSR0_RID) {
-			add_read_queue(0 , deltv - n * TIME_CONST); /*space*/
-			add_read_queue(1, n * TIME_CONST); /*pulse*/
-			n = 0;
-			last_tv = curr_tv;
-		}
-	}
-
-	if (status & UTSR0_TFS)
-		pr_err("transmit fifo not full, shouldn't happen\n");
-
-	/* We must clear certain bits. */
-	status &= (UTSR0_RID | UTSR0_RBB | UTSR0_REB);
-	if (status)
-		Ser2UTSR0 = status;
-#else
 	unsigned long deltintrtv;
 	unsigned long flags;
 	int iir, lsr;
@@ -698,44 +535,9 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 			break;
 		}
 	}
-#endif
 	return IRQ_RETVAL(IRQ_HANDLED);
 }
 
-#ifdef LIRC_ON_SA1100
-static void send_pulse(unsigned long length)
-{
-	unsigned long k, delay;
-	int flag;
-
-	if (length == 0)
-		return;
-	/*
-	 * this won't give us the carrier frequency we really want
-	 * due to integer arithmetic, but we can accept this inaccuracy
-	 */
-
-	for (k = flag = 0; k < length; k += delay, flag = !flag) {
-		if (flag) {
-			off();
-			delay = space_width;
-		} else {
-			on();
-			delay = pulse_width;
-		}
-		safe_udelay(delay);
-	}
-	off();
-}
-
-static void send_space(unsigned long length)
-{
-	if (length == 0)
-		return;
-	off();
-	safe_udelay(length);
-}
-#else
 static void send_space(unsigned long len)
 {
 	safe_udelay(len);
@@ -755,31 +557,6 @@ static void send_pulse(unsigned long len)
 			;
 	}
 }
-#endif
-
-#ifdef CONFIG_SA1100_COLLIE
-static int sa1100_irda_set_power_collie(int state)
-{
-	if (state) {
-		/*
-		 *  0 - off
-		 *  1 - short range, lowest power
-		 *  2 - medium range, medium power
-		 *  3 - maximum range, high power
-		 */
-		ucb1200_set_io_direction(TC35143_GPIO_IR_ON,
-					 TC35143_IODIR_OUTPUT);
-		ucb1200_set_io(TC35143_GPIO_IR_ON, TC35143_IODAT_LOW);
-		udelay(100);
-	} else {
-		/* OFF */
-		ucb1200_set_io_direction(TC35143_GPIO_IR_ON,
-					 TC35143_IODIR_OUTPUT);
-		ucb1200_set_io(TC35143_GPIO_IR_ON, TC35143_IODAT_HIGH);
-	}
-	return 0;
-}
-#endif
 
 static int init_hardware(void)
 {
@@ -787,51 +564,7 @@ static int init_hardware(void)
 
 	spin_lock_irqsave(&hardware_lock, flags);
 	/* reset UART */
-#ifdef LIRC_ON_SA1100
-#ifdef CONFIG_SA1100_COLLIE
-	sa1100_irda_set_power_collie(3);	/* power on */
-#endif
-	sr.hscr0 = Ser2HSCR0;
-
-	sr.utcr0 = Ser2UTCR0;
-	sr.utcr1 = Ser2UTCR1;
-	sr.utcr2 = Ser2UTCR2;
-	sr.utcr3 = Ser2UTCR3;
-	sr.utcr4 = Ser2UTCR4;
-
-	sr.utdr = Ser2UTDR;
-	sr.utsr0 = Ser2UTSR0;
-	sr.utsr1 = Ser2UTSR1;
-
-	/* configure GPIO */
-	/* output */
-	PPDR |= PPC_TXD2;
-	PSDR |= PPC_TXD2;
-	/* set output to 0 */
-	off();
-
-	/* Enable HP-SIR modulation, and ensure that the port is disabled. */
-	Ser2UTCR3 = 0;
-	Ser2HSCR0 = sr.hscr0 & (~HSCR0_HSSP);
-
-	/* clear status register to prevent unwanted interrupts */
-	Ser2UTSR0 &= (UTSR0_RID | UTSR0_RBB | UTSR0_REB);
-
-	/* 7N1 */
-	Ser2UTCR0 = UTCR0_1StpBit|UTCR0_7BitData;
-	/* 115200 */
-	Ser2UTCR1 = 0;
-	Ser2UTCR2 = 1;
-	/* use HPSIR, 1.6 usec pulses */
-	Ser2UTCR4 = UTCR4_HPSIR|UTCR4_Z1_6us;
-
-	/* enable receiver, receive fifo interrupt */
-	Ser2UTCR3 = UTCR3_RXE|UTCR3_RIE;
-
-	/* clear status register to prevent unwanted interrupts */
-	Ser2UTSR0 &= (UTSR0_RID | UTSR0_RBB | UTSR0_REB);
-
-#elif defined(LIRC_SIR_TEKRAM)
+#if defined(LIRC_SIR_TEKRAM)
 	/* disable FIFO */
 	soutp(UART_FCR,
 	      UART_FCR_CLEAR_RCVR|
@@ -927,23 +660,9 @@ static void drop_hardware(void)
 
 	spin_lock_irqsave(&hardware_lock, flags);
 
-#ifdef LIRC_ON_SA1100
-	Ser2UTCR3 = 0;
-
-	Ser2UTCR0 = sr.utcr0;
-	Ser2UTCR1 = sr.utcr1;
-	Ser2UTCR2 = sr.utcr2;
-	Ser2UTCR4 = sr.utcr4;
-	Ser2UTCR3 = sr.utcr3;
-
-	Ser2HSCR0 = sr.hscr0;
-#ifdef CONFIG_SA1100_COLLIE
-	sa1100_irda_set_power_collie(0);	/* power off */
-#endif
-#else
 	/* turn off interrupts */
 	outb(0, io + UART_IER);
-#endif
+
 	spin_unlock_irqrestore(&hardware_lock, flags);
 }
 
@@ -954,24 +673,18 @@ static int init_port(void)
 	int retval;
 
 	/* get I/O port access and IRQ line */
-#ifndef LIRC_ON_SA1100
 	if (request_region(io, 8, LIRC_DRIVER_NAME) == NULL) {
 		pr_err("i/o port 0x%.4x already in use.\n", io);
 		return -EBUSY;
 	}
-#endif
 	retval = request_irq(irq, sir_interrupt, 0,
 			     LIRC_DRIVER_NAME, NULL);
 	if (retval < 0) {
-#               ifndef LIRC_ON_SA1100
 		release_region(io, 8);
-#               endif
 		pr_err("IRQ %d already in use.\n", irq);
 		return retval;
 	}
-#ifndef LIRC_ON_SA1100
 	pr_info("I/O port 0x%.4x, IRQ %d.\n", io, irq);
-#endif
 
 	init_timer(&timerlist);
 	timerlist.function = sir_timeout;
@@ -984,9 +697,7 @@ static void drop_port(void)
 {
 	free_irq(irq, NULL);
 	del_timer_sync(&timerlist);
-#ifndef LIRC_ON_SA1100
 	release_region(io, 8);
-#endif
 }
 
 #ifdef LIRC_SIR_ACTISYS_ACT200L
@@ -1284,9 +995,6 @@ module_exit(lirc_sir_exit);
 #ifdef LIRC_SIR_TEKRAM
 MODULE_DESCRIPTION("Infrared receiver driver for Tekram Irmate 210");
 MODULE_AUTHOR("Christoph Bartelmus");
-#elif defined(LIRC_ON_SA1100)
-MODULE_DESCRIPTION("LIRC driver for StrongARM SA1100 embedded microprocessor");
-MODULE_AUTHOR("Christoph Bartelmus");
 #elif defined(LIRC_SIR_ACTISYS_ACT200L)
 MODULE_DESCRIPTION("LIRC driver for Actisys Act200L");
 MODULE_AUTHOR("Karl Bongers");
@@ -1299,10 +1007,6 @@ MODULE_AUTHOR("Milan Pikula");
 #endif
 MODULE_LICENSE("GPL");
 
-#ifdef LIRC_ON_SA1100
-module_param(irq, int, S_IRUGO);
-MODULE_PARM_DESC(irq, "Interrupt (16)");
-#else
 module_param(io, int, S_IRUGO);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
@@ -1311,7 +1015,6 @@ MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
 module_param(threshold, int, S_IRUGO);
 MODULE_PARM_DESC(threshold, "space detection threshold (3)");
-#endif
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable debugging messages");
-- 
1.8.3.2

