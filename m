Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3IMHuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:50:51 -0400
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:39158 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755509Ab3IMHus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:50:48 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 3/4] pinctrl: at91: improve pinconf_set/get function robustness
Date: Fri, 13 Sep 2013 09:49:09 +0200
Message-Id: <1379058549-3413-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14175642779133311200
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset caller's config variable before setting current config flags to avoid
erronous config return.

DEBOUNCE and DEGLITCH options are mutually exclusive. Return an error if they
are both defined in the config.
Do not call set_deglitch if DEBOUNCE is enabled to avoid reseting the IFSR
register (which will result in disabling the debounce filter).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 6624bce..ac9dbea 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -724,6 +724,7 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
 	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, *config);
 	pio = pin_to_controller(info, pin_to_bank(pin_id));
 	pin = pin_id % MAX_NB_GPIO_PER_BANK;
+	*config = 0;
 
 	if (at91_mux_get_multidrive(pio, pin))
 		*config |= MULTI_DRIVE;
@@ -757,13 +758,20 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
 	if (config & PULL_UP && config & PULL_DOWN)
 		return -EINVAL;
 
-	at91_mux_set_pullup(pio, mask, config & PULL_UP);
-	at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
-	if (info->ops->set_deglitch)
-		info->ops->set_deglitch(pio, mask, config & DEGLITCH);
-	if (info->ops->set_debounce)
+	if (config & DEBOUNCE && config & DEGLITCH)
+		return -EINVAL;
+
+	if (config & DEBOUNCE) {
+		if (!info->ops->set_debounce)
+			return -ENOTSUPP;
+
 		info->ops->set_debounce(pio, mask, config & DEBOUNCE,
 				(config & DEBOUNCE_VAL) >> DEBOUNCE_VAL_SHIFT);
+	} else if (info->ops->set_deglitch)
+		info->ops->set_deglitch(pio, mask, config & DEGLITCH);
+
+	at91_mux_set_pullup(pio, mask, config & PULL_UP);
+	at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
 	if (info->ops->set_pulldown)
 		info->ops->set_pulldown(pio, mask, config & PULL_DOWN);
 	if (info->ops->disable_schmitt_trig && config & DIS_SCHMIT)
-- 
1.7.9.5

