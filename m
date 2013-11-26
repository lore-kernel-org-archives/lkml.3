Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3KZCEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:04:39 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5363 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3KZCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:04:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 18:02:11 -0800
Date: Mon, 25 Nov 2013 18:04:34 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: SPEAr: clk_round_rate() can return a zero upon
 error
Message-ID: <alpine.DEB.2.02.1311251801210.23090@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Treat both negative and zero return values from clk_round_rate()
as errors.  This is needed since subsequent patches will convert
clk_round_rate()'s return value to be an unsigned type, rather
than a signed type, since some clock sources can generate rates
higher than (2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of
zero will be considered a error.  All other values will be
considered valid rates.  The comparison against values less than
0 is kept to preserve the correct behavior in the meantime.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
Applies on v3.13-rc1.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  drivers/cpufreq/spear-cpufreq.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index d02ccd19c9c4..45ea4c094542 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -138,7 +138,7 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
  	}

  	newfreq = clk_round_rate(srcclk, newfreq * mult);
-	if (newfreq < 0) {
+	if (newfreq <= 0) {
  		pr_err("clk_round_rate failed for cpu src clock\n");
  		return newfreq;
  	}
