Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881AbaGPSGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:06:51 -0400
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:47922 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965867AbaGPSGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:06:44 -0400
X-AuditID: 12074423-f79bf6d000007580-dd-53c6bf333f28
Message-ID: <53C6BEB9.6090503@mit.edu>
Date: Wed, 16 Jul 2014 23:34:41 +0530
From: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>	<CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>	<53C65F03.1050609@mit.edu> <CAKohpomKF_TvpPZzEwocOK33RKnLWLtE2cPK6hk7YuhTVaNg2g@mail.gmail.com>
In-Reply-To: <CAKohpomKF_TvpPZzEwocOK33RKnLWLtE2cPK6hk7YuhTVaNg2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixCmqrGu8/1iwwZZluhabHl9jtZi4/yy7
	xeVdc9gsPvceYbQ4c/oSq8WPM90sFgcuTmSzOLu8mc1i41cPB06Py329TB4LNpV63Lm2h81j
	85J6jy1X21k8Pm+SC2CL4rJJSc3JLEst0rdL4MqY2faHteCEZMXXmYkNjOdFuhg5OSQETCRa
	f05kgbDFJC7cW88GYgsJzGaSeHYTqIYLyN7IKLH+1EF2CGcbk0Tb+ivsIFW8AmoS/c/Xgtks
	AqoSH5afY+xi5OBgE9CWWLZREiQsKhAn0Xj8OyNEuaDEyZlPWEBKRAS0JF7eTAUZySzwgFni
	2N+pTCA1wgIxEr/u74PatYRJYuriu2AJToFAifvnL7GDNDMLqEusnycEEmYWkJfY/nYO8wRG
	wVlIVsxCqJqFpGoBI/MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXTO93MwSvdSU0k2MoAhhd1He
	wfjnoNIhRgEORiUe3h3tx4KFWBPLiitzDzFKcjApifJa7wIK8SXlp1RmJBZnxBeV5qQWH2KU
	4GBWEuGdNgsox5uSWFmVWpQPk5LmYFES531rbRUsJJCeWJKanZpakFoEk5Xh4FCS4JXfB9Qo
	WJSanlqRlplTgpBm4uAEGc4DNFwOpIa3uCAxtzgzHSJ/ilFRSpz3zR6ghABIIqM0D64XlsBe
	MYoDvSLMaw7SzgNMfnDdr4AGMwENLq85DDK4JBEhJdXAWMpeEcvgvLJI9Nmv22W6FyQiE1kN
	p7YpHTn9/eV7taSerTZLUyfJ7ChUvKwzT7xyy4ErjrwqTJ3XI2/9rPtYKfs84mzQv+jA+8ue
	/OG1VN2dH3VsRr2zZsJf5v2zvOMf66300JZl/sz5yd78kveJzurrxsavTHsZymepHz/bdStt
	w11ZmZ5UJZbijERDLeai4kQA/k4H1jsDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 06:43 PM, Viresh Kumar wrote:
> On 16 July 2014 16:46, Srivatsa S. Bhat <srivatsa@mit.edu> wrote:
>> Short answer: If the sysfs directory has already been created by cpufreq,
>> then yes, it will remain as it is. However, if the online operation failed
>> before that, then cpufreq won't know about that CPU at all, and no file will
>> be created.
>>
>> Long answer:
>> The existing cpufreq code does all its work (including creating the sysfs
>> directories etc) at the CPU_ONLINE stage. This stage is not expected to fail
>> (in fact even the core CPU hotplug code in kernel/cpu.c doesn't care for
>> error returns at this point). So if a CPU fails to come up in earlier stages
>> itself (such as CPU_UP_PREPARE), then cpufreq won't even hear about that CPU,
>> and hence no sysfs files will be created/linked. However, if the CPU bringup
>> operation fails during the CPU_ONLINE stage after the cpufreq's notifier has
>> been invoked, then we do nothing about it and the cpufreq sysfs files will
>> remain.
> 
> In short, the problem I mentioned before this para is genuine. And setting
> policy->cpu to the first cpu of a mask is indeed a bad idea.
> 
>>> Also, how does suspend/resume work without CONFIG_HOTPLUG_CPU ?
>>> What's the sequence of events?
>>>
>>
>> Well, CONFIG_SUSPEND doesn't have an explicit dependency on HOTPLUG_CPU, but
>> SMP systems usually use CONFIG_PM_SLEEP_SMP, which sets CONFIG_HOTPLUG_CPU.
> 
> I read usually as *optional*
> 
>> (I guess the reason why CONFIG_SUSPEND doesn't depend on HOTPLUG_CPU is
>> because suspend is possible even on uniprocessor systems and hence the
>> Kconfig dependency wasn't really justified).
> 
> Again the same question, how do we suspend when HOTPLUG is disabled?
> 

>From what I understand, if you disable HOTPLUG_CPU and enable CONFIG_SUSPEND
and try suspend/resume on an SMP system, the disable_nonboot_cpus() call will
return silently without doing anything. Thus, suspend will fail silently and
the system might have trouble resuming.

But surprisingly we have never had such bug reports so far! Most probably this
is because PM_SLEEP_SMP has a default of y (which in turn selects HOTPLUG_CPU):

config PM_SLEEP_SMP
        def_bool y
        depends on SMP
        depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
        depends on PM_SLEEP
        select HOTPLUG_CPU

So I guess nobody really tried turning this off on SMP systems and then trying
suspend. Then I started looking at the git history and wondered where this
Kconfig dependency between SUSPEND and SMP<->HOTPLUG_CPU got messed up. But
instead I found that the initial commit itself didn't get the dependency right.

Commit 296699de6bdc (Introduce CONFIG_SUSPEND for suspend-to-Ram and standby)
introduced all the Kconfig options, and it indeed mentions this in the
changelog: "Make HOTPLUG_CPU be selected automatically if SUSPEND or
HIBERNATION has been chosen and the kernel is intended for SMP systems". But
unfortunately, the code didn't get it right because it made CONFIG_SUSPEND
depend on SUSPEND_SMP_POSSIBLE instead of SUSPEND_SMP.

In other words, we have had this incorrect dependency all the time!

Regards,
Srivatsa S. Bhat
