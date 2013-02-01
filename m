Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3BANIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:08:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:44365 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127Ab3BANIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:08:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 16/89] mfd: tc3589x: Use simple irqdomain
Date: Fri,  1 Feb 2013 14:07:31 +0100
Message-Id: <20130201130208.620954318@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@stericsson.com>

commit 1f0529b4d80ad02df637be67ed4f82e93b8db32f upstream.

This fixes a regression in the TC3589x driver introduced in
commit 15e27b1088245a2de3b7d09d39cd209212eb16af
"mfd: Provide the tc3589x with its own IRQ domain"

If a system with a TC3589x expander is booted and a base
IRQ is passed from platform data, a legacy domain will
be used. However, since the Ux500 is now switched to use
SPARSE_IRQ, no descriptors get allocated on-the-fly,
and we get a crash.

Fix this by switching to using the simple irqdomain that
will handle this uniformly and also allocates descriptors
explicitly.

Also fix two small whitespace errors in the vicinity while
we're at it.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/tc3589x.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -219,25 +219,18 @@ static void tc3589x_irq_unmap(struct irq
 }
 
 static struct irq_domain_ops tc3589x_irq_ops = {
-        .map    = tc3589x_irq_map,
+	.map    = tc3589x_irq_map,
 	.unmap  = tc3589x_irq_unmap,
-        .xlate  = irq_domain_xlate_twocell,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)
 {
 	int base = tc3589x->irq_base;
 
-	if (base) {
-		tc3589x->domain = irq_domain_add_legacy(
-			NULL, TC3589x_NR_INTERNAL_IRQS, base,
-			0, &tc3589x_irq_ops, tc3589x);
-	}
-	else {
-		tc3589x->domain = irq_domain_add_linear(
-			np, TC3589x_NR_INTERNAL_IRQS,
-			&tc3589x_irq_ops, tc3589x);
-	}
+	tc3589x->domain = irq_domain_add_simple(
+		np, TC3589x_NR_INTERNAL_IRQS, base,
+		&tc3589x_irq_ops, tc3589x);
 
 	if (!tc3589x->domain) {
 		dev_err(tc3589x->dev, "Failed to create irqdomain\n");


