Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaLPAuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:50:54 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36830 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaLPAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:50:52 -0500
Date: Mon, 15 Dec 2014 16:50:48 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Anson Huang <b20788@freescale.com>,
        John Tobias <john.tobias.ph@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: imx6: prorect calls to dev_pm_opp_get_opp_count
 with RCU lock
Message-ID: <20141216005048.GA3802@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_pm_opp_get_opp_count() must be called with RCU lock held.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested at all...

 drivers/cpufreq/imx6q-cpufreq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 380a90d..851d4fd 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -200,7 +200,9 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	 * Just, incase the platform did not supply the OPP
 	 * table, it will try to get it.
 	 */
+	rcu_read_lock();
 	num = dev_pm_opp_get_opp_count(cpu_dev);
+	rcu_read_unlock();
 	if (num < 0) {
 		ret = of_init_opp_table(cpu_dev);
 		if (ret < 0) {
@@ -211,7 +213,9 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		/* Because we have added the OPPs here, we must free them */
 		free_opp = true;
 
+		rcu_read_lock();
 		num = dev_pm_opp_get_opp_count(cpu_dev);
+		rcu_read_unlock();
 		if (num < 0) {
 			ret = num;
 			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
