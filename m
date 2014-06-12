Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaFLL51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:57:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853AbaFLL5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:57:23 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 19/19] irqchip: crossbar allow for quirky hardware with direct hardwiring of GIC
Date: Thu, 12 Jun 2014 17:23:27 +0530
Message-ID: <1402574007-13987-20-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10, 131,
132, 133 are direct wired to hardware blocks bypassing crossbar.
This quirky implementation is *NOT* supposed to be the expectation
of crossbar hardware usage. However, these are already marked in our
description of the hardware with SKIP and RESERVED where appropriate.

Unfortunately, we need to be able to refer to these hardwired IRQs.
So, to request these, crossbar driver can use the existing information
from it's table that these SKIP/RESERVED maps are direct wired sources
and generic allocation/programming of crossbar should be avoided.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/arm/omap/crossbar.txt      |   12 ++++++++++--
 drivers/irqchip/irq-crossbar.c                     |   20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
index 816d11b..7476d9b 100644
--- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -35,8 +35,10 @@ Documentation/devicetree/bindings/arm/gic.txt for further details.
 
 An interrupt consumer on an SoC using crossbar will use:
 	interrupts = <GIC_SPI request_number interrupt_level>
-request number shall be between 0 to that described by
-"ti,max-crossbar-sources"
+When the request number is between 0 to that described by
+"ti,max-crossbar-sources", it is assumed to be a crossbar mapping. If the
+request_number is greater than "ti,max-crossbar-sources", then it is mapped as a
+quirky hardware mapping direct to GIC.
 
 Example:
 	device_x@0x4a023000 {
@@ -44,3 +46,9 @@ Example:
 		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
 		...
 	};
+
+	device_y@0x4a033000 {
+		/* Direct mapped GIC SPI 1 used */
+		interrupts = <GIC_SPI 401 IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 745ad0a..2b61bbb 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -98,8 +98,13 @@ static inline int allocate_free_irq(int cb_no)
 
 static inline bool needs_crossbar_write(irq_hw_number_t hw)
 {
-	if (hw > GIC_IRQ_START)
-		return true;
+	int cb_no;
+
+	if (hw > GIC_IRQ_START) {
+		cb_no = cb->irq_map[hw - GIC_IRQ_START];
+		if (cb_no != IRQ_RESERVED && cb_no != IRQ_SKIP)
+			return true;
+	}
 
 	return false;
 }
@@ -139,8 +144,19 @@ static int crossbar_domain_xlate(struct irq_domain *d,
 {
 	int ret;
 	int req_num = intspec[1];
+	int direct_map_num;
 
 	if (req_num >= cb->max_crossbar_sources) {
+		direct_map_num = req_num - cb->max_crossbar_sources;
+		if (direct_map_num < cb->int_max) {
+			ret = cb->irq_map[direct_map_num];
+			if (ret == IRQ_RESERVED || ret == IRQ_SKIP) {
+				/* We use the interrupt num as h/w irq num */
+				ret = direct_map_num;
+				goto found;
+			}
+		}
+
 		pr_err("%s: requested crossbar number %d > max %d\n",
 		       __func__, req_num, cb->max_crossbar_sources);
 		return -EINVAL;
-- 
1.7.9.5

