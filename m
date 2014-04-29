Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbaD2NTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:19:42 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58121 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaD2NTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:19:39 -0400
Message-ID: <535FA6B2.8060804@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 18:48:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
References: <20140429130506.7052.54268.stgit@srivatsabhat.in.ibm.com> <alpine.SOC.1.00.1404291609220.3349@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1404291609220.3349@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042913-5490-0000-0000-000005869B5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:39 PM, Meelis Roos wrote:
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>> v2: Removed the coverage of ASYNC_NOTIFICATION drivers, in order to avoid
>> false-positives.
> 
> I am confused - on top of what patches should I test it?
> 
>

Well, actually this is not a fix. Its only a debug infrastructure to
catch the problems you reported, more easily. And this patch is
independent, it doesn't depend on any patch. So if you try this patch
as it is on your system (which doesn't include any of the other patches
I sent) then you'll see a warning during boot (before you hit the hang).
That's the intended behavior of this debug patch - to throw warnings,
if a scenario is detected which can lead to a hang.

You have already tested the fix that I sent for longhaul (and other
2 drivers) and they have made it to Rafael's bleeding-edge branch.

http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=bleeding-edge

So if you instead test this debug patch on *top* of Rafael's tree,
you'll see that the hang is not reproducible (because of the longhaul
fix that went in) and also this debug patch will not print any warning.
That's again the intended behavior.

Regards,
Srivatsa S. Bhat

> 
>>
>>  drivers/cpufreq/cpufreq.c |    7 +++++++
>>  include/linux/cpufreq.h   |    1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index abda660..afcac67 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -354,6 +354,11 @@ static void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>>  void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>>  		struct cpufreq_freqs *freqs)
>>  {
>> +
>> +	/* Catch double invocations of _begin() which lead to self-deadlock */
>> +	WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
>> +				&& current == policy->transition_task);
>> +
>>  wait:
>>  	wait_event(policy->transition_wait, !policy->transition_ongoing);
>>  
>> @@ -365,6 +370,7 @@ wait:
>>  	}
>>  
>>  	policy->transition_ongoing = true;
>> +	policy->transition_task = current;
>>  
>>  	spin_unlock(&policy->transition_lock);
>>  
>> @@ -381,6 +387,7 @@ void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
>>  	cpufreq_notify_post_transition(policy, freqs, transition_failed);
>>  
>>  	policy->transition_ongoing = false;
>> +	policy->transition_task = NULL;
>>  
>>  	wake_up(&policy->transition_wait);
>>  }
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 5ae5100..8f44d79 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -110,6 +110,7 @@ struct cpufreq_policy {
>>  	bool			transition_ongoing; /* Tracks transition status */
>>  	spinlock_t		transition_lock;
>>  	wait_queue_head_t	transition_wait;
>> +	struct task_struct	*transition_task; /* Task which is doing the transition */
>>  };
>>  
>>  /* Only for ACPI */
>>
> 

