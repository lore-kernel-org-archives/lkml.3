Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbbAEKNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:13:45 -0500
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:37994
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753168AbbAEKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:13:41 -0500
From: Vijay Rai <vijay.rai@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
CC: Vijay Rai <vijay.rai@freescale.com>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>
Subject: [PATCH V2] tty: 8250: Add 64byte UART support for FSL platforms
Date: Mon, 5 Jan 2015 21:14:42 +0530
Message-ID: <1420472682-16213-1-git-send-email-vijay.rai@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=vijay.rai@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(85426001)(87936001)(77156002)(62966003)(46102003)(86362001)(120916001)(92566001)(2201001)(99396003)(107046002)(33646002)(68736005)(229853001)(36756003)(77096005)(19580395003)(19580405001)(50986999)(105606002)(69596002)(106466001)(81156004)(6806004)(48376002)(50466002)(31966008)(4396001)(47776003)(50226001)(97736003)(64706001)(21056001)(104016003)(20776003)(84676001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB0849;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB0849;
X-Forefront-PRVS: 0447DB1C71
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 10:13:38.0436
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB0849
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
-tx_loadsz is set to 63-bytes instead of 64-bytes to implement
 workaround of errata A-008006 which states that tx_loadsz should
 be configured less than Maximum supported fifo bytes

Signed-off-by: Vijay Rai <vijay.rai@freescale.com>
Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Poonam Aggrwal <poonam.aggrwal@freescale.com>
---
Changes from V1:
- tx_loadsz is set to 63-bytes now earlier it was set to 36
- Added comment mentioning the erratum A-008006
- Updated PORT_MAX_8250 to 30

 drivers/tty/serial/8250/8250_core.c |   23 ++++++++++++++++++++++-
 include/uapi/linux/serial_core.h    |    3 ++-
 include/uapi/linux/serial_reg.h     |    3 ++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 11c6685..221e047 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -329,6 +329,17 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
 	},
+/* tx_loadsz is set to 63-bytes instead of 64-bytes to implement
+workaround of errata A-008006 which states that tx_loadsz should  be
+configured less than Maximum supported fifo bytes */
+	[PORT_16550A_FSL64] = {
+		.name		= "16550A_FSL64",
+		.fifo_size	= 64,
+		.tx_loadsz	= 63,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+				  UART_FCR7_64BYTE,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 /* Uart divisor latch read */
@@ -956,7 +967,17 @@ static void autoconfig_16550a(struct uart_8250_port *up)
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
index c172180..263918b 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -55,7 +55,8 @@
 #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
 #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
 #define PORT_RT2880	29	/* Ralink RT2880 internal UART */
-#define PORT_MAX_8250	29	/* max port ID */
+#define PORT_16550A_FSL64 30	/* Freescale 16550 UART with 64 FIFOs */
+#define PORT_MAX_8250	30	/* max port ID */
 
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

