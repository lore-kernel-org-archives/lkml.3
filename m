Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3GQOGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:06:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55935 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3GQOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:46 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH v2 11/15] cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:20 +0100
Message-Id: <1374069984-20567-12-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:42.0493 (UTC) FILETIME=[DD31FED0:01CE82F6]
X-MC-Unique: 113071715064314401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE7pFI026332

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index c233ea6..18aa3eb 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -165,6 +166,7 @@ static struct cpufreq_driver kirkwood_cpufreq_driver = {
 static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 {
 	struct device_node *np;
+	struct device *cpu_dev;
 	struct resource *res;
 	int err;
 
@@ -175,9 +177,17 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 	if (IS_ERR(priv.base))
 		return PTR_ERR(priv.base);
 
-	np = of_find_node_by_path("/cpus/cpu@0");
-	if (!np)
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev) {
+		dev_err(&pdev->dev, "failed to get cpu device\n");
 		return -ENODEV;
+	}
+
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		dev_err(&pdev->dev, "failed to get cpu device node\n");
+		return -ENODEV;
+	}
 
 	priv.cpu_clk = of_clk_get_by_name(np, "cpu_clk");
 	if (IS_ERR(priv.cpu_clk)) {
-- 
1.8.1.2


