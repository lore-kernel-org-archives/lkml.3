Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaIUQ2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:28:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43960 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaIUQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:44 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 6/8] tty: crisv32: Coding style cleanup, delete dead code
Date: Sun, 21 Sep 2014 09:27:16 -0700
Message-Id: <1411316838-15135-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/tty/serial/crisv32.c | 1178 ++++++++++++++++++++----------------------
 1 file changed, 567 insertions(+), 611 deletions(-)

diff --git a/drivers/tty/serial/crisv32.c b/drivers/tty/serial/crisv32.c
index a69f131..fa2ab5b 100644
--- a/drivers/tty/serial/crisv32.c
+++ b/drivers/tty/serial/crisv32.c
@@ -1,4 +1,4 @@
-/* $Id: crisv32.c,v 1.109 2010-07-09 15:00:44 jespern Exp $
+/* crisv32.c 1.109 2010-07-09 15:00:44 jespern
  *
  * Serial port driver for the ETRAX FS chip
  *
@@ -21,9 +21,9 @@
 #include <linux/slab.h>
 #include <linux/tty_flip.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <dma.h>
 #include <arch/system.h>
@@ -36,7 +36,7 @@
 #include <hwregs/intr_vect_defs.h>
 #include <hwregs/reg_map.h>
 
-#define UART_NR CONFIG_ETRAX_SERIAL_PORTS + 1 /* Ports + dummy port */
+#define UART_NR	(CONFIG_ETRAX_SERIAL_PORTS + 1)	/* Ports + dummy port */
 #define SERIAL_RECV_DESCRIPTORS 8
 
 /* We only buffer 255 characters here, no need for more tx descriptors. */
@@ -45,13 +45,13 @@
 /* Kept for experimental purposes. */
 #define SERIAL_DESCR_BUF_SIZE 256
 #define regi_NULL 0
-#define DMA_WAIT_UNTIL_RESET(inst)			\
-  do {							\
-	reg_dma_rw_stat r;				\
-	do {						\
-	  	r = REG_RD(dma, (inst), rw_stat);	\
-	} while (r.mode != regk_dma_rst);		\
-  } while (0)
+#define DMA_WAIT_UNTIL_RESET(inst)				\
+	do {							\
+		reg_dma_rw_stat r;				\
+		do {						\
+			r = REG_RD(dma, (inst), rw_stat);	\
+		} while (r.mode != regk_dma_rst);		\
+	} while (0)
 
 #define __DMA(ch) regi_dma##ch
 #define DMA(ch) __DMA(ch)
