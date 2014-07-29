Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaG2Q31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:29:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58435 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaG2Q3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:29:23 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC 3/5] regulator: core: Only apply constraints if available on list voltage
Date: Tue, 29 Jul 2014 18:28:57 +0200
Message-Id: <1406651339-28901-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a selector can't be used on a platform due to voltage constraints,
regulator_list_voltage() returns 0. Doing this unconditionally made
sense since constraints were set in machine_constraints_voltage() at
regulator registration time.

But for load switches that don't define a voltage output, the parent
supply voltage is used so the constraints should only be applied if
they were defined for the child regulators.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c3785..7472535 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2228,9 +2228,11 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 	}
 
 	if (ret > 0) {
-		if (ret < rdev->constraints->min_uV)
+		if (rdev->constraints->min_uV &&
+		    ret < rdev->constraints->min_uV)
 			ret = 0;
-		else if (ret > rdev->constraints->max_uV)
+		else if (rdev->constraints->max_uV &&
+			 ret > rdev->constraints->max_uV)
 			ret = 0;
 	}
 
-- 
2.0.0.rc2

