Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaGNGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:09:57 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41194 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaGNGJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <53C0A12A.2060204@codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
	<1405052287-4744-1-git-send-email-skannan@codeaurora.org>
	<CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
	<2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
	<CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
	<53C0A12A.2060204@codeaurora.org>
Date: Mon, 14 Jul 2014 11:39:48 +0530
Message-ID: <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
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

On 12 July 2014 08:14, Saravana Kannan <skannan@codeaurora.org> wrote:

>>> I'm just always adding the real nodes to the first CPU in a cluster
>>> independent of which CPU gets added first. Makes it easier to know which
>>> ones to symlink. See comment next to policy->cpu for full context.
>>
>>
>> Yeah, and that is the order in which CPUs will boot and cpufreq_add_dev()
>> will be called. So, isn't policy->cpu the right CPU always?
>
>
> No, the "first" cpu in a cluster doesn't need to be the first one to be
> added. An example is 2x2 cluster system where the system is booted with max
> cpus = 2 and then cpu3 could be onlined first by userspace.

Because we are getting rid of much of the complexity now, I do not want
policy->cpu to keep changing. Just fix it up to the cpu for which the policy
gets created first. That's it. No more changes required. It doesn't matter at
userspace which cpu owns it as symlinks would anyway duplicate it under
every cpu.

> Yeah, it is pretty convolution. But pretty much anywhere in the gov code
> where policy->cpu is used could cause this. The specific crash I hit was in
> this code:
>
> static void od_dbs_timer(struct work_struct *work)
> {
>         struct od_cpu_dbs_info_s *dbs_info =
>                 container_of(work, struct od_cpu_dbs_info_s,
> cdbs.work.work);
>         unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
>
> ======= CPU is policy->cpu here.
>
>         struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
>                         cpu);
>
> ======= Picks the per CPU struct of an offline CPU
>
> <snip>
>
>         mutex_lock(&core_dbs_info->cdbs.timer_mutex);
>
> ======= Dies trying to lock a destroyed mutex

I am still not getting it. Why would we get into this if policy->cpu is fixed
once at boot ?
