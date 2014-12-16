Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLPALF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:11:05 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:44391 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaLPALD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:11:03 -0500
Date: Mon, 15 Dec 2014 16:10:58 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq-dt: defer probing if OPP table is not ready
Message-ID: <20141216001058.GA31286@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-dt driver supports mode when OPP table is provided by platform
code and not device tree. However on certain platforms code that fills
OPP table may run after cpufreq driver tries to initialize, so let's
report -EPROBE_DEFER if we do not find any entires in OPP table for the
CPU.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/cpufreq/cpufreq-dt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
index f56147a..4f874fa 100644
--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -211,6 +211,19 @@ static int cpufreq_init(struct cpufreq_policy *policy)
 	/* OPPs might be populated at runtime, don't check for error here */
 	of_init_opp_table(cpu_dev);
 
+	/*
+	 * But we need OPP table to function so if it is not there let's
+	 * give platform code chance to provide it for us.
+	 */
+	rcu_read_lock();
+	ret = dev_pm_opp_get_opp_count(cpu_dev);
+	rcu_read_unlock();
+	if (ret <= 0) {
+		pr_debug("OPP table is not ready, deferring probe\n");
+		ret = -EPROBE_DEFER;
+		goto out_free_opp;
+	}
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
