Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3LTG4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:56:48 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33088 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LTG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:56:46 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org, rjw@rjwysocki.net,
        shawn.guo@linaro.org, festevam@gmail.com, b20788@freescale.com,
        viresh.kumar@linaro.org
Cc: John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH v3] cpufreq: imx6q: add of_init_opp_table
Date: Thu, 19 Dec 2013 22:56:28 -0800
Message-Id: <1387522588-13114-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a routine check to see if the platform supplied the OPP table.
Incase there's no OPP table exist, it will try to initialise it.

It's been tested on iMX6SL board where the platform doesn't have
an OPP table.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
 drivers/cpufreq/imx6q-cpufreq.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 4b3f18e..e125aed 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -187,12 +187,25 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		goto put_node;
 	}
 
-	/* We expect an OPP table supplied by platform */
+	/*
+	 * We expect an OPP table supplied by platform.
+	 * Just, incase the platform did not supply the OPP
+	 * table, it will try to get it.
+	 */
 	num = dev_pm_opp_get_opp_count(cpu_dev);
 	if (num < 0) {
-		ret = num;
-		dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
-		goto put_node;
+		ret = of_init_opp_table(cpu_dev);
+		if (ret < 0) {
+			dev_err(cpu_dev, "failed to init OPP table: %d\n", ret);
+			goto put_node;
+		}
+
+		num = dev_pm_opp_get_opp_count(cpu_dev);
+		if (num < 0) {
+			ret = num;
+			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
+			goto put_node;
+		}
 	}
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
-- 
1.8.3.2

