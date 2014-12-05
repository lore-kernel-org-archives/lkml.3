Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaLEXCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:02:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaLEXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:01:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17 104/122] irqchip: atmel-aic: Fix irqdomain initialization
Date: Fri,  5 Dec 2014 14:44:38 -0800
Message-Id: <20141205223321.692081272@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@free-electrons.com>

commit 45977fe35bf014f5cf9552717e1320783398ae0d upstream.

First of all IRQCHIP_SKIP_SET_WAKE is not a valid irq_gc_flags and thus
should not be passed as the last argument of
irq_alloc_domain_generic_chips.

Then pass the correct handler (handle_fasteoi_irq) to
irq_alloc_domain_generic_chips instead of manually re-setting it in the
initialization loop.

And eventually initialize default irq flags to the pseudo standard:
IRQ_REQUEST | IRQ_PROBE | IRQ_AUTOEN.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
Fixes: b1479ebb77200 ("irqchip: atmel-aic: Add atmel AIC/AIC5 drivers")
Link: https://lkml.kernel.org/r/1415712816-9202-1-git-send-email-boris.brezillon@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-atmel-aic-common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -217,8 +217,9 @@ struct irq_domain *__init aic_common_of_
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
-					     handle_level_irq, 0, 0,
-					     IRQCHIP_SKIP_SET_WAKE);
+					     handle_fasteoi_irq,
+					     IRQ_NOREQUEST | IRQ_NOPROBE |
+					     IRQ_NOAUTOEN, 0, 0);
 	if (ret)
 		goto err_domain_remove;
 
@@ -230,7 +231,6 @@ struct irq_domain *__init aic_common_of_
 		gc->unused = 0;
 		gc->wake_enabled = ~0;
 		gc->chip_types[0].type = IRQ_TYPE_SENSE_MASK;
-		gc->chip_types[0].handler = handle_fasteoi_irq;
 		gc->chip_types[0].chip.irq_eoi = irq_gc_eoi;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_shutdown = aic_common_shutdown;


