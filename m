Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KPO2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:28:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56777 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751750Ab3KPO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:28:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Update PATCH 1/1] Cpufreq: Make governor data on nonboot cpus across system suspend/resume
Date: Sat, 16 Nov 2013 15:41:10 +0100
Message-ID: <9847309.KdKOG5y1Zx@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5286EDBF.9050001@intel.com>
References: <1384495294-10565-1-git-send-email-tianyu.lan@intel.com> <2368963.sKiLjXYCVt@vostro.rjw.lan> <5286EDBF.9050001@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 11:59:59 AM Lan Tianyu wrote:
> On 11/16/2013 08:38 AM, Rafael J. Wysocki wrote:
> > On Friday, November 15, 2013 04:15:34 PM Lan Tianyu wrote:
> >> Currently, governor of nonboot cpus will be put to EXIT when system suspend.
> >> Since all these cpus will be unplugged and the governor usage_count decreases
> >> to zero. The governor data and its sysfs interfaces will be freed or released.
> >> This makes user config of these governors loss during suspend and resume.
> >
> > First off, do we have a pointer to a bug report related to that?
> >
> 
> No, I found this bug when I tried to resolve other similar bug.
> https://bugzilla.kernel.org/show_bug.cgi?id=63081. I still have no idea 
> about bug 63081 and asked reporter to try this patch.
> 
> > Second, what does need to be done to reproduce this problem?
> >
> 
> Defaultly, all cpus use ondemand governor after bootup. Change one 
> non-boot cpu's governor to conservative,

Well, why would anyone want to do that?  Just out of curiosity ...

> modify conservative config via sysfs interface and then do system suspend.
> After resume, the config of conservative is reset. On my machine, all cpus
> have owen policy.

So this is acpi-cpufreq, right?

The patch looks basically OK to me, but ->

> >> This doesn't happen on the governor covering boot cpu because it isn't
> >> unplugged during system suspend.
> >>
> >> To fix this issue, skipping governor exit during system suspend and check
> >> policy governor data to determine whether the governor is really needed
> >> to be initialized when do init. If not, return EALREADY to indicate the
> >> governor has been initialized and should do nothing. __cpufreq_governor()
> >> convert EALREADY to 0 as return value for INIT event since governor is
> >> still under INIT state and can do START operation.
> >>
> >> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> >> ---
> >> Fix some typos
> >>
> >>   drivers/cpufreq/cpufreq.c          |  5 ++++-
> >>   drivers/cpufreq/cpufreq_governor.c | 13 ++++++++++++-
> >>   2 files changed, 16 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index 02d534d..38f2e4a 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -1239,7 +1239,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
> >>
> >>   	/* If cpu is last user of policy, free policy */
> >>   	if (cpus == 1) {
> >> -		if (has_target()) {
> >> +		if (has_target() && !frozen) {
> >>   			ret = __cpufreq_governor(policy,
> >>   					CPUFREQ_GOV_POLICY_EXIT);
> >>   			if (ret) {
> >> @@ -1822,6 +1822,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >>   			((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> >>   		module_put(policy->governor->owner);
> >>
> >> +	if ((event == CPUFREQ_GOV_POLICY_INIT) && ret == -EALREADY)
> >> +		ret = 0;
> >> +

-> I'd prefer this check to be combined with the one done to determine whether
or not we need to do the module_put().  Something like

	if (event == CPUFREQ_GOV_POLICY_EXIT && ret) {
		module_put(policy->governor->owner);
		if (ret == -EALREADY)
			return 0;
	} else if (event == CPUFREQ_GOV_POLICY_EXIT && !ret) {
		module_put(policy->governor->owner);
	}

Thanks!

> >>   	return ret;
> >>   }
> >>
> >> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> >> index 0806c31..ddb93af 100644
> >> --- a/drivers/cpufreq/cpufreq_governor.c
> >> +++ b/drivers/cpufreq/cpufreq_governor.c
> >> @@ -204,9 +204,20 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> >>
> >>   	switch (event) {
> >>   	case CPUFREQ_GOV_POLICY_INIT:
> >> +		/*
> >> +		 * In order to keep governor data across suspend/resume,
> >> +		 * Governor doesn't exit when suspend and will be
> >> +		 * reinitialized when resume. Here check policy governor
> >> +		 * data to determine whether the governor has been exited.
> >> +		 * If not, return EALREADY.
> >> +		 */
> >>   		if (have_governor_per_policy()) {
> >> -			WARN_ON(dbs_data);
> >> +			if (dbs_data)
> >> +				return -EALREADY;
> >>   		} else if (dbs_data) {
> >> +			if (policy->governor_data == dbs_data)
> >> +				return -EALREADY;
> >> +
> >>   			dbs_data->usage_count++;
> >>   			policy->governor_data = dbs_data;
> >>   			return 0;
> >>
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