@@ -60,55 +60,57 @@
 /* Macro to set up control lines for a port. */
 #define SETUP_PINS(port) \
 	if (serial_cris_ports[port].used) { \
-	if (strcmp(CONFIG_ETRAX_SER##port##_DTR_BIT, "")) \
-		crisv32_io_get_name(&serial_cris_ports[port].dtr_pin, \
-				    CONFIG_ETRAX_SER##port##_DTR_BIT); \
-	else \
-		serial_cris_ports[port].dtr_pin = dummy_pin; \
-	if (strcmp(CONFIG_ETRAX_SER##port##_DSR_BIT, "")) \
-		crisv32_io_get_name(&serial_cris_ports[port].dsr_pin, \
-				    CONFIG_ETRAX_SER##port##_DSR_BIT); \
-	else \
-		serial_cris_ports[port].dsr_pin = dummy_pin; \
-	if (strcmp(CONFIG_ETRAX_SER##port##_RI_BIT, "")) \
-		crisv32_io_get_name(&serial_cris_ports[port].ri_pin, \
-				    CONFIG_ETRAX_SER##port##_RI_BIT); \
-	else \
-		serial_cris_ports[port].ri_pin = dummy_pin; \
-	if (strcmp(CONFIG_ETRAX_SER##port##_CD_BIT, "")) \
-		crisv32_io_get_name(&serial_cris_ports[port].cd_pin, \
-				    CONFIG_ETRAX_SER##port##_CD_BIT); \
-	else \
-		serial_cris_ports[port].cd_pin = dummy_pin; \
+		if (strcmp(CONFIG_ETRAX_SER##port##_DTR_BIT, "")) \
+			crisv32_io_get_name(&serial_cris_ports[port].dtr_pin, \
+					    CONFIG_ETRAX_SER##port##_DTR_BIT); \
+		else \
+			serial_cris_ports[port].dtr_pin = dummy_pin; \
+		if (strcmp(CONFIG_ETRAX_SER##port##_DSR_BIT, "")) \
+			crisv32_io_get_name(&serial_cris_ports[port].dsr_pin, \
+					    CONFIG_ETRAX_SER##port##_DSR_BIT); \
+		else \
+			serial_cris_ports[port].dsr_pin = dummy_pin; \
+		if (strcmp(CONFIG_ETRAX_SER##port##_RI_BIT, "")) \
+			crisv32_io_get_name(&serial_cris_ports[port].ri_pin, \
+					    CONFIG_ETRAX_SER##port##_RI_BIT); \
+		else \
+			serial_cris_ports[port].ri_pin = dummy_pin; \
+		if (strcmp(CONFIG_ETRAX_SER##port##_CD_BIT, "")) \
+			crisv32_io_get_name(&serial_cris_ports[port].cd_pin, \
+					    CONFIG_ETRAX_SER##port##_CD_BIT); \
+		else \
+			serial_cris_ports[port].cd_pin = dummy_pin; \
 	}
 
 /* Set a serial port register if anything has changed. */
-#define MODIFY_REG(instance, reg, var)			\
-  if (REG_RD_INT(ser, instance, reg)			\
-      != REG_TYPE_CONV(int, reg_ser_##reg, var))	\
-      REG_WR(ser, instance, reg, var);
+#define MODIFY_REG(instance, reg, var)				\
+	do {							\
+		if (REG_RD_INT(ser, instance, reg) !=		\
+		    REG_TYPE_CONV(int, reg_ser_##reg, var))	\
+			REG_WR(ser, instance, reg, var);	\
+	} while (0)
 
 /*
  * Regarding RS485 operation in crisv32 serial driver.
  * ---------------------------------------------------
  * RS485 can be run in two modes, full duplex using four wires (485FD) and
- * half duplex using two wires (485HD). The default mode of each serial port 
- * is configured in the kernel configuration. The available modes are: 
- * RS-232, RS-485 half duplex, and RS-485 full duplex. 
+ * half duplex using two wires (485HD). The default mode of each serial port
+ * is configured in the kernel configuration. The available modes are:
+ * RS-232, RS-485 half duplex, and RS-485 full duplex.
  *
  * In the 485HD mode the direction of the data bus must be able to switch.
- * The direction of the transceiver is controlled by the RTS signal. Hence 
- * the auto_rts function in the ETRAX FS chip is enabled in this mode, which 
- * automatically toggle RTS when transmitting. The initial direction of the 
+ * The direction of the transceiver is controlled by the RTS signal. Hence
+ * the auto_rts function in the ETRAX FS chip is enabled in this mode, which
+ * automatically toggle RTS when transmitting. The initial direction of the
  * port is receiving.
  *
- * In the 485FD mode two transceivers will be used, one in each direction. 
- * Usually the hardware can handle both 485HD and 485FD, which implies that 
- * one of the transceivers can change direction. Consequently that transceiver 
+ * In the 485FD mode two transceivers will be used, one in each direction.
+ * Usually the hardware can handle both 485HD and 485FD, which implies that
+ * one of the transceivers can change direction. Consequently that transceiver
  * must be tied to operate in the opposite direction of the other one, setting
  * and keeping RTS to a fixed value do this.
  *
- * There are two special "ioctl" that can configure the ports. These two are 
+ * There are two special "ioctl" that can configure the ports. These two are
  * left for backward compatible with older applications. The effects of using
  * them are described below:
  * The TIOCSERSETRS485:
@@ -137,297 +139,286 @@ struct etrax_recv_buffer {
 };
 
 struct uart_cris_port {
-	struct uart_port	port;
+	struct uart_port port;
 
 	int initialized;
 	int used;
 	int irq;
 
 	/* Used to check if port enabled as well by testing for zero. */
-	reg_scope_instances	regi_ser;
-	reg_scope_instances	regi_dmain;
-	reg_scope_instances	regi_dmaout;
-
-	struct crisv32_iopin    dtr_pin;
-	struct crisv32_iopin    dsr_pin;
-	struct crisv32_iopin    ri_pin;
-	struct crisv32_iopin    cd_pin;
-
-	struct dma_descr_context tr_context_descr
-		__attribute__ ((__aligned__(32)));
-	struct dma_descr_data	 tr_descr[SERIAL_TX_DESCRIPTORS]
-		__attribute__ ((__aligned__(32)));
-  	struct dma_descr_context rec_context_descr
-		__attribute__ ((__aligned__(32)));
-	struct dma_descr_data	 rec_descr[SERIAL_RECV_DESCRIPTORS]
-		__attribute__ ((__aligned__(32)));
+	reg_scope_instances regi_ser;
+	reg_scope_instances regi_dmain;
+	reg_scope_instances regi_dmaout;
+
+	struct crisv32_iopin dtr_pin;
+	struct crisv32_iopin dsr_pin;
+	struct crisv32_iopin ri_pin;
+	struct crisv32_iopin cd_pin;
+
+	struct dma_descr_context tr_context_descr __aligned(32);
+	struct dma_descr_data tr_descr[SERIAL_TX_DESCRIPTORS] __aligned(32);
+	struct dma_descr_context rec_context_descr __aligned(32);
+	struct dma_descr_data rec_descr[SERIAL_RECV_DESCRIPTORS] __aligned(32);
 
 	/* This is the first one in the list the HW is working on now. */
-	struct dma_descr_data*   first_tx_descr;
+	struct dma_descr_data *first_tx_descr;
 
 	/* This is the last one in the list the HW is working on now. */
-	struct dma_descr_data*   last_tx_descr;
+	struct dma_descr_data *last_tx_descr;
 
 	/* This is how many characters the HW is working on now. */
-	unsigned int		 tx_pending_chars;
+	unsigned int tx_pending_chars;
 
-	int			 tx_started;
-	unsigned int		 cur_rec_descr;
+	int tx_started;
+	unsigned int cur_rec_descr;
 	struct etrax_recv_buffer *first_recv_buffer;
 	struct etrax_recv_buffer *last_recv_buffer;
 
-	unsigned int		recv_cnt;
-	unsigned int		max_recv_cnt;
+	unsigned int recv_cnt;
+	unsigned int max_recv_cnt;
 
 	/* The time for 1 char, in usecs. */
-	unsigned long		char_time_usec;
+	unsigned long char_time_usec;
 
 	/* Last tx usec in the jiffies. */
-	unsigned long		last_tx_active_usec;
+	unsigned long last_tx_active_usec;
 
 	/* Last tx time in jiffies. */
-	unsigned long		last_tx_active;
+	unsigned long last_tx_active;
 
 	/* Last rx usec in the jiffies. */
-	unsigned long		last_rx_active_usec;
+	unsigned long last_rx_active_usec;
 
 	/* Last rx time in jiffies. */
-	unsigned long		last_rx_active;
+	unsigned long last_rx_active;
 
 #ifdef CONFIG_ETRAX_RS485
 	/* RS-485 support, duh. */
-	struct rs485_control	rs485;
+	struct rs485_control rs485;
 #endif
-	int			port_type;
-	int			write_ongoing;
+	int port_type;
+	int write_ongoing;
 };
 
-extern struct uart_driver serial_cris_driver;
+static struct uart_driver serial_cris_driver;
 static struct uart_port *console_port;
 static int console_baud = 115200;
 static struct uart_cris_port serial_cris_ports[UART_NR] = {
-{
+	{
 #ifdef CONFIG_ETRAX_SERIAL_PORT0
-	.used        = 1,
-	.irq         = SER0_INTR_VECT,
-	.regi_ser    = regi_ser0,
-	/*
-	 * We initialize the dma stuff like this to get a compiler error
-	 * if a CONFIG is missing
-	 */
-	.regi_dmain  =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
-	               regi_dma7,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT0_DMA1_IN)
-                       regi_dma1,
-#  elif defined CONFIG_ETRAX_SERIAL_PORT0_NO_DMA_IN
-	               regi_NULL,
-#  endif
-
-	.regi_dmaout =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
-	               regi_dma6,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT0_DMA7_OUT)
-		       regi_dma7,
-#  else
-	               regi_NULL,
-#  endif
-
-#  ifdef CONFIG_ETRAX_RS485
-#    ifdef CONFIG_ETRAX_SERIAL_PORT0_TYPE_485HD
-	.port_type = TYPE_485HD,
-#    endif
-#    ifdef CONFIG_ETRAX_SERIAL_PORT0_TYPE_485FD
-	.port_type = TYPE_485FD,
-#    endif
-#  endif
+	 .used = 1,
+	 .irq = SER0_INTR_VECT,
+	 .regi_ser = regi_ser0,
+	 /*
+	  * We initialize the dma stuff like this to get a compiler error
+	  * if a CONFIG is missing
+	  */
+	 .regi_dmain =
+#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
+	 regi_dma7,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT0_DMA1_IN)
+	 regi_dma1,
+#elif defined CONFIG_ETRAX_SERIAL_PORT0_NO_DMA_IN
+	 regi_NULL,
+#endif
+
+	 .regi_dmaout =
+#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
+	 regi_dma6,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT0_DMA7_OUT)
+	 regi_dma7,
 #else
-	.regi_ser    = regi_NULL,
-	.regi_dmain  = regi_NULL,
-	.regi_dmaout = regi_NULL,
+	 regi_NULL,
 #endif
-	.write_ongoing = 0
-},  /* ttyS0 */
-{
+
+#ifdef CONFIG_ETRAX_RS485
+#ifdef CONFIG_ETRAX_SERIAL_PORT0_TYPE_485HD
+	 .port_type = TYPE_485HD,
+#endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT0_TYPE_485FD
+	 .port_type = TYPE_485FD,
+#endif
+#endif
+#else
+	 .regi_ser = regi_NULL,
+	 .regi_dmain = regi_NULL,
+	 .regi_dmaout = regi_NULL,
+#endif
+	 .write_ongoing = 0},	/* ttyS0 */
+	{
 #ifdef CONFIG_ETRAX_SERIAL_PORT1
-	.used        = 1,
-	.irq         = SER1_INTR_VECT,
-	.regi_ser    = regi_ser1,
-	.regi_dmain  =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA5_IN
-	               regi_dma5,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT1_NO_DMA_IN)
-	               regi_NULL,
-#  endif
-
-	.regi_dmaout =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA4_OUT
-	               regi_dma4,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT1_NO_DMA_OUT)
-	               regi_NULL,
-#  endif
-
-#  ifdef CONFIG_ETRAX_RS485
-#    ifdef CONFIG_ETRAX_SERIAL_PORT1_TYPE_485HD
-	.port_type = TYPE_485HD,
-#    endif
-#    ifdef CONFIG_ETRAX_SERIAL_PORT1_TYPE_485FD
-	.port_type = TYPE_485FD,
-#    endif
-#  endif
+	 .used = 1,
+	 .irq = SER1_INTR_VECT,
+	 .regi_ser = regi_ser1,
+	 .regi_dmain =
+#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA5_IN
+	 regi_dma5,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT1_NO_DMA_IN)
+	 regi_NULL,
+#endif
+
+	 .regi_dmaout =
+#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA4_OUT
+	 regi_dma4,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT1_NO_DMA_OUT)
+	 regi_NULL,
+#endif
+
+#ifdef CONFIG_ETRAX_RS485
+#ifdef CONFIG_ETRAX_SERIAL_PORT1_TYPE_485HD
+	 .port_type = TYPE_485HD,
+#endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT1_TYPE_485FD
+	 .port_type = TYPE_485FD,
+#endif
+#endif
 #else
-	.regi_ser    = regi_NULL,
-	.regi_dmain  = regi_NULL,
-	.regi_dmaout = regi_NULL,
+	 .regi_ser = regi_NULL,
+	 .regi_dmain = regi_NULL,
+	 .regi_dmaout = regi_NULL,
 #endif
-	.write_ongoing = 0
-},  /* ttyS1 */
-{
+	 .write_ongoing = 0},	/* ttyS1 */
+	{
 #ifdef CONFIG_ETRAX_SERIAL_PORT2
-	.used       = 1,
-	.irq        = SER2_INTR_VECT,
-	.regi_ser    = regi_ser2,
-	.regi_dmain  =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
-	               regi_dma3,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT2_DMA7_IN)
-	               regi_dma7,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_IN)
-	               regi_NULL,
-#  endif
+	 .used = 1,
+	 .irq = SER2_INTR_VECT,
+	 .regi_ser = regi_ser2,
+	 .regi_dmain =
+#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
+	 regi_dma3,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT2_DMA7_IN)
+	 regi_dma7,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_IN)
+	 regi_NULL,
+#endif
 
 	 .regi_dmaout =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT
-	               regi_dma2,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT2_DMA6_OUT)
-	               regi_dma6,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_OUT)
-	               regi_NULL,
-#  endif
-
-#  ifdef CONFIG_ETRAX_RS485
-#    ifdef CONFIG_ETRAX_SERIAL_PORT2_TYPE_485HD
-	.port_type = TYPE_485HD,
-#    endif
-#    ifdef CONFIG_ETRAX_SERIAL_PORT2_TYPE_485FD
-	.port_type = TYPE_485FD,
-#    endif
-#  endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT
+	 regi_dma2,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT2_DMA6_OUT)
+	 regi_dma6,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_OUT)
+	 regi_NULL,
+#endif
+
+#ifdef CONFIG_ETRAX_RS485
+#ifdef CONFIG_ETRAX_SERIAL_PORT2_TYPE_485HD
+	 .port_type = TYPE_485HD,
+#endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT2_TYPE_485FD
+	 .port_type = TYPE_485FD,
+#endif
+#endif
 #else
-	.regi_ser    = regi_NULL,
-	.regi_dmain  = regi_NULL,
-	.regi_dmaout = regi_NULL,
+	 .regi_ser = regi_NULL,
+	 .regi_dmain = regi_NULL,
+	 .regi_dmaout = regi_NULL,
 #endif
-	.write_ongoing = 0
-},  /* ttyS2 */
-{
+	 .write_ongoing = 0},	/* ttyS2 */
+	{
 #ifdef CONFIG_ETRAX_SERIAL_PORT3
-	.used       = 1,
-	.irq        = SER3_INTR_VECT,
-	.regi_ser    = regi_ser3,
-	.regi_dmain  =
-#  ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA9_IN
-	               regi_dma9,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT3_DMA4_IN)
-	               regi_dma3,
-#  else
-	               regi_NULL,
-#  endif
-
-	 .regi_dmaout = 
-#  ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA8_OUT
-	               regi_dma8,
-#  elif defined(CONFIG_ETRAX_SERIAL_PORT3_DMA2_OUT)
-	               regi_dma2,
-#  else
-	               regi_NULL,
-#  endif
-#  ifdef CONFIG_ETRAX_RS485
-#    ifdef CONFIG_ETRAX_SERIAL_PORT3_TYPE_485HD
-	.port_type = TYPE_485HD,
-#    endif
-#    ifdef CONFIG_ETRAX_SERIAL_PORT3_TYPE_485FD
-	.port_type = TYPE_485FD,
-#    endif
-#  endif
+	 .used = 1,
+	 .irq = SER3_INTR_VECT,
+	 .regi_ser = regi_ser3,
+	 .regi_dmain =
+#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA9_IN
+	 regi_dma9,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT3_DMA4_IN)
+	 regi_dma3,
 #else
-	.regi_ser    = regi_NULL,
-	.regi_dmain  = regi_NULL,
-	.regi_dmaout = regi_NULL,
+	 regi_NULL,
 #endif
-	.write_ongoing = 0
-},  /* ttyS3 */
+
+	 .regi_dmaout =
+#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA8_OUT
+	 regi_dma8,
+#elif defined(CONFIG_ETRAX_SERIAL_PORT3_DMA2_OUT)
+	 regi_dma2,
+#else
+	 regi_NULL,
+#endif
+#ifdef CONFIG_ETRAX_RS485
+#ifdef CONFIG_ETRAX_SERIAL_PORT3_TYPE_485HD
+	 .port_type = TYPE_485HD,
+#endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT3_TYPE_485FD
+	 .port_type = TYPE_485FD,
+#endif
+#endif
+#else
+	 .regi_ser = regi_NULL,
+	 .regi_dmain = regi_NULL,
+	 .regi_dmaout = regi_NULL,
+#endif
+	 .write_ongoing = 0},	/* ttyS3 */
 #if CONFIG_ETRAX_SERIAL_PORTS == 5
-{ 
+	{
 #ifdef CONFIG_ETRAX_SERIAL_PORT4
-	.used       = 1,
-	.irq        = SER4_INTR_VECT,
-	.regi_ser    = regi_ser4,
-	.regi_dmain  = 
-#  ifdef CONFIG_ETRAX_SERIAL_PORT4_DMA9_IN
-	               regi_dma9,
-#  else
-	               regi_NULL,
-#  endif
+	 .used = 1,
+	 .irq = SER4_INTR_VECT,
+	 .regi_ser = regi_ser4,
+	 .regi_dmain =
+#ifdef CONFIG_ETRAX_SERIAL_PORT4_DMA9_IN
+	 regi_dma9,
+#else
+	 regi_NULL,
+#endif
 
 	 .regi_dmaout = regi_NULL,
-#  ifdef CONFIG_ETRAX_RS485
-#    ifdef CONFIG_ETRAX_SERIAL_PORT4_TYPE_485HD
-	.port_type = TYPE_485HD,
-#    endif
-#    ifdef CONFIG_ETRAX_SERIAL_PORT4_TYPE_485FD
-	.port_type = TYPE_485FD,
-#    endif
-#  endif
+#ifdef CONFIG_ETRAX_RS485
+#ifdef CONFIG_ETRAX_SERIAL_PORT4_TYPE_485HD
+	 .port_type = TYPE_485HD,
+#endif
+#ifdef CONFIG_ETRAX_SERIAL_PORT4_TYPE_485FD
+	 .port_type = TYPE_485FD,
+#endif
+#endif
 #else
-	.regi_ser    = regi_NULL,
-	.regi_dmain  = regi_NULL,
-	.regi_dmaout = regi_NULL,
+	 .regi_ser = regi_NULL,
+	 .regi_dmain = regi_NULL,
+	 .regi_dmaout = regi_NULL,
 #endif
-	.write_ongoing = 0
-},  /* ttyS4 */
+	 .write_ongoing = 0},	/* ttyS4 */
 #endif
-{
+	{
 #ifdef CONFIG_ETRAX_DEBUG_PORT_NULL
-	.used        = 1,
+	 .used = 1,
 #endif
-	.regi_ser    = regi_NULL,
-	.write_ongoing = 0
-}   /* Dummy console port */
+	 .regi_ser = regi_NULL,
+	 .write_ongoing = 0}	/* Dummy console port */
 
 };
 
 /* Dummy pin used for unused CD, DSR, DTR and RI signals. */
 static unsigned long io_dummy;
-static struct crisv32_ioport dummy_port =
-{
+static struct crisv32_ioport dummy_port = {
 	&io_dummy,
 	&io_dummy,
 	&io_dummy,
 	32
 };
-static struct crisv32_iopin dummy_pin =
-{
+
+static struct crisv32_iopin dummy_pin = {
 	&dummy_port,
 	0
 };
 
 static int selected_console =
 #if defined(CONFIG_ETRAX_DEBUG_PORT0)
-0;
+	0;
 #elif defined(CONFIG_ETRAX_DEBUG_PORT1)
-1;
+	1;
 #elif defined(CONFIG_ETRAX_DEBUG_PORT2)
-2;
+	2;
 #elif defined(CONFIG_ETRAX_DEBUG_PORT3)
-3;
+	3;
 #elif defined(CONFIG_ETRAX_DEBUG_PORT4)
-4;
-#else  /* CONFIG_ETRAX_DEBUG_PORT_NULL */
+	4;
+#else /* CONFIG_ETRAX_DEBUG_PORT_NULL */
 #if CONFIG_ETRAX_SERIAL_PORTS == 5
-5;
+	5;
 #else
-4;
+	4;
 #endif
 #endif
 
@@ -438,7 +429,6 @@ static void serial_cris_stop_rx(struct uart_port *port);
 /*
  * Interrupts are disabled on entering
  */
-#ifndef CONFIG_ETRAX_VCS_SIM
 static void
 cris_console_write(struct console *co, const char *s, unsigned int count)
 {
@@ -458,7 +448,7 @@ cris_console_write(struct console *co, const char *s, unsigned int count)
 		return;
 
 	/* Switch to manual mode. */
-	tr_dma_en = old = REG_RD (ser, up->regi_ser, rw_tr_dma_en);
+	tr_dma_en = old = REG_RD(ser, up->regi_ser, rw_tr_dma_en);
 	if (tr_dma_en.en == regk_ser_yes) {
 		tr_dma_en.en = regk_ser_no;
 		REG_WR(ser, up->regi_ser, rw_tr_dma_en, tr_dma_en);
@@ -469,15 +459,15 @@ cris_console_write(struct console *co, const char *s, unsigned int count)
 		/* LF -> CRLF */
 		if (s[i] == '\n') {
 			do {
-				stat = REG_RD (ser, up->regi_ser, r_stat_din);
+				stat = REG_RD(ser, up->regi_ser, r_stat_din);
 			} while (!stat.tr_rdy);
-			REG_WR_INT (ser, up->regi_ser, rw_dout, '\r');
+			REG_WR_INT(ser, up->regi_ser, rw_dout, '\r');
 		}
 		/* Wait until transmitter is ready and send. */
 		do {
-			stat = REG_RD (ser, up->regi_ser, r_stat_din);
+			stat = REG_RD(ser, up->regi_ser, r_stat_din);
 		} while (!stat.tr_rdy);
-		REG_WR_INT (ser, up->regi_ser, rw_dout, s[i]);
+		REG_WR_INT(ser, up->regi_ser, rw_dout, s[i]);
 
 		/* Feed watchdog, because this may take looong time. */
 		reset_watchdog();
@@ -487,39 +477,9 @@ cris_console_write(struct console *co, const char *s, unsigned int count)
 	if (tr_dma_en.en != old.en)
 		REG_WR(ser, up->regi_ser, rw_tr_dma_en, old);
 }
-#else
-
-extern void print_str( const char *str );
-static char buffer[1024];
-static char msg[] = "Debug: ";
-static int buffer_pos = sizeof(msg) - 1;
-
-static void 
-cris_console_write(struct console *co, const char *buf, unsigned int len)
-{  
-	char* pos;
-	pos = memchr(buf, '\n', len);
-	if (pos) {
-		int l = ++pos - buf;
-		memcpy(buffer + buffer_pos, buf, l);
-		memcpy(buffer, msg, sizeof(msg) - 1);
-		buffer[buffer_pos + l] = '\0';
-		print_str(buffer);
-		buffer_pos = sizeof(msg) - 1;
-		if (pos - buf != len) {
-			memcpy(buffer + buffer_pos, pos, len - l);
-			buffer_pos += len - l;
-		}
-	} else {
-		memcpy(buffer + buffer_pos, buf, len);
-		buffer_pos += len;
-	}
-}
-#endif
 
 static void cris_serial_port_init(struct uart_port *port, int line);
-static int __init
-cris_console_setup(struct console *co, char *options)
+static int __init cris_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
 	int baud = 115200;
@@ -532,7 +492,7 @@ cris_console_setup(struct console *co, char *options)
 	if (options)
 		selected_console = co->index;
 	port = &serial_cris_ports[selected_console].port;
-        console_port = port;
+	console_port = port;
 
 	co->flags |= CON_CONSDEV;
 
@@ -546,8 +506,7 @@ cris_console_setup(struct console *co, char *options)
 	return 0;
 }
 
-static struct tty_driver*
-cris_console_device(struct console* co, int *index)
+static struct tty_driver *cris_console_device(struct console *co, int *index)
 {
 	struct uart_driver *p = co->data;
 	*index = selected_console;
@@ -555,28 +514,26 @@ cris_console_device(struct console* co, int *index)
 }
 
 static struct console cris_console = {
-	.name		= "ttyS",
-	.write		= cris_console_write,
-	.device		= cris_console_device,
-	.setup		= cris_console_setup,
-	.flags		= CON_PRINTBUFFER,
-	.index		= -1,
-	.data		= &serial_cris_driver,
+	.name = "ttyS",
+	.write = cris_console_write,
+	.device = cris_console_device,
+	.setup = cris_console_setup,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+	.data = &serial_cris_driver,
 };
 
-#define SERIAL_CRIS_CONSOLE	&cris_console
-
-struct uart_driver serial_cris_driver = {
-	.owner			= THIS_MODULE,
-	.driver_name		= "serial",
-	.dev_name		= "ttyS",
-	.major			= TTY_MAJOR,
-	.minor			= 64,
-	.nr			= UART_NR,
-	.cons			= SERIAL_CRIS_CONSOLE,
+static struct uart_driver serial_cris_driver = {
+	.owner = THIS_MODULE,
+	.driver_name = "serial",
+	.dev_name = "ttyS",
+	.major = TTY_MAJOR,
+	.minor = 64,
+	.nr = UART_NR,
+	.cons = &cris_console,
 };
 
-static int inline crisv32_serial_get_rts(struct uart_cris_port *up)
+static inline int crisv32_serial_get_rts(struct uart_cris_port *up)
 {
 	reg_scope_instances regi_ser = up->regi_ser;
 	/*
@@ -584,6 +541,7 @@ static int inline crisv32_serial_get_rts(struct uart_cris_port *up)
 	 * what the pin is? (if auto_rts is used it differs during tx)
 	 */
 	reg_ser_r_stat_din rstat = REG_RD(ser, regi_ser, r_stat_din);
+
 	return !(rstat.rts_n == regk_ser_active);
 }
 
@@ -591,14 +549,15 @@ static int inline crisv32_serial_get_rts(struct uart_cris_port *up)
  * A set = 0 means 3.3V on the pin, bitvalue: 0=active, 1=inactive
  *                                            0=0V    , 1=3.3V
  */
-static inline void crisv32_serial_set_rts(struct uart_cris_port *up, int set, int force)
+static inline void crisv32_serial_set_rts(struct uart_cris_port *up, int set,
+					  int force)
 {
 	reg_scope_instances regi_ser = up->regi_ser;
 
 #ifdef CONFIG_ETRAX_RS485
 	/* Never toggle RTS if port is in 485 mode. If port is in 485FD mode we
 	 * do not want to send with the reciever and for 485HD mode auto_rts
-	 * take care of the RTS for us. 
+	 * take care of the RTS for us.
 	 */
 	if (force || !up->rs485.enabled) {
 #else
@@ -609,7 +568,7 @@ static inline void crisv32_serial_set_rts(struct uart_cris_port *up, int set, in
 
 		local_irq_save(flags);
 		rec_ctrl = REG_RD(ser, regi_ser, rw_rec_ctrl);
-                
+
 		if (set)
 			rec_ctrl.rts_n = regk_ser_active;
 		else
@@ -620,10 +579,11 @@ static inline void crisv32_serial_set_rts(struct uart_cris_port *up, int set, in
 }
 
 /* Input */
-static int inline crisv32_serial_get_cts(struct uart_cris_port *up)
+static inline int crisv32_serial_get_cts(struct uart_cris_port *up)
 {
 	reg_scope_instances regi_ser = up->regi_ser;
 	reg_ser_r_stat_din rstat = REG_RD(ser, regi_ser, r_stat_din);
+
 	return (rstat.cts_n == regk_ser_active);
 }
 
@@ -646,9 +606,9 @@ static int inline crisv32_serial_get_cts(struct uart_cris_port *up)
 
 void serial_cris_send_xchar(struct uart_port *port, char ch)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
-	reg_ser_rw_dout dout = { .data = ch };
-	reg_ser_rw_ack_intr ack_intr = { .tr_rdy = regk_ser_yes };
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
+	reg_ser_rw_dout dout = {.data = ch };
+	reg_ser_rw_ack_intr ack_intr = {.tr_rdy = regk_ser_yes };
 	reg_ser_r_stat_din rstat;
 	reg_ser_rw_tr_ctrl prev_tr_ctrl, tr_ctrl;
 	reg_scope_instances regi_ser = up->regi_ser;
@@ -695,8 +655,9 @@ void serial_cris_send_xchar(struct uart_port *port, char ch)
 	 * inhibit transmission of the character.
 	 */
 	if (rstat.xoff_detect) {
-		reg_ser_rw_xoff_clr xoff_clr = { .clr = 1 };
+		reg_ser_rw_xoff_clr xoff_clr = {.clr = 1 };
 		reg_ser_rw_tr_dma_en tr_dma_en;
+
 		REG_WR(ser, regi_ser, rw_xoff_clr, xoff_clr);
 		tr_dma_en = REG_RD(ser, regi_ser, rw_tr_dma_en);
 
@@ -728,23 +689,23 @@ static void transmit_chars_dma(struct uart_cris_port *up);
 
 static void serial_cris_start_tx(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	reg_scope_instances regi_ser = up->regi_ser;
 	reg_ser_rw_tr_ctrl tr_ctrl;
 
 	/* we have already done below if a write is ongoing */
-	if (!up->regi_dmaout && up->write_ongoing) 
+	if (!up->regi_dmaout && up->write_ongoing)
 		return;
 
 #ifdef CONFIG_ETRAX_RS485
-        if (up->rs485.enabled)
-        {
+	if (up->rs485.enabled) {
 		/* If we are in RS-485 mode, we need to toggle RTS and disable
 		 * the receiver before initiating a DMA transfer
 		 */
 
 		if (up->rs485.delay_rts_before_send > 0) {
-			reg_ser_rw_tr_ctrl tr_ctrl = REG_RD(ser, regi_ser, rw_tr_ctrl);
+			reg_ser_rw_tr_ctrl tr_ctrl =
+			    REG_RD(ser, regi_ser, rw_tr_ctrl);
 			tr_ctrl.auto_rts = regk_ser_no;
 			REG_WR(ser, regi_ser, rw_tr_ctrl, tr_ctrl);
 			crisv32_serial_set_rts(up, up->rs485.rts_on_send, 1);
@@ -752,16 +713,16 @@ static void serial_cris_start_tx(struct uart_port *port)
 			tr_ctrl.auto_rts = regk_ser_yes;
 			REG_WR(ser, regi_ser, rw_tr_ctrl, tr_ctrl);
 			crisv32_serial_set_rts(up, !up->rs485.rts_on_send, 1);
-                }
-        }
+		}
+	}
 #endif
-        
+
 	tr_ctrl = REG_RD(ser, regi_ser, rw_tr_ctrl);
 	tr_ctrl.stop = regk_ser_no;
 	REG_WR(ser, regi_ser, rw_tr_ctrl, tr_ctrl);
 	if (!up->regi_dmaout) {
 		reg_ser_rw_intr_mask intr_mask =
-			REG_RD(ser, regi_ser, rw_intr_mask);
+		    REG_RD(ser, regi_ser, rw_intr_mask);
 		intr_mask.tr_rdy = regk_ser_yes;
 		REG_WR(ser, regi_ser, rw_intr_mask, intr_mask);
 		up->write_ongoing = 1;
@@ -770,7 +731,8 @@ static void serial_cris_start_tx(struct uart_port *port)
 		 * We're called possibly to re-enable transmission after it
 		 * has been disabled.  If so, DMA needs to be re-enabled.
 		 */
-		reg_ser_rw_tr_dma_en tr_dma_en = { .en = 1 };
+		reg_ser_rw_tr_dma_en tr_dma_en = {.en = 1 };
+
 		REG_WR(ser, regi_ser, rw_tr_dma_en, tr_dma_en);
 		transmit_chars_dma(up);
 	}
@@ -789,12 +751,12 @@ static void serial_cris_start_tx(struct uart_port *port)
 
 static void serial_cris_stop_tx(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	reg_scope_instances regi_ser = up->regi_ser;
 	reg_ser_rw_tr_ctrl tr_ctrl;
 	reg_ser_rw_intr_mask intr_mask;
-	reg_ser_rw_tr_dma_en tr_dma_en = {0};
-	reg_ser_rw_xoff_clr xoff_clr = {0};
+	reg_ser_rw_tr_dma_en tr_dma_en = { 0 };
+	reg_ser_rw_xoff_clr xoff_clr = { 0 };
 
 	/*
 	 * For the non-DMA case, we'd get a tr_rdy interrupt that we're not
@@ -832,7 +794,7 @@ static void serial_cris_stop_tx(struct uart_port *port)
 
 static void serial_cris_stop_rx(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	reg_scope_instances regi_ser = up->regi_ser;
 	reg_ser_rw_rec_ctrl rec_ctrl = REG_RD(ser, regi_ser, rw_rec_ctrl);
 
@@ -850,10 +812,10 @@ static void check_modem_status(struct uart_cris_port *up)
 
 static unsigned int serial_cris_tx_empty(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned long flags;
 	unsigned int ret;
-	reg_ser_r_stat_din rstat = {0};
+	reg_ser_r_stat_din rstat = { 0 };
 
 	spin_lock_irqsave(&up->port.lock, flags);
 	if (up->regi_dmaout) {
@@ -881,17 +843,18 @@ static unsigned int serial_cris_tx_empty(struct uart_port *port)
 	rstat = REG_RD(ser, up->regi_ser, r_stat_din);
 	ret = rstat.tr_empty ? TIOCSER_TEMT : 0;
 
- done:
+done:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 	return ret;
 }
+
 static unsigned int serial_cris_get_mctrl(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned int ret;
 
 	ret = 0;
-        if (crisv32_serial_get_rts(up))
+	if (crisv32_serial_get_rts(up))
 		ret |= TIOCM_RTS;
 	/* DTR is active low */
 	if (!crisv32_io_rd(&up->dtr_pin))
@@ -912,7 +875,7 @@ static unsigned int serial_cris_get_mctrl(struct uart_port *port)
 
 static void serial_cris_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 
 	crisv32_serial_set_rts(up, mctrl & TIOCM_RTS ? 1 : 0, 0);
 	/* DTR is active low */
@@ -925,7 +888,7 @@ static void serial_cris_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void serial_cris_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned long flags;
 	reg_ser_rw_tr_ctrl tr_ctrl;
 	reg_ser_rw_tr_dma_en tr_dma_en;
@@ -936,7 +899,7 @@ static void serial_cris_break_ctl(struct uart_port *port, int break_state)
 	tr_dma_en = REG_RD(ser, up->regi_ser, rw_tr_dma_en);
 	intr_mask = REG_RD(ser, up->regi_ser, rw_intr_mask);
 
-	if (break_state != 0) { /* Send break */
+	if (break_state != 0) {	/* Send break */
 		/*
 		 * We need to disable DMA (if used) or tr_rdy interrupts if no
 		 * DMA.  No need to make this conditional on use of DMA;
@@ -975,14 +938,13 @@ static void serial_cris_break_ctl(struct uart_port *port, int break_state)
  * possible.
  */
 
-static void
-transmit_chars_dma(struct uart_cris_port *up)
+static void transmit_chars_dma(struct uart_cris_port *up)
 {
 	struct dma_descr_data *descr, *pending_descr, *dmapos;
 	struct dma_descr_data *last_tx_descr;
 	struct circ_buf *xmit = &up->port.state->xmit;
 	unsigned int sentl = 0;
-	reg_dma_rw_ack_intr ack_intr = { .data = regk_dma_yes };
+	reg_dma_rw_ack_intr ack_intr = {.data = regk_dma_yes };
 	reg_dma_rw_stat status;
 	reg_scope_instances regi_dmaout = up->regi_dmaout;
 	unsigned int chars_in_q;
@@ -997,7 +959,7 @@ transmit_chars_dma(struct uart_cris_port *up)
 	 */
 	status = REG_RD(dma, regi_dmaout, rw_stat);
 	if (status.list_state == regk_dma_data_at_eol || !up->tx_started)
-		dmapos = phys_to_virt((int)up->last_tx_descr->next);
+		dmapos = phys_to_virt((int) up->last_tx_descr->next);
 	else
 		dmapos = phys_to_virt(REG_RD_INT(dma, regi_dmaout, rw_data));
 
@@ -1005,8 +967,8 @@ transmit_chars_dma(struct uart_cris_port *up)
 	while (pending_descr != dmapos) {
 		sentl += pending_descr->after - pending_descr->buf;
 		pending_descr->after = pending_descr->buf = NULL;
-		pending_descr = phys_to_virt((int)pending_descr->next);
-        }
+		pending_descr = phys_to_virt((int) pending_descr->next);
+	}
 
 	up->first_tx_descr = pending_descr;
 	last_tx_descr = up->last_tx_descr;
@@ -1043,7 +1005,7 @@ transmit_chars_dma(struct uart_cris_port *up)
 	if (chars_to_send == 0)
 		goto done;
 
-	descr = phys_to_virt((int)last_tx_descr->next);
+	descr = phys_to_virt((int) last_tx_descr->next);
 
 	/*
 	 * We can't send anything if we could make the condition in
@@ -1056,8 +1018,8 @@ transmit_chars_dma(struct uart_cris_port *up)
 		goto done;
 
 	/* Set up the descriptor for output. */
-	descr->buf = (void*)virt_to_phys(xmit->buf + xmit->tail
-					 + up->tx_pending_chars);
+	descr->buf = (void *) virt_to_phys(xmit->buf + xmit->tail
+					   + up->tx_pending_chars);
 	descr->after = descr->buf + chars_to_send;
 	descr->eol = 1;
 	descr->out_eop = 0;
@@ -1079,38 +1041,38 @@ transmit_chars_dma(struct uart_cris_port *up)
 		up->tx_started = 1;
 		up->tr_context_descr.next = 0;
 		up->tr_context_descr.saved_data
-			= (dma_descr_data*)virt_to_phys(descr);
+		    = (dma_descr_data *) virt_to_phys(descr);
 		up->tr_context_descr.saved_data_buf = descr->buf;
 		DMA_START_CONTEXT(regi_dmaout,
 				  virt_to_phys(&up->tr_context_descr));
-        } else
+	} else
 		DMA_CONTINUE_DATA(regi_dmaout);
 
 	/* DMA is now running (hopefully). */
 
- done:
+done:
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
 }
 
-static void
-transmit_chars_no_dma(struct uart_cris_port *up)
+static void transmit_chars_no_dma(struct uart_cris_port *up)
 {
 	int max_count;
 	struct circ_buf *xmit = &up->port.state->xmit;
 
 	reg_scope_instances regi_ser = up->regi_ser;
 	reg_ser_r_stat_din rstat;
-	reg_ser_rw_ack_intr ack_intr = { .tr_rdy = regk_ser_yes };
+	reg_ser_rw_ack_intr ack_intr = {.tr_rdy = regk_ser_yes };
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
 		/* No more to send, so disable the interrupt. */
 		reg_ser_rw_intr_mask intr_mask;
+
 		intr_mask = REG_RD(ser, regi_ser, rw_intr_mask);
 		intr_mask.tr_rdy = 0;
 		intr_mask.tr_empty = 0;
 		REG_WR(ser, regi_ser, rw_intr_mask, intr_mask);
-		up->write_ongoing=0;
+		up->write_ongoing = 0;
 		return;
 	}
 
@@ -1118,10 +1080,11 @@ transmit_chars_no_dma(struct uart_cris_port *up)
 	   exiting the loop.  */
 	max_count = 64;
 	do {
-		reg_ser_rw_dout dout = { .data = xmit->buf[xmit->tail] };
+		reg_ser_rw_dout dout = {.data = xmit->buf[xmit->tail] };
+
 		REG_WR(ser, regi_ser, rw_dout, dout);
 		REG_WR(ser, regi_ser, rw_ack_intr, ack_intr);
-		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE-1);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		up->port.icount.tx++;
 		if (xmit->head == xmit->tail)
 			break;
@@ -1130,16 +1093,16 @@ transmit_chars_no_dma(struct uart_cris_port *up)
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
-} /* transmit_chars_no_dma */
+}				/* transmit_chars_no_dma */
 
-static struct etrax_recv_buffer *
-alloc_recv_buffer(unsigned int size)
+static struct etrax_recv_buffer *alloc_recv_buffer(unsigned int size)
 {
 	struct etrax_recv_buffer *buffer;
 
-	if (!(buffer = kmalloc(sizeof *buffer + size, GFP_ATOMIC)))
+	buffer = kmalloc(sizeof(*buffer) + size, GFP_ATOMIC);
+	if (!buffer)
 		panic("%s: Could not allocate %d bytes buffer\n",
-		      __FUNCTION__, size);
+		      __func__, size);
 
 	buffer->next = NULL;
 	buffer->length = 0;
@@ -1149,8 +1112,7 @@ alloc_recv_buffer(unsigned int size)
 }
 
 static void
-append_recv_buffer(struct uart_cris_port *up,
-		   struct etrax_recv_buffer *buffer)
+append_recv_buffer(struct uart_cris_port *up, struct etrax_recv_buffer *buffer)
 {
 	unsigned long flags;
 
@@ -1188,8 +1150,7 @@ add_char_and_flag(struct uart_cris_port *up, unsigned char data,
 	return 1;
 }
 
-static void
-flush_to_flip_buffer(struct uart_cris_port *up)
+static void flush_to_flip_buffer(struct uart_cris_port *up)
 {
 	struct etrax_recv_buffer *buffer;
 
@@ -1198,9 +1159,9 @@ flush_to_flip_buffer(struct uart_cris_port *up)
 
 	while ((buffer = up->first_recv_buffer)) {
 		unsigned int count = (unsigned int)
-			tty_insert_flip_string(&up->port.state->port,
-					       buffer->buffer,
-					       buffer->length);
+		    tty_insert_flip_string(&up->port.state->port,
+					   buffer->buffer,
+					   buffer->length);
 
 		up->recv_cnt -= count;
 
@@ -1227,12 +1188,11 @@ handle_descr_data(struct uart_cris_port *up, struct dma_descr_data *descr,
 		  unsigned int recvl)
 {
 	struct etrax_recv_buffer *buffer
-		= phys_to_virt((unsigned long)descr->buf) - sizeof *buffer;
+	    = phys_to_virt((unsigned long) descr->buf) - sizeof(*buffer);
 
 	if (up->recv_cnt + recvl > 65536) {
-		printk(KERN_ERR "Too much pending incoming data on %s!"
-		       " Dropping %u bytes.\n", up->port.state->port.tty->name,
-		       recvl);
+		pr_err("Too much pending incoming data on %s! Dropping %u bytes.\n",
+		       up->port.state->port.tty->name, recvl);
 		return 0;
 	}
 
@@ -1243,18 +1203,16 @@ handle_descr_data(struct uart_cris_port *up, struct dma_descr_data *descr,
 	flush_to_flip_buffer(up);
 
 	buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE);
-	descr->buf = (void*)virt_to_phys(buffer->buffer);
+	descr->buf = (void *) virt_to_phys(buffer->buffer);
 	descr->after = descr->buf + SERIAL_DESCR_BUF_SIZE;
 
 	return recvl;
 }
 
-static unsigned int
-handle_all_descr_data(struct uart_cris_port *up)
+static unsigned int handle_all_descr_data(struct uart_cris_port *up)
 {
-	struct dma_descr_data *descr
-		 = &up->rec_descr[(up->cur_rec_descr - 1)
-				  % SERIAL_RECV_DESCRIPTORS];
+	struct dma_descr_data *descr = &up->rec_descr[(up->cur_rec_descr - 1) %
+					SERIAL_RECV_DESCRIPTORS];
 	struct dma_descr_data *prev_descr;
 	unsigned int recvl;
 	unsigned int ret = 0;
@@ -1284,18 +1242,17 @@ handle_all_descr_data(struct uart_cris_port *up)
 		 */
 		barrier();
 		prev_descr->eol = 0;
-		flush_dma_descr(descr,1); // Cache bug workaround
-		flush_dma_descr(prev_descr,0); // Cache bug workaround
+		flush_dma_descr(descr, 1);	/* Cache bug workaround */
+		flush_dma_descr(prev_descr, 0);	/* Cache bug workaround */
 	}
 
 	return ret;
 }
 
-static void
-receive_chars_dma(struct uart_cris_port *up)
+static void receive_chars_dma(struct uart_cris_port *up)
 {
 	reg_ser_r_stat_din rstat;
-	reg_dma_rw_ack_intr ack_intr = {0};
+	reg_dma_rw_ack_intr ack_intr = { 0 };
 
 	/* Acknowledge both dma_descr and dma_eop irq. */
 	ack_intr.data = 1;
@@ -1313,7 +1270,8 @@ receive_chars_dma(struct uart_cris_port *up)
 		 * rs_stat_din register and put the data in buffer manually.
 		 */
 		reg_ser_rs_stat_din stat_din;
-                stat_din = REG_RD(ser, up->regi_ser, rs_stat_din);
+
+		stat_din = REG_RD(ser, up->regi_ser, rs_stat_din);
 
 		if (stat_din.par_err)
 			add_char_and_flag(up, stat_din.data, TTY_PARITY);
@@ -1350,13 +1308,12 @@ void receive_chars_no_dma(struct uart_cris_port *up)
 		icount->rx++;
 
 		if (stat_din.framing_err | stat_din.par_err | stat_din.orun) {
-			if (stat_din.data == 0x00 &&
-                            stat_din.framing_err) {
+			if (stat_din.data == 0x00 && stat_din.framing_err) {
 				/* Most likely a break. */
 				flag = TTY_BREAK;
 				icount->brk++;
 			} else if (stat_din.par_err) {
-			        flag = TTY_PARITY;
+				flag = TTY_PARITY;
 				icount->parity++;
 			} else if (stat_din.orun) {
 				flag = TTY_OVERRUN;
@@ -1371,14 +1328,15 @@ void receive_chars_no_dma(struct uart_cris_port *up)
 		 * If this becomes important, we probably *could* handle this
 		 * gracefully by keeping track of the unhandled character.
 		 */
-                if (!tty_insert_flip_char(&up->port.state->port, stat_din.data, flag))
-			panic("%s: No tty buffer space", __FUNCTION__);
+		if (!tty_insert_flip_char
+		    (&up->port.state->port, stat_din.data, flag))
+			panic("%s: No tty buffer space", __func__);
 		rstat = REG_RD(ser, up->regi_ser, r_stat_din);
 	} while (rstat.dav && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(&up->port.state->port);
 	spin_lock(&up->port.lock);
-} /* receive_chars_no_dma */
+}				/* receive_chars_no_dma */
 
 /*
  * DMA output channel interrupt handler.
@@ -1387,7 +1345,7 @@ void receive_chars_no_dma(struct uart_cris_port *up)
  */
 static irqreturn_t dma_tr_interrupt(int irq, void *dev_id)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)dev_id;
+	struct uart_cris_port *up = (struct uart_cris_port *) dev_id;
 	reg_dma_r_masked_intr masked_intr;
 	reg_scope_instances regi_dmaout;
 	int handled = 0;
@@ -1424,10 +1382,9 @@ static irqreturn_t dma_tr_interrupt(int irq, void *dev_id)
 
 /* DMA input channel interrupt handler. */
 
-static irqreturn_t
-dma_rec_interrupt(int irq, void *dev_id)
+static irqreturn_t dma_rec_interrupt(int irq, void *dev_id)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)dev_id;
+	struct uart_cris_port *up = (struct uart_cris_port *) dev_id;
 	reg_dma_r_masked_intr masked_intr;
 	reg_scope_instances regi_dmain;
 	int handled = 0;
@@ -1453,10 +1410,9 @@ dma_rec_interrupt(int irq, void *dev_id)
 
 /* "Normal" serial port interrupt handler - both rx and tx. */
 
-static irqreturn_t
-ser_interrupt(int irq, void *dev_id)
+static irqreturn_t ser_interrupt(int irq, void *dev_id)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)dev_id;
+	struct uart_cris_port *up = (struct uart_cris_port *) dev_id;
 	reg_scope_instances regi_ser;
 	int handled = 0;
 
@@ -1470,6 +1426,7 @@ ser_interrupt(int irq, void *dev_id)
 
 	if (regi_ser) {
 		reg_ser_r_masked_intr masked_intr;
+
 		masked_intr = REG_RD(ser, regi_ser, r_masked_intr);
 		/*
 		 * Check what interrupts are active before taking
@@ -1489,7 +1446,7 @@ ser_interrupt(int irq, void *dev_id)
 	}
 	spin_unlock(&up->port.lock);
 	return IRQ_RETVAL(handled);
-} /* ser_interrupt */
+}				/* ser_interrupt */
 
 static int start_recv_dma(struct uart_cris_port *up)
 {
@@ -1500,8 +1457,8 @@ static int start_recv_dma(struct uart_cris_port *up)
 	/* Set up the receiving descriptors. */
 	for (i = 0; i < SERIAL_RECV_DESCRIPTORS; i++) {
 		buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE);
-		descr[i].next = (void*)virt_to_phys(&descr[i+1]);
-		descr[i].buf = (void*)virt_to_phys(buffer->buffer);
+		descr[i].next = (void *) virt_to_phys(&descr[i + 1]);
+		descr[i].buf = (void *) virt_to_phys(buffer->buffer);
 		descr[i].after = descr[i].buf + SERIAL_DESCR_BUF_SIZE;
 		descr[i].eol = 0;
 		descr[i].out_eop = 0;
@@ -1513,21 +1470,20 @@ static int start_recv_dma(struct uart_cris_port *up)
 	}
 
 	/* Link the last descriptor to the first. */
-	descr[i-1].next = (void*)virt_to_phys(&descr[0]);
+	descr[i - 1].next = (void *) virt_to_phys(&descr[0]);
 
 	/* And mark it as end of list. */
-	descr[i-1].eol = 1;
+	descr[i - 1].eol = 1;
 
 	/* Start with the first descriptor in the list. */
 	up->cur_rec_descr = 0;
 	up->rec_context_descr.next = 0;
 	up->rec_context_descr.saved_data
-		= (dma_descr_data *)virt_to_phys(&descr[up->cur_rec_descr]);
+	    = (dma_descr_data *) virt_to_phys(&descr[up->cur_rec_descr]);
 	up->rec_context_descr.saved_data_buf = descr[up->cur_rec_descr].buf;
 
 	/* Start the DMA. */
-	DMA_START_CONTEXT(up->regi_dmain,
-			  virt_to_phys(&up->rec_context_descr));
+	DMA_START_CONTEXT(up->regi_dmain, virt_to_phys(&up->rec_context_descr));
 
 	/* Input DMA should be running now. */
 	return 1;
@@ -1543,7 +1499,7 @@ static int serial_artpec_get_poll_char(struct uart_port *port)
 {
 	reg_ser_rs_stat_din stat;
 	reg_ser_rw_ack_intr ack_intr = { 0 };
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 
 	do {
 		stat = REG_RD(ser, up->regi_ser, rs_stat_din);
@@ -1556,25 +1512,24 @@ static int serial_artpec_get_poll_char(struct uart_port *port)
 	return stat.data;
 }
 
-static void serial_artpec_put_poll_char(struct uart_port *port,
-                         		unsigned char c)
+static void serial_artpec_put_poll_char(struct uart_port *port, unsigned char c)
 {
 	reg_ser_r_stat_din stat;
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 
 	do {
-		stat = REG_RD (ser, up->regi_ser, r_stat_din);
+		stat = REG_RD(ser, up->regi_ser, r_stat_din);
 	} while (!stat.tr_rdy);
-	REG_WR_INT (ser, up->regi_ser, rw_dout, c);
+	REG_WR_INT(ser, up->regi_ser, rw_dout, c);
 }
 #endif /* CONFIG_CONSOLE_POLL */
 
 static void start_receive(struct uart_cris_port *up)
 {
 	reg_scope_instances regi_dmain = up->regi_dmain;
-	if (regi_dmain) {
+
+	if (regi_dmain)
 		start_recv_dma(up);
-	}
 }
 
 
@@ -1582,16 +1537,17 @@ static void start_transmitter(struct uart_cris_port *up)
 {
 	int i;
 	reg_scope_instances regi_dmaout = up->regi_dmaout;
+
 	if (regi_dmaout) {
 		for (i = 0; i < SERIAL_TX_DESCRIPTORS; i++) {
 			memset(&up->tr_descr[i], 0, sizeof(up->tr_descr[i]));
 			up->tr_descr[i].eol = 1;
 			up->tr_descr[i].intr = 1;
 			up->tr_descr[i].next = (dma_descr_data *)
-				virt_to_phys(&up->tr_descr[i+1]);
+			    virt_to_phys(&up->tr_descr[i + 1]);
 		}
-		up->tr_descr[i-1].next = (dma_descr_data *)
-			virt_to_phys(&up->tr_descr[0]);
+		up->tr_descr[i - 1].next = (dma_descr_data *)
+		    virt_to_phys(&up->tr_descr[0]);
 		up->first_tx_descr = &up->tr_descr[0];
 
 		/*
@@ -1602,7 +1558,7 @@ static void start_transmitter(struct uart_cris_port *up)
 		 * accidentally working code and data as we'd take a pass over
 		 * the first, unused, descriptor.
 		 */
-		up->last_tx_descr = &up->tr_descr[i-1];
+		up->last_tx_descr = &up->tr_descr[i - 1];
 		up->tx_started = 0;
 		up->tx_pending_chars = 0;
 	}
@@ -1610,12 +1566,12 @@ static void start_transmitter(struct uart_cris_port *up)
 
 static int serial_cris_startup(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned long flags;
-	reg_ser_rw_intr_mask ser_intr_mask = {0};
-	reg_dma_rw_intr_mask dmain_intr_mask = {0};
-	reg_dma_rw_intr_mask dmaout_intr_mask = {0};
-	reg_dma_rw_cfg cfg = {.en = 1};
+	reg_ser_rw_intr_mask ser_intr_mask = { 0 };
+	reg_dma_rw_intr_mask dmain_intr_mask = { 0 };
+	reg_dma_rw_intr_mask dmaout_intr_mask = { 0 };
+	reg_dma_rw_cfg cfg = {.en = 1 };
 	reg_scope_instances regi_dma;
 
 	/* We dont disable interrupts here because request_irq should
@@ -1629,8 +1585,7 @@ static int serial_cris_startup(struct uart_port *port)
 
 	if (port->line == 0) {
 		if (request_irq(SER0_INTR_VECT, ser_interrupt,
-				IRQF_DISABLED, "ser0",
-				&serial_cris_ports[0]))
+				IRQF_DISABLED, "ser0", &serial_cris_ports[0]))
 			panic("irq ser0");
 		/* Port ser0 can use dma6 for tx and dma7 for rx. */
 #ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
@@ -1638,21 +1593,18 @@ static int serial_cris_startup(struct uart_port *port)
 				IRQF_DISABLED, "serial 0 dma tr",
 				&serial_cris_ports[0]))
 			panic("irq ser0txdma");
-		crisv32_request_dma(6, "ser0", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser0);
+		crisv32_request_dma(6, "ser0", DMA_PANIC_ON_ERROR, 0, dma_ser0);
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
 		if (request_irq(DMA7_INTR_VECT, dma_rec_interrupt,
 				IRQF_DISABLED, "serial 0 dma rec",
 				&serial_cris_ports[0]))
 			panic("irq ser0rxdma");
-		crisv32_request_dma(7, "ser0", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser0);
+		crisv32_request_dma(7, "ser0", DMA_PANIC_ON_ERROR, 0, dma_ser0);
 #endif
 	} else if (port->line == 1) {
 		if (request_irq(SER1_INTR_VECT, ser_interrupt,
-				IRQF_DISABLED, "ser1",
-				&serial_cris_ports[1]))
+				IRQF_DISABLED, "ser1", &serial_cris_ports[1]))
 			panic("irq ser1");
 
 		/* Port ser1 can use dma4 for tx and dma5 for rx. */
@@ -1661,21 +1613,18 @@ static int serial_cris_startup(struct uart_port *port)
 				IRQF_DISABLED, "serial 1 dma tr",
 				&serial_cris_ports[1]))
 			panic("irq ser1txdma");
-		crisv32_request_dma(4, "ser1", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser1);
+		crisv32_request_dma(4, "ser1", DMA_PANIC_ON_ERROR, 0, dma_ser1);
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA5_IN
 		if (request_irq(DMA5_INTR_VECT, dma_rec_interrupt,
 				IRQF_DISABLED, "serial 1 dma rec",
 				&serial_cris_ports[1]))
 			panic("irq ser1rxdma");
-		crisv32_request_dma(5, "ser1", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser1);
+		crisv32_request_dma(5, "ser1", DMA_PANIC_ON_ERROR, 0, dma_ser1);
 #endif
 	} else if (port->line == 2) {
 		if (request_irq(SER2_INTR_VECT, ser_interrupt,
-				IRQF_DISABLED, "ser2",
-				&serial_cris_ports[2]))
+				IRQF_DISABLED, "ser2", &serial_cris_ports[2]))
 			panic("irq ser2");
 
 		/* Port ser2 can use dma2 for tx and dma3 for rx. */
@@ -1684,22 +1633,19 @@ static int serial_cris_startup(struct uart_port *port)
 				IRQF_DISABLED, "serial 2 dma tr",
 				&serial_cris_ports[2]))
 			panic("irq ser2txdma");
-		crisv32_request_dma(2, "ser2", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser2);
+		crisv32_request_dma(2, "ser2", DMA_PANIC_ON_ERROR, 0, dma_ser2);
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
 		if (request_irq(DMA3_INTR_VECT, dma_rec_interrupt,
 				IRQF_DISABLED, "serial 2 dma rec",
 				&serial_cris_ports[2]))
 			panic("irq ser2rxdma");
-		crisv32_request_dma(3, "ser2", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser2);
+		crisv32_request_dma(3, "ser2", DMA_PANIC_ON_ERROR, 0, dma_ser2);
 #endif
 	} else if (port->line == 3) {
 		if (request_irq(SER3_INTR_VECT, ser_interrupt,
-				IRQF_DISABLED, "ser3",
-				&serial_cris_ports[3]))
-			panic("irq ser3" );
+				IRQF_DISABLED, "ser3", &serial_cris_ports[3]))
+			panic("irq ser3");
 
 		/* Port ser3 can use dma8 for tx and dma9 for rx. */
 #ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA8_OUT
@@ -1707,40 +1653,35 @@ static int serial_cris_startup(struct uart_port *port)
 				IRQF_DISABLED, "serial 3 dma tr",
 				&serial_cris_ports[3]))
 			panic("irq ser3txdma");
-		crisv32_request_dma(8, "ser3", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser3);
+		crisv32_request_dma(8, "ser3", DMA_PANIC_ON_ERROR, 0, dma_ser3);
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA9_IN
 		if (request_irq(DMA9_INTR_VECT, dma_rec_interrupt,
 				IRQF_DISABLED, "serial 3 dma rec",
 				&serial_cris_ports[3]))
 			panic("irq ser3rxdma");
-		crisv32_request_dma(9, "ser3", DMA_PANIC_ON_ERROR, 0,
-				    dma_ser3);
+		crisv32_request_dma(9, "ser3", DMA_PANIC_ON_ERROR, 0, dma_ser3);
 #endif
 	}
 #if CONFIG_ETRAX_SERIAL_PORTS == 5
 	else if (port->line == 4) {
-		if (request_irq(SER4_INTR_VECT, ser_interrupt, 
-				IRQF_DISABLED, "ser4", 
-				&serial_cris_ports[4]))
-			panic("irq ser4" );
+		if (request_irq(SER4_INTR_VECT, ser_interrupt,
+				IRQF_DISABLED, "ser4", &serial_cris_ports[4]))
+			panic("irq ser4");
 
 #ifdef CONFIG_ETRAX_SERIAL_PORT4_DMA_OUT
-		if (request_irq(DMA4_INTR_VECT, dma_tr_interrupt, 
-				IRQF_DISABLED, "serial 4 dma tr", 
+		if (request_irq(DMA4_INTR_VECT, dma_tr_interrupt,
+				IRQF_DISABLED, "serial 4 dma tr",
 				&serial_cris_ports[4]))
 			panic("irq ser4txdma");
-		crisv32_request_dma(5, "ser4", DMA_PANIC_ON_ERROR, 0, 
-				    dma_ser4);
+		crisv32_request_dma(5, "ser4", DMA_PANIC_ON_ERROR, 0, dma_ser4);
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT4_DMA_IN
-		if (request_irq(DMA5_INTR_VECT, dma_rec_interrupt, 
-				IRQF_DISABLED, "serial 4 dma rec", 
+		if (request_irq(DMA5_INTR_VECT, dma_rec_interrupt,
+				IRQF_DISABLED, "serial 4 dma rec",
 				&serial_cris_ports[4]))
 			panic("irq ser4rxdma");
-		crisv32_request_dma(5, "ser4", DMA_PANIC_ON_ERROR, 0, 
-				    dma_ser4);
+		crisv32_request_dma(5, "ser4", DMA_PANIC_ON_ERROR, 0, dma_ser4);
 #endif
 	}
 #endif
@@ -1754,6 +1695,7 @@ static int serial_cris_startup(struct uart_port *port)
 	regi_dma = up->regi_dmain;
 	if (regi_dma) {
 		reg_dma_rw_ack_intr ack_intr = { 0 };
+
 		DMA_RESET(regi_dma);
 		/* Wait until reset cycle is complete. */
 		DMA_WAIT_UNTIL_RESET(regi_dma);
@@ -1769,6 +1711,7 @@ static int serial_cris_startup(struct uart_port *port)
 	regi_dma = up->regi_dmaout;
 	if (regi_dma) {
 		reg_dma_rw_ack_intr ack_intr = { 0 };
+
 		DMA_RESET(regi_dma);
 		/* Wait until reset cycle is complete. */
 		DMA_WAIT_UNTIL_RESET(regi_dma);
@@ -1801,7 +1744,7 @@ static int serial_cris_startup(struct uart_port *port)
 
 static void serial_cris_shutdown(struct uart_port *port)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -1867,7 +1810,7 @@ static void serial_cris_shutdown(struct uart_port *port)
 		crisv32_free_dma(3);
 		free_irq(DMA3_INTR_VECT, &serial_cris_ports[3]);
 #endif
-	} 
+	}
 #if CONFIG_ETRAX_SERIAL_PORTS == 5
 	else if (port->line == 4) {
 		free_irq(SER4_INTR_VECT, &serial_cris_ports[4]);
@@ -1893,7 +1836,7 @@ static void serial_cris_shutdown(struct uart_port *port)
 		 */
 		for (rb = up->first_recv_buffer; rb != NULL; rb = rb_next) {
 			rb_next = rb->next;
-			kfree (rb);
+			kfree(rb);
 		}
 		up->first_recv_buffer = NULL;
 		up->last_recv_buffer = NULL;
@@ -1903,11 +1846,10 @@ static void serial_cris_shutdown(struct uart_port *port)
 		 * before we shut down the hardware above.
 		 */
 		for (i = 0, descr = up->rec_descr;
-		     i < SERIAL_RECV_DESCRIPTORS;
-		     i++)
+		     i < SERIAL_RECV_DESCRIPTORS; i++)
 			if (descr[i].buf) {
 				rb = phys_to_virt((u32) descr[i].buf)
-				  - sizeof *rb;
+				    - sizeof(*rb);
 				kfree(rb);
 				descr[i].buf = NULL;
 			}
@@ -1919,22 +1861,22 @@ static void serial_cris_shutdown(struct uart_port *port)
 
 static void
 serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
-		        struct ktermios *old)
+			struct ktermios *old)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	unsigned long flags;
 	reg_ser_rw_xoff xoff;
-	reg_ser_rw_xoff_clr xoff_clr = {0};
-	reg_ser_rw_tr_ctrl tx_ctrl = {0};
-	reg_ser_rw_tr_dma_en tx_dma_en = {0};
-	reg_ser_rw_rec_ctrl rx_ctrl = {0};
-	reg_ser_rw_tr_baud_div tx_baud_div = {0};
-	reg_ser_rw_rec_baud_div rx_baud_div = {0};
+	reg_ser_rw_xoff_clr xoff_clr = { 0 };
+	reg_ser_rw_tr_ctrl tx_ctrl = { 0 };
+	reg_ser_rw_tr_dma_en tx_dma_en = { 0 };
+	reg_ser_rw_rec_ctrl rx_ctrl = { 0 };
+	reg_ser_rw_tr_baud_div tx_baud_div = { 0 };
+	reg_ser_rw_rec_baud_div rx_baud_div = { 0 };
 	reg_ser_r_stat_din rstat;
-        int baud;
+	int baud;
 
 	if (old &&
-            termios->c_cflag == old->c_cflag &&
+	    termios->c_cflag == old->c_cflag &&
 	    termios->c_iflag == old->c_iflag)
 		return;
 
@@ -1950,16 +1892,15 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 		tx_ctrl.rts_setup = regk_ser_bits2;
 
 		if (termios->c_cflag & CSTOPB) {
-		        /* 2 stop bits. */
-		        tx_ctrl.rts_delay = regk_ser_del2;
-		}
-		else {
+			/* 2 stop bits. */
+			tx_ctrl.rts_delay = regk_ser_del2;
+		} else {
 			/* 1 stop bits. */
 			tx_ctrl.rts_delay = regk_ser_del1;
 		}
 	} else
 #endif
-	  tx_ctrl.auto_rts = regk_ser_no;
+		tx_ctrl.auto_rts = regk_ser_no;
 	tx_ctrl.txd = 1;
 	tx_ctrl.auto_cts = 0;
 	/* Rx: 8 bit, no/even parity. */
@@ -1973,16 +1914,16 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 
 #ifdef CONFIG_ETRAX_RS485
 	if (up->rs485.enabled && (up->port_type != TYPE_485FD)) {
-#  ifdef CONFIG_ETRAX_RS485_DISABLE_RECEIVER
+#ifdef CONFIG_ETRAX_RS485_DISABLE_RECEIVER
 		rx_ctrl.half_duplex = regk_ser_yes;
-#  endif 
+#endif
 		rx_ctrl.rts_n = up->rs485.rts_after_sent ?
-		  regk_ser_active : regk_ser_inactive;
+		    regk_ser_active : regk_ser_inactive;
 	} else if (up->port_type == TYPE_485FD) {
 		rx_ctrl.rts_n = regk_ser_active;
 	} else
 #endif
-	  rx_ctrl.rts_n = regk_ser_inactive;
+		rx_ctrl.rts_n = regk_ser_inactive;
 
 	/* Common for tx and rx: 8N1. */
 	tx_ctrl.data_bits = regk_ser_bits8;
@@ -2008,7 +1949,7 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * For the console port we keep the original baudrate here.  Not very
 	 * beautiful.
 	 */
-        if ((port != console_port) || old)
+	if ((port != console_port) || old)
 		baud = uart_get_baud_rate(port, termios, old, 0,
 					  port->uartclk / 8);
 	else
@@ -2048,8 +1989,8 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 	} else {
 		if (termios->c_cflag & PARODD) {
 			/* Set odd parity. */
-		       tx_ctrl.par = regk_ser_odd;
-		       rx_ctrl.par = regk_ser_odd;
+			tx_ctrl.par = regk_ser_odd;
+			rx_ctrl.par = regk_ser_odd;
 		}
 	}
 
@@ -2094,7 +2035,7 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Actually write the control regs (if modified) to the hardware. */
 
-	uart_update_timeout(port, termios->c_cflag, port->uartclk/8);
+	uart_update_timeout(port, termios->c_cflag, port->uartclk / 8);
 	MODIFY_REG(up->regi_ser, rw_rec_baud_div, rx_baud_div);
 	MODIFY_REG(up->regi_ser, rw_rec_ctrl, rx_ctrl);
 
@@ -2126,8 +2067,7 @@ serial_cris_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-static const char *
-serial_cris_type(struct uart_port *port)
+static const char *serial_cris_type(struct uart_port *port)
 {
 	return "CRISv32";
 }
@@ -2143,13 +2083,15 @@ static int serial_cris_request_port(struct uart_port *port)
 
 static void serial_cris_config_port(struct uart_port *port, int flags)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
+
 	up->port.type = PORT_CRIS;
 }
 
 #if defined(CONFIG_ETRAX_RS485)
 
-static void cris_set_rs485_mode(struct uart_cris_port* up) {
+static void cris_set_rs485_mode(struct uart_cris_port *up)
+{
 	reg_ser_rw_tr_ctrl tr_ctrl;
 	reg_ser_rw_rec_ctrl rec_ctrl;
 	reg_scope_instances regi_ser = up->regi_ser;
@@ -2165,7 +2107,7 @@ static void cris_set_rs485_mode(struct uart_cris_port* up) {
 	if (up->rs485.enabled) {
 		tr_ctrl.auto_rts = regk_ser_yes;
 		rec_ctrl.rts_n = up->rs485.rts_after_sent ?
-		  regk_ser_active : regk_ser_inactive;
+		    regk_ser_active : regk_ser_inactive;
 	}
 	/* Set port to RS-232 mode */
 	else {
@@ -2179,8 +2121,7 @@ static void cris_set_rs485_mode(struct uart_cris_port* up) {
 }
 
 /* Enable/disable RS-485 mode on selected port. */
-static int
-cris_enable_rs485(struct uart_cris_port* up, struct rs485_control *r)
+static int cris_enable_rs485(struct uart_cris_port *up, struct rs485_control *r)
 {
 	if (up->port_type == TYPE_485FD)
 		/* Port in 485FD mode can not chage mode */
@@ -2190,9 +2131,9 @@ cris_enable_rs485(struct uart_cris_port* up, struct rs485_control *r)
 	up->rs485.rts_on_send = 0x01 & r->rts_on_send;
 	up->rs485.rts_after_sent = 0x01 & r->rts_after_sent;
 	up->rs485.delay_rts_before_send = r->delay_rts_before_send;
-	
+
 	cris_set_rs485_mode(up);
- out:
+out:
 	return 0;
 }
 
@@ -2201,7 +2142,7 @@ cris_enable_rs485(struct uart_cris_port* up, struct rs485_control *r)
  * in 485 mode after the data has been sent.
  */
 static int
-cris_write_rs485(struct uart_cris_port *up, const unsigned char* buf, int count)
+cris_write_rs485(struct uart_cris_port *up, const unsigned char *buf, int count)
 {
 	up->rs485.enabled = 1;
 
@@ -2209,7 +2150,9 @@ cris_write_rs485(struct uart_cris_port *up, const unsigned char* buf, int count)
 	cris_set_rs485_mode(up);
 
 	/* Send the data */
-	count = serial_cris_driver.tty_driver->ops->write(up->port.state->port.tty, buf, count);
+	count =
+	    serial_cris_driver.tty_driver->ops->write(up->port.state->port.tty,
+						      buf, count);
 
 	return count;
 }
@@ -2217,73 +2160,82 @@ cris_write_rs485(struct uart_cris_port *up, const unsigned char* buf, int count)
 #endif /* CONFIG_ETRAX_RS485 */
 
 static int serial_cris_ioctl(struct uart_port *port, unsigned int cmd,
-                             unsigned long arg)
+			     unsigned long arg)
 {
 #if defined(CONFIG_ETRAX_RS485)
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 
 	switch (cmd) {
-	case TIOCSRS485: {
-		struct serial_rs485 in;
-		struct rs485_control rs485ctrl;
-		if (copy_from_user(&in, (struct serial_rs485 *)cmd,
-				   sizeof(rs485ctrl)))
-			return -EFAULT;
-		rs485ctrl.rts_on_send = in.flags & SER_RS485_RTS_ON_SEND;
-		rs485ctrl.rts_after_sent = in.flags & SER_RS485_RTS_AFTER_SEND;
-		rs485ctrl.enabled = in.flags & SER_RS485_ENABLED;
-		rs485ctrl.delay_rts_before_send = in.delay_rts_before_send;
-
-		return cris_enable_rs485(up, &rs485ctrl);
-	}
+	case TIOCSRS485:{
+			struct serial_rs485 in;
+			struct rs485_control rs485ctrl;
+
+			if (copy_from_user(&in, (struct serial_rs485 *) cmd,
+					   sizeof(rs485ctrl)))
+				return -EFAULT;
+			rs485ctrl.rts_on_send =
+			    in.flags & SER_RS485_RTS_ON_SEND;
+			rs485ctrl.rts_after_sent =
+			    in.flags & SER_RS485_RTS_AFTER_SEND;
+			rs485ctrl.enabled = in.flags & SER_RS485_ENABLED;
+			rs485ctrl.delay_rts_before_send =
+			    in.delay_rts_before_send;
+
+			return cris_enable_rs485(up, &rs485ctrl);
+		}
 
-	case TIOCSERSETRS485: {
-		struct rs485_control rs485ctrl;
-		if (copy_from_user(&rs485ctrl, (struct rs485_control*) arg,
-				   sizeof(rs485ctrl)))
-			return -EFAULT;
+	case TIOCSERSETRS485:{
+			struct rs485_control rs485ctrl;
 
-		return cris_enable_rs485(up, &rs485ctrl);
-	}
+			if (copy_from_user
+			    (&rs485ctrl, (struct rs485_control *) arg,
+			     sizeof(rs485ctrl)))
+				return -EFAULT;
 
-	case TIOCSERWRRS485: {
-		struct rs485_write rs485wr;
-		if (copy_from_user(&rs485wr, (struct rs485_write*)arg,
-				   sizeof(rs485wr)))
-			return -EFAULT;
+			return cris_enable_rs485(up, &rs485ctrl);
+		}
 
-		return cris_write_rs485(up, rs485wr.outc, rs485wr.outc_size);
-	}
+	case TIOCSERWRRS485:{
+			struct rs485_write rs485wr;
 
-	case TIOCSERSETRS485FD: {
-		reg_scope_instances regi_ser = up->regi_ser;
-		reg_ser_rw_rec_ctrl rec_ctrl = REG_RD(ser, regi_ser, rw_rec_ctrl);
+			if (copy_from_user(&rs485wr, (struct rs485_write *) arg,
+					   sizeof(rs485wr)))
+				return -EFAULT;
 
-		if (arg)
-			rec_ctrl.half_duplex = regk_ser_no;
-		else
-			rec_ctrl.half_duplex = regk_ser_yes;
+			return cris_write_rs485(up, rs485wr.outc,
+						rs485wr.outc_size);
+		}
 
-		REG_WR(ser, regi_ser, rw_rec_ctrl, rec_ctrl);
-		return 0;
-	}
+	case TIOCSERSETRS485FD:{
+			reg_scope_instances regi_ser = up->regi_ser;
+			reg_ser_rw_rec_ctrl rec_ctrl =
+			    REG_RD(ser, regi_ser, rw_rec_ctrl);
+
+			if (arg)
+				rec_ctrl.half_duplex = regk_ser_no;
+			else
+				rec_ctrl.half_duplex = regk_ser_yes;
 
-	case TIOCSERSETDIVISOR: {
-		reg_ser_rw_tr_baud_div tx_baud_div = {0};
-		reg_ser_rw_rec_baud_div rx_baud_div = {0};
+			REG_WR(ser, regi_ser, rw_rec_ctrl, rec_ctrl);
+			return 0;
+		}
 
-		/* divisor must be >= 8 */
-		if (arg < 8) 
-			return -EINVAL;
+	case TIOCSERSETDIVISOR:{
+			reg_ser_rw_tr_baud_div tx_baud_div = { 0 };
+			reg_ser_rw_rec_baud_div rx_baud_div = { 0 };
 
-		tx_baud_div.div = arg;
-		rx_baud_div.div = tx_baud_div.div; /* same as tx. */
+			/* divisor must be >= 8 */
+			if (arg < 8)
+				return -EINVAL;
 
-		MODIFY_REG(up->regi_ser, rw_rec_baud_div, rx_baud_div);
-		MODIFY_REG(up->regi_ser, rw_tr_baud_div, tx_baud_div);
+			tx_baud_div.div = arg;
+			rx_baud_div.div = tx_baud_div.div; /* same as tx. */
 
-		return 0;
-	}
+			MODIFY_REG(up->regi_ser, rw_rec_baud_div, rx_baud_div);
+			MODIFY_REG(up->regi_ser, rw_tr_baud_div, tx_baud_div);
+
+			return 0;
+		}
 
 	default:
 		return -ENOIOCTLCMD;
@@ -2296,23 +2248,23 @@ static int serial_cris_ioctl(struct uart_port *port, unsigned int cmd,
 }
 
 static const struct uart_ops serial_cris_pops = {
-	.tx_empty	= serial_cris_tx_empty,
-	.set_mctrl	= serial_cris_set_mctrl,
-	.get_mctrl	= serial_cris_get_mctrl,
-	.stop_tx	= serial_cris_stop_tx,
-	.start_tx	= serial_cris_start_tx,
-	.send_xchar	= serial_cris_send_xchar,
-	.stop_rx	= serial_cris_stop_rx,
-	.enable_ms	= serial_cris_enable_ms,
-	.break_ctl	= serial_cris_break_ctl,
-	.startup	= serial_cris_startup,
-	.shutdown	= serial_cris_shutdown,
-	.set_termios	= serial_cris_set_termios,
-	.type		= serial_cris_type,
-	.release_port	= serial_cris_release_port,
-	.request_port	= serial_cris_request_port,
-	.config_port	= serial_cris_config_port,
-	.ioctl		= serial_cris_ioctl,
+	.tx_empty = serial_cris_tx_empty,
+	.set_mctrl = serial_cris_set_mctrl,
+	.get_mctrl = serial_cris_get_mctrl,
+	.stop_tx = serial_cris_stop_tx,
+	.start_tx = serial_cris_start_tx,
+	.send_xchar = serial_cris_send_xchar,
+	.stop_rx = serial_cris_stop_rx,
+	.enable_ms = serial_cris_enable_ms,
+	.break_ctl = serial_cris_break_ctl,
+	.startup = serial_cris_startup,
+	.shutdown = serial_cris_shutdown,
+	.set_termios = serial_cris_set_termios,
+	.type = serial_cris_type,
+	.release_port = serial_cris_release_port,
+	.request_port = serial_cris_request_port,
+	.config_port = serial_cris_config_port,
+	.ioctl = serial_cris_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial_artpec_get_poll_char,
 	.poll_put_char = serial_artpec_put_poll_char,
@@ -2350,8 +2302,9 @@ static void serial_cris_stop_tx_dummy(struct uart_port *port)
 static void serial_cris_start_tx_dummy(struct uart_port *port)
 {
 	/* Discard outbound characters. */
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	struct circ_buf *xmit = &up->port.state->xmit;
+
 	xmit->tail = xmit->head;
 	uart_write_wakeup(port);
 }
@@ -2360,8 +2313,7 @@ static void serial_cris_start_tx_dummy(struct uart_port *port)
 
 #define serial_cris_enable_ms_dummy serial_cris_stop_tx_dummy
 
-static void serial_cris_break_ctl_dummy(struct uart_port *port,
-					int break_state)
+static void serial_cris_break_ctl_dummy(struct uart_port *port, int break_state)
 {
 }
 
@@ -2389,34 +2341,34 @@ static const struct uart_ops serial_cris_dummy_pops = {
 	 * For the ones we don't define here, the default (usually meaning
 	 * "unimplemented") makes sense.
 	 */
-	.tx_empty	= serial_cris_tx_empty_dummy,
-	.set_mctrl	= serial_cris_set_mctrl_dummy,
-	.get_mctrl	= serial_cris_get_mctrl_dummy,
-	.stop_tx	= serial_cris_stop_tx_dummy,
-	.start_tx	= serial_cris_start_tx_dummy,
-	.stop_rx	= serial_cris_stop_rx_dummy,
-	.enable_ms	= serial_cris_enable_ms_dummy,
-	.break_ctl	= serial_cris_break_ctl_dummy,
-	.startup	= serial_cris_startup_dummy,
-	.shutdown	= serial_cris_shutdown_dummy,
-	.set_termios	= serial_cris_set_termios_dummy,
+	.tx_empty = serial_cris_tx_empty_dummy,
+	.set_mctrl = serial_cris_set_mctrl_dummy,
+	.get_mctrl = serial_cris_get_mctrl_dummy,
+	.stop_tx = serial_cris_stop_tx_dummy,
+	.start_tx = serial_cris_start_tx_dummy,
+	.stop_rx = serial_cris_stop_rx_dummy,
+	.enable_ms = serial_cris_enable_ms_dummy,
+	.break_ctl = serial_cris_break_ctl_dummy,
+	.startup = serial_cris_startup_dummy,
+	.shutdown = serial_cris_shutdown_dummy,
+	.set_termios = serial_cris_set_termios_dummy,
 
 	/* This one we keep the same. */
-	.type		= serial_cris_type,
+	.type = serial_cris_type,
 
-	.release_port	= serial_cris_release_port_dummy,
-	.request_port	= serial_cris_request_port_dummy,
+	.release_port = serial_cris_release_port_dummy,
+	.request_port = serial_cris_request_port_dummy,
 
 	/*
 	 * This one we keep the same too, as long as it doesn't do
 	 * anything else but to set the type.
 	 */
-	.config_port	= serial_cris_config_port,
+	.config_port = serial_cris_config_port,
 };
 
 static void cris_serial_port_init(struct uart_port *port, int line)
 {
-	struct uart_cris_port *up = (struct uart_cris_port *)port;
+	struct uart_cris_port *up = (struct uart_cris_port *) port;
 	static int first = 1;
 
 	if (up->initialized)
@@ -2425,8 +2377,7 @@ static void cris_serial_port_init(struct uart_port *port, int line)
 	port->line = line;
 	spin_lock_init(&port->lock);
 	port->ops =
-		up->regi_ser == 0 ? &serial_cris_dummy_pops :
-		&serial_cris_pops;
+	    up->regi_ser == 0 ? &serial_cris_dummy_pops : &serial_cris_pops;
 	port->irq = up->irq;
 	port->iobase = up->regi_ser ? up->regi_ser : 1;
 	port->uartclk = 29493000;
@@ -2475,11 +2426,12 @@ static void cris_serial_port_init(struct uart_port *port, int line)
 static int __init serial_cris_init(void)
 {
 	int ret, i;
-	printk(KERN_INFO "Serial: CRISv32 driver $Revision: 1.109 $ ");
+
+	pr_info("Serial: CRISv32 driver Revision: 1.109");
 
 	ret = uart_register_driver(&serial_cris_driver);
 	if (ret)
-		goto out;
+		return ret;
 
 	for (i = 0; i < UART_NR; i++) {
 		if (serial_cris_ports[i].used) {
@@ -2488,34 +2440,37 @@ static int __init serial_cris_init(void)
 			reg_ser_rw_rec_ctrl rec_ctrl;
 
 			/* Make sure that the RTS pin stays low when allocating
-			 * pins for a port in 485 mode. 
+			 * pins for a port in 485 mode.
 			 */
 			if (serial_cris_ports[i].port_type > TYPE_232) {
-				rec_ctrl = REG_RD(ser, serial_cris_ports[i].regi_ser, rw_rec_ctrl);
+				rec_ctrl =
+				    REG_RD(ser, serial_cris_ports[i].regi_ser,
+					   rw_rec_ctrl);
 				rec_ctrl.rts_n = regk_ser_active;
-				REG_WR(ser, serial_cris_ports[i].regi_ser, rw_rec_ctrl, rec_ctrl); 
+				REG_WR(ser, serial_cris_ports[i].regi_ser,
+				       rw_rec_ctrl, rec_ctrl);
 			}
 #endif
 			switch (serial_cris_ports[i].regi_ser) {
-                        case regi_ser0:
-                                break;
+			case regi_ser0:
+				break;
 			case regi_ser1:
 				if (crisv32_pinmux_alloc_fixed(pinmux_ser1)) {
-					printk("Failed to allocate pins for ser1, disable port\n");
+					pr_err("Failed to allocate pins for ser1, disable port\n");
 					serial_cris_ports[i].used = 0;
 					continue;
 				}
 				break;
 			case regi_ser2:
 				if (crisv32_pinmux_alloc_fixed(pinmux_ser2)) {
-					printk("Failed to allocate pins for ser2, disable port\n");
+					pr_err("Failed to allocate pins for ser2, disable port\n");
 					serial_cris_ports[i].used = 0;
 					continue;
 				}
 				break;
 			case regi_ser3:
 				if (crisv32_pinmux_alloc_fixed(pinmux_ser3)) {
-					printk("Failed to allocate pins for ser3, disable port\n");
+					pr_err("Failed to allocate pins for ser3, disable port\n");
 					serial_cris_ports[i].used = 0;
 					continue;
 				}
@@ -2523,14 +2478,15 @@ static int __init serial_cris_init(void)
 #if CONFIG_ETRAX_SERIAL_PORTS == 5
 			case regi_ser4:
 				if (crisv32_pinmux_alloc_fixed(pinmux_ser4)) {
-					printk("Failed to allocate pins for ser4, disable port\n");
+					pr_err("Failed to allocate pins for ser4, disable port\n");
 					serial_cris_ports[i].used = 0;
 					continue;
 				}
 				break;
 #endif
 			default:
-				printk("Error: No such serial port (%d) \n", serial_cris_ports[i].regi_ser);
+				pr_err("No such serial port (%d)\n",
+				       serial_cris_ports[i].regi_ser);
 				serial_cris_ports[i].used = 0;
 				break;
 			}
@@ -2541,14 +2497,13 @@ static int __init serial_cris_init(void)
 			uart_add_one_port(&serial_cris_driver, port);
 		}
 	}
-
-out:
-	return ret;
+	return 0;
 }
 
 static void __exit serial_cris_exit(void)
 {
 	int i;
+
 	for (i = 0; i < UART_NR; i++)
 		if (serial_cris_ports[i].used) {
 			switch (serial_cris_ports[i].regi_ser) {
@@ -2567,12 +2522,13 @@ static void __exit serial_cris_exit(void)
 				break;
 #endif
 			default:
-				printk("Error: No such serial port (%d) \n", serial_cris_ports[i].regi_ser);
+				pr_err("No such serial port (%d)\n",
+				       serial_cris_ports[i].regi_ser);
 				serial_cris_ports[i].used = 0;
 				break;
 			}
 			uart_remove_one_port(&serial_cris_driver,
-				 &serial_cris_ports[i].port);
+					     &serial_cris_ports[i].port);
 		}
 	uart_unregister_driver(&serial_cris_driver);
 }
-- 
1.9.1

