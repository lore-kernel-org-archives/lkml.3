Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3JCFmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:42:23 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18703 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755728Ab3JCFmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:42:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/74bcSP0f8ctnX+ZfsMj79
Subject: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC specific
 features
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>, linux-omap@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>
Date: Wed, 02 Oct 2013 22:42:18 -0700
Message-ID: <20131003054218.8941.19273.stgit@localhost>
In-Reply-To: <20131003054104.8941.88857.stgit@localhost>
References: <20131003054104.8941.88857.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's replace is_pinconf with flags and add struct pcs_soc_data
so we can support SoC specific features like pin wake-up events.

Done in collaboration with Roger Quadros <rogerq@ti.com>.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Prakash Manjunathappa <prakash.pm@ti.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/pinctrl-single.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index a82ace4..f88d3d1 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -150,19 +150,27 @@ struct pcs_name {
 };
 
 /**
+ * struct pcs_soc_data - SoC specific settings
+ * @flags:	initial SoC specific PCS_FEAT_xxx values
+ */
+struct pcs_soc_data {
+	unsigned flags;
+};
+
+/**
  * struct pcs_device - pinctrl device instance
  * @res:	resources
  * @base:	virtual address of the controller
  * @size:	size of the ioremapped area
  * @dev:	device entry
  * @pctl:	pin controller device
+ * @flags:	mask of PCS_FEAT_xxx values
  * @mutex:	mutex protecting the lists
  * @width:	bits per mux register
  * @fmask:	function register mask
  * @fshift:	function register shift
  * @foff:	value to turn mux off
  * @fmax:	max number of functions in fmask
- * @is_pinconf:	whether supports pinconf
  * @bits_per_pin:number of bits per pin
  * @names:	array of register names for pins
  * @pins:	physical pins on the SoC
@@ -183,6 +191,8 @@ struct pcs_device {
 	unsigned size;
 	struct device *dev;
 	struct pinctrl_dev *pctl;
+	unsigned flags;
+#define PCS_FEAT_PINCONF	(1 << 0)
 	struct mutex mutex;
 	unsigned width;
 	unsigned fmask;
@@ -190,7 +200,6 @@ struct pcs_device {
 	unsigned foff;
 	unsigned fmax;
 	bool bits_per_mux;
-	bool is_pinconf;
 	unsigned bits_per_pin;
 	struct pcs_name *names;
 	struct pcs_data pins;
@@ -206,6 +215,8 @@ struct pcs_device {
 	void (*write)(unsigned val, void __iomem *reg);
 };
 
+#define PCS_HAS_PINCONF		(pcs->flags & PCS_FEAT_PINCONF)
+
 static int pcs_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config);
 static int pcs_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
@@ -1060,7 +1071,7 @@ static int pcs_parse_pinconf(struct pcs_device *pcs, struct device_node *np,
 	};
 
 	/* If pinconf isn't supported, don't parse properties in below. */
-	if (!pcs->is_pinconf)
+	if (!PCS_HAS_PINCONF)
 		return 0;
 
 	/* cacluate how much properties are supported in current node */
@@ -1184,7 +1195,7 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 	(*map)->data.mux.group = np->name;
 	(*map)->data.mux.function = np->name;
 
-	if (pcs->is_pinconf) {
+	if (PCS_HAS_PINCONF) {
 		res = pcs_parse_pinconf(pcs, np, function, map);
 		if (res)
 			goto free_pingroups;
@@ -1305,7 +1316,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 	(*map)->data.mux.group = np->name;
 	(*map)->data.mux.function = np->name;
 
-	if (pcs->is_pinconf) {
+	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
 		goto free_pingroups;
 	}
@@ -1525,6 +1536,7 @@ static int pcs_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	struct resource *res;
 	struct pcs_device *pcs;
+	const struct pcs_soc_data *soc;
 	int ret;
 
 	match = of_match_device(pcs_of_match, &pdev->dev);
@@ -1541,7 +1553,8 @@ static int pcs_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcs->pingroups);
 	INIT_LIST_HEAD(&pcs->functions);
 	INIT_LIST_HEAD(&pcs->gpiofuncs);
-	pcs->is_pinconf = match->data;
+	soc = match->data;
+	pcs->flags = soc->flags;
 
 	PCS_GET_PROP_U32("pinctrl-single,register-width", &pcs->width,
 			 "register width not specified\n");
@@ -1610,7 +1623,7 @@ static int pcs_probe(struct platform_device *pdev)
 	pcs->desc.name = DRIVER_NAME;
 	pcs->desc.pctlops = &pcs_pinctrl_ops;
 	pcs->desc.pmxops = &pcs_pinmux_ops;
-	if (pcs->is_pinconf)
+	if (PCS_HAS_PINCONF)
 		pcs->desc.confops = &pcs_pinconf_ops;
 	pcs->desc.owner = THIS_MODULE;
 
@@ -1652,9 +1665,16 @@ static int pcs_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct pcs_soc_data pinctrl_single = {
+};
+
+static const struct pcs_soc_data pinconf_single = {
+	.flags = PCS_FEAT_PINCONF,
+};
+
 static struct of_device_id pcs_of_match[] = {
-	{ .compatible = "pinctrl-single", .data = (void *)false },
-	{ .compatible = "pinconf-single", .data = (void *)true },
+	{ .compatible = "pinctrl-single", .data = &pinctrl_single },
+	{ .compatible = "pinconf-single", .data = &pinconf_single },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, pcs_of_match);

