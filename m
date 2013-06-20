Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3FTVnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:43:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60455 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab3FTVnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:43:49 -0400
Date: Thu, 20 Jun 2013 16:43:45 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <viresh.kumar@linaro.org>,
        <cpufreq@vger.kernel.org>
Subject: Re: [RFC PATCH] regulator: core: allow consumers to request to
 closes step voltage
Message-ID: <20130620214344.GA10756@kahuna>
References: <1371669474-24473-1-git-send-email-nm@ti.com>
 <20130619223828.GK1403@sirena.org.uk>
 <20130620124542.GA28320@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130620124542.GA28320@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:45-20130620, Nishanth Menon wrote:
> On 23:38-20130619, Mark Brown wrote:
> > On Wed, Jun 19, 2013 at 02:17:54PM -0500, Nishanth Menon wrote:
> > 
> > > Account for step size accuracy when exact voltage requests are send for
> > > step based regulators.
> > 
> > If the consumer can tolerate a different voltage why not just request
> > the range that can be tolerated?  Your problem here is specifying an
> > exact voltage.
> I think you mean using regulator_get_linear_step
> 
> > 
> > > The specific example I faced was using cpufreq-cpu0 driver with voltages
> > > for OPPs for MPU rail and attempting the common definitions against voltages
> > > that are non-exact multiples of stepsize of PMIC.
> > 
> > > The alternative would be implement custom set_voltage (as againsta simpler
> > > set_voltage_sel and using linear map/list functions) for the regulator which
> > > will account for the same.
> > 
> > > Yet another alternative might be to introduce yet another custom function similar
> > > to regulator_set_voltage_tol which accounts for this. something like:
> > > regulator_set_voltage_floor(regulator, voltage, tol) or something to that effect.
> > 
> > Or as I keep telling you guys the consumer can just do that directly
> > using the existing API; the whole point in specifying the voltage as a
> > range is to allow the consumer to cope with arbatrary regulators by
> > giving a range of voltages that it can accept.
> > 
> > The API is deliberately very conservative in these matters since there
> > is a danger of physical damage if things really go wrong in some
> > applications, it makes sure that both the drivers and the system
> > integration are involved.
> I agree. The intent of this series was to start a conversation to see if
> we can make it simpler.
> 
> Searching for the users of regulator_get_linear_step in 3.10-rc6
> shows none.
> 
> For a generic driver which needs to handle platforms which
> have tolerance, they'd use regulator_set_voltage_tol. But the
> implementation would allow for uV - tol to uV + tol as range, which in
> the case I mentioned(min voltage =uV) wont work.
> 
> If the consumer wants to be aware of linear step regulator, they'd have to do:
> step_uV = regulator_get_linear_step(...);
> regulator_set_voltage(uV, uV + step_uV);
> 
> Then this wont handle tolerance. So the solution seems to be (for the
> consumer):
> step_uV = regulator_get_linear_step(...);
> ..
> if (tol)
> 	regulator_set_voltage_tol(uV, tol);
> else
> 	regulator_set_voltage(uV, uV + step_uV);
> (with the required error checks for regulator being a linear regulator
>  etc..).
> 
> At least to me, there is no sane manner to handle "tolerance" and linear step
> accuracy for a defined voltage (Should tolerance be rounded off to
> step_uV? what about the border cases etc.)
> 
> Would you agree?

Here is an RFC for the same. My hope was to see if something simpler
could be done.
>From cb9830191cb9b8021e50bcda25d110b4b9a7dbd3 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Thu, 20 Jun 2013 16:37:30 -0500
Subject: [RFC PATCH] cpufreq: cpufreq-cpu0: account for regulator step size
 accuracy

Generic regulator consumers such as cpufreq-cpu0 are not aware
of the characteristics of regulator used to supply. For example:
consumerX requests for voltage min_uV = 500mV, max_uV = 500mV
On a regulator which has a step size of 10mV, this can be exactly
achieved.

However, on a regulator which is non-exact divider step size (example
12.66mV step size), the closest achievable would be 506.4.
regulator_set_voltage_tol does not work out either as <500mV is not an
acceptable operational voltage.

Account for step size accuracy when exact voltage requests are send for
step based regulators.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..707565c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -28,6 +28,7 @@ static struct device *cpu_dev;
 static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
+static int cpu_reg_step_size;
 
 static int cpu0_verify_speed(struct cpufreq_policy *policy)
 {
@@ -91,7 +92,12 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 
 	/* scaling up?  scale voltage before frequency */
 	if (cpu_reg && freqs.new > freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		if (tol)
+			ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		else
+			ret = regulator_set_voltage(cpu_reg, volt,
+						    volt + cpu_reg_step_size);
+
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
 			freqs.new = freqs.old;
@@ -102,15 +108,28 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	ret = clk_set_rate(cpu_clk, freq_exact);
 	if (ret) {
 		pr_err("failed to set clock rate: %d\n", ret);
-		if (cpu_reg)
-			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
+		if (cpu_reg) {
+			if (tol)
+				ret = regulator_set_voltage_tol(cpu_reg,
+								volt_old,
+								tol);
+			else
+				ret = regulator_set_voltage(cpu_reg,
+							    volt_old,
+							    volt_old +
+							    cpu_reg_step_size);
+		}
 		freqs.new = freqs.old;
 		goto post_notify;
 	}
 
 	/* scaling down?  scale voltage after frequency */
 	if (cpu_reg && freqs.new < freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		if (tol)
+			ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		else
+			ret = regulator_set_voltage(cpu_reg, volt,
+						    volt + cpu_reg_step_size);
 		if (ret) {
 			pr_err("failed to scale voltage down: %d\n", ret);
 			clk_set_rate(cpu_clk, freqs.old * 1000);
@@ -260,6 +279,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		ret = regulator_set_voltage_time(cpu_reg, min_uV, max_uV);
 		if (ret > 0)
 			transition_latency += ret * 1000;
+		cpu_reg_step_size = regulator_get_linear_step(cpu_reg);
 	}
 
 	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
-- 
1.7.9.5


-- 
Regards,
Nishanth Menon
