Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaG2Qak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:30:40 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58421 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaG2Q3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:29:20 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC 1/5] regulator: core: Get voltage from parent if not available
Date: Tue, 29 Jul 2014 18:28:55 +0200
Message-Id: <1406651339-28901-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load switches are modeled as regulators but they just provide
the voltage of their parent input supply. So the drivers for
these switches usually don't provide a .get_voltage function
handler but there is code in the kernel that assumes that all
regulators should be able to provide its current voltage rail.

So, if the output voltage for a regulator is not available and
it has a parent supply, then pass the voltage of its parent.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 69c9c08..089cea8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2695,6 +2695,8 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->list_voltage(rdev, 0);
 	} else if (rdev->desc->fixed_uV && (rdev->desc->n_voltages == 1)) {
 		ret = rdev->desc->fixed_uV;
+	} else if (rdev->supply) {
+		ret = regulator_get_voltage(rdev->supply);
 	} else {
 		return -EINVAL;
 	}
-- 
2.0.0.rc2

