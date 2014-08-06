Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaHFUCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:02:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46491 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaHFUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:02:52 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: devicetree@vger.kernel.org
Cc: grant.likely@linaro.org, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2] of/irq: lookup 'interrupts-extended' property first
Date: Wed,  6 Aug 2014 13:02:27 -0700
Message-Id: <1407355347-30286-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the Device Tree blob passed by the boot agent supplies both an
'interrupts-extended' and an 'interrupts' property in order to allow for
older kernels to be usable, prefer the new-style 'interrupts-extended'
property which conveys a lot more information.

This allows us to have bootloaders willingly maintaining backwards
compatibility with older kernels without entirely deprecating the
'interrupts' property.

Update the bindings documentation to describe a situation where both the
'interrupts-extended' and the 'interrupts' property are present, and
which one takes precedence over the other.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- added Brian's update to the binding
- added Rob's hack based on the initial patch
- slightly reworked the comment about drivers/of/irq.c to specify which
  property we look up first

 .../bindings/interrupt-controller/interrupts.txt        | 12 +++++++-----
 drivers/of/irq.c                                        | 17 +++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
index 1486497a24c1..ce6a1a072028 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -4,11 +4,13 @@ Specifying interrupt information for devices
 1) Interrupt client nodes
 -------------------------
 
-Nodes that describe devices which generate interrupts must contain an either an
-"interrupts" property or an "interrupts-extended" property. These properties
-contain a list of interrupt specifiers, one per output interrupt. The format of
-the interrupt specifier is determined by the interrupt controller to which the
-interrupts are routed; see section 2 below for details.
+Nodes that describe devices which generate interrupts must contain an
+"interrupts" property, an "interrupts-extended" property, or both. If both are
+present, the latter should take precedence; the former may be provided simply
+for compatibility with software that does not recognize the latter. These
+properties contain a list of interrupt specifiers, one per output interrupt. The
+format of the interrupt specifier is determined by the interrupt controller to
+which the interrupts are routed; see section 2 below for details.
 
   Example:
 	interrupt-parent = <&intc1>;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 3e06a699352d..1471e0a223a5 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -301,16 +301,17 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	/* Get the reg property (if any) */
 	addr = of_get_property(device, "reg", NULL);
 
+	/* Try the new-style interrupts-extended first */
+	res = of_parse_phandle_with_args(device, "interrupts-extended",
+					"#interrupt-cells", index, out_irq);
+	if (!res)
+		return of_irq_parse_raw(addr, out_irq);
+
 	/* Get the interrupts property */
 	intspec = of_get_property(device, "interrupts", &intlen);
-	if (intspec == NULL) {
-		/* Try the new-style interrupts-extended */
-		res = of_parse_phandle_with_args(device, "interrupts-extended",
-						"#interrupt-cells", index, out_irq);
-		if (res)
-			return -EINVAL;
-		return of_irq_parse_raw(addr, out_irq);
-	}
+	if (intspec == NULL)
+		return -EINVAL;
+
 	intlen /= sizeof(*intspec);
 
 	pr_debug(" intspec=%d intlen=%d\n", be32_to_cpup(intspec), intlen);
-- 
1.9.1

