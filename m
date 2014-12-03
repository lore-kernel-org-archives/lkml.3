Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaLCNmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:42:00 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:38330 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaLCNl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:41:57 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v6 2/7] ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev() for pm_clk setup
Date: Wed,  3 Dec 2014 14:41:42 +0100
Message-Id: <1417614107-5985-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417614107-5985-1-git-send-email-geert+renesas@glider.be>
References: <1417614107-5985-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the just introduced genpd attach/detach callbacks to register the
devices' module clocks, instead of doing it directly, to make it
DT-proof.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v6:
  - No changes,
v5:
  - Update for {at,de}tach_dev() taking a generic_pm_domain pointer
    again,
v4:
  - Add Reviewed-by,
  - Add missing pm_clk_create()/pm_clk_destroy() calls,
  - Update for attach_dev() returning an error code again,
v3:
  - Update for callback signature changes,
v2:
  - New.
---
 arch/arm/mach-shmobile/pm-rmobile.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 717e6413d29cb998..168046c355fc8368 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -101,6 +101,36 @@ static bool rmobile_pd_active_wakeup(struct device *dev)
 	return true;
 }
 
+static int rmobile_pd_attach_dev(struct generic_pm_domain *domain,
+				 struct device *dev)
+{
+	int error;
+
+	error = pm_clk_create(dev);
+	if (error) {
+		dev_err(dev, "pm_clk_create failed %d\n", error);
+		return error;
+	}
+
+	error = pm_clk_add(dev, NULL);
+	if (error) {
+		dev_err(dev, "pm_clk_add failed %d\n", error);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	pm_clk_destroy(dev);
+	return error;
+}
+
+static void rmobile_pd_detach_dev(struct generic_pm_domain *domain,
+				  struct device *dev)
+{
+	pm_clk_destroy(dev);
+}
+
 static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 {
 	struct generic_pm_domain *genpd = &rmobile_pd->genpd;
@@ -112,6 +142,8 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 	genpd->dev_ops.active_wakeup	= rmobile_pd_active_wakeup;
 	genpd->power_off		= rmobile_pd_power_down;
 	genpd->power_on			= rmobile_pd_power_up;
+	genpd->attach_dev		= rmobile_pd_attach_dev;
+	genpd->detach_dev		= rmobile_pd_detach_dev;
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
@@ -130,8 +162,6 @@ void rmobile_add_device_to_domain_td(const char *domain_name,
 	struct device *dev = &pdev->dev;
 
 	__pm_genpd_name_add_device(domain_name, dev, td);
-	if (pm_clk_no_clocks(dev))
-		pm_clk_add(dev, NULL);
 }
 
 void rmobile_add_devices_to_domains(struct pm_domain_device data[],
-- 
1.9.1

