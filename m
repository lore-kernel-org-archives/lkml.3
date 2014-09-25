Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIYQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:29:31 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58261 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaIYQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:55 -0400
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
Subject: [PATCH v3 01/13] PM / Domains: Add genpd attach/detach callbacks
Date: Thu, 25 Sep 2014 18:28:28 +0200
Message-Id: <1411662520-22795-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
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
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v3:
  - Add Reviewed-by (Ulf: are you still OK with the changes in v3?)
  - Move calling of the callbacks to a point where dev->pm_domain is
    valid, so the domain parameter is no longer needed,
  - Make callbacks return void.
v2:
  - New

 drivers/base/power/domain.c | 6 ++++++
 include/linux/pm_domain.h   | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index cd400575ee0ee89c..6e36bb09e7d9c144 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1436,6 +1436,9 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 
 	spin_unlock_irq(&dev->power.lock);
 
+	if (genpd->attach_dev)
+		genpd->attach_dev(dev);
+
 	mutex_lock(&gpd_data->lock);
 	gpd_data->base.dev = dev;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
@@ -1528,6 +1531,9 @@ int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 	genpd->device_count--;
 	genpd->max_off_time_changed = true;
 
+	if (genpd->detach_dev)
+		genpd->detach_dev(dev);
+
 	spin_lock_irq(&dev->power.lock);
 
 	dev->pm_domain = NULL;
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 292079d8da6b8a78..9a93e622bdea3f79 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -73,6 +73,8 @@ struct generic_pm_domain {
 	bool cached_power_down_ok;
 	struct device_node *of_node; /* Node in device tree */
 	struct gpd_cpu_data *cpu_data;
+	void (*attach_dev)(struct device *dev);
+	void (*detach_dev)(struct device *dev);
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
-- 
1.9.1

