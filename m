Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaGCIyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:54:13 -0400
Received: from cernmx11.cern.ch ([188.184.36.50]:26098 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbaGCIyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:54:10 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH] ipoctal: request_irq after configuration
Date: Thu, 3 Jul 2014 10:53:58 +0200
Message-ID: <1404377638-23387-1-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The request for an IRQ handler must be done after whole configuration. This
was not the case for this driver which request the IRQ in the middle of
the configuration. Sometimes, it happens that something is not completely
configured, we recieve an interrupt thus we stumble into troubles in the
IRQ handler.

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
---
 drivers/ipack/devices/ipoctal.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index a7ec6f9..72fd761 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -344,13 +344,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 			 &block_regs[i].w.imr);
 	}
 
-	/*
-	 * IP-OCTAL has different addresses to copy its IRQ vector.
-	 * Depending of the carrier these addresses are accesible or not.
-	 * More info in the datasheet.
-	 */
-	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
-				       ipoctal_irq_handler, ipoctal);
 	/* Dummy write */
 	iowrite8(1, ipoctal->mem8_space + 1);
 
@@ -411,6 +404,14 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		dev_set_drvdata(tty_dev, channel);
 	}
 
+	/*
+	 * IP-OCTAL has different addresses to copy its IRQ vector.
+	 * Depending of the carrier these addresses are accesible or not.
+	 * More info in the datasheet.
+	 */
+	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
+				       ipoctal_irq_handler, ipoctal);
+
 	return 0;
 }
 
-- 
1.7.10.4

