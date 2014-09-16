Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaIPSuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:50:39 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:34957 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaIPStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:25 -0400
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
Subject: [PATCH/RFC v2 04/12] PM / Domains: Add genpd attach/detach callbacks
Date: Tue, 16 Sep 2014 20:48:51 +0200
Message-Id: <1410893339-6361-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While a PM domain can enable PM runtime management of its devices' module
clocks by setting

	genpd->dev_ops.stop = pm_clk_suspend;
	genpd->dev_ops.start = pm_clk_resume;

this also requires registering the clocks with the pm_clk subsystem.
In the legacy case, this is handled by the platform code, after
attaching the device to its PM domain.

When the devices are instantiated from DT, devices are attached to their
PM domains by generic code, leaving no method for the platform-specific
PM domain code to register their clocks.

Add two callbacks, allowing a PM domain to perform platform-specific
tasks when a device is attached to or detached from a PM domain.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 drivers/base/power/domain.c | 12 ++++++++++++
 include/linux/pm_domain.h   |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index f09b615e61515d11..3fa15b6c54f09b36 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1418,6 +1418,12 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	if (ret)
 		goto out;
 
+	if (genpd->attach_dev) {
+		ret = genpd->attach_dev(genpd, dev);
+		if (ret)
+			goto out;
+	}
+
 	genpd->device_count++;
 	genpd->max_off_time_changed = true;
 
@@ -1541,6 +1547,12 @@ int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 
 	spin_unlock_irq(&dev->power.lock);
 
+	if (genpd->detach_dev) {
+		ret = genpd->detach_dev(genpd, dev);
+		if (ret)
+			goto out;
+	}
+
 	mutex_lock(&gpd_data->lock);
 	pdd->dev = NULL;
 	mutex_unlock(&gpd_data->lock);
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index ff128c1ec0de231c..ac07918f907b7495 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -73,6 +73,8 @@ struct generic_pm_domain {
 	bool cached_power_down_ok;
 	struct device_node *of_node; /* Node in device tree */
 	struct gpd_cpu_data *cpu_data;
+	int (*attach_dev)(struct generic_pm_domain *domain, struct device *dev);
+	int (*detach_dev)(struct generic_pm_domain *domain, struct device *dev);
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
-- 
1.9.1

