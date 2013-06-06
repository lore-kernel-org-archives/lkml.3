Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3FFK5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:57:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58842 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3FFK5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:57:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Jin <joe.jin@oracle.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Neil Gu <qing.gu@oracle.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: update user_policy.max when _PPC updated
Date: Thu, 06 Jun 2013 13:06:45 +0200
Message-ID: <42861210.QMFsUVH8RU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51AFD75C.3030705@oracle.com>
References: <51AE8BE4.8050409@oracle.com> <31897041.QcNuTieHbo@vostro.rjw.lan> <51AFD75C.3030705@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 06, 2013 08:27:08 AM Joe Jin wrote:
> On 06/06/13 04:40, Rafael J. Wysocki wrote:
> > On Wednesday, June 05, 2013 08:52:52 AM Joe Jin wrote:
> >> When _PPC changed dynamically the user_policy.max will not be updated,
> >> this prevent CPU run on the highest frequency.
> > 
> > Why should the user setting be always related to the current maximum available
> > frequency?  What if the user sets the limit for power capping purposes?
> 
> cpufreq_update_policy() get policy->max from user_policy.max:
> 
> 1782 int cpufreq_update_policy(unsigned int cpu)
> 1783 {
> [...]
> 1800         policy.min = data->user_policy.min;
> 1801         policy.max = data->user_policy.max;
> 1802         policy.policy = data->user_policy.policy;
> 1803         policy.governor = data->user_policy.governor;
> [...]
> 1819         ret = __cpufreq_set_policy(data, &policy);
> [...]
> 
> /sys/devices/system/cpu/cpu$/cpufreq/scaling_max_freq using policy->max 
> and user_policy->max, when update it, so I think _PPC changes also need
> to update these two?

Yes, if policy.max happens to be greater that the maximum available frequency,
then (and only then) it probably should be updated.  It should never be bumped
up, though.

Thanks,
Rafael


> >> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> >> ---
> >>  drivers/acpi/processor_perflib.c | 17 ++++++++++++++++-
> >>  1 file changed, 16 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> >> index e854582..e01aa7d 100644
> >> --- a/drivers/acpi/processor_perflib.c
> >> +++ b/drivers/acpi/processor_perflib.c
> >> @@ -180,6 +180,7 @@ static void acpi_processor_ppc_ost(acpi_handle handle, int status)
> >>  int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
> >>  {
> >>  	int ret;
> >> +	unsigned int saved = (unsigned int)pr->performance_platform_limit;
> >>  
> >>  	if (ignore_ppc) {
> >>  		/*
> >> @@ -204,8 +205,22 @@ int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
> >>  	}
> >>  	if (ret < 0)
> >>  		return (ret);
> >> -	else
> >> +	else {
> >> +		unsigned int ppc = (unsigned int)pr->performance_platform_limit;
> >> +
> >> +		if (saved != ppc) {
> >> +			struct cpufreq_policy *policy;
> >> +
> >> +			policy = cpufreq_cpu_get(pr->id);
> >> +			if (likely(policy))
> >> +				policy->user_policy.max =
> >> +					pr->performance->states[ppc].
> >> +					core_frequency * 1000;
> >> +			cpufreq_cpu_put(policy);
> >> +		}
> >> +
> >>  		return cpufreq_update_policy(pr->id);
> >> +	}
> >>  }
> >>  
> >>  int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
> >>
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
