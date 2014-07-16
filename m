Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbaGPNOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:14:06 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34715 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933690AbaGPNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <53C65F03.1050609@mit.edu>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
	<53C65F03.1050609@mit.edu>
Date: Wed, 16 Jul 2014 18:43:45 +0530
Message-ID: <CAKohpomKF_TvpPZzEwocOK33RKnLWLtE2cPK6hk7YuhTVaNg2g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa@mit.edu>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 16:46, Srivatsa S. Bhat <srivatsa@mit.edu> wrote:
> Short answer: If the sysfs directory has already been created by cpufreq,
> then yes, it will remain as it is. However, if the online operation failed
> before that, then cpufreq won't know about that CPU at all, and no file will
> be created.
>
> Long answer:
> The existing cpufreq code does all its work (including creating the sysfs
> directories etc) at the CPU_ONLINE stage. This stage is not expected to fail
> (in fact even the core CPU hotplug code in kernel/cpu.c doesn't care for
> error returns at this point). So if a CPU fails to come up in earlier stages
> itself (such as CPU_UP_PREPARE), then cpufreq won't even hear about that CPU,
> and hence no sysfs files will be created/linked. However, if the CPU bringup
> operation fails during the CPU_ONLINE stage after the cpufreq's notifier has
> been invoked, then we do nothing about it and the cpufreq sysfs files will
> remain.

In short, the problem I mentioned before this para is genuine. And setting
policy->cpu to the first cpu of a mask is indeed a bad idea.

>> Also, how does suspend/resume work without CONFIG_HOTPLUG_CPU ?
>> What's the sequence of events?
>>
>
> Well, CONFIG_SUSPEND doesn't have an explicit dependency on HOTPLUG_CPU, but
> SMP systems usually use CONFIG_PM_SLEEP_SMP, which sets CONFIG_HOTPLUG_CPU.

I read usually as *optional*

> (I guess the reason why CONFIG_SUSPEND doesn't depend on HOTPLUG_CPU is
> because suspend is possible even on uniprocessor systems and hence the
> Kconfig dependency wasn't really justified).

Again the same question, how do we suspend when HOTPLUG is disabled?
