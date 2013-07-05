Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3GEJNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:13:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33693 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3GEJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:13:17 -0400
Message-ID: <1373015592.18252.2.camel@phoenix>
Subject: [PATCH RFC] genirq: Genric chip: Use DIV_ROUND_UP to count numchips
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date: Fri, 05 Jul 2013 17:13:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of interrupts in a domain may be not divisible by the number of
interrupts each chip handles.
Integer division may truncate the result, thus use DIV_ROUND_UP to count
numchips.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Seems all users of irq_alloc_domain_generic_chips() in current code do not
have this issue. I just found the issue while reading the code.

In the commit 02c981c0 of "ARM: CSR: Adding CSR SiRFprimaII board support"
It set SIRFSOC_INTENAL_IRQ_END to 59.
So I think this might be a possible case for some hardware.

 kernel/irq/generic-chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 10e663a..452d6f2 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -275,7 +275,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	if (d->gc)
 		return -EBUSY;
 
-	numchips = d->revmap_size / irqs_per_chip;
+	numchips = DIV_ROUND_UP(d->revmap_size, irqs_per_chip);
 	if (!numchips)
 		return -EINVAL;
 
-- 
1.8.1.2



