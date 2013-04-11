Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937782Ab3DKAMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:12:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937362Ab3DKAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/30] tty: serial/samsung: make register definitions global
Date: Thu, 11 Apr 2013 02:04:48 +0200
Message-Id: <1365638712-1028578-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5jRdBD5r97VqLIrs8xMZt+46Pgx9GluM51pdgheC1Nf
 S5SJu9PJ0XRstH86eXVaJO06l07f9DnnaV04gv0g6rPjywFt2W
 aJPTDqHg8bLf0NuXMiAygIY2FBy94SttV9u8pYhZU6AAMoleyE
 5WFYaIZ2Lww6W+IrK/RBQVRczGUz8J3LeLqk7xv6S7QKjuvlGg
 2selq9VJJaWhcWhT5z5CGSKcrZ7rTmB3WEpXLf2u4IUEvQklt1
 ZEmQgenPYxG/AKgS1es41BbadbyyPkjHz+mxfQyN3CnBe/WsEZ
 tHTN66JdNc4X3+mk2LD5+snTHCdjRMUvLMG6QPuueI856pztdm
 SYV45nwLnzShB04LkSO8Dc/17oQgpx0PD+roRg+E+2vgtWhvIo
 A1jKj9fngBwPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers for the Samsung S3C serial port are currently defined in
the platform specific arch/arm/plat-samsung/include/plat/regs-serial.h
file, which is not visible to multiplatform capable drivers.

Unfortunately, it is not possible to move the file into a more local
place as we should normally try to, because the same registers
may be used in one of four places:

* In the driver itself
* In platform-independent ARM code for early debug output
* In platform_data definitions
* In the Samsung platform power management code

I have also found no way to logically split out a platform_data
file, other than possibly move everything into
include/linux/platform_data, which also felt wrong. The only
part of this file that makes sense to keep specific to the s3c24xx
platform are the virtual and physical addresses defined here,
which are needed in no other location.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-s3c24xx/clock-s3c2440.c            |   5 +
 arch/arm/mach-s3c24xx/common.c                   |   5 +
 arch/arm/plat-samsung/include/plat/regs-serial.h | 282 +----------------------
 drivers/tty/serial/samsung.c                     |   6 +-
 include/linux/serial_s3c.h                       | 260 +++++++++++++++++++++
 5 files changed, 274 insertions(+), 284 deletions(-)
 create mode 100644 include/linux/serial_s3c.h

diff --git a/arch/arm/mach-s3c24xx/clock-s3c2440.c b/arch/arm/mach-s3c24xx/clock-s3c2440.c
index 04b87ec..1069b56 100644
--- a/arch/arm/mach-s3c24xx/clock-s3c2440.c
+++ b/arch/arm/mach-s3c24xx/clock-s3c2440.c
@@ -123,6 +123,11 @@ static struct clk s3c2440_clk_ac97 = {
 	.ctrlbit	= S3C2440_CLKCON_AC97,
 };
 
