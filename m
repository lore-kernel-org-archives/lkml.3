Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3K0LyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:54:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50493 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3K0LyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:54:09 -0500
Date: Wed, 27 Nov 2013 12:54:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: viresh.kumar@linaro.org, egtvedt@samfundet.no, jesper.nilsson@axis.com,
        linux@arm.linux.org.uk, swarren@nvidia.com, andrew@lunn.ch,
        nicolas.pitre@linaro.org, tianyu.lan@intel.com,
        rafael.j.wysocki@intel.com, kernel list <linux-kernel@vger.kernel.org>,
        tony@atomide.com, sre@ring0.de, pali.rohar@gmail.com, arm@kernel.org
Subject: omap-cpufreq compilation breakage in 3.13-rc1
Message-ID: <20131127115407.GA6773@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit d4019f0a92ab802f385cc9c8ad3ab7b5449712cb broke compilation for
omap-cpufreq.c . Given impresive list of ACKs and Tested-bys, I'd not
expect such problem. This fixes it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index be6d143..96c9ee49 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -56,6 +56,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 	struct dev_pm_opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
+	long ret;
 
 	old_freq = omap_getspeed(policy->cpu);
 	new_freq = freq_table[index].frequency;
@@ -91,6 +92,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 
 	/* scaling up?  scale voltage before frequency */
 	if (mpu_reg && (new_freq > old_freq)) {
+		long r;
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
@@ -103,6 +105,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 
 	/* scaling down?  scale voltage after frequency */
 	if (mpu_reg && (new_freq < old_freq)) {
+		long r;
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
