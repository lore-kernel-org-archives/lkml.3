Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaGPT5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:57:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34109 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaGPT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:56:59 -0400
Message-ID: <53C6D90A.1000402@codeaurora.org>
Date: Wed, 16 Jul 2014 12:56:58 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Srivatsa S. Bhat" <srivatsa@mit.edu>,
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
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org> <1405464473-3916-2-git-send-email-skannan@codeaurora.org> <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com> <53C65F03.1050609@mit.edu> <CAKohpomKF_TvpPZzEwocOK33RKnLWLtE2cPK6hk7YuhTVaNg2g@mail.gmail.com>
In-Reply-To: <CAKohpomKF_TvpPZzEwocOK33RKnLWLtE2cPK6hk7YuhTVaNg2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 06:13 AM, Viresh Kumar wrote:
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

No it's not. All the cpu*/ directories for all possible CPUs will be 
there whether a CPU is online/offline. Which is why I also weed out 
impossible CPUs, but you said the driver shouldn't be passing impossible 
CPUs anyway. I'm just picking one directory to put the real cpufreq 
directory under. So, the code as-is is definitely not broken.

Sure, I can pick the first cpu that comes online to decide where to put 
the real sysfs cpufreq directory, but then I have to keep track of that 
in a separate field when it's time to remove it when the cpufreq driver 
is unregistered. It's yet another pointless thing to keep track. And no, 
we shouldn't be moving sysfs directory to stay with only an online 
directory. That's the thing this patch is trying to simplify.

So, I think using the first cpu in related CPUs will always work. If 
there's any disagreement, I think it's purely a personal preference over 
adding another field vs calling cpumask_first()

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
