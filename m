Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaDEAYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:24:07 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43951 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaDEAYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:24:03 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>
Cc: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: [RESEND PATCH v3 2/9] tty: xuartps: Initialize ports according to aliases
Date: Fri,  4 Apr 2014 17:23:38 -0700
Message-Id: <1396657425-31029-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

Register port numbers according to order in DT aliases.
If aliases are not defined, order in DT is used.
If aliases are defined, register port id based
on that.
This patch ensures proper ttyPS0/1 assignment.

[soren]: Combined integer declarations in probe(), removed warning message
if no alias is found.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
The alias is an optional feature. Print a warning if it is not provided
does not seem appropriate.

Changes in v3: None
Changes in v2:
 - this patch has been added

---
 drivers/tty/serial/xilinx_uartps.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b2f929e48ddd..2cd0cd456c7a 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1031,17 +1031,21 @@ static struct uart_port xuartps_port[2];
  * xuartps_get_port - Configure the port from the platform device resource
  *			info
  *
+ * @id: Port id
+ *
  * Return: a pointer to a uart_port or NULL for failure
  */
-static struct uart_port *xuartps_get_port(void)
+static struct uart_port *xuartps_get_port(int id)
 {
 	struct uart_port *port;
-	int id;
 
-	/* Find the next unused port */
-	for (id = 0; id < XUARTPS_NR_PORTS; id++)
-		if (xuartps_port[id].mapbase == 0)
-			break;
+	/* Try the given port id if failed use default method */
+	if (xuartps_port[id].mapbase != 0) {
+		/* Find the next unused port */
+		for (id = 0; id < XUARTPS_NR_PORTS; id++)
+			if (xuartps_port[id].mapbase == 0)
+				break;
+	}
 
 	if (id >= XUARTPS_NR_PORTS)
 		return NULL;
@@ -1329,7 +1333,7 @@ static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
  */
 static int xuartps_probe(struct platform_device *pdev)
 {
-	int rc;
+	int rc, id;
 	struct uart_port *port;
 	struct resource *res, *res2;
 	struct xuartps *xuartps_data;
@@ -1380,9 +1384,13 @@ static int xuartps_probe(struct platform_device *pdev)
 				&xuartps_data->clk_rate_change_nb))
 		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
 #endif
+	/* Look for a serialN alias */
+	id = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (id < 0)
+		id = 0;
 
 	/* Initialize the port structure */
-	port = xuartps_get_port();
+	port = xuartps_get_port(id);
 
 	if (!port) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
-- 
1.9.1.1.gbb9f595

