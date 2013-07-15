Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3GOKIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:08:38 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35423 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3GOKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:08:35 -0400
Message-ID: <51E3C950.90503@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 15:35:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] cpufreq: Preserve policy structure across suspend/resume
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <20130711221704.547.64296.stgit@srivatsabhat.in.ibm.com> <CAKohpom+WcTcefCZitgZQcSjTPsgXsa6VKQF5y6GJA31-rBm0w@mail.gmail.com>
In-Reply-To: <CAKohpom+WcTcefCZitgZQcSjTPsgXsa6VKQF5y6GJA31-rBm0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071510-4790-0000-0000-000009446275
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:25 PM, Viresh Kumar wrote:
> Hi Srivatsa,
> 
> I may be wrong but it looks something is wrong in this patch.
> 
> On 12 July 2013 03:47, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
>> @@ -1239,29 +1263,40 @@ static int __cpufreq_remove_dev(struct device *dev,
>>         if ((cpus == 1) && (cpufreq_driver->target))
>>                 __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
>>
>> -       pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
>> -       cpufreq_cpu_put(data);
>> +       if (!frozen) {
>> +               pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
>> +               cpufreq_cpu_put(data);
> 
> So, we don't decrement usage count here. But we are still increasing
> counts on cpufreq_add_dev after resume, isn't it?
> 
> So, we wouldn't be able to free policy struct once all the cpus of a
> policy are removed after suspend/resume has happened once.
> 

Actually even I was wondering about this while writing the patch and
I even tested shutdown after multiple suspend/resume cycles, to verify that
the refcount is messed up. But surprisingly, things worked just fine.

Logically there should've been a refcount mismatch and things should have
failed, but everything worked fine during my tests. Apart from suspend/resume
and shutdown tests, I even tried mixing a few regular CPU hotplug operations
(echo 0/1 to sysfs online files), but nothing stood out.

Sorry, I forgot to document this in the patch. Either the patch is wrong
or something else is silently fixing this up. Not sure what is the exact
situation.

Regards,
Srivatsa S. Bhat

