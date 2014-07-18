Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbaGRNJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:44 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17451 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761756AbaGRNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 120/170] serial: Fix IGNBRK handling
Date: Fri, 18 Jul 2014 14:12:05 +0200
Message-Id: <cf409774a0171086f04ad49de87b1de3235f7df9.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ef8b9ddcb45fa3b1e11acd72be2398001e807d14 upstream.

If IGNBRK is set without either BRKINT or PARMRK set, some uart
drivers send a 0x00 byte for BREAK without the TTYBREAK flag to the
line discipline, when it should send either nothing or the TTYBREAK flag
set. This happens because the read_status_mask masks out the BI
condition, which uart_insert_char() then interprets as a normal 0x00 byte.

SUS v3 is clear regarding the meaning of IGNBRK; Section 11.2.2, General
Terminal Interface - Input Modes, states:
  "If IGNBRK is set, a break condition detected on input shall be ignored;
   that is, not put on the input queue and therefore not read by any
   process."

Fix read_status_mask to include the BI bit if IGNBRK is set; the
lsr status retains the BI bit if a BREAK is recv'd, which is
subsequently ignored in uart_insert_char() when masked with the
ignore_status_mask.

Affected drivers:
8250 - all
serial_txx9
mfd
amba-pl010
amba-pl011
atmel_serial
bfin_uart
dz
ip22zilog
max310x
mxs-auart
netx-serial
pnx8xxx_uart
pxa
sb1250-duart
sccnxp
serial_ks8695
sirfsoc_uart
st-asc
vr41xx_siu
zs
sunzilog
fsl_lpuart
sunsab
ucc_uart
bcm63xx_uart
sunsu
efm32-uart
pmac_zilog
mpsc
msm_serial
m32r_sio

Unaffected drivers:
omap-serial
rp2
sa1100
imx
icom

Annotated for fixes:
altera_uart
mcf

Drivers without break detection:
21285
xilinx-uartps
altera_jtaguart
apbuart
arc-uart
clps711x
max3100
uartlite
msm_serial_hs
nwpserial
lantiq
vt8500_serial

Unknown:
samsung
mpc52xx_uart
bfin_sport_uart
cpm_uart/core

Fixes: Bugzilla #71651, '8250_core.c incorrectly handles IGNBRK flag'
Reported-by: Ivan <athlon_@mail.ru>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/8250_core.c | 2 +-
 drivers/tty/serial/altera_uart.c    | 6 ++++++
 drivers/tty/serial/amba-pl010.c     | 2 +-
 drivers/tty/serial/amba-pl011.c     | 2 +-
 drivers/tty/serial/atmel_serial.c   | 2 +-
 drivers/tty/serial/bcm63xx_uart.c   | 2 +-
 drivers/tty/serial/bfin_uart.c      | 2 +-
 drivers/tty/serial/dz.c             | 2 +-
 drivers/tty/serial/efm32-uart.c     | 2 +-
 drivers/tty/serial/fsl_lpuart.c     | 2 +-
 drivers/tty/serial/ip22zilog.c      | 2 +-
 drivers/tty/serial/m32r_sio.c       | 2 +-
 drivers/tty/serial/max310x.c        | 2 +-
 drivers/tty/serial/mcf.c            | 6 ++++++
 drivers/tty/serial/mfd.c            | 2 +-
 drivers/tty/serial/mpsc.c           | 2 +-
 drivers/tty/serial/msm_serial.c     | 2 +-
 drivers/tty/serial/mxs-auart.c      | 2 +-
 drivers/tty/serial/netx-serial.c    | 2 +-
 drivers/tty/serial/pmac_zilog.c     | 2 +-
 drivers/tty/serial/pnx8xxx_uart.c   | 2 +-
 drivers/tty/serial/pxa.c            | 2 +-
 drivers/tty/serial/sb1250-duart.c   | 2 +-
 drivers/tty/serial/sccnxp.c         | 2 +-
 drivers/tty/serial/serial_ks8695.c  | 2 +-
 drivers/tty/serial/serial_txx9.c    | 2 +-
 drivers/tty/serial/sirfsoc_uart.c   | 2 +-
 drivers/tty/serial/st-asc.c         | 2 +-
 drivers/tty/serial/sunsab.c         | 2 +-
 drivers/tty/serial/sunsu.c          | 2 +-
 drivers/tty/serial/sunzilog.c       | 2 +-
 drivers/tty/serial/ucc_uart.c       | 2 +-
 drivers/tty/serial/vr41xx_siu.c     | 2 +-
 drivers/tty/serial/zs.c             | 2 +-
 34 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index bf9d2ac9c9ed..04c8772639d3 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2356,7 +2356,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	port->read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= UART_LSR_BI;
 
 	/*
diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 501667e3e3f5..323376668b72 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -185,6 +185,12 @@ static void altera_uart_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 	altera_uart_writel(port, baudclk, ALTERA_UART_DIVISOR_REG);
 	spin_unlock_irqrestore(&port->lock, flags);
+
+	/*
+	 * FIXME: port->read_status_mask and port->ignore_status_mask
+	 * need to be initialized based on termios settings for
+	 * INPCK, IGNBRK, IGNPAR, PARMRK, BRKINT
+	 */
 }
 
 static void altera_uart_rx_chars(struct altera_uart *pp)
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 8b90f0b6dfdf..40bff818b947 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -420,7 +420,7 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	uap->port.read_status_mask = UART01x_RSR_OE;
 	if (termios->c_iflag & INPCK)
 		uap->port.read_status_mask |= UART01x_RSR_FE | UART01x_RSR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		uap->port.read_status_mask |= UART01x_RSR_BE;
 
 	/*
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 1440d0b4a7bc..a976ba99a006 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1731,7 +1731,7 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 	port->read_status_mask = UART011_DR_OE | 255;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= UART011_DR_FE | UART011_DR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= UART011_DR_BE;
 
 	/*
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 41bb8387e80d..3b301a7ec662 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1794,7 +1794,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	port->read_status_mask = ATMEL_US_OVRE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (ATMEL_US_FRAME | ATMEL_US_PARE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= ATMEL_US_RXBRK;
 
 	if (atmel_use_pdc_rx(port))
diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index 649d5129c4b4..88b07adedaef 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -568,7 +568,7 @@ static void bcm_uart_set_termios(struct uart_port *port,
 		port->read_status_mask |= UART_FIFO_FRAMEERR_MASK;
 		port->read_status_mask |= UART_FIFO_PARERR_MASK;
 	}
-	if (new->c_iflag & (BRKINT))
+	if (new->c_iflag & (IGNBRK | BRKINT))
 		port->read_status_mask |= UART_FIFO_BRKDET_MASK;
 
 	port->ignore_status_mask = 0;
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 3c75e8e04028..8d3046909c23 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -833,7 +833,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	port->read_status_mask = OE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (FE | PE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= BI;
 
 	/*
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index 2f2b2e538a54..cdbbc788230a 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -625,7 +625,7 @@ static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
 	dport->port.read_status_mask = DZ_OERR;
 	if (termios->c_iflag & INPCK)
 		dport->port.read_status_mask |= DZ_FERR | DZ_PERR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		dport->port.read_status_mask |= DZ_BREAK;
 
 	/* characters to ignore */
diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
index 0eb5b5673ede..948f17b6b497 100644
--- a/drivers/tty/serial/efm32-uart.c
+++ b/drivers/tty/serial/efm32-uart.c
@@ -407,7 +407,7 @@ static void efm32_uart_set_termios(struct uart_port *port,
 	if (new->c_iflag & INPCK)
 		port->read_status_mask |=
 			UARTn_RXDATAX_FERR | UARTn_RXDATAX_PERR;
-	if (new->c_iflag & (BRKINT | PARMRK))
+	if (new->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= SW_UARTn_RXDATAX_BERR;
 
 	port->ignore_status_mask = 0;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 8978dc9a58b7..175f123f4f09 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -496,7 +496,7 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	sport->port.read_status_mask = 0;
 	if (termios->c_iflag & INPCK)
 		sport->port.read_status_mask |=	(UARTSR1_FE | UARTSR1_PE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		sport->port.read_status_mask |= UARTSR1_FE;
 
 	/* characters to ignore */
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index cb3c81eb0996..a90f4089d080 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -850,7 +850,7 @@ ip22zilog_convert_to_zs(struct uart_ip22zilog_port *up, unsigned int cflag,
 	up->port.read_status_mask = Rx_OVR;
 	if (iflag & INPCK)
 		up->port.read_status_mask |= CRC_ERR | PAR_ERR;
-	if (iflag & (BRKINT | PARMRK))
+	if (iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= BRK_ABRT;
 
 	up->port.ignore_status_mask = 0;
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 9cd9b4eba9fc..68f2c53e0b54 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -737,7 +737,7 @@ static void m32r_sio_set_termios(struct uart_port *port,
 	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (termios->c_iflag & INPCK)
 		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= UART_LSR_BI;
 
 	/*
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index b2e707aa603a..518364311b75 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -842,7 +842,7 @@ static void max310x_set_termios(struct uart_port *port,
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= MAX310X_LSR_RXPAR_BIT |
 					  MAX310X_LSR_FRERR_BIT;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= MAX310X_LSR_RXBRK_BIT;
 
 	/* Set status ignore mask */
diff --git a/drivers/tty/serial/mcf.c b/drivers/tty/serial/mcf.c
index 0edfaf8cd269..a6f085717f94 100644
--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -248,6 +248,12 @@ static void mcf_set_termios(struct uart_port *port, struct ktermios *termios,
 		mr1 |= MCFUART_MR1_PARITYNONE;
 	}
 
+	/*
+	 * FIXME: port->read_status_mask and port->ignore_status_mask
+	 * need to be initialized based on termios settings for
+	 * INPCK, IGNBRK, IGNPAR, PARMRK, BRKINT
+	 */
+
 	if (termios->c_cflag & CSTOPB)
 		mr2 |= MCFUART_MR2_STOP2;
 	else
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index d3db042f649e..81ad559ee9cb 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -975,7 +975,7 @@ serial_hsu_set_termios(struct uart_port *port, struct ktermios *termios,
 	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (termios->c_iflag & INPCK)
 		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= UART_LSR_BI;
 
 	/* Characters to ignore */
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 8d702677acc5..76749f404b68 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -1458,7 +1458,7 @@ static void mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
 		pi->port.read_status_mask |= SDMA_DESC_CMDSTAT_PE
 			| SDMA_DESC_CMDSTAT_FR;
 
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		pi->port.read_status_mask |= SDMA_DESC_CMDSTAT_BR;
 
 	/* Characters/events to ignore */
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index b5d779cd3c2b..c0f2b3e5452f 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -570,7 +570,7 @@ static void msm_set_termios(struct uart_port *port, struct ktermios *termios,
 	port->read_status_mask = 0;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= UART_SR_PAR_FRAME_ERR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= UART_SR_RX_BREAK;
 
 	uart_update_timeout(port, termios->c_cflag, baud);
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 10e9d70b5c40..ea96c39b387d 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -600,7 +600,7 @@ static void mxs_auart_settermios(struct uart_port *u,
 
 	if (termios->c_iflag & INPCK)
 		u->read_status_mask |= AUART_STAT_PERR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		u->read_status_mask |= AUART_STAT_BERR;
 
 	/*
diff --git a/drivers/tty/serial/netx-serial.c b/drivers/tty/serial/netx-serial.c
index 0a4dd70d29eb..7a6745601d4e 100644
--- a/drivers/tty/serial/netx-serial.c
+++ b/drivers/tty/serial/netx-serial.c
@@ -419,7 +419,7 @@ netx_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	port->read_status_mask = 0;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= SR_BE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= SR_PE | SR_FE;
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 5ba30e078236..409d7ad0ac75 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1090,7 +1090,7 @@ static void pmz_convert_to_zs(struct uart_pmac_port *uap, unsigned int cflag,
 	uap->port.read_status_mask = Rx_OVR;
 	if (iflag & INPCK)
 		uap->port.read_status_mask |= CRC_ERR | PAR_ERR;
-	if (iflag & (BRKINT | PARMRK))
+	if (iflag & (IGNBRK | BRKINT | PARMRK))
 		uap->port.read_status_mask |= BRK_ABRT;
 
 	uap->port.ignore_status_mask = 0;
diff --git a/drivers/tty/serial/pnx8xxx_uart.c b/drivers/tty/serial/pnx8xxx_uart.c
index de6c05c63683..2ba24a45c97f 100644
--- a/drivers/tty/serial/pnx8xxx_uart.c
+++ b/drivers/tty/serial/pnx8xxx_uart.c
@@ -477,7 +477,7 @@ pnx8xxx_set_termios(struct uart_port *port, struct ktermios *termios,
 		sport->port.read_status_mask |=
 			FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE) |
 			FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR);
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		sport->port.read_status_mask |=
 			ISTAT_TO_SM(PNX8XXX_UART_INT_BREAK);
 
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index f9f20f383760..fc3f308cd6c1 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -492,7 +492,7 @@ serial_pxa_set_termios(struct uart_port *port, struct ktermios *termios,
 	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (termios->c_iflag & INPCK)
 		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= UART_LSR_BI;
 
 	/*
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index a7cdec2962dd..771f361c47ea 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -596,7 +596,7 @@ static void sbd_set_termios(struct uart_port *uport, struct ktermios *termios,
 	if (termios->c_iflag & INPCK)
 		uport->read_status_mask |= M_DUART_FRM_ERR |
 					   M_DUART_PARITY_ERR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		uport->read_status_mask |= M_DUART_RCVD_BRK;
 
 	uport->ignore_status_mask = 0;
diff --git a/drivers/tty/serial/sccnxp.c b/drivers/tty/serial/sccnxp.c
index 49e9bbfe6cab..0ea128a76b1b 100644
--- a/drivers/tty/serial/sccnxp.c
+++ b/drivers/tty/serial/sccnxp.c
@@ -667,7 +667,7 @@ static void sccnxp_set_termios(struct uart_port *port,
 	port->read_status_mask = SR_OVR;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= SR_PE | SR_FE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= SR_BRK;
 
 	/* Set status ignore mask */
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index e1caa99e3d3b..5c79bdab985d 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -437,7 +437,7 @@ static void ks8695uart_set_termios(struct uart_port *port, struct ktermios *term
 	port->read_status_mask = URLS_URROE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (URLS_URFE | URLS_URPE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= URLS_URBI;
 
 	/*
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 440a962412da..ce13f42814a3 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -702,7 +702,7 @@ serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 		TXX9_SIDISR_TDIS | TXX9_SIDISR_RDIS;
 	if (termios->c_iflag & INPCK)
 		up->port.read_status_mask |= TXX9_SIDISR_UFER | TXX9_SIDISR_UPER;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= TXX9_SIDISR_UBRK;
 
 	/*
diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index a72c33f8e263..6904818d3424 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -897,7 +897,7 @@ static void sirfsoc_uart_set_termios(struct uart_port *port,
 		if (termios->c_iflag & INPCK)
 			port->read_status_mask |= uint_en->sirfsoc_frm_err_en;
 	}
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 			port->read_status_mask |= uint_en->sirfsoc_rxd_brk_en;
 	if (sirfport->uart_reg->uart_type == SIRF_REAL_UART) {
 		if (termios->c_iflag & IGNPAR)
diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 21e6e84c0df8..0ee31755cb5a 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -547,7 +547,7 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
 	ascport->port.read_status_mask = ASC_RXBUF_DUMMY_OE;
 	if (termios->c_iflag & INPCK)
 		ascport->port.read_status_mask |= ASC_RXBUF_FE | ASC_RXBUF_PE;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		ascport->port.read_status_mask |= ASC_RXBUF_DUMMY_BE;
 
 	/*
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 5d6136b2a04a..2fee558f2b13 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -719,7 +719,7 @@ static void sunsab_convert_to_sab(struct uart_sunsab_port *up, unsigned int cfla
 	if (iflag & INPCK)
 		up->port.read_status_mask |= (SAB82532_ISR0_PERR |
 					      SAB82532_ISR0_FERR);
-	if (iflag & (BRKINT | PARMRK))
+	if (iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= (SAB82532_ISR1_BRK << 8);
 
 	/*
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 699cc1b5f6aa..c41a5b8b717f 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -834,7 +834,7 @@ sunsu_change_speed(struct uart_port *port, unsigned int cflag,
 	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (iflag & INPCK)
 		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (iflag & (BRKINT | PARMRK))
+	if (iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= UART_LSR_BI;
 
 	/*
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 135a15203532..ed92578eba4e 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -915,7 +915,7 @@ sunzilog_convert_to_zs(struct uart_sunzilog_port *up, unsigned int cflag,
 	up->port.read_status_mask = Rx_OVR;
 	if (iflag & INPCK)
 		up->port.read_status_mask |= CRC_ERR | PAR_ERR;
-	if (iflag & (BRKINT | PARMRK))
+	if (iflag & (IGNBRK | BRKINT | PARMRK))
 		up->port.read_status_mask |= BRK_ABRT;
 
 	up->port.ignore_status_mask = 0;
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 88317482b81f..37df3897cb5a 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -934,7 +934,7 @@ static void qe_uart_set_termios(struct uart_port *port,
 	port->read_status_mask = BD_SC_EMPTY | BD_SC_OV;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= BD_SC_FR | BD_SC_PR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= BD_SC_BR;
 
 	/*
diff --git a/drivers/tty/serial/vr41xx_siu.c b/drivers/tty/serial/vr41xx_siu.c
index a63c14bc9a24..db0c8a4ab03e 100644
--- a/drivers/tty/serial/vr41xx_siu.c
+++ b/drivers/tty/serial/vr41xx_siu.c
@@ -559,7 +559,7 @@ static void siu_set_termios(struct uart_port *port, struct ktermios *new,
 	port->read_status_mask = UART_LSR_THRE | UART_LSR_OE | UART_LSR_DR;
 	if (c_iflag & INPCK)
 		port->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (c_iflag & (BRKINT | PARMRK))
+	if (c_iflag & (IGNBRK | BRKINT | PARMRK))
 		port->read_status_mask |= UART_LSR_BI;
 
 	port->ignore_status_mask = 0;
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index 6a169877109b..2b65bb7ffb8a 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -923,7 +923,7 @@ static void zs_set_termios(struct uart_port *uport, struct ktermios *termios,
 	uport->read_status_mask = Rx_OVR;
 	if (termios->c_iflag & INPCK)
 		uport->read_status_mask |= FRM_ERR | PAR_ERR;
-	if (termios->c_iflag & (BRKINT | PARMRK))
+	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
 		uport->read_status_mask |= Rx_BRK;
 
 	uport->ignore_status_mask = 0;
-- 
2.0.0

