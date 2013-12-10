Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3LJCSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:18:25 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9721 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LJCSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:18:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 18:11:28 -0800
Date: Mon, 9 Dec 2013 18:18:22 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: <linux-omap@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: omap: clk_round_rate() can return a zero upon
 error
Message-ID: <alpine.DEB.2.02.1312091812440.4127@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Treat both negative and zero return values from clk_round_rate() as 
errors.  This is needed since subsequent patches will convert 
clk_round_rate()'s return value to be an unsigned type, rather than a 
signed type, since some clock sources can generate rates higher than 
(2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of
zero will be considered a error.  All other values will be
considered valid rates.  The comparison against values less than
0 is kept to preserve the correct behavior in the meantime.

This patch also removes a bogus usage of IS_ERR_VALUE(), which is intended 
to be used only on combination pointer/error code return values; a 
side-benefit.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  drivers/cpufreq/omap-cpufreq.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index a0acd0bfba40..0f41eb2609f3 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -63,7 +63,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)

  	freq = new_freq * 1000;
  	ret = clk_round_rate(mpu_clk, freq);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret <= 0) {
  		dev_warn(mpu_dev,
  			 "CPUfreq: Cannot find matching frequency for %lu\n",
  			 freq);
