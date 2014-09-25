Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaIYQbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:31:44 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:38524 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaIYQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:53 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 06/13] PM / Domains: Retrieve PM QoS device latencies from DT
Date: Thu, 25 Sep 2014 18:28:33 +0200
Message-Id: <1411662520-22795-7-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - No changes
v2:
  - New

 drivers/base/power/domain.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 0ebc6bb31c9c227f..c79d5d43a5249562 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2174,6 +2174,8 @@ int genpd_dev_pm_attach(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args pd_args;
 	struct generic_pm_domain *pd;
+	struct gpd_timing_data td;
+	u32 latency;
 	int ret;
 
 	if (!np)
@@ -2206,10 +2208,20 @@ int genpd_dev_pm_attach(struct device *dev)
 		return PTR_ERR(pd);
 	}
 
+	memset(&td, 0, sizeof(td));
+	if (!of_property_read_u32(np, "stop-latency", &latency))
+		td.stop_latency_ns = latency;
+	if (!of_property_read_u32(np, "start-latency", &latency))
+		td.start_latency_ns = latency;
+	if (!of_property_read_u32(np, "save-state-latency", &latency))
+		td.save_state_latency_ns = latency;
+	if (!of_property_read_u32(np, "restore-state-latency", &latency))
+		td.restore_state_latency_ns = latency;
+
 	dev_dbg(dev, "adding to PM domain %s\n", pd->name);
 
 	while (1) {
-		ret = pm_genpd_add_device(pd, dev);
+		ret = __pm_genpd_add_device(pd, dev, &td);
 		if (ret != -EAGAIN)
 			break;
 		cond_resched();
-- 
1.9.1

