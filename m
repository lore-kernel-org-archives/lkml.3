Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaL3Ekn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:40:43 -0500
Received: from mail-bl2on0106.outbound.protection.outlook.com ([65.55.169.106]:12779
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751532AbaL3Ekk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:40:40 -0500
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 23:40:39 EST
From: Vijay Rai <vijay.rai@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
CC: Vijay Rai <vijay.rai@freescale.com>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>
Subject: [PATCH] tty: 8250: Add 64byte UART support for FSL platforms
Date: Tue, 30 Dec 2014 15:08:08 +0530
Message-ID: <1419932288-17562-1-git-send-email-vijay.rai@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=vijay.rai@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(31966008)(97736003)(33646002)(64706001)(2201001)(4396001)(107046002)(48376002)(36756003)(120916001)(50466002)(50986999)(92566001)(87936001)(21056001)(77156002)(86362001)(69596002)(229853001)(50226001)(68736005)(62966003)(104016003)(89996001)(99396003)(77096005)(105606002)(20776003)(6806004)(84676001)(46102003)(19580405001)(81156004)(106466001)(47776003)(19580395003)(85426001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB0854;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0854;
X-Forefront-PRVS: 04410E544A
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 04:07:03.0932
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB0854
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of FSL SoCs like T1040 has new version of UART controller which
can support 64byte FiFo.
To enable 64 byte support, following needs to be done:
-FCR[EN64] needs to be programmed to 1 to enable it.
-Also, when FCR[EN64]==1, RTL bits to be used as below
to define various Receive Trigger Levels:
        -FCR[RTL] = 00  1 byte
        -FCR[RTL] = 01  16 bytes
        -FCR[RTL] = 10  32 bytes
        -FCR[RTL] = 11  56 bytes
-tx_loadsz is set to 32-bytes instead of 64-bytes to implement
 workaround of errata A-008006 which states that tx_loadsz should
 be configured less than Maximum supported fifo bytes

Signed-off-by: Vijay Rai <vijay.rai@freescale.com>
Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Poonam Aggrwal <poonam.aggrwal@freescale.com>
---
 drivers/tty/serial/8250/8250_core.c |   20 +++++++++++++++++++-
 include/uapi/linux/serial_core.h    |    3 ++-
 include/uapi/linux/serial_reg.h     |    3 ++-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 11c6685..565748c 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -329,6 +329,14 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
 	},
+	[PORT_16550A_FSL64] = {
+		.name		= "16550A_FSL64",
+		.fifo_size	= 64,
+		.tx_loadsz	= 32,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+				  UART_FCR7_64BYTE,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 /* Uart divisor latch read */
@@ -956,7 +964,17 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 			up->port.type = PORT_16650;
 			up->capabilities |= UART_CAP_EFR | UART_CAP_SLEEP;
 		} else {
-			DEBUG_AUTOCONF("Motorola 8xxx DUART ");
+			serial_out(up, UART_LCR, 0);
+			serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO |
+				   UART_FCR7_64BYTE);
+			status1 = serial_in(up, UART_IIR) >> 5;
+			serial_out(up, UART_FCR, 0);
+			serial_out(up, UART_LCR, 0);
+
+			if (status1 == 7)
+				up->port.type = PORT_16550A_FSL64;
+			else
+				DEBUG_AUTOCONF("Motorola 8xxx DUART ");
 		}
 		serial_out(up, UART_EFR, 0);
 		return;
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index c172180..a3b4491 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -55,7 +55,8 @@
 #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
 #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
 #define PORT_RT2880	29	/* Ralink RT2880 internal UART */
-#define PORT_MAX_8250	29	/* max port ID */
+#define PORT_16550A_FSL64 30	/* Freescale 16550 UART with 64 FIFOs */
+#define PORT_MAX_8250	31	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index 53af3b7..00adb01 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -86,7 +86,8 @@
 #define UART_FCR6_T_TRIGGER_8	0x10 /* Mask for transmit trigger set at 8 */
 #define UART_FCR6_T_TRIGGER_24  0x20 /* Mask for transmit trigger set at 24 */
 #define UART_FCR6_T_TRIGGER_30	0x30 /* Mask for transmit trigger set at 30 */
-#define UART_FCR7_64BYTE	0x20 /* Go into 64 byte mode (TI16C750) */
+#define UART_FCR7_64BYTE	0x20 /* Go into 64 byte mode (TI16C750 and
+					some Freescale UARTs) */
 
 #define UART_FCR_R_TRIG_SHIFT		6
 #define UART_FCR_R_TRIG_BITS(x)		\
-- 
1.7.9.5

