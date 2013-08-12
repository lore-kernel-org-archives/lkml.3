Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3HLGHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:07:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33691 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab3HLGHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:07:38 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz2ei87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8hff4m129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH v2] pinctrl: pinmux: Don't free pins requested by other devices in pinmux_disable_setting.
Date: Mon, 12 Aug 2013 14:10:21 +0800
Message-ID: <1376287821-22980-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

One peripheral may share part of its pins with the 2nd
peripheral and the other pins with the 3rd. If it requests all pins
when part of them has already be requested and owned by the 2nd
peripheral, this request fails and pinmux_disable_setting() is called.
The pinmux_disable_setting() frees all pins of the first peripheral
without checking if the pin is owned by itself or the 2nd, which
results in the malfunction of the 2nd peripheral driver.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/core.h   |  1 +
 drivers/pinctrl/pinmux.c | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 75476b3..a24e889 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -154,6 +154,7 @@ struct pin_desc {
 	const char *mux_owner;
 	const struct pinctrl_setting_mux *mux_setting;
 	const char *gpio_owner;
+	const struct pinctrl_setting *owning_setting
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 88cc509..c32a77b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -428,6 +428,7 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 			continue;
 		}
 		desc->mux_setting = &(setting->data.mux);
+		desc->owning_setting = setting;
 	}
 
 	ret = ops->enable(pctldev, setting->data.mux.func,
@@ -441,8 +442,10 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 err_enable:
 	for (i = 0; i < num_pins; i++) {
 		desc = pin_desc_get(pctldev, pins[i]);
-		if (desc)
+		if (desc) {
 			desc->mux_setting = NULL;
+			desc->owning_setting = NULL;
+		}
 	}
 err_pin_request:
 	/* On error release all taken pins */
@@ -480,15 +483,18 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 			dev_warn(pctldev->dev,
 				 "could not get pin desc for pin %d\n",
 				 pins[i]);
+			/* And release the pin */
+			pin_free(pctldev, pins[i], NULL);
 			continue;
 		}
-		desc->mux_setting = NULL;
+		if (desc->owning_setting == setting) {
+			desc->mux_setting = NULL;
+			desc->owning_setting = NULL;
+			/* And release the pin */
+			pin_free(pctldev, pins[i], NULL);
+		}
 	}
 
-	/* And release the pins */
-	for (i = 0; i < num_pins; i++)
-		pin_free(pctldev, pins[i], NULL);
-
 	if (ops->disable)
 		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
 }
-- 
1.8.2.3


