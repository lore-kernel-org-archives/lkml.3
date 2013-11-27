Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3K0Hjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:39:37 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49625 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3K0Hjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <52959A74.70007@intel.com>
References: <cover.1385374819.git.viresh.kumar@linaro.org>
	<CAKohpok0E=m=63KXM22usiW7Rsu59cD7Q=+k3tRcW=8269tZnQ@mail.gmail.com>
	<4253729.doK7ubnxKx@vostro.rjw.lan>
	<4787675.sJF8mqYyxv@vostro.rjw.lan>
	<CAKohpo=iSJSh_x3Xj3h-GRE6S25ptsdHf34MftMuD6JVSZw=rg@mail.gmail.com>
	<52959A74.70007@intel.com>
Date: Wed, 27 Nov 2013 13:09:30 +0530
Message-ID: <CAKohpomV3xByHbcRtcrF3F6k_Nw=f3G0vX7gU6RqWZ4z+j=a_Q@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2013 12:38, Lan Tianyu <tianyu.lan@intel.com> wrote:
> Hi Viresh:

Hey Lan,

>         First, I agree the new solution you are working on. :)

Thanks :)

> But actually I don't totally agree my origin patch have design issue.
> Because I think governor should have the ability to check whether it has
> been EXIT when doing INIT and it should return error code at that point.
> The design is to make governor code stronger to deal with the case that
> governor is reinitialized before EXIT. Just from my view.

> Sorry for noise.

Ahh, these are useful discussions. Everyone have their own thoughts and
its upto all of us to get meaningful stuff out of it..

I agree to whatever you wrote above but this isn't exactly what's being
done in your patch. I was more concerned about this stuff:

On 22 November 2013 13:08, Lan Tianyu <tianyu.lan@intel.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> +               if (has_target() && !frozen) {
>                         ret = __cpufreq_governor(policy,
>                                         CPUFREQ_GOV_POLICY_EXIT);

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> @@ -204,9 +204,20 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>
>         switch (event) {
>         case CPUFREQ_GOV_POLICY_INIT:
> +               /*
> +                * In order to keep governor data across suspend/resume,
> +                * Governor doesn't exit when suspend and will be
> +                * reinitialized when resume. Here check policy governor
> +                * data to determine whether the governor has been exited.
> +                * If not, return EALREADY.
> +                */
>                 if (have_governor_per_policy()) {
> -                       WARN_ON(dbs_data);
> +                       if (dbs_data)
> +                               return -EALREADY;
>                 } else if (dbs_data) {
> +                       if (policy->governor_data == dbs_data)
> +                               return -EALREADY;
> +
>                         dbs_data->usage_count++;
>                         policy->governor_data = dbs_data;
>                         return 0;

Here the cpufreq core has skipped the call to governor's EXIT,
and so it shouldn't pass on the following INIT call to them..

That's a bit wrong. These two calls work in pairs and are exactly
opposite to each other. And so if some decision has to be taken
then either that should be done completely at governor level
or core level. Doing stuff partly in governor and partly in core
is like giving invitation to new bugs/problems :)

Nothing personal otherwise. Recently there were patches sent
by people, you, Nishanth, etc, which I have just overridden with
my versions.. It wasn't about getting my count higher :) but
getting the solution at right places instead of solving them at
wrong locations..

I am already having tough time upstreaming patches for cpufreq
consolidation, as the number of patches is huge. It takes time
for people to absorb/test them. Though Rafael has taken almost all
of them in v3.13 finally, but I understand its difficult for him as
well and he did his job wonderfully :)

And so I don't really want to get any new stuff in which will surely
get consolidated later. Lets do it now, we had enough of it :)

Even, related to your patch, I was already thinking of getting
rid of "frozen" variable and parameter to functions, as we already
know status from a global variable now, cpufreq_suspended. And
so we don't actually need to pass any additional parameters
to many routines, which have something like 'frozen' currently.

--
viresh
