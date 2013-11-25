Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3KYSpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:45:09 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:34988 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3KYSpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:45:07 -0500
Date: Mon, 25 Nov 2013 19:47:04 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH RESEND v2] clk: probe defer when clock not yet ready
Message-ID: <20131125194704.5a5922b7@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At probe time, a clock device may not be ready when some other device
wants to use it. 

This patch lets the functions clk_get/devm_clk_get return a probe defer
when the clock is defined in the DT but not yet available.

It also fixes an erroneous call to clk_get_sys() when __clk_get() fails.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
resend v2: remove ASoc from subject (thank you, Mark)
resend: - patch subject change from
   [PATCH v3 1/2] ASoC: kirkwood: clk: probe defer when clock not yet ready
	- base kernel 3.13.0-rc1
v2: fix __clk_get() failure (from Russell King)
---
 drivers/clk/clk.c    | 2 +-
 drivers/clk/clkdev.c | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2cf2ea6..41361c6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2187,7 +2187,7 @@ EXPORT_SYMBOL_GPL(of_clk_del_provider);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
 	struct of_clk_provider *provider;
-	struct clk *clk = ERR_PTR(-ENOENT);
+	struct clk *clk = ERR_PTR(-EPROBE_DEFER);
 
 	/* Check if we have such a provider in our array */
 	mutex_lock(&of_clk_lock);
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..1f402b9 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -157,7 +157,12 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 
 	if (dev) {
 		clk = of_clk_get_by_name(dev->of_node, con_id);
-		if (!IS_ERR(clk) && __clk_get(clk))
+		if (!IS_ERR(clk)) {
+			if (!__clk_get(clk))
+				clk = ERR_PTR(-ENOENT);
+			return clk;
+		}
+		if (PTR_ERR(clk) == -EPROBE_DEFER)
 			return clk;
 	}
 
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
