Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbaJCX5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:57:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaJCVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH 3.16 257/357] gpio: Fix potential NULL handler data in chained irqchip handler
Date: Fri,  3 Oct 2014 14:30:43 -0700
Message-Id: <20141003212941.225492139@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 324b0398781e7afb846378dd2d8a4374faaf236b upstream.

There is possibility with misconfigured pins that interrupt occurs instantly
after setting irq_set_chained_handler() in gpiochip_set_chained_irqchip().
Now if handler gets called before irq_set_handler_data() the handler gets
NULL handler data.

Fix this by moving irq_set_handler_data() call before
irq_set_chained_handler() in gpiochip_set_chained_irqchip().

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1368,12 +1368,12 @@ void gpiochip_set_chained_irqchip(struct
 		return;
 	}
 
-	irq_set_chained_handler(parent_irq, parent_handler);
 	/*
 	 * The parent irqchip is already using the chip_data for this
 	 * irqchip, so our callbacks simply use the handler_data.
 	 */
 	irq_set_handler_data(parent_irq, gpiochip);
+	irq_set_chained_handler(parent_irq, parent_handler);
 }
 EXPORT_SYMBOL_GPL(gpiochip_set_chained_irqchip);
 


