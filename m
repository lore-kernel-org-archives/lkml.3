Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3KMPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:16:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46999 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab3KMPQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:16:50 -0500
Date: Wed, 13 Nov 2013 09:16:46 -0600
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
Message-ID: <20131113151645.GA17828@kahuna>
References: <1382638087-32054-1-git-send-email-nm@ti.com>
 <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
 <52824522.7020401@ti.com>
 <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:19-20131113, Viresh Kumar wrote:
> On 12 November 2013 20:41, Nishanth Menon <nm@ti.com> wrote:
> > On 11/12/2013 12:03 AM, Viresh Kumar wrote:
[...]
> >> Can you try attached patch? I will then repost it formally...
> >
> > I tried a equivalent of this for v3.12 tag:
[..]
> > @@ -1252,7 +1252,7 @@ static int __cpufreq_remove_dev_finish(struct
> > device *dev,
> >
> >         /* If cpu is last user of policy, free policy */
> >         if (cpus == 1) {
> > -               if (cpufreq_driver->target) {
> > +               if (cpufreq_driver->target && !frozen) {
> >                         ret = __cpufreq_governor(policy,
> >                                         CPUFREQ_GOV_POLICY_EXIT);
> 
> This is not an equivalent of my patch :)

arrgh, my bad.. Apologies for the bad one.. I missed it :( Does the following
look equivalent?
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 04548f7..a9847ce 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1186,7 +1186,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target) {
+	if (cpufreq_driver->target && (!frozen || policy->governor_enabled)) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -1295,7 +1295,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		if (!frozen)
 			cpufreq_policy_free(policy);
 	} else {
-		if (cpufreq_driver->target) {
+		if (cpufreq_driver->target && !frozen) {
 			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 				pr_err("%s: Failed to start governor\n",


With this, I now see:
wakeup from "mem" at Sat Jan  1 00:17:45 2000
[   40.823352] PM: Syncing filesystems ... done.
[   40.848058] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   40.857869] Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
[   40.884567] smsc95xx 1-3:1.0 eth0: entering SUSPEND2 mode
[   40.955323] PM: suspend of devices complete after 81.563 msecs
[   40.967333] PM: late suspend of devices complete after 5.789 msecs
[   40.981182] PM: noirq suspend of devices complete after 7.274 msecs
[   40.988005] Disabling non-boot CPUs ...
[   41.000297] CPU1: shutdown
[   43.169193] Powerdomain (core_pwrdm) didn't enter target state 1
[   43.175681] Powerdomain (emu_pwrdm) didn't enter target state 1
[   43.182097] Powerdomain (l3init_pwrdm) didn't enter target state 1
[   43.188762] Could not enter target state in pm_suspend
[   43.194298] A possible cause could be an old bootloader - try u-boot >= v2012.07
[   43.203291] Enabling non-boot CPUs ...
[   43.210398] CPU1: Booted secondary processor
[   43.212714] cpufreq: cpufreq_add_policy_cpu: Failed to stop governor
^^^ ??
[   43.224252] CPU1 is up
[   43.248114] PM: noirq resume of devices complete after 21.329 msecs
[   43.260582] PM: early resume of devices complete after 4.201 msecs
[   43.623307] ata1: SATA link down (SStatus 0 SControl 300)
[   44.006234] PM: resume of devices complete after 742.501 msecs
[   44.020163] Restarting tasks ... done.

but, yes, the patch does squelch the warning I saw.
-- 
Regards,
Nishanth Menon
