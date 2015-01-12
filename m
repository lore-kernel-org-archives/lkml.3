Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbALSFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbbALSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 007/216] regulator: anatop: Set default voltage selector for vddpu
Date: Mon, 12 Jan 2015 18:02:04 +0000
Message-Id: <1421085933-32536-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit fe08be3ec8672ed92b3ed1b85810df9fa0f98931 upstream.

The code reads the default voltage selector from its register. If the
bootloader disables the regulator, the default voltage selector will be
0 which results in faulty behaviour of this regulator driver.

This patch sets a default voltage selector for vddpu if it is not set in
the register.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/anatop-regulator.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 4f730af70e7c..30e8d7ad5813 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -283,6 +283,14 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 			sreg->sel = 0;
 			sreg->bypass = true;
 		}
+
+		/*
+		 * In case vddpu was disabled by the bootloader, we need to set
+		 * a sane default until imx6-cpufreq was probed and changes the
+		 * voltage to the correct value. In this case we set 1.25V.
+		 */
+		if (!sreg->sel && !strcmp(sreg->name, "vddpu"))
+			sreg->sel = 22;
 	} else {
 		rdesc->ops = &anatop_rops;
 	}
-- 
2.1.4

