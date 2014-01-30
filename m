Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaA3Uhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:37:43 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:53344 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751997AbaA3Uhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:37:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3868:3871:4321:4385:4390:4395:5007:7652:7903:8603:9010:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: back67_25bd386668e32
X-Filterd-Recvd-Size: 2218
Message-ID: <1391114256.2422.71.camel@joe-AO722>
Subject: [PATCH] pinctrl: Avoid kasprintf/kfree
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 30 Jan 2014 12:37:36 -0800
In-Reply-To: <1391108694.2422.59.camel@joe-AO722>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
	 <1391108694.2422.59.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid an unnecessary allocation/free by using stack instead.

Signed-off-by; Joe Perches <joe@perches.com>
---

This allocation seems unnecessary and the kasprintf isn't
checked for non-null, so maybe this is better.

 drivers/pinctrl/devicetree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 340fb4e..ffb59c8 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -176,13 +176,13 @@ int pinctrl_dt_to_map(struct pinctrl *p)
 {
 	struct device_node *np = p->dev->of_node;
 	int state, ret;
-	char *propname;
 	struct property *prop;
 	const char *statename;
 	const __be32 *list;
 	int size, config;
 	phandle phandle;
 	struct device_node *np_config;
+	char propname[9 + sizeof(int) * 2 + 4] = "pinctrl-";
 
 	/* CONFIG_OF enabled, p->dev not instantiated from DT */
 	if (!np) {
@@ -196,9 +196,8 @@ int pinctrl_dt_to_map(struct pinctrl *p)
 	/* For each defined state ID */
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
-		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		snprintf(&propname[8], ARRAY_SIZE(propname) - 9, "%d", state);
 		prop = of_find_property(np, propname, &size);
-		kfree(propname);
 		if (!prop)
 			break;
 		list = prop->value;


