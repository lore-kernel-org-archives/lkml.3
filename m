Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3JVTiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:38:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:60553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab3JVTiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396924877"
From: David Cohen <david.a.cohen@linux.intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, ning.li@intel.com,
        ivan.gorinov@intel.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        "Chen, Jie" <jie.d.chen@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 1/2] mrst_max3110: fix unbalanced IRQ issue during resume
Date: Tue, 22 Oct 2013 12:42:09 -0700
Message-Id: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen, Jie" <jie.d.chen@intel.com>

During resume, a startup will request_irq again, meantime resume function's
enable_irq will cause unbalanced IRQ issue.
Fix this issue by moving request_irq to probe function.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Chen, Jie <jie.d.chen@intel.com>
---
 drivers/tty/serial/mrst_max3110.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index a67e708..6f618dd 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -43,6 +43,7 @@
 
 #include <linux/kthread.h>
 #include <linux/spi/spi.h>
+#include <linux/pm.h>
 
 #include "mrst_max3110.h"
 
@@ -491,19 +492,9 @@ static int serial_m3110_startup(struct uart_port *port)
 	port->state->port.low_latency = 1;
 
 	if (max->irq) {
-		max->read_thread = NULL;
-		ret = request_irq(max->irq, serial_m3110_irq,
-				IRQ_TYPE_EDGE_FALLING, "max3110", max);
-		if (ret) {
-			max->irq = 0;
-			pr_err(PR_FMT "unable to allocate IRQ, polling\n");
-		}  else {
-			/* Enable RX IRQ only */
-			config |= WC_RXA_IRQ_ENABLE;
-		}
-	}
-
-	if (max->irq == 0) {
+		/* Enable RX IRQ only */
+		config |= WC_RXA_IRQ_ENABLE;
+	} else {
 		/* If IRQ is disabled, start a read thread for input data */
 		max->read_thread =
 			kthread_run(max3110_read_thread, max, "max3110_read");
@@ -517,8 +508,6 @@ static int serial_m3110_startup(struct uart_port *port)
 
 	ret = max3110_out(max, config);
 	if (ret) {
-		if (max->irq)
-			free_irq(max->irq, max);
 		if (max->read_thread)
 			kthread_stop(max->read_thread);
 		max->read_thread = NULL;
@@ -540,9 +529,6 @@ static void serial_m3110_shutdown(struct uart_port *port)
 		max->read_thread = NULL;
 	}
 
-	if (max->irq)
-		free_irq(max->irq, max);
-
 	/* Disable interrupts from this port */
 	config = WC_TAG | WC_SW_SHDI;
 	max3110_out(max, config);
@@ -840,6 +826,16 @@ static int serial_m3110_probe(struct spi_device *spi)
 		goto err_kthread;
 	}
 
+	if (max->irq) {
+		ret = request_irq(max->irq, serial_m3110_irq,
+				IRQ_TYPE_EDGE_FALLING, "max3110", max);
+		if (ret) {
+			max->irq = 0;
+			dev_warn(&spi->dev,
+			"unable to allocate IRQ, will use polling method\n");
+		}
+	}
+
 	spi_set_drvdata(spi, max);
 	pmax = max;
 
@@ -867,6 +863,9 @@ static int serial_m3110_remove(struct spi_device *dev)
 
 	free_page((unsigned long)max->con_xmit.buf);
 
+	if (max->irq)
+		free_irq(max->irq, max);
+
 	if (max->main_thread)
 		kthread_stop(max->main_thread);
 
-- 
1.8.4.rc3

