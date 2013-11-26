Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3KZCF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:05:26 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5397 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KZCFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:05:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 18:03:00 -0800
Date: Mon, 25 Nov 2013 18:01:18 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Mike Turquette <mturquette@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: cpufreq-cpu0: clk_round_rate() can return a zero
 upon error
Message-ID: <alpine.DEB.2.02.1311251559460.23090@tamien>
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

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
---
Applies on v3.13-rc1.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  drivers/cpufreq/cpufreq-cpu0.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index d4585ce2346c..0faf756f6197 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -44,7 +44,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
  	int ret;

  	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
-	if (freq_Hz < 0)
+	if (freq_Hz <= 0)
  		freq_Hz = freq_table[index].frequency * 1000;

  	freq_exact = freq_Hz;
