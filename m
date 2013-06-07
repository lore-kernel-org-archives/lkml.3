Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3FGKLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:11:54 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:44872 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3FGKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:11:52 -0400
Date: Fri, 7 Jun 2013 10:11:51 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Mark Brown <broonie@kernel.org>
cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Subject: Re: [PATCH] regulator: core: add regulator_get_linear_step()
In-Reply-To: <alpine.DEB.2.02.1306071000330.32163@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.02.1306071010380.32163@utopia.booyaka.com>
References: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com> <20130607090923.GH31367@sirena.org.uk> <alpine.DEB.2.02.1306070920010.32163@utopia.booyaka.com> <20130607095936.GK31367@sirena.org.uk>
 <alpine.DEB.2.02.1306071000330.32163@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jun 2013, Paul Walmsley wrote:

> The IP block has an I2C controller embedded in it that autonomously sends 
> set-voltage commands (across a range of voltages) to the PMIC.  To enable 
> that, the driver must first initialize the IP block with a 
> voltage-to-selector table.

Here's the table loading code -

+/**
+ * _load_lut - load voltage lookup table into DFLL RAM
+ * @pdev: DFLL instance
+ *
+ * Load the voltage-to-PMIC register value lookup table into the DFLL
+ * IP block LUT memory.  td->lut_min and td->lut_max are used to cap
+ * the minimum and maximum voltage requested.  This function shouldn't
+ * be called directly by code other than dfll_load_lut(), since this
+ * function doesn't handle the necessary pre- and post-requisites.  No
+ * return value.
+ */
+static void _load_lut(struct platform_device *pdev)
+{
+	struct tegra_dfll *td = dev_get_drvdata(&pdev->dev);
+	int i;
+	u32 val;
+
+	val = td->out_map[td->lut_min]->reg_value;
+	for (i = 0; i <= td->lut_min; i++)
+		dfll_writel(td, val, DFLL_OUTPUT_LUT + i * 4);
+
+	for (; i < td->lut_max; i++) {
+		val = td->out_map[i]->reg_value;
+		dfll_writel(td, val, DFLL_OUTPUT_LUT + i * 4);
+	}
+
+	val = td->out_map[td->lut_max]->reg_value;
+	for (; i < td->num_voltages; i++)
+		dfll_writel(td, val, DFLL_OUTPUT_LUT + i * 4);
+
+	dfll_wmb(td);
+}



- Paul
