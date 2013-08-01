Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3HATZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:25:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43547 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3HATZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:25:06 -0400
Message-ID: <51FAB534.1070301@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 00:51:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <1656801.jLHjvytfNU@vostro.rjw.lan> <51FAB083.5050900@linux.vnet.ibm.com> <7752148.JjTSgAt1Xy@vostro.rjw.lan>
In-Reply-To: <7752148.JjTSgAt1Xy@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080119-9574-0000-0000-000008FE46C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 12:51 AM, Rafael J. Wysocki wrote:
> On Friday, August 02, 2013 12:31:23 AM Srivatsa S. Bhat wrote:
>> On 08/02/2013 12:31 AM, Rafael J. Wysocki wrote:
>>> On Thursday, August 01, 2013 11:36:49 PM Srivatsa S. Bhat wrote:
>>>> Its the cpufreq_cpu_get() hidden away in cpufreq_add_dev_symlink(). With
>>>> that taken care of, everything should be OK. Then we can change the
>>>> synchronization part to avoid using refcounts.
>>>
>>> So I actually don't see why cpufreq_add_dev_symlink() needs to call
>>> cpufreq_cpu_get() at all, since the policy refcount is already 1 at the
>>> point it is called and the bumping up of the driver module refcount is
>>> pointless.
>>>
>>
>> Hmm, yes, it seems so.
>>
>>> However, if I change that I also need to change the piece of code that
>>> calls the complementary cpufreq_cpu_put() and I kind of cannot find it.
>>>
>>
>> ... I guess that's because you are looking at the code with your patch
>> applied (and your patch removed that _put()) ;-)
> 
> No, it's not that one.  That one was complementary to the cpufreq_cpu_get()
> done by cpufreq_add_policy_cpu() before my patch.  Since my patch changes
> cpufreq_add_policy_cpu() to call cpufreq_cpu_put() before returning and
> bump up the policy refcount with kobject_get(), the one in
> __cpufreq_remove_dev() is changed into kobject_put() (correctly, IMO).
> 
> What gives?
> 

Actually, it _is_ the one I pointed above. This thing is tricky, here's why:

cpufreq_add_policy_cpu() is called only if:
a. The CPU being onlined has per_cpu(cpufreq_cpu_data, cpu) == NULL
and 
b. Its is present in some CPU's related_cpus mask. 

If condition (a) doesn't hold good, you get out right in the beginning of
__cpufreq_add_dev().

So, cpufreq_add_policy_cpu() is called very rarely because, inside
__cpufreq_add_dev we do:

1093         write_lock_irqsave(&cpufreq_driver_lock, flags);
1094         for_each_cpu(j, policy->cpus) {
1095                 per_cpu(cpufreq_cpu_data, j) = policy;
1096                 per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
1097         }
1098         write_unlock_irqrestore(&cpufreq_driver_lock, flags);

So for all the CPUs in the above policy->cpus mask, we simply return
without further ado when they are onlined. In particular, we *dont* call
cpufreq_add_policy_cpu() for any of them.

And their refcounts are incremented by the cpufreq_add_dev_interface()->
cpufreq_add_dev_symlink() function.

So, ultimately, we increment the refcount for a given non-policy-owner CPU
only once. *Either* in cpufreq_add_dev_symlink() *or* in cpufreq_add_policy_cpu(),
but never both.

So, in the teardown path, __cpufreq_remove_dev() needs only one place to
decrement it as shown below:

1303         } else {
1304 
1305                 if (!frozen) {
1306                         pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
1307                         cpufreq_cpu_put(data);
1308                 }


Pretty good maze, right? ;-(
 
Regards,
Srivatsa S. Bhat

