Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3GQFjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:39:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47948 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab3GQFji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:39:38 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz8275bhz2ei87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23hff4m129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <buildroot-devel@blackfin.uclinux.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinmux: Don't free pins requested by other devices
Date: Wed, 17 Jul 2013 13:31:45 +0800
Message-ID: <1374039105-17777-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

in pinmux_disable_setting after current device fails to request
the same pins.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/pinmux.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 88cc509..9ebcf3b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -482,13 +482,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 				 pins[i]);
 			continue;
 		}
+		/* And release the pins */
+		if (desc->mux_usecount &&
+			!strcmp(desc->mux_owner, setting->dev_name))
+			pin_free(pctldev, pins[i], NULL);
+
 		desc->mux_setting = NULL;
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


