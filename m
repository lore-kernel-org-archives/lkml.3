Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3EUSNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46851 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3EUSNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:17 -0500
Message-Id: <1369160001-4019-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 3/7] mfd: arizona: Add missing cleanup on remove
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd forgotten to disable /RESET or the regulators. Practically speaking
this code is unlikely to ever be run.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 25bfd1e..8002e2d 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -839,6 +839,11 @@ int arizona_dev_exit(struct arizona *arizona)
 	arizona_free_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, arizona);
 	pm_runtime_disable(arizona->dev);
 	arizona_irq_exit(arizona);
+	if (arizona->pdata.reset)
+		gpio_set_value_cansleep(arizona->pdata.reset, 0);
+	regulator_disable(arizona->dcvdd);
+	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
+			       arizona->core_supplies);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(arizona_dev_exit);
-- 
1.7.10.4

