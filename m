Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3IKSq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:46:26 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60962 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3IKSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:46:23 -0400
Message-ID: <5230B991.3040702@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 00:12:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com> <523094CD.3000506@wwwdotorg.org> <5230B078.3070306@linux.vnet.ibm.com>
In-Reply-To: <5230B078.3070306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091118-4790-0000-0000-00000A442BDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 11:33 PM, Srivatsa S. Bhat wrote:
> On 09/11/2013 09:35 PM, Stephen Warren wrote:
>> On 09/11/2013 04:21 AM, Srivatsa S. Bhat wrote:
>>> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>>>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
>>>>> On 09/09/2013 05:14 PM, Rafael J. Wysocki wrote:
>>>>>> On Monday, September 09, 2013 03:29:06 PM Stephen Warren wrote:
>>>>>>> On 09/09/2013 02:24 PM, Rafael J. Wysocki wrote:
>>>>>>>> On Monday, September 09, 2013 02:01:32 PM Stephen Warren wrote:
>>>>>>>>> On 09/09/2013 02:01 PM, Rafael J. Wysocki wrote:
>>>>>>>>>> On Monday, September 09, 2013 01:22:23 PM Stephen Warren wrote:
>>>>>>>>>>> Viresh,
>>>>>>>>>>>
>>>>>>>>>>> I'm seeing the crash below when suspending my system for the second time.
>> ...
>>> Stephen, I went through the code and I think I found out what is going wrong.
>>> Can you please try the following patch?
>>
>> Unfortunately, I still see the exact same failure/backtrace with this
>> patch applied.
>>
> 
> Oh, is it? Can you please give me the map of the related cpus on your
> system? (ie., cat /sys/devices/system/cpu/cpu*/cpufreq/related_cpus for
> each CPU.)
> 
> I must be missing something...
>

OK, I took a second look at the code, and I suspect that applying the
second patch might help. So can you try by applying both the patches
please[1][2]?

Basically here is my hunch: say CPUs 2 and 3 are part of a policy and
3 is the policy->cpu. During suspend, CPU 2 will be taken offline first,
and we hit this code:

1199         if (cpu != policy->cpu && !frozen) {
1200                 sysfs_remove_link(&dev->kobj, "cpufreq");
1201         } else if (cpus > 1) {
1202 
1203                 new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
1204                 if (new_cpu >= 0) {
1205                         WARN_ON(lock_policy_rwsem_write(cpu));
1206                         update_policy_cpu(policy, new_cpu);
1207                         unlock_policy_rwsem_write(cpu);
1208 
1209                         if (!frozen) {
1210                                 pr_debug("%s: policy Kobject moved to cpu: %d "
1211                                          "from: %d\n",__func__, new_cpu, cpu);
1212                         }
1213                 }
1214         }

At this point, the first 'if' condition fails because frozen == true.
So it enters the else part. But, policy->cpu is actually 3, not 2,
and hence we invoke nominate_...() unnecessarily. That function returns
3 since that's the only CPU remaining in the mask, and so we call
update_policy_cpu() with new_cpu = 3, and old_cpu was also 3! And that
is the perfect recipe for disaster, with the current implementation of
update_policy_cpu().

And my second patch [2] tried to fix this exact problem, although I
didn't realize we actually had a case where we hit this in the current
code itself.

So please try by applying both the patches and let me know how it goes.
Thanks a lot for your testing efforts!

[1]. http://marc.info/?l=linux-kernel&m=137889516210816&w=2
[2]. http://marc.info/?l=linux-kernel&m=137889800511940&w=2
 
Regards,
Srivatsa S. Bhat

