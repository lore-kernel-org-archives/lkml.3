Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaKCPgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:36:19 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:34925 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaKCPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:35:04 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 5/9] ARM: shmobile: R-Mobile: Enable module clocks if !CONFIG_PM_RUNTIME
Date: Mon,  3 Nov 2014 16:34:52 +0100
Message-Id: <1415028896-9005-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
References: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_RUNTIME is not set, the clocks must be enabled before the
devices can be used.

Currently these clocks are enabled by the !CONFIG_PM_RUNTIME version of
pm_clk_notify, activated by the hack in drivers/sh/pm_runtime.c, but
this will go away soon (at least for DT).

On detach, disabling the clocks is already handled by pm_clk_destroy().
On system suspend/resume, disabling/enabling clocks is already handled
from the genpd->dev_ops.{start,stop}() callbacks.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v4:
  - New.
---
 arch/arm/mach-shmobile/pm-rmobile.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 068608d5f54a9a64..6fb86cdb9fa2b3a7 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -117,6 +117,14 @@ static int rmobile_pd_attach_dev(struct device *dev)
 		goto fail;
 	}
 
+	if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
+		error = pm_clk_resume(dev);
+		if (error) {
+			dev_err(dev, "pm_clk_resume failed %d\n", error);
+			goto fail;
+		}
+	}
+
 	return 0;
 
 fail:
-- 
1.9.1

