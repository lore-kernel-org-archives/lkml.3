Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775Ab3DCPca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:32:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55110 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761434Ab3DCPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <1365001386-29970-1-git-send-email-nzimmer@sgi.com>
References: <AKohpo=Um9LGhGtMB0z9C2jxmS3oHwV7i_Gmsq5rR80ZcGYyLw@mail.gmail.com>
	<1365001386-29970-1-git-send-email-nzimmer@sgi.com>
Date: Wed, 3 Apr 2013 21:02:27 +0530
Message-ID: <CAKohpon1QiCfJhWBi_f7U1EU410JMGHq+QnpEPJ+rdiUjsKsQA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: convert the cpufreq_driver to use the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please always mention Version number and history. Not everybody
remembers what changed after last version.

On 3 April 2013 20:33, Nathan Zimmer <nzimmer@sgi.com> wrote:
> We eventually would like to remove the rwlock cpufreq_driver_lock or convert
> it back to a spinlock and protect the read sections with RCU.  The first step in

Why do we want to convert it back to spinlock?

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

>  bool have_governor_per_policy(void)
>  {
> -       return cpufreq_driver->have_governor_per_policy;
> +       bool have_governor;

Name it have_governor_per_policy, it looks wrong otherwise.

> +       rcu_read_lock();
> +       have_governor = rcu_dereference(cpufreq_driver)->have_governor_per_policy;
> +       rcu_read_unlock();
> +       return have_governor;
>  }

>  static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
>  {
> -       return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
> +       char *name;
> +       rcu_read_lock();
> +       name = rcu_dereference(cpufreq_driver)->name;
> +       rcu_read_unlock();
> +       return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", name);
>  }

This is the definition of struct cpufreq_driver:

struct cpufreq_driver {
	struct module           *owner;
	char			name[CPUFREQ_NAME_LEN];

       ...
};

Purpose of rcu read_lock/unlock are to define the rcu critical section
after which rcu layer is free to free the memory allocated to earlier
instance of cpufreq_driver.

So, after the unlock() call you _should_not_ use the memory allocated to
cpufreq_driver instance. And here, you are using memory allocated to name[]
after the unlock() call.

Which looks to be wrong... I left other parts of driver upto you to fix for this
"rule of thumb".

Sorry for not pointing this earlier but rcu is as new to me as it is
to you. I know
you must be frustrated with so many versions of this patch, and everytime we
get a new problem to you... Don't get disheartened with it.. Keep the good work
going :)

--
viresh