+#define S3C24XX_VA_UART0      (S3C_VA_UART)
+#define S3C24XX_VA_UART1      (S3C_VA_UART + 0x4000 )
+#define S3C24XX_VA_UART2      (S3C_VA_UART + 0x8000 )
+#define S3C24XX_VA_UART3      (S3C_VA_UART + 0xC000 )
+
 static unsigned long  s3c2440_fclk_n_getrate(struct clk *clk)
 {
 	unsigned long ucon0, ucon1, ucon2, divisor;
diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index d97533d..c157103 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -236,6 +236,11 @@ void __init s3c24xx_init_io(struct map_desc *mach_desc, int size)
 
 /* Serial port registrations */
 
+#define S3C2410_PA_UART0      (S3C24XX_PA_UART)
+#define S3C2410_PA_UART1      (S3C24XX_PA_UART + 0x4000 )
+#define S3C2410_PA_UART2      (S3C24XX_PA_UART + 0x8000 )
+#define S3C2443_PA_UART3      (S3C24XX_PA_UART + 0xC000 )
+
 static struct resource s3c2410_uart0_resource[] = {
 	[0] = DEFINE_RES_MEM(S3C2410_PA_UART0, SZ_16K),
 	[1] = DEFINE_RES_NAMED(IRQ_S3CUART_RX0, \
diff --git a/arch/arm/plat-samsung/include/plat/regs-serial.h b/arch/arm/plat-samsung/include/plat/regs-serial.h
index 29c26a8..f05f2af 100644
--- a/arch/arm/plat-samsung/include/plat/regs-serial.h
+++ b/arch/arm/plat-samsung/include/plat/regs-serial.h
@@ -1,281 +1 @@
-/* arch/arm/plat-samsung/include/plat/regs-serial.h
- *
- *  From linux/include/asm-arm/hardware/serial_s3c2410.h
- *
- *  Internal header file for Samsung S3C2410 serial ports (UART0-2)
- *
- *  Copyright (C) 2002 Shane Nay (shane@minirl.com)
- *
- *  Additional defines, Copyright 2003 Simtec Electronics (linux@simtec.co.uk)
- *
- *  Adapted from:
- *
- *  Internal header file for MX1ADS serial ports (UART1 & 2)
- *
- *  Copyright (C) 2002 Shane Nay (shane@minirl.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-*/
-
-#ifndef __ASM_ARM_REGS_SERIAL_H
-#define __ASM_ARM_REGS_SERIAL_H
-
-#define S3C24XX_VA_UART0      (S3C_VA_UART)
-#define S3C24XX_VA_UART1      (S3C_VA_UART + 0x4000 )
-#define S3C24XX_VA_UART2      (S3C_VA_UART + 0x8000 )
-#define S3C24XX_VA_UART3      (S3C_VA_UART + 0xC000 )
-
-#define S3C2410_PA_UART0      (S3C24XX_PA_UART)
-#define S3C2410_PA_UART1      (S3C24XX_PA_UART + 0x4000 )
-#define S3C2410_PA_UART2      (S3C24XX_PA_UART + 0x8000 )
-#define S3C2443_PA_UART3      (S3C24XX_PA_UART + 0xC000 )
-
-#define S3C2410_URXH	  (0x24)
-#define S3C2410_UTXH	  (0x20)
-#define S3C2410_ULCON	  (0x00)
-#define S3C2410_UCON	  (0x04)
-#define S3C2410_UFCON	  (0x08)
-#define S3C2410_UMCON	  (0x0C)
-#define S3C2410_UBRDIV	  (0x28)
-#define S3C2410_UTRSTAT	  (0x10)
-#define S3C2410_UERSTAT	  (0x14)
-#define S3C2410_UFSTAT	  (0x18)
-#define S3C2410_UMSTAT	  (0x1C)
-
-#define S3C2410_LCON_CFGMASK	  ((0xF<<3)|(0x3))
-
-#define S3C2410_LCON_CS5	  (0x0)
-#define S3C2410_LCON_CS6	  (0x1)
-#define S3C2410_LCON_CS7	  (0x2)
-#define S3C2410_LCON_CS8	  (0x3)
-#define S3C2410_LCON_CSMASK	  (0x3)
-
-#define S3C2410_LCON_PNONE	  (0x0)
-#define S3C2410_LCON_PEVEN	  (0x5 << 3)
-#define S3C2410_LCON_PODD	  (0x4 << 3)
-#define S3C2410_LCON_PMASK	  (0x7 << 3)
-
-#define S3C2410_LCON_STOPB	  (1<<2)
-#define S3C2410_LCON_IRM          (1<<6)
-
-#define S3C2440_UCON_CLKMASK	  (3<<10)
-#define S3C2440_UCON_CLKSHIFT	  (10)
-#define S3C2440_UCON_PCLK	  (0<<10)
-#define S3C2440_UCON_UCLK	  (1<<10)
-#define S3C2440_UCON_PCLK2	  (2<<10)
-#define S3C2440_UCON_FCLK	  (3<<10)
-#define S3C2443_UCON_EPLL	  (3<<10)
-
-#define S3C6400_UCON_CLKMASK	(3<<10)
-#define S3C6400_UCON_CLKSHIFT	(10)
-#define S3C6400_UCON_PCLK	(0<<10)
-#define S3C6400_UCON_PCLK2	(2<<10)
-#define S3C6400_UCON_UCLK0	(1<<10)
-#define S3C6400_UCON_UCLK1	(3<<10)
-
-#define S3C2440_UCON2_FCLK_EN	  (1<<15)
-#define S3C2440_UCON0_DIVMASK	  (15 << 12)
-#define S3C2440_UCON1_DIVMASK	  (15 << 12)
-#define S3C2440_UCON2_DIVMASK	  (7 << 12)
-#define S3C2440_UCON_DIVSHIFT	  (12)
-
-#define S3C2412_UCON_CLKMASK	(3<<10)
-#define S3C2412_UCON_CLKSHIFT	(10)
-#define S3C2412_UCON_UCLK	(1<<10)
-#define S3C2412_UCON_USYSCLK	(3<<10)
-#define S3C2412_UCON_PCLK	(0<<10)
-#define S3C2412_UCON_PCLK2	(2<<10)
-
-#define S3C2410_UCON_CLKMASK	(1 << 10)
-#define S3C2410_UCON_CLKSHIFT	(10)
-#define S3C2410_UCON_UCLK	  (1<<10)
-#define S3C2410_UCON_SBREAK	  (1<<4)
-
-#define S3C2410_UCON_TXILEVEL	  (1<<9)
-#define S3C2410_UCON_RXILEVEL	  (1<<8)
-#define S3C2410_UCON_TXIRQMODE	  (1<<2)
-#define S3C2410_UCON_RXIRQMODE	  (1<<0)
-#define S3C2410_UCON_RXFIFO_TOI	  (1<<7)
-#define S3C2443_UCON_RXERR_IRQEN  (1<<6)
-#define S3C2443_UCON_LOOPBACK	  (1<<5)
-
-#define S3C2410_UCON_DEFAULT	  (S3C2410_UCON_TXILEVEL  | \
-				   S3C2410_UCON_RXILEVEL  | \
-				   S3C2410_UCON_TXIRQMODE | \
-				   S3C2410_UCON_RXIRQMODE | \
-				   S3C2410_UCON_RXFIFO_TOI)
-
-#define S3C2410_UFCON_FIFOMODE	  (1<<0)
-#define S3C2410_UFCON_TXTRIG0	  (0<<6)
-#define S3C2410_UFCON_RXTRIG8	  (1<<4)
-#define S3C2410_UFCON_RXTRIG12	  (2<<4)
-
-/* S3C2440 FIFO trigger levels */
-#define S3C2440_UFCON_RXTRIG1	  (0<<4)
-#define S3C2440_UFCON_RXTRIG8	  (1<<4)
-#define S3C2440_UFCON_RXTRIG16	  (2<<4)
-#define S3C2440_UFCON_RXTRIG32	  (3<<4)
-
-#define S3C2440_UFCON_TXTRIG0	  (0<<6)
-#define S3C2440_UFCON_TXTRIG16	  (1<<6)
-#define S3C2440_UFCON_TXTRIG32	  (2<<6)
-#define S3C2440_UFCON_TXTRIG48	  (3<<6)
-
-#define S3C2410_UFCON_RESETBOTH	  (3<<1)
-#define S3C2410_UFCON_RESETTX	  (1<<2)
-#define S3C2410_UFCON_RESETRX	  (1<<1)
-
-#define S3C2410_UFCON_DEFAULT	  (S3C2410_UFCON_FIFOMODE | \
-				   S3C2410_UFCON_TXTRIG0  | \
-				   S3C2410_UFCON_RXTRIG8 )
-
-#define	S3C2410_UMCOM_AFC	  (1<<4)
-#define	S3C2410_UMCOM_RTS_LOW	  (1<<0)
-
-#define S3C2412_UMCON_AFC_63	(0<<5)		/* same as s3c2443 */
-#define S3C2412_UMCON_AFC_56	(1<<5)
-#define S3C2412_UMCON_AFC_48	(2<<5)
-#define S3C2412_UMCON_AFC_40	(3<<5)
-#define S3C2412_UMCON_AFC_32	(4<<5)
-#define S3C2412_UMCON_AFC_24	(5<<5)
-#define S3C2412_UMCON_AFC_16	(6<<5)
-#define S3C2412_UMCON_AFC_8	(7<<5)
-
-#define S3C2410_UFSTAT_TXFULL	  (1<<9)
-#define S3C2410_UFSTAT_RXFULL	  (1<<8)
-#define S3C2410_UFSTAT_TXMASK	  (15<<4)
-#define S3C2410_UFSTAT_TXSHIFT	  (4)
-#define S3C2410_UFSTAT_RXMASK	  (15<<0)
-#define S3C2410_UFSTAT_RXSHIFT	  (0)
-
-/* UFSTAT S3C2443 same as S3C2440 */
-#define S3C2440_UFSTAT_TXFULL	  (1<<14)
-#define S3C2440_UFSTAT_RXFULL	  (1<<6)
-#define S3C2440_UFSTAT_TXSHIFT	  (8)
-#define S3C2440_UFSTAT_RXSHIFT	  (0)
-#define S3C2440_UFSTAT_TXMASK	  (63<<8)
-#define S3C2440_UFSTAT_RXMASK	  (63)
-
-#define S3C2410_UTRSTAT_TXE	  (1<<2)
-#define S3C2410_UTRSTAT_TXFE	  (1<<1)
-#define S3C2410_UTRSTAT_RXDR	  (1<<0)
-
-#define S3C2410_UERSTAT_OVERRUN	  (1<<0)
-#define S3C2410_UERSTAT_FRAME	  (1<<2)
-#define S3C2410_UERSTAT_BREAK	  (1<<3)
-#define S3C2443_UERSTAT_PARITY	  (1<<1)
-
-#define S3C2410_UERSTAT_ANY	  (S3C2410_UERSTAT_OVERRUN | \
-				   S3C2410_UERSTAT_FRAME | \
-				   S3C2410_UERSTAT_BREAK)
-
-#define S3C2410_UMSTAT_CTS	  (1<<0)
-#define S3C2410_UMSTAT_DeltaCTS	  (1<<2)
-
-#define S3C2443_DIVSLOT		  (0x2C)
-
-/* S3C64XX interrupt registers. */
-#define S3C64XX_UINTP		0x30
-#define S3C64XX_UINTSP		0x34
-#define S3C64XX_UINTM		0x38
-
-#define S3C64XX_UINTM_RXD	(0)
-#define S3C64XX_UINTM_TXD	(2)
-#define S3C64XX_UINTM_RXD_MSK	(1 << S3C64XX_UINTM_RXD)
-#define S3C64XX_UINTM_TXD_MSK	(1 << S3C64XX_UINTM_TXD)
-
-/* Following are specific to S5PV210 */
-#define S5PV210_UCON_CLKMASK	(1<<10)
-#define S5PV210_UCON_CLKSHIFT	(10)
-#define S5PV210_UCON_PCLK	(0<<10)
-#define S5PV210_UCON_UCLK	(1<<10)
-
-#define S5PV210_UFCON_TXTRIG0	(0<<8)
-#define S5PV210_UFCON_TXTRIG4	(1<<8)
-#define S5PV210_UFCON_TXTRIG8	(2<<8)
-#define S5PV210_UFCON_TXTRIG16	(3<<8)
-#define S5PV210_UFCON_TXTRIG32	(4<<8)
-#define S5PV210_UFCON_TXTRIG64	(5<<8)
-#define S5PV210_UFCON_TXTRIG128 (6<<8)
-#define S5PV210_UFCON_TXTRIG256 (7<<8)
-
-#define S5PV210_UFCON_RXTRIG1	(0<<4)
-#define S5PV210_UFCON_RXTRIG4	(1<<4)
-#define S5PV210_UFCON_RXTRIG8	(2<<4)
-#define S5PV210_UFCON_RXTRIG16	(3<<4)
-#define S5PV210_UFCON_RXTRIG32	(4<<4)
-#define S5PV210_UFCON_RXTRIG64	(5<<4)
-#define S5PV210_UFCON_RXTRIG128	(6<<4)
-#define S5PV210_UFCON_RXTRIG256	(7<<4)
-
-#define S5PV210_UFSTAT_TXFULL	(1<<24)
-#define S5PV210_UFSTAT_RXFULL	(1<<8)
-#define S5PV210_UFSTAT_TXMASK	(255<<16)
-#define S5PV210_UFSTAT_TXSHIFT	(16)
-#define S5PV210_UFSTAT_RXMASK	(255<<0)
-#define S5PV210_UFSTAT_RXSHIFT	(0)
-
-#define S3C2410_UCON_CLKSEL0	(1 << 0)
-#define S3C2410_UCON_CLKSEL1	(1 << 1)
-#define S3C2410_UCON_CLKSEL2	(1 << 2)
-#define S3C2410_UCON_CLKSEL3	(1 << 3)
-
-/* Default values for s5pv210 UCON and UFCON uart registers */
-#define S5PV210_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
-				 S3C2410_UCON_RXILEVEL |	\
-				 S3C2410_UCON_TXIRQMODE |	\
-				 S3C2410_UCON_RXIRQMODE |	\
-				 S3C2410_UCON_RXFIFO_TOI |	\
-				 S3C2443_UCON_RXERR_IRQEN)
-
-#define S5PV210_UFCON_DEFAULT	(S3C2410_UFCON_FIFOMODE |	\
-				 S5PV210_UFCON_TXTRIG4 |	\
-				 S5PV210_UFCON_RXTRIG4)
-
-#ifndef __ASSEMBLY__
-
-/* configuration structure for per-machine configurations for the
- * serial port
- *
- * the pointer is setup by the machine specific initialisation from the
- * arch/arm/mach-s3c2410/ directory.
-*/
-
-struct s3c2410_uartcfg {
-	unsigned char	   hwport;	 /* hardware port number */
-	unsigned char	   unused;
-	unsigned short	   flags;
-	upf_t		   uart_flags;	 /* default uart flags */
-	unsigned int	   clk_sel;
-
-	unsigned int	   has_fracval;
-
-	unsigned long	   ucon;	 /* value of ucon for port */
-	unsigned long	   ulcon;	 /* value of ulcon for port */
-	unsigned long	   ufcon;	 /* value of ufcon for port */
-};
-
-/* s3c24xx_uart_devs
- *
- * this is exported from the core as we cannot use driver_register(),
- * or platform_add_device() before the console_initcall()
-*/
-
-extern struct platform_device *s3c24xx_uart_devs[4];
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __ASM_ARM_REGS_SERIAL_H */
-
+#include <linux/serial_s3c.h>
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 603f3f3..729a60d 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -39,6 +39,7 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
+#include <linux/serial_s3c.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
@@ -46,10 +47,9 @@
 
 #include <asm/irq.h>
 
