Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaG3BwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:52:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaG3BuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh@kernel.org>
Subject: [PATCH 3.15 37/37] platform_get_irq: Revert to platform_get_resource if of_irq_get fails
Date: Tue, 29 Jul 2014 18:49:13 -0700
Message-Id: <20140730014829.568340444@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aff008ad813c7cf3cfe7b532e7ba2c526c136f22 upstream.

Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
change the semantics of platform_get_irq and platform_get_irq_byname
to always rely on devicetree information if devicetree is enabled
and if a devicetree node is attached to the device. The functions
now return an error if the devicetree data does not include interrupt
information, even if the information is available as platform resource
data.

This causes mfd client drivers to fail if the interrupt number is
passed via platform resources. Therefore, if of_irq_get fails, try
platform_get_resource as method of last resort. This restores the
original functionality for drivers depending on platform resources
to get irq information.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Rob Herring <robh@kernel.org>
[ Guenter Roeck: backported to 3.15 ]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

---
 drivers/base/platform.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -89,8 +89,13 @@ int platform_get_irq(struct platform_dev
 	return dev->archdata.irqs[num];
 #else
 	struct resource *r;
-	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
-		return of_irq_get(dev->dev.of_node, num);
+	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
+		int ret;
+
+		ret = of_irq_get(dev->dev.of_node, num);
+		if (ret >= 0 || ret == -EPROBE_DEFER)
+			return ret;
+	}
 
 	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
 


