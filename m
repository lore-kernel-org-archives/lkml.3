Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3BFQTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:19:43 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57879 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3BFQTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:19:41 -0500
MIME-Version: 1.0
In-Reply-To: <51128097.9000801@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-6-git-send-email-dirk.brandewie@gmail.com>
	<CAOh2x=kJPFyhkG3y_q=a5ciG1HRAn-JkoVYy9OZ9POA+-isbCQ@mail.gmail.com>
	<5111BB2E.2090505@gmail.com>
	<CAKohpokoG16S8uft0nSFSoejipS8X=zhhg6goJs4mBSt3tAwxw@mail.gmail.com>
	<51128097.9000801@gmail.com>
Date: Wed, 6 Feb 2013 21:49:40 +0530
Message-ID: <CAKohpo=9G+ebAxfOxkhQneEz2Vc_rfnR=he65WiZ4ERfmy-erg@mail.gmail.com>
Subject: Re: [PATCH 5/7] cpufreq: balance out cpufreq_cpu_{get,put} for
 scaling drivers using setpolicy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2013 21:41, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> our files are clearly out of sync :-)  The code in cpufreq_add_dev() is

I was at latest bleeding-edge then, but i still have below code in my HEAD.

> #ifdef CONFIG_SMP
>         /* check whether a different CPU already registered this
>          * CPU because it is in the same boat. */
>         policy = cpufreq_cpu_get(cpu);
>         if (unlikely(policy)) {
>                 cpufreq_cpu_put(policy);
>                 return 0;
>         }
>
> The reference added by this cpufreq_cpu_get() is finally dropped in
> __cpufreq_remove_dev() with the call to __cpufreq_governor()

__cpufreq_governor() is not calling cpufreq_cpu_put() at all and is dropping
reference for the governor only, not for policy.

>         if (driver->target)
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
> Without this change I hang at:
>                 pr_debug("waiting for dropping of refcount\n");
>                 wait_for_completion(cmp);

Below should have fixed it for you i believe.

	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
	cpufreq_cpu_put(data);
	unlock_policy_rwsem_write(cpu);

--
viresh
