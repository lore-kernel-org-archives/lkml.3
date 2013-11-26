Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3KZC0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:26:22 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46439 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KZC0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <40779593.MBXsTetiKz@vostro.rjw.lan>
References: <cover.1385374819.git.viresh.kumar@linaro.org>
	<55cc3fbf9c553d669629e8ba98eef2b0ef33aaad.1385374822.git.viresh.kumar@linaro.org>
	<40779593.MBXsTetiKz@vostro.rjw.lan>
Date: Tue, 26 Nov 2013 07:56:19 +0530
Message-ID: <CAKohpok0E=m=63KXM22usiW7Rsu59cD7Q=+k3tRcW=8269tZnQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2013 04:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> @@ -1259,6 +1262,8 @@ int dpm_suspend(pm_message_t state)
>>
>>       might_sleep();
>>
>> +     cpufreq_suspend();
>> +
>>
>>       mutex_lock(&dpm_list_mtx);
>>       pm_transition = state;
>>       async_error = 0;
>
> Shouldn't it do cpufreq_resume() on errors?

Yes and this is already done I believe. In case dpm_suspend() fails,
dpm_resume() gets called. Isn't it?

>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> +void cpufreq_suspend(void)
>> +{
>> +     struct cpufreq_policy *policy;
>> +
>> +     if (!has_target())
>> +             return;
>> +
>> +     pr_debug("%s: Suspending Governors\n", __func__);
>> +
>> +     list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
>> +             if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
>> +                     pr_err("%s: Failed to stop governor for policy: %p\n",
>> +                                     __func__, policy);
>
> This appears to be racy.  Is it really racy, or just seemingly?

Why does it look racy to you? Userspace should be frozen by now,
policy_list should be stable as well as nobody would touch it.
