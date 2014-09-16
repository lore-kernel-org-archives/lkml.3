Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaIPSwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:52:41 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:49806 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaIPStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:23 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 06/12] PM / Domains: Retrieve PM QoS device latencies from DT
Date: Tue, 16 Sep 2014 20:48:53 +0200
Message-Id: <1410893339-6361-7-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 drivers/base/power/domain.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index e1cbde985d4de606..7b166911be541229 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2133,6 +2133,8 @@ int genpd_dev_pm_attach(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args pd_args;
 	struct generic_pm_domain *pd;
+	struct gpd_timing_data td;
+	u32 latency;
 	int ret;
 
 	if (!np)
@@ -2165,10 +2167,20 @@ int genpd_dev_pm_attach(struct device *dev)
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

