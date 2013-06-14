Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3FNPoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:44:00 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34469 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3FNPn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:43:58 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/5] pinctrl: dynamically alloc temp array when parsing dt pinconf options
Date: Fri, 14 Jun 2013 17:43:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de>
In-Reply-To: <201306141741.46077.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141743.55811.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocating the temorary array in pinconf_generic_parse_dt_config on stack
might cause problems later on, when the number of options grows over time.
Therefore also allocate this array dynamically to be on the safe side.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/pinctrl/pinconf-generic.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index ea9da17..794dad7 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -182,7 +182,7 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 				    unsigned long **configs,
 				    unsigned int *nconfigs)
 {
-	unsigned long cfg[ARRAY_SIZE(dt_params)];
+	unsigned long *cfg;
 	unsigned int ncfg = 0;
 	int ret;
 	int i;
@@ -191,6 +191,11 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 	if (!np)
 		return -EINVAL;
 
+	/* allocate a temporary array big enough to hold one of each option */
+	cfg = kzalloc(sizeof(*cfg) * ARRAY_SIZE(dt_params), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		struct pinconf_generic_dt_params *par = &dt_params[i];
 		ret = of_property_read_u32(np, par->property, &val);
@@ -208,11 +213,13 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 		ncfg++;
 	}
 
+	ret = 0;
+
 	/* no configs found at all */
 	if (ncfg == 0) {
 		*configs = NULL;
 		*nconfigs = 0;
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -220,11 +227,16 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 	 * found properties.
 	 */
 	*configs = kzalloc(ncfg * sizeof(unsigned long), GFP_KERNEL);
-	if (!*configs)
-		return -ENOMEM;
+	if (!*configs) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	memcpy(*configs, &cfg, ncfg * sizeof(unsigned long));
+	memcpy(*configs, cfg, ncfg * sizeof(unsigned long));
 	*nconfigs = ncfg;
-	return 0;
+
+out:
+	kfree(cfg);
+	return ret;
 }
 #endif
-- 
1.7.10.4

