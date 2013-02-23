Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3BWDjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 22:39:36 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49881 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3BWDjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 22:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <1361550275-5716-3-git-send-email-nzimmer@sgi.com>
References: <51265E0F.6090209@sgi.com>
	<1361550275-5716-1-git-send-email-nzimmer@sgi.com>
	<1361550275-5716-3-git-send-email-nzimmer@sgi.com>
Date: Sat, 23 Feb 2013 09:09:31 +0530
Message-ID: <CAKohpom9q93cVD61qeht2WXgA=no64dwXowtMHS0wCy0k6qxXw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] cpufreq: Convert the cpufreq_driver_lock to use
 the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

Sorry for pointing out this so late but i still feel we are missing something
really important.

On 22 February 2013 21:54, Nathan Zimmer <nzimmer@sgi.com> wrote:

> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
> +       rcu_read_lock();
> +       freqs->flags = rcu_dereference(cpufreq_driver)->flags;
>         policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +       rcu_read_unlock();

> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
> +       spin_lock_irqsave(&cpufreq_driver_lock, flags);
>         for_each_cpu(j, policy->cpus) {
>                 per_cpu(cpufreq_cpu_data, j) = policy;
>                 per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
>         }
> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +       spin_unlock_irqrestore(&cpufreq_driver_lock, flags);

Look at how we are protecting cpufreq_cpu_data here. rcu_read_[un]lock()
only marks the start/end of critical section. How are we sure here that
cpufreq_cpu_data is not read simultaneously when we are updating it?

rcu lock/unlock only works for cpufreq_driver pointer only and not for
this data. We still need the same locking for for cpufreq_cpu_data.

What do you say?
