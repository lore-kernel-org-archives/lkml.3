Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3BAMIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:08:48 -0500
Received: from nbd.name ([46.4.11.11]:41413 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab3BAMIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:08:02 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH 10/11] PINCTRL: lantiq: fix pin availability check
Date: Fri,  1 Feb 2013 13:05:04 +0100
Message-Id: <1359720305-31933-10-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock needs to be activated for the check to work. In order to be compatible
with future silicon make sure that at least 1 pin is available before probing
the pad controller.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-falcon.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 4a0d54a..de9d1db 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -455,12 +455,17 @@ static int pinctrl_falcon_probe(struct platform_device *pdev)
 				*bank);
 			return -ENOMEM;
 		}
+		clk_activate(falcon_info.clk[*bank]);
 		avail = pad_r32(falcon_info.membase[*bank],
 					LTQ_PADC_AVAIL);
 		pins = fls(avail);
-		lantiq_load_pin_desc(&falcon_pads[pad_count], *bank, pins);
-		pad_count += pins;
-		clk_enable(falcon_info.clk[*bank]);
+		if (pins) {
+			lantiq_load_pin_desc(&falcon_pads[pad_count],
+								*bank, pins);
+			pad_count += pins;
+		} else {
+			clk_deactivate(falcon_info.clk[*bank]);
+		}
 		dev_dbg(&pdev->dev, "found %s with %d pads\n",
 				res.name, pins);
 	}
-- 
1.7.10.4

