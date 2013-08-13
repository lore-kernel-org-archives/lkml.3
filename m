Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3HMG4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:56:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3HMGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 19/60] cpufreq: loongson2: fix regression related to clock management
Date: Mon, 12 Aug 2013 23:33:46 -0700
Message-Id: <20130813063334.828604700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit f54fe64d14dff3df6d45a48115d248a82557811f upstream.

Commit 42913c799 (MIPS: Loongson2: Use clk API instead of direct
dereferences) broke the cpufreq functionality on Loongson2 boards:
clk_set_rate() is called before the CPU frequency table is
initialized, and therefore will always fail.

Fix by moving the clk_set_rate() after the table initialization.
Tested on Lemote FuLoong mini-PC.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/loongson2_cpufreq.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -118,11 +118,6 @@ static int loongson2_cpufreq_cpu_init(st
 		clk_put(cpuclk);
 		return -EINVAL;
 	}
-	ret = clk_set_rate(cpuclk, rate);
-	if (ret) {
-		clk_put(cpuclk);
-		return ret;
-	}
 
 	/* clock table init */
 	for (i = 2;
@@ -130,6 +125,12 @@ static int loongson2_cpufreq_cpu_init(st
 	     i++)
 		loongson2_clockmod_table[i].frequency = (rate * i) / 8;
 
+	ret = clk_set_rate(cpuclk, rate);
+	if (ret) {
+		clk_put(cpuclk);
+		return ret;
+	}
+
 	policy->cur = loongson2_cpufreq_get(policy->cpu);
 
 	cpufreq_frequency_table_get_attr(&loongson2_clockmod_table[0],


