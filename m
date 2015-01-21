Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbbAUKIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:08:35 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:51271
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752932AbbAUKI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:27 -0500
X-Greylist: delayed 5635 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 05:08:27 EST
From: Yuan Yao <yao.yuan@freescale.com>
To: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>, <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>
Subject: [PATCH] serial: fsl-lpuart: disable interrupt when suspend
Date: Wed, 21 Jan 2015 16:32:10 +0800
Message-ID: <1421829130-32985-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(46102003)(68736005)(64706001)(106466001)(87936001)(47776003)(105606002)(86362001)(77096005)(19580395003)(33646002)(85426001)(50986999)(6806004)(19580405001)(229853001)(48376002)(50466002)(36756003)(92566002)(104016003)(50226001)(97736003)(62966003)(2201001)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB335;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR03MB335;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR03MB335;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB335;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 08:34:26.5250
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR03MB335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management support, we should disable TX/RX
interrupts so that kernel can prepare for deep sleep.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/tty/serial/fsl_lpuart.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 1c5d020..bfd6ea2 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1449,6 +1449,21 @@ static int lpuart_remove(struct platform_device *pdev)
 static int lpuart_suspend(struct device *dev)
 {
 	struct lpuart_port *sport = dev_get_drvdata(dev);
+	unsigned long temp;
+
+	if (sport->lpuart32) {
+		/* disable Rx/Tx and interrupts */
+		temp = lpuart32_read(sport->port.membase + UARTCTRL);
+		temp &= ~(UARTCTRL_TE | UARTCTRL_RE |
+				UARTCTRL_TIE | UARTCTRL_TCIE | UARTCTRL_RIE);
+		lpuart32_write(temp, sport->port.membase + UARTCTRL);
+	} else {
+		/* disable Rx/Tx and interrupts */
+		temp = readb(sport->port.membase + UARTCR2);
+		temp &= ~(UARTCR2_TE | UARTCR2_RE |
+				UARTCR2_TIE | UARTCR2_TCIE | UARTCR2_RIE);
+		writeb(temp, sport->port.membase + UARTCR2);
+	}
 
 	uart_suspend_port(&lpuart_reg, &sport->port);
 
-- 
2.1.0.27.g96db324

