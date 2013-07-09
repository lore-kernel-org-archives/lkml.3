Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3GIAdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:33:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55747 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:33:35 -0400
Message-ID: <1373330011.4223.7.camel@phoenix>
Subject: [RFT][PATCH 2/2] irqchip: vt8500: Support 'rising and falling edge'
 trigger mode
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Prisk <linux@prisktech.co.nz>, Alexey Charkov <alchark@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Jul 2013 08:33:31 +0800
In-Reply-To: <1373329275.4223.1.camel@phoenix>
References: <1373329275.4223.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chip supports below interrupt request trigger mode:

Destination Control Register:
BIT[5:4] Interrupt Request Trigger Mode.
        00: High level trigger
        01: Posedge trigger
        10: Negedge trigger
        11: Both posedge and negedge trigger

This patch adds support for setting 'posedge and negedge trigger' mode.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Current code does not correctly handle the case if a driver request irq with
"IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING" flag.
I'm not sure if we have such use case in current code.

 drivers/irqchip/irq-vt8500.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index eb6d05a..e040994 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -136,6 +136,10 @@ static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
 		dctr |= VT8500_TRIGGER_RISING;
 		__irq_set_handler_locked(d->irq, handle_edge_irq);
 		break;
+	case IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING:
+		dctr |= VT8500_EDGE;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+		break;
 	}
 	writeb(dctr, base + VT8500_ICDC + d->hwirq);
 
-- 
1.8.1.2



