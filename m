Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3B0AmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:42:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3BZX6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 139/150] gpio: em: Use irq_domain_add_simple() to fix runtime error
Date: Tue, 26 Feb 2013 15:56:36 -0800
Message-Id: <20130226235538.838847247@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Damm <damm@opensource.se>

commit c7886b18273b07042e25e8d3ba5c983837b84123 upstream.

Adjust the gpio-em.c driver to reconsider the pdata->irq_base
variable. Non-DT board code like for instance board-kzm9d.c
needs to operate of a static IRQ range for platform devices.

So this patch is updating the code to make use of the function
irq_domain_add_simple() instead of irq_domain_add_linear().

Fixes a EMEV2 / KZM9D runtime error caused by the following commit:
7385500 gpio/em: convert to linear IRQ domain

Signed-off-by: Magnus Damm <damm@opensource.se>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
Reported-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-em.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -299,8 +299,9 @@ static int em_gio_probe(struct platform_
 	irq_chip->irq_set_type = em_gio_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
 
-	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
+	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      pdata->number_of_pins,
+					      pdata->irq_base,
 					      &em_gio_irq_domain_ops, p);
 	if (!p->irq_domain) {
 		ret = -ENXIO;


