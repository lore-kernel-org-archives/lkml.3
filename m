Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaI3VeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaI3VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 016/103] of/irq: Fix lookup to use 'interrupts-extended' property first
Date: Tue, 30 Sep 2014 14:30:21 -0700
Message-Id: <1412112708-27356-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

commit a9ecdc0fdc54aa499604dbd43132988effcac9b4 upstream.

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
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 .../bindings/interrupt-controller/interrupts.txt        | 12 +++++++-----
 drivers/of/irq.c                                        | 17 +++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
index 1486497..ce6a1a0 100644
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
index 5d8c346..13d4e7c 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -298,16 +298,17 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
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

