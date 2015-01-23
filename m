Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbbAWKGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:06:00 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:30592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbbAWKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:05:57 -0500
From: Yuan Yao <yao.yuan@freescale.com>
To: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>, <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>
Subject: [PATCH v2] serial: fsl-lpuart: disable interrupt when suspend
Date: Fri, 23 Jan 2015 17:48:54 +0800
Message-ID: <1422006534-16264-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=permerror action=none
 header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(50466002)(77096005)(106466001)(105606002)(229853001)(36756003)(62966003)(46102003)(77156002)(87936001)(48376002)(92566002)(47776003)(19580395003)(19580405001)(6806004)(50226001)(2201001)(104016003)(33646002)(85426001)(86362001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB331;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR03MB331;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB331;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB331;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 09:51:14.5617
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management support, we should disable TX and
TX interrupt so that kernel can prepare for deep sleep.

Retain RX and RX interrupt for wakeup the kernel when
receive the input character.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---

Changed in v2: 
	- Retain RX and RX interrupt for wakeup the kernel when
 receive the input character.
 drivers/tty/serial/fsl_lpuart.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 1c5d020..b195cfc 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1449,6 +1449,19 @@ static int lpuart_remove(struct platform_device *pdev)
 static int lpuart_suspend(struct device *dev)
 {
 	struct lpuart_port *sport = dev_get_drvdata(dev);
+	unsigned long temp;
+
+	if (sport->lpuart32) {
+		/* disable Rx/Tx and interrupts */
+		temp = lpuart32_read(sport->port.membase + UARTCTRL);
+		temp &= ~(UARTCTRL_TE | UARTCTRL_TIE | UARTCTRL_TCIE);
+		lpuart32_write(temp, sport->port.membase + UARTCTRL);
+	} else {
+		/* disable Rx/Tx and interrupts */
+		temp = readb(sport->port.membase + UARTCR2);
+		temp &= ~(UARTCR2_TE | UARTCR2_TIE | UARTCR2_TCIE);
+		writeb(temp, sport->port.membase + UARTCR2);
+	}
 
 	uart_suspend_port(&lpuart_reg, &sport->port);
 
-- 
2.1.0.27.g96db324

