Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbbAYSZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:25:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbbAYSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 169/183] bus: omap_l3_noc: Add resume hook to restore context
Date: Sun, 25 Jan 2015 10:08:11 -0800
Message-Id: <20150125180817.514461210@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keerthy <j-keerthy@ti.com>

commit 61b43d4e919e8fa5e10c77ee32ba328da07e0264 upstream.

On certain SoCs such as AM437x SoC, L3_noc error registers are
maintained in power domain such as per domain which looses context as part
of low power state such as RTC+DDR mode. On these platforms when we
mask interrupts which we cannot handle, the source of these interrupts
still remain on resume, however, the flag mux registers now contain
their reset value (unmasked) - this breaks the system with infinite
interrupts since we do not these interrupts to take place ever again.

To handle this: restore the masking of interrupts which we have
already recorded in the system as ones we cannot handle.

Fixes: 2100b595b7 ("bus: omap_l3_noc: ignore masked out unclearable targets")
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/omap_l3_noc.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -296,11 +296,66 @@ static int omap_l3_probe(struct platform
 	return ret;
 }
 
+#ifdef	CONFIG_PM
+
+/**
+ * l3_resume_noirq() - resume function for l3_noc
+ * @dev:	pointer to l3_noc device structure
+ *
+ * We only have the resume handler only since we
+ * have already maintained the delta register
+ * configuration as part of configuring the system
+ */
+static int l3_resume_noirq(struct device *dev)
+{
+	struct omap_l3 *l3 = dev_get_drvdata(dev);
+	int i;
+	struct l3_flagmux_data *flag_mux;
+	void __iomem *base, *mask_regx = NULL;
+	u32 mask_val;
+
+	for (i = 0; i < l3->num_modules; i++) {
+		base = l3->l3_base[i];
+		flag_mux = l3->l3_flagmux[i];
+		if (!flag_mux->mask_app_bits && !flag_mux->mask_dbg_bits)
+			continue;
+
+		mask_regx = base + flag_mux->offset + L3_FLAGMUX_MASK0 +
+			   (L3_APPLICATION_ERROR << 3);
+		mask_val = readl_relaxed(mask_regx);
+		mask_val &= ~(flag_mux->mask_app_bits);
+
+		writel_relaxed(mask_val, mask_regx);
+		mask_regx = base + flag_mux->offset + L3_FLAGMUX_MASK0 +
+			   (L3_DEBUG_ERROR << 3);
+		mask_val = readl_relaxed(mask_regx);
+		mask_val &= ~(flag_mux->mask_dbg_bits);
+
+		writel_relaxed(mask_val, mask_regx);
+	}
+
+	/* Dummy read to force OCP barrier */
+	if (mask_regx)
+		(void)readl(mask_regx);
+
+	return 0;
+}
+
+static const struct dev_pm_ops l3_dev_pm_ops = {
+	.resume_noirq		= l3_resume_noirq,
+};
+
+#define L3_DEV_PM_OPS (&l3_dev_pm_ops)
+#else
+#define L3_DEV_PM_OPS NULL
+#endif
+
 static struct platform_driver omap_l3_driver = {
 	.probe		= omap_l3_probe,
 	.driver		= {
 		.name		= "omap_l3_noc",
 		.owner		= THIS_MODULE,
+		.pm		= L3_DEV_PM_OPS,
 		.of_match_table = of_match_ptr(l3_noc_match),
 	},
 };


