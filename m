Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaLIB7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:59:41 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:61493 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIB7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:59:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141208142217.GA1831@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
	<1417806260-9264-7-git-send-email-javi.merino@arm.com>
	<CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
	<20141208125033.GB2980@e104805>
	<CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
	<20141208142217.GA1831@e104805>
Date: Tue, 9 Dec 2014 07:29:39 +0530
Message-ID: <CAKohpomy7=v_qE3B_+hhwdUE8MCJkV7gzmPpUOb==t1BuZAnAA@mail.gmail.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2014 at 19:52, Javi Merino <javi.merino@arm.com> wrote:
> Ok, changed it into:
>
>         cpu = cpumask_any(&cpufreq_device->allowed_cpus);
>         dev = get_cpu_device(cpu);
>         if (!dev) {
>                 dev_warn(&cpufreq_device->cool_dev->device,
>                         "No cpu device for cpu %d\n", cpu);
>                 ret = -EINVAL;
>                 goto unlock;
>         }
>
>         num_opps = dev_pm_opp_get_opp_count(dev);
>         if (num_opps <= 0) {
>                 ret = (num_opps < 0)? num_opps : -EINVAL;
>                 goto unlock;
>         }

And this might not work. This is what I said in the first reply.

So, a bit lengthy reply now :)

Every cpu has a device struct associated with it. When cpufreq
core initializes drivers, they ask for mapping (initializing) the opps.
At that point we pass policy->cpu to opp core. OPP core doesn't
know which cores share clock line (I am trying to solve that [1]) and
so it just initializes the OPPs for policy->cpu. Let us say it cpuX.

Now there will be few more CPUs which are going to share clock
line with it and hence will use the same OPPs. In thermal core,
you got clip_cpus which is exactly the masks of all these CPUs
sharing clock line.

If the OPP layer is good enough, then above code can work. But
because right now the OPPs are mapped to just cpuX, passing
any other cpu from clip_cpus will fail as it doesn't have any associated
OPPs.

Now what I asked you is to use the CPU for which
__cpufreq_cooling_register() is called. Normally we are calling
__cpufreq_cooling_register() for the CPU for which OPPs are
registered (but people might call it up for other CPUs as well)..

So, using that cpu *might* have worked here.

Now the earlier loop you used was good to get this information,
but it wasn't consistent and so I objected.

What you should do:

- Create another routine to find the cpu for which OPPs are bound
to
-  And save the cpu_dev for it in the global struct for cpu_cooling
- reuse it wherever required.

--
viresh

[1] https://www.marc.info/?t=141769172100002&r=1&w=2
