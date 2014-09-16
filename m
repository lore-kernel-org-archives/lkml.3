Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaIPSvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:51:45 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:49796 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaIPStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:23 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 05/12] PM / Domains: Add helper variable np = dev->of_node
Date: Tue, 16 Sep 2014 20:48:52 +0200
Message-Id: <1410893339-6361-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 drivers/base/power/domain.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 3fa15b6c54f09b36..e1cbde985d4de606 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2130,17 +2130,18 @@ static struct generic_pm_domain *of_genpd_get_from_provider(
  */
 int genpd_dev_pm_attach(struct device *dev)
 {
+	struct device_node *np = dev->of_node;
 	struct of_phandle_args pd_args;
 	struct generic_pm_domain *pd;
 	int ret;
 
-	if (!dev->of_node)
+	if (!np)
 		return -ENODEV;
 
 	if (dev->pm_domain)
 		return -EEXIST;
 
-	ret = of_parse_phandle_with_args(dev->of_node, "power-domains",
+	ret = of_parse_phandle_with_args(np, "power-domains",
 					"#power-domain-cells", 0, &pd_args);
 	if (ret < 0) {
 		if (ret != -ENOENT)
@@ -2151,8 +2152,7 @@ int genpd_dev_pm_attach(struct device *dev)
 		 * (for backwards compatibility of DT ABI)
 		 */
 		pd_args.args_count = 0;
-		pd_args.np = of_parse_phandle(dev->of_node,
-						"samsung,power-domain", 0);
+		pd_args.np = of_parse_phandle(np, "samsung,power-domain", 0);
 		if (!pd_args.np)
 			return -ENOENT;
 	}
@@ -2161,7 +2161,7 @@ int genpd_dev_pm_attach(struct device *dev)
 	if (IS_ERR(pd)) {
 		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
 			__func__, PTR_ERR(pd));
-		of_node_put(dev->of_node);
+		of_node_put(np);
 		return PTR_ERR(pd);
 	}
 
@@ -2177,7 +2177,7 @@ int genpd_dev_pm_attach(struct device *dev)
 	if (ret < 0) {
 		dev_err(dev, "failed to add to PM domain %s: %d",
 			pd->name, ret);
-		of_node_put(dev->of_node);
+		of_node_put(np);
 		return ret;
 	}
 
-- 
1.9.1

