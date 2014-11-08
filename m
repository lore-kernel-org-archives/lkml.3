Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKHBGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:06:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55087 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752682AbaKHBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:06:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lucas Stach <l.stach@pengutronix.de>, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] cpufreq: Avoid crash in resume on SMP without OPP
Date: Sat, 08 Nov 2014 02:27:22 +0100
Message-ID: <2837337.oz3KWfM6uC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415117125-27069-1-git-send-email-geert+renesas@glider.be>
References: <1415117125-27069-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 05:05:25 PM Geert Uytterhoeven wrote:
> When resuming from s2ram on an SMP system without cpufreq operating
> points (e.g. there's no "operating-points" property for the CPU node in
> DT, or the platform doesn't use DT yet), the kernel crashes when
> bringing CPU 1 online:
> 
>     Enabling non-boot CPUs ...
>     CPU1: Booted secondary processor
>     Unable to handle kernel NULL pointer dereference at virtual address 0000003c
>     pgd = ee5e6b00
>     [0000003c] *pgd=6e579003, *pmd=6e588003, *pte=00000000
>     Internal error: Oops: a07 [#1] SMP ARM
>     Modules linked in:
>     CPU: 0 PID: 1246 Comm: s2ram Tainted: G        W      3.18.0-rc3-koelsch-01614-g0377af242bb175c8-dirty #589
>     task: eeec5240 ti: ee704000 task.ti: ee704000
>     PC is at __cpufreq_add_dev.isra.24+0x24c/0x77c
>     LR is at __cpufreq_add_dev.isra.24+0x244/0x77c
>     pc : [<c0298efc>]    lr : [<c0298ef4>]    psr: 60000153
>     sp : ee705d48  ip : ee705d48  fp : ee705d84
>     r10: c04e0450  r9 : 00000000  r8 : 00000001
>     r7 : c05426a8  r6 : 00000001  r5 : 00000001  r4 : 00000000
>     r3 : 00000000  r2 : 00000000  r1 : 20000153  r0 : c0542734
> 
> Verify that policy is not NULL before dereferencing it to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Notes:
>   - Is this the right fix?

The fix looks correct to me.

To my eyes what happens is that cpufreq_driver->init() in __cpufreq_add_dev()
fails and then cpufreq_cpu_data_fallback is cleared.  cpufreq_cpu_data is not
set for the CPU, so cpufreq_cpu_data_fallback is NULL all the time.  Then,
during resume, __cpufreq_add_dev() is called again and it calls
cpufreq_policy_restore(), because cpufreq_suspended is set.  You know the rest. :-)

I'm queuing this up for the next PM pull request (most likely next week
for -rc5).

>   - Interestingly, the crash is the same as the one reported in
>     http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c81407fe573d8ac3c7150f5373475598c59197de
>     ("cpufreq: cpufreq-dt: Restore default cpumask_setall(policy->cpus)"),
>     but the cause is different.
> 
>   - The crash was initially observed on sh73a0/kzm9g-legacy, but it can
>     easily be reproduced on e.g. r8a7791/koelsch, by removing the
>     "operating-points" property from the cpu0 node in
>     arch/arm/boot/dts/r8a7791.dtsi, or by any other means to make the
>     call to dev_pm_opp_init_cpufreq_table() in
>     drivers/cpufreq/cpufreq-dt.c:cpufreq_init() fail.
> 
>   - I did not add
> 
> 	Fixes: 6e2c89d16d987e6e ("cpufreq: move call to __find_governor() to cpufreq_init_policy()")

To me, that should be:

	Fixes: 8414809c6a1e (cpufreq: Preserve policy structure across suspend/resume)

and therefore should go into 3.12+.

I'll add the appropriate tags.

> 
>     as I couldn't verify that the issue is also present in that (old)
>     version (there have been too many s2ram-related platform and driver
>     fixes since v3.15).
> ---
>  drivers/cpufreq/cpufreq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 644b54e1e7d13e8e..4473eba1d6b0b608 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1022,7 +1022,8 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
>  
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  
> -	policy->governor = NULL;
> +	if (policy)
> +		policy->governor = NULL;
>  
>  	return policy;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