-#include <mach/hardware.h>
-
-#include <plat/regs-serial.h>
+#ifdef CONFIG_SAMSUNG_CLOCK
 #include <plat/clock.h>
+#endif
 
 #include "samsung.h"
 
diff --git a/include/linux/serial_s3c.h b/include/linux/serial_s3c.h
new file mode 100644
index 0000000..907d9d1
--- /dev/null
+++ b/include/linux/serial_s3c.h
@@ -0,0 +1,260 @@
+/*
+ *  Internal header file for Samsung S3C2410 serial ports (UART0-2)
+ *
+ *  Copyright (C) 2002 Shane Nay (shane@minirl.com)
+ *
+ *  Additional defines, Copyright 2003 Simtec Electronics (linux@simtec.co.uk)
+ *
+ *  Adapted from:
+ *
+ *  Internal header file for MX1ADS serial ports (UART1 & 2)
+ *
+ *  Copyright (C) 2002 Shane Nay (shane@minirl.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#ifndef __ASM_ARM_REGS_SERIAL_H
+#define __ASM_ARM_REGS_SERIAL_H
+
+#define S3C2410_URXH	  (0x24)
+#define S3C2410_UTXH	  (0x20)
+#define S3C2410_ULCON	  (0x00)
+#define S3C2410_UCON	  (0x04)
+#define S3C2410_UFCON	  (0x08)
+#define S3C2410_UMCON	  (0x0C)
+#define S3C2410_UBRDIV	  (0x28)
+#define S3C2410_UTRSTAT	  (0x10)
+#define S3C2410_UERSTAT	  (0x14)
+#define S3C2410_UFSTAT	  (0x18)
+#define S3C2410_UMSTAT	  (0x1C)
+
+#define S3C2410_LCON_CFGMASK	  ((0xF<<3)|(0x3))
+
+#define S3C2410_LCON_CS5	  (0x0)
+#define S3C2410_LCON_CS6	  (0x1)
+#define S3C2410_LCON_CS7	  (0x2)
+#define S3C2410_LCON_CS8	  (0x3)
+#define S3C2410_LCON_CSMASK	  (0x3)
+
+#define S3C2410_LCON_PNONE	  (0x0)
+#define S3C2410_LCON_PEVEN	  (0x5 << 3)
+#define S3C2410_LCON_PODD	  (0x4 << 3)
+#define S3C2410_LCON_PMASK	  (0x7 << 3)
+
+#define S3C2410_LCON_STOPB	  (1<<2)
+#define S3C2410_LCON_IRM          (1<<6)
+
+#define S3C2440_UCON_CLKMASK	  (3<<10)
+#define S3C2440_UCON_CLKSHIFT	  (10)
+#define S3C2440_UCON_PCLK	  (0<<10)
+#define S3C2440_UCON_UCLK	  (1<<10)
+#define S3C2440_UCON_PCLK2	  (2<<10)
+#define S3C2440_UCON_FCLK	  (3<<10)
+#define S3C2443_UCON_EPLL	  (3<<10)
+
+#define S3C6400_UCON_CLKMASK	(3<<10)
+#define S3C6400_UCON_CLKSHIFT	(10)
+#define S3C6400_UCON_PCLK	(0<<10)
+#define S3C6400_UCON_PCLK2	(2<<10)
+#define S3C6400_UCON_UCLK0	(1<<10)
+#define S3C6400_UCON_UCLK1	(3<<10)
+
+#define S3C2440_UCON2_FCLK_EN	  (1<<15)
+#define S3C2440_UCON0_DIVMASK	  (15 << 12)
+#define S3C2440_UCON1_DIVMASK	  (15 << 12)
+#define S3C2440_UCON2_DIVMASK	  (7 << 12)
+#define S3C2440_UCON_DIVSHIFT	  (12)
+
+#define S3C2412_UCON_CLKMASK	(3<<10)
+#define S3C2412_UCON_CLKSHIFT	(10)
+#define S3C2412_UCON_UCLK	(1<<10)
+#define S3C2412_UCON_USYSCLK	(3<<10)
+#define S3C2412_UCON_PCLK	(0<<10)
+#define S3C2412_UCON_PCLK2	(2<<10)
+
+#define S3C2410_UCON_CLKMASK	(1 << 10)
+#define S3C2410_UCON_CLKSHIFT	(10)
+#define S3C2410_UCON_UCLK	  (1<<10)
+#define S3C2410_UCON_SBREAK	  (1<<4)
+
+#define S3C2410_UCON_TXILEVEL	  (1<<9)
+#define S3C2410_UCON_RXILEVEL	  (1<<8)
+#define S3C2410_UCON_TXIRQMODE	  (1<<2)
+#define S3C2410_UCON_RXIRQMODE	  (1<<0)
+#define S3C2410_UCON_RXFIFO_TOI	  (1<<7)
+#define S3C2443_UCON_RXERR_IRQEN  (1<<6)
+#define S3C2443_UCON_LOOPBACK	  (1<<5)
+
+#define S3C2410_UCON_DEFAULT	  (S3C2410_UCON_TXILEVEL  | \
+				   S3C2410_UCON_RXILEVEL  | \
+				   S3C2410_UCON_TXIRQMODE | \
+				   S3C2410_UCON_RXIRQMODE | \
+				   S3C2410_UCON_RXFIFO_TOI)
+
+#define S3C2410_UFCON_FIFOMODE	  (1<<0)
+#define S3C2410_UFCON_TXTRIG0	  (0<<6)
+#define S3C2410_UFCON_RXTRIG8	  (1<<4)
+#define S3C2410_UFCON_RXTRIG12	  (2<<4)
+
+/* S3C2440 FIFO trigger levels */
+#define S3C2440_UFCON_RXTRIG1	  (0<<4)
+#define S3C2440_UFCON_RXTRIG8	  (1<<4)
+#define S3C2440_UFCON_RXTRIG16	  (2<<4)
+#define S3C2440_UFCON_RXTRIG32	  (3<<4)
+
+#define S3C2440_UFCON_TXTRIG0	  (0<<6)
+#define S3C2440_UFCON_TXTRIG16	  (1<<6)
+#define S3C2440_UFCON_TXTRIG32	  (2<<6)
+#define S3C2440_UFCON_TXTRIG48	  (3<<6)
+
+#define S3C2410_UFCON_RESETBOTH	  (3<<1)
+#define S3C2410_UFCON_RESETTX	  (1<<2)
+#define S3C2410_UFCON_RESETRX	  (1<<1)
+
+#define S3C2410_UFCON_DEFAULT	  (S3C2410_UFCON_FIFOMODE | \
+				   S3C2410_UFCON_TXTRIG0  | \
+				   S3C2410_UFCON_RXTRIG8 )
+
+#define	S3C2410_UMCOM_AFC	  (1<<4)
+#define	S3C2410_UMCOM_RTS_LOW	  (1<<0)
+
+#define S3C2412_UMCON_AFC_63	(0<<5)		/* same as s3c2443 */
+#define S3C2412_UMCON_AFC_56	(1<<5)
+#define S3C2412_UMCON_AFC_48	(2<<5)
+#define S3C2412_UMCON_AFC_40	(3<<5)
+#define S3C2412_UMCON_AFC_32	(4<<5)
+#define S3C2412_UMCON_AFC_24	(5<<5)
+#define S3C2412_UMCON_AFC_16	(6<<5)
+#define S3C2412_UMCON_AFC_8	(7<<5)
+
+#define S3C2410_UFSTAT_TXFULL	  (1<<9)
+#define S3C2410_UFSTAT_RXFULL	  (1<<8)
+#define S3C2410_UFSTAT_TXMASK	  (15<<4)
+#define S3C2410_UFSTAT_TXSHIFT	  (4)
+#define S3C2410_UFSTAT_RXMASK	  (15<<0)
+#define S3C2410_UFSTAT_RXSHIFT	  (0)
+
+/* UFSTAT S3C2443 same as S3C2440 */
+#define S3C2440_UFSTAT_TXFULL	  (1<<14)
+#define S3C2440_UFSTAT_RXFULL	  (1<<6)
+#define S3C2440_UFSTAT_TXSHIFT	  (8)
+#define S3C2440_UFSTAT_RXSHIFT	  (0)
+#define S3C2440_UFSTAT_TXMASK	  (63<<8)
+#define S3C2440_UFSTAT_RXMASK	  (63)
+
+#define S3C2410_UTRSTAT_TXE	  (1<<2)
+#define S3C2410_UTRSTAT_TXFE	  (1<<1)
+#define S3C2410_UTRSTAT_RXDR	  (1<<0)
+
+#define S3C2410_UERSTAT_OVERRUN	  (1<<0)
+#define S3C2410_UERSTAT_FRAME	  (1<<2)
+#define S3C2410_UERSTAT_BREAK	  (1<<3)
+#define S3C2443_UERSTAT_PARITY	  (1<<1)
+
+#define S3C2410_UERSTAT_ANY	  (S3C2410_UERSTAT_OVERRUN | \
+				   S3C2410_UERSTAT_FRAME | \
+				   S3C2410_UERSTAT_BREAK)
+
+#define S3C2410_UMSTAT_CTS	  (1<<0)
+#define S3C2410_UMSTAT_DeltaCTS	  (1<<2)
+
+#define S3C2443_DIVSLOT		  (0x2C)
+
+/* S3C64XX interrupt registers. */
+#define S3C64XX_UINTP		0x30
+#define S3C64XX_UINTSP		0x34
+#define S3C64XX_UINTM		0x38
+
+#define S3C64XX_UINTM_RXD	(0)
+#define S3C64XX_UINTM_TXD	(2)
+#define S3C64XX_UINTM_RXD_MSK	(1 << S3C64XX_UINTM_RXD)
+#define S3C64XX_UINTM_TXD_MSK	(1 << S3C64XX_UINTM_TXD)
+
+/* Following are specific to S5PV210 */
+#define S5PV210_UCON_CLKMASK	(1<<10)
+#define S5PV210_UCON_CLKSHIFT	(10)
+#define S5PV210_UCON_PCLK	(0<<10)
+#define S5PV210_UCON_UCLK	(1<<10)
+
+#define S5PV210_UFCON_TXTRIG0	(0<<8)
+#define S5PV210_UFCON_TXTRIG4	(1<<8)
+#define S5PV210_UFCON_TXTRIG8	(2<<8)
+#define S5PV210_UFCON_TXTRIG16	(3<<8)
+#define S5PV210_UFCON_TXTRIG32	(4<<8)
+#define S5PV210_UFCON_TXTRIG64	(5<<8)
+#define S5PV210_UFCON_TXTRIG128 (6<<8)
+#define S5PV210_UFCON_TXTRIG256 (7<<8)
+
+#define S5PV210_UFCON_RXTRIG1	(0<<4)
+#define S5PV210_UFCON_RXTRIG4	(1<<4)
+#define S5PV210_UFCON_RXTRIG8	(2<<4)
+#define S5PV210_UFCON_RXTRIG16	(3<<4)
+#define S5PV210_UFCON_RXTRIG32	(4<<4)
+#define S5PV210_UFCON_RXTRIG64	(5<<4)
+#define S5PV210_UFCON_RXTRIG128	(6<<4)
+#define S5PV210_UFCON_RXTRIG256	(7<<4)
+
+#define S5PV210_UFSTAT_TXFULL	(1<<24)
+#define S5PV210_UFSTAT_RXFULL	(1<<8)
+#define S5PV210_UFSTAT_TXMASK	(255<<16)
+#define S5PV210_UFSTAT_TXSHIFT	(16)
+#define S5PV210_UFSTAT_RXMASK	(255<<0)
+#define S5PV210_UFSTAT_RXSHIFT	(0)
+
+#define S3C2410_UCON_CLKSEL0	(1 << 0)
+#define S3C2410_UCON_CLKSEL1	(1 << 1)
+#define S3C2410_UCON_CLKSEL2	(1 << 2)
+#define S3C2410_UCON_CLKSEL3	(1 << 3)
+
+/* Default values for s5pv210 UCON and UFCON uart registers */
+#define S5PV210_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
+				 S3C2410_UCON_RXILEVEL |	\
+				 S3C2410_UCON_TXIRQMODE |	\
+				 S3C2410_UCON_RXIRQMODE |	\
+				 S3C2410_UCON_RXFIFO_TOI |	\
+				 S3C2443_UCON_RXERR_IRQEN)
+
+#define S5PV210_UFCON_DEFAULT	(S3C2410_UFCON_FIFOMODE |	\
+				 S5PV210_UFCON_TXTRIG4 |	\
+				 S5PV210_UFCON_RXTRIG4)
+
+#ifndef __ASSEMBLY__
+
+/* configuration structure for per-machine configurations for the
+ * serial port
+ *
+ * the pointer is setup by the machine specific initialisation from the
+ * arch/arm/mach-s3c2410/ directory.
+*/
+
+struct s3c2410_uartcfg {
+	unsigned char	   hwport;	 /* hardware port number */
+	unsigned char	   unused;
+	unsigned short	   flags;
+	upf_t		   uart_flags;	 /* default uart flags */
+	unsigned int	   clk_sel;
+
+	unsigned int	   has_fracval;
+
+	unsigned long	   ucon;	 /* value of ucon for port */
+	unsigned long	   ulcon;	 /* value of ulcon for port */
+	unsigned long	   ufcon;	 /* value of ufcon for port */
+};
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_ARM_REGS_SERIAL_H */
+
-- 
1.8.1.2

