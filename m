Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaIPSt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:49:29 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:53711 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaIPStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:20 -0400
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
Subject: [PATCH/RFC v2 07/12] ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev() for pm_clk setup
Date: Tue, 16 Sep 2014 20:48:54 +0200
Message-Id: <1410893339-6361-8-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the just introduced genpd attach/detach callbacks to register the
devices' module clocks, instead of doing it directly, to make it
DT-proof.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 arch/arm/mach-shmobile/pm-rmobile.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 717e6413d29cb998..4c8e47179fdd333b 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -101,6 +101,22 @@ static bool rmobile_pd_active_wakeup(struct device *dev)
 	return true;
 }
 
+static int rmobile_pd_attach_dev(struct generic_pm_domain *genpd,
+				 struct device *dev)
+{
+	if (pm_clk_no_clocks(dev))
+		pm_clk_add(dev, NULL);
+
+	return 0;
+}
+
+static int rmobile_pd_detach_dev(struct generic_pm_domain *genpd,
+				 struct device *dev)
+{
+	pm_clk_remove(dev, NULL);
+	return 0;
+}
+
 static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 {
 	struct generic_pm_domain *genpd = &rmobile_pd->genpd;
@@ -112,6 +128,8 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 	genpd->dev_ops.active_wakeup	= rmobile_pd_active_wakeup;
 	genpd->power_off		= rmobile_pd_power_down;
 	genpd->power_on			= rmobile_pd_power_up;
+	genpd->attach_dev		= rmobile_pd_attach_dev;
+	genpd->detach_dev		= rmobile_pd_detach_dev;
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
@@ -130,8 +148,6 @@ void rmobile_add_device_to_domain_td(const char *domain_name,
 	struct device *dev = &pdev->dev;
 
 	__pm_genpd_name_add_device(domain_name, dev, td);
-	if (pm_clk_no_clocks(dev))
-		pm_clk_add(dev, NULL);
 }
 
 void rmobile_add_devices_to_domains(struct pm_domain_device data[],
-- 
1.9.1

