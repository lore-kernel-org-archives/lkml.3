Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbaJCXzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:55:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaJCVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3.14 023/238] of/irq: Fix lookup to use interrupts-extended property first
Date: Fri,  3 Oct 2014 14:28:58 -0700
Message-Id: <20141003212914.407307385@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt |   12 ++++---
 drivers/of/irq.c                                                      |   17 +++++-----
 2 files changed, 16 insertions(+), 13 deletions(-)

--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -4,11 +4,13 @@ Specifying interrupt information for dev
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
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -301,16 +301,17 @@ int of_irq_parse_one(struct device_node
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


