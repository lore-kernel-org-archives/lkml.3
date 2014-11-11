Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKKNLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:11:23 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52290 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaKKNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <5461FEA0.5070706@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-6-git-send-email-prarit@redhat.com>
	<CAKohpon3ybK1YhemeZ_kxFCLowsJSZSO3P7=CTZaWpAMwNh7Dg@mail.gmail.com>
	<5461FEA0.5070706@redhat.com>
Date: Tue, 11 Nov 2014 18:41:21 +0530
Message-ID: <CAKohpongwC4anO6+kLWVMDefuLWUmpNvUdBoLgFw7ru1vRYLgw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to aid
 debugging failures
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 17:48, Prarit Bhargava <prarit@redhat.com> wrote:
> the problem is tht the userful information is the values of initialized,
> enabled, and what the  event was :(
>
> in every case i ended up needing the values.

So, just add a pr_debug instead and let every thing crash as it does today.

>>> @@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>> -       WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
>>> +       if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
>>> +               pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
>>> +                        policy->governor->name,
>>> +                        atomic_read(&policy->governor->initialized),
>>> +                        policy->governor_enabled, event);
>>> +               BUG();
>>
>> How is the BUG better than the WARN here ?
>>
>
> we null pointer panic later on, and again the useful values are the ones displayed.

For the values, I would add a pr_debug() for all cases. And maybe just
do s/WARN_ON/BUG_ON

>>>         switch (event) {
>>>         case CPUFREQ_GOV_POLICY_INIT:
>>> @@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>>         case CPUFREQ_GOV_POLICY_EXIT:
>>>                 mutex_lock(&dbs_data->usage_count_mutex);
>>>                 if (atomic_dec_and_test(&dbs_data->usage_count)) {
>>> +                       if (atomic_read(&policy->governor->initialized) > 1) {
>>
>> Isn't this wrong? Consider 4 CPUs with separate clock line and have set
>> governor-per-policy to true. EXIT will be called for every CPU hotplug and
>> initialized will be 4 initially..
>>
>> Or I am still vacation lag'd ? :)
>
> oh, is that right?  i'll look into that.

What is right? sorry couldn't understand :(
