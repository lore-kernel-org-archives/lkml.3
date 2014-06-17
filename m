Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaFQHjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:39:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44384 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754214AbaFQHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:39:08 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 4/7] regulator: axp20x: reset probe data before each probe
Date: Tue, 17 Jun 2014 09:38:40 +0200
Message-Id: <1402990723-28138-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_data and of_node fields of the axp2xx_matches tables are filled
at each device probe by the axp20x_regulator_parse_dt function (which then
calls the of_regulator_match function).
This means we can probe a new device and consider data initialized during
the probe of another device as valid.

Reset init_data and of_node field to NULL before each probe in order to
avoid this kind of issue.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/axp20x-regulator.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 7a30f49..d42bf6d 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -324,6 +324,15 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 		nregulators = AXP20X_REG_ID_MAX;
 	}
 
+	/*
+	 * Reset matches table (this table might have been modified by a
+	 * previous AXP2xx device probe).
+	 */
+	for (i = 0; i < nmatches; i++) {
+		matches[i].init_data = NULL;
+		matches[i].of_node = NULL;
+	}
+
 	ret = axp20x_regulator_parse_dt(pdev, matches, nmatches);
 	if (ret)
 		return ret;
-- 
1.8.3.2

