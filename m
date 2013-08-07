Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3HGK1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:27:52 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56447 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab3HGK1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:49 -0400
Date: Wed, 7 Aug 2013 12:21:09 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 21/26] AMBA: pci-amba bridge: improve code readability
Message-ID: <54c0c73085554a63a585cf0b35a3bf4ce9f87181.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the code fixing up irq numbers for amba devices
to a separate function (fixup_amba_irqs()).

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/amba/pci-amba.c |   97 +++++++++++++++++++++++++---------------------
 1 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/drivers/amba/pci-amba.c b/drivers/amba/pci-amba.c
index e56717b..c825c7a 100644
--- a/drivers/amba/pci-amba.c
+++ b/drivers/amba/pci-amba.c
@@ -25,19 +25,63 @@
 */
 #define IMAP_ROW_LEN (1 + 1 + 1 + 1 + 1)
 
+static int fixup_amba_irq(struct device_node *amba_node,
+			  struct device_node *amba_bus,
+			  struct pci_dev *pdev)
+{
+	const void *p;
+	struct property *newimap;
+	u32 *ptr, *newv;
+	const u32 *reg;
+	int i, len, found;
+
+	p = of_get_property(amba_bus, "interrupt-map", &len);
+	if (!p)
+		/* No amba bus interrupt-map property */
+		return -EINVAL;
+
+	newimap = devm_kzalloc(&pdev->dev, sizeof(*newimap), GFP_KERNEL);
+	if (!newimap)
+		return -ENOMEM;
+
+	newimap->name = kstrdup("interrupt-map", GFP_KERNEL);
+	if (!newimap->name)
+		return -ENOMEM;
+
+	newv = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
+	if (!newv) {
+		kfree(newimap->name);
+		return -ENOMEM;
+	}
+
+	newimap->value = newv;
+	newimap->length = len;
+	memcpy(newv, p, len);
+	for (ptr = newv, i = 0, found = 0;
+	     i < len/sizeof(u32); ptr += IMAP_ROW_LEN, i += IMAP_ROW_LEN) {
+		reg = of_get_property(amba_node, "reg", NULL);
+		if (ptr[0] == reg[0]) {
+			ptr[IMAP_ROW_LEN - 1] = cpu_to_be32(pdev->irq);
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		pr_err("Could not update amba irq\n");
+		return -EINVAL;
+	}
+	of_update_property(amba_bus, newimap);
+	return 0;
+}
+
 static int pci_amba_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *id)
 {
 	struct amba_device *adev;
-	int i, ret, len;
+	int ret;
 	struct device_node *n, *node, *pci_amba_bridge, *amba_bus = NULL,
 		*amba_node = NULL;
-	const void *p;
 	char *name;
-	struct property *newimap;
-	u32 *newv, *ptr;
-	const u32 *reg;
-	int found;
 
 	pci_enable_msi(pdev);
 	ret = pci_enable_device(pdev);
@@ -96,44 +140,9 @@ static int pci_amba_probe(struct pci_dev *pdev,
 	  map to fix things up.
 	*/
 	if (of_get_property(amba_node, "interrupts", NULL)) {
-		p = of_get_property(amba_bus, "interrupt-map", &len);
-		if (!p)
-			/* No amba bus interrupt-map property */
-			return -EINVAL;
-
-		newimap = devm_kzalloc(&pdev->dev, sizeof(*newimap),
-				       GFP_KERNEL);
-		if (!newimap)
-			return -ENOMEM;
-
-		newimap->name = kstrdup("interrupt-map", GFP_KERNEL);
-		if (!newimap->name)
-			return -ENOMEM;
-
-		newv = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
-		if (!newv) {
-			kfree(newimap->name);
-			return -ENOMEM;
-		}
-
-		newimap->value = newv;
-		newimap->length = len;
-		memcpy(newv, p, len);
-		for (ptr = newv, i = 0, found = 0;
-		     i < len/sizeof(u32);
-		     ptr += IMAP_ROW_LEN, i += IMAP_ROW_LEN) {
-			reg = of_get_property(amba_node, "reg", NULL);
-			if (ptr[0] == reg[0]) {
-				ptr[IMAP_ROW_LEN - 1] = cpu_to_be32(pdev->irq);
-				found = 1;
-				break;
-			}
-		}
-		if (!found) {
-			pr_err("Could not update amba irq\n");
-			return -EINVAL;
-		}
-		of_update_property(amba_bus, newimap);
+		ret = fixup_amba_irq(amba_node, amba_bus, pdev);
+		if (ret < 0)
+			return ret;
 	}
 
 	/* And finally create the amba device */
-- 
1.7.7.2
