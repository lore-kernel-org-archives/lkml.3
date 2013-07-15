Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3GOGX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:23:57 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47856 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3GOGXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:23:55 -0400
Message-ID: <51E394A8.1030001@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:50:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cpufreq: Fix misplaced call to cpufreq_update_policy()
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <20130711221553.547.56787.stgit@srivatsabhat.in.ibm.com> <CAKohpo=DNhKTGdectgyWLW3XkfDOAiEhJ=hi+zW=6G6fWShybg@mail.gmail.com>
In-Reply-To: <CAKohpo=DNhKTGdectgyWLW3XkfDOAiEhJ=hi+zW=6G6fWShybg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071517-3568-0000-0000-000003ED071D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:36 PM, Viresh Kumar wrote:
> On 12 July 2013 03:45, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> The call to cpufreq_update_policy() is placed in the CPU hotplug callback
>> of cpufreq_stats, which has a higher priority than the CPU hotplug callback
>> of cpufreq-core. As a result, during CPU_ONLINE/CPU_ONLINE_FROZEN, we end up
>> calling cpufreq_update_policy() *before* calling cpufreq_add_dev() !
>> And for uninitialized CPUs, it just returns silently, not doing anything.
> 
> Hmm..
> 
>> To add to it, cpufreq_stats is not even the right place to call
>> cpufreq_update_policy() to begin with. The cpufreq core ought to handle
>> this in its own callback, from an elegance/relevance perspective.
>>
>> So move the invocation of cpufreq_update_policy() to cpufreq_cpu_callback,
>> and place it *after* cpufreq_add_dev().
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpufreq/cpufreq.c       |    1 +
>>  drivers/cpufreq/cpufreq_stats.c |    6 ------
>>  2 files changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index ccc6eab..f8c3100 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1943,6 +1943,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>>                 case CPU_ONLINE:
>>                 case CPU_ONLINE_FROZEN:
>>                         cpufreq_add_dev(dev, NULL);
>> +                       cpufreq_update_policy(cpu);
> 
> Do we need to call this for every hotplug of cpu? I am not
> talking about suspend/resume here.
> 

I don't think we need to, but I think it would be better to postpone
optimizations until all the cpufreq regressions get fixed. Later perhaps
we could revisit these minor optimizations if desired.

Regards,
Srivatsa S. Bhat

