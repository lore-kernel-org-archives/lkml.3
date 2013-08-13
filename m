Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3HMEuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:50:08 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:29633
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab3HMEuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:50:05 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH v3] pinctrl: pinmux: Don't free pins requested by other devices in pinmux_disable_setting.
Date: Tue, 13 Aug 2013 12:54:26 +0800
Message-ID: <1376369666-2564-1-git-send-email-sonic.adi@gmail.com>
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
 drivers/pinctrl/pinmux.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 88cc509..ab41552 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -480,15 +480,17 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 			dev_warn(pctldev->dev,
 				 "could not get pin desc for pin %d\n",
 				 pins[i]);
+			/* And release the pin */
+			pin_free(pctldev, pins[i], NULL);
 			continue;
 		}
-		desc->mux_setting = NULL;
+		if (desc->mux_setting == &(setting->data.mux)) {
+			desc->mux_setting = NULL;
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


