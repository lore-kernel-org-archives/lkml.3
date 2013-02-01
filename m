Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192Ab3BAMIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:08:50 -0500
Received: from nbd.name ([46.4.11.11]:41404 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3BAMIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:08:01 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH 09/11] PINCTRL: lantiq: add functionality to falcon_pinconf_dbg_show
Date: Fri,  1 Feb 2013 13:05:03 +0100
Message-Id: <1359720305-31933-9-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code only has a stub for falcon_pinconf_dbg_show. This patch adds
proper functionality.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-falcon.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index c5a9868..4a0d54a 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -315,6 +315,37 @@ static int falcon_pinconf_set(struct pinctrl_dev *pctrldev,
 static void falcon_pinconf_dbg_show(struct pinctrl_dev *pctrldev,
 			struct seq_file *s, unsigned offset)
 {
+	unsigned long config;
+	struct pin_desc *desc;
+
+	struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	int port = PORT(offset);
+
+	seq_printf(s, " (port %d) mux %d -- ", port,
+		pad_r32(info->membase[port], LTQ_PADC_MUX(PORT_PIN(offset))));
+
+	config = LTQ_PINCONF_PACK(LTQ_PINCONF_PARAM_PULL, 0);
+	if (!falcon_pinconf_get(pctrldev, offset, &config))
+		seq_printf(s, "pull %d ",
+			(int)LTQ_PINCONF_UNPACK_ARG(config));
+
+	config = LTQ_PINCONF_PACK(LTQ_PINCONF_PARAM_DRIVE_CURRENT, 0);
+	if (!falcon_pinconf_get(pctrldev, offset, &config))
+		seq_printf(s, "drive-current %d ",
+			(int)LTQ_PINCONF_UNPACK_ARG(config));
+
+	config = LTQ_PINCONF_PACK(LTQ_PINCONF_PARAM_SLEW_RATE, 0);
+	if (!falcon_pinconf_get(pctrldev, offset, &config))
+		seq_printf(s, "slew-rate %d ",
+			(int)LTQ_PINCONF_UNPACK_ARG(config));
+
+	desc = pin_desc_get(pctrldev, offset);
+	if (desc) {
+		if (desc->gpio_owner)
+			seq_printf(s, " owner: %s", desc->gpio_owner);
+	} else {
+		seq_printf(s, " not registered");
+	}
 }
 
 static void falcon_pinconf_group_dbg_show(struct pinctrl_dev *pctrldev,
-- 
1.7.10.4

