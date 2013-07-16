Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3GPJAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:00:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50837 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3GPJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:00:26 -0400
Message-ID: <51E50AD4.6040208@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 14:26:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] cpufreq: Preserve policy structure across suspend/resume
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <20130711221704.547.64296.stgit@srivatsabhat.in.ibm.com> <CAKohpom+WcTcefCZitgZQcSjTPsgXsa6VKQF5y6GJA31-rBm0w@mail.gmail.com> <51E3C950.90503@linux.vnet.ibm.com> <CAKohpo=tfd_CXDBkbE23=UdEF99ZK-17NM_cvpGJ_e9wXGzsZQ@mail.gmail.com>
In-Reply-To: <CAKohpo=tfd_CXDBkbE23=UdEF99ZK-17NM_cvpGJ_e9wXGzsZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071608-4790-0000-0000-000009498CF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 11:45 AM, Viresh Kumar wrote:
> On 15 July 2013 15:35, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Actually even I was wondering about this while writing the patch and
>> I even tested shutdown after multiple suspend/resume cycles, to verify that
>> the refcount is messed up. But surprisingly, things worked just fine.
>>
>> Logically there should've been a refcount mismatch and things should have
>> failed, but everything worked fine during my tests. Apart from suspend/resume
>> and shutdown tests, I even tried mixing a few regular CPU hotplug operations
>> (echo 0/1 to sysfs online files), but nothing stood out.
>>
>> Sorry, I forgot to document this in the patch. Either the patch is wrong
>> or something else is silently fixing this up. Not sure what is the exact
>> situation.
> 
> To understand it I actually applied your patches to get better view of the code.
> (Haven't tested it though).. And found that your code is doing the right thing
> and we shouldn't get a mismatch.. This is the sequence of events I can draw:
> 
> - __cpu_add_dev() for first cpu. sets the refcount to 'x', where x are
> the no. of
> cpus in its clock domain.
> - _cpu_add_dev() for other cpus: doesn't change anything in refcount
> 
> - Suspend:
>  - cpu_remove_dev() for all cpus, due to frozen flag we don't touch the value
> of count
> - Resume:
>  - cpu_add_dev() for all cpus, due to frozen flag we don't touch the
> value of count.
>

Actually this one is tricky (I took a look again). So we have this code in the
beginning of _cpufreq_add_dev():


1008 #ifdef CONFIG_SMP
1009         /* check whether a different CPU already registered this
1010          * CPU because it is in the same boat. */
1011         policy = cpufreq_cpu_get(cpu);
1012         if (unlikely(policy)) {
1013                 cpufreq_cpu_put(policy);
1014                 return 0;
1015         }

The _get() is not controlled by the frozen flag, but it still doesn't take a
refcount because of a subtle reason: per_cpu(cpufreq_cpu_data, cpu) was set to
NULL in __cpufreq_remove_dev() and the memory was saved away in fallback storage.
So, when __cpufreq_cpu_get() executes, it sees:

 204         /* get the CPU */
 205         data = per_cpu(cpufreq_cpu_data, cpu);
 206 
 207         if (!data)
 208                 goto err_out_put_module;

Thus, since data is NULL, cpufreq_cpu_get() won't take a refcount and will return
silently.

Further down in __cpufreq_add_dev(), we restore the original memory, using
the frozen flag:

1037         if (frozen)
1038                 /* Restore the saved policy when doing light-weight init */
1039                 policy = cpufreq_policy_restore(cpu);
1040         else
1041                 policy = cpufreq_policy_alloc();


So that is how we manage to fool cpufreq_cpu_get() into not taking a fresh
refcount while resuming :)
 
> And so things work as expected. That's why your code isn't breaking anything I
> believe.
> 

Thanks a lot for the code inspection and your detailed analysis!

> But can no. of cpus change inbetween suspend/resume? Then count would be
> tricky as we are using the same policy structure.
> 

No, number of CPUs won't change in between suspend/resume. Even if somebody
tried that, that would be an eccentric case and we won't handle that.
Besides, *many more* things will break than just cpufreq, if somebody actually
tries that out!

Regards,
Srivatsa S. Bhat

