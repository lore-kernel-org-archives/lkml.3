Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaE0JkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:40:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752195AbaE0JkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:40:06 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 4/6] regulator: axp20x: reset probe data before each probe
Date: Tue, 27 May 2014 11:38:53 +0200
Message-Id: <1401183535-31003-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
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
index feaa0b5..4486517 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -323,6 +323,15 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
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

