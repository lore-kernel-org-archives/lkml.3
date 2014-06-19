Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966430AbaFSXeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:34:03 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63650 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786AbaFSXeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:34:00 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: devicetree@vger.kernel.org
Cc: grant.likely@linaro.org, robh+dt@kernel.org, computersforpeace@gmail.com,
        linux-kernel@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] of/irq: lookup 'interrupts-extended' property first
Date: Thu, 19 Jun 2014 16:33:43 -0700
Message-Id: <1403220823-19444-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the Device Tree blob passed by the boot agent supplies both an
'interrupts-extended' and an 'interrupts' property in order to allow for
older kernels to be usable, prefer the new-style 'interrupts-extended'
property which convey a lot more information.

This allows us to have bootloaders willingly maintaining backwards
compatibility with older kernels without entirely deprecating the
'interrupts' property (although that is a clear violation of the binding
specified at
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt)

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/irq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 3e06a699352d..1af3be2396db 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -301,16 +301,17 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	/* Get the reg property (if any) */
 	addr = of_get_property(device, "reg", NULL);
 
+	/* Try the new-style interrupts-extended */
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

