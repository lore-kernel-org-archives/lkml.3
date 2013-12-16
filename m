Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3LPJN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:13:27 -0500
Received: from [213.199.154.209] ([213.199.154.209]:18300 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab3LPJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:13:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Anson Huang <b20788@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] regulator: anatop: add is_enabled interface
Date: Mon, 16 Dec 2013 16:09:48 -0500
Message-ID: <1387228188-461-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add is_enabled interface for anatop regulator in case
some drivers need to know regulator's status.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 drivers/regulator/anatop-regulator.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..770d836 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -97,10 +97,25 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 	return regulator_get_voltage_sel_regmap(reg);
 }
 
+static int anatop_regmap_is_enabled(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	u32 val;
+
+	if (!anatop_reg->control_reg)
+		return -ENOTSUPP;
+
+	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
+
+	return (val >> anatop_reg->vol_bit_shift) &
+		((1 << anatop_reg->vol_bit_width) - 1) ? 1 : 0;
+}
+
 static struct regulator_ops anatop_rops = {
 	.set_voltage_sel = anatop_regmap_set_voltage_sel,
 	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
+	.is_enabled = anatop_regmap_is_enabled,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
-- 
1.7.9.5


