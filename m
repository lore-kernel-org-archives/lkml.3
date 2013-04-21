Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3DUXWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:22:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40193 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3DUXWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:22:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, sedat.dilek@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
Date: Mon, 22 Apr 2013 01:30:50 +0200
Message-ID: <2533805.egcIGXDHJD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=OOPBYCD_K6RLw2YrJxhMokwrOww4QM2t2T4SnGObyQQ@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com> <516C25AE.4050503@intel.com> <CAKohpo=OOPBYCD_K6RLw2YrJxhMokwrOww4QM2t2T4SnGObyQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 15, 2013 10:52:28 PM Viresh Kumar wrote:
> On 15 April 2013 21:37, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> > If the intel_pstate driver is being used __cpufreq_governor() should NOT be
> > called intel_pstate does not implement the target() callback.
> >
> > Nathan's commit 5800043b2 changed the fence around the call to
> > __cpufreq_governor() in __cpufreq_remove_dev() here is the relevant hunk.
> 
> No it isn't.
> 
> > +       if (has_target)
> >                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
> 
> As it has taken care of this limitation.
> 
> BUT some of my earlier patches haven't. :(
> Here is the fix (Sedat please try this and give your tested-by, use the attached
> patch as gmail might break what i am copying in mail)..
> 
> Sorry for being late in fixing this issue, i am still down with Tonsil infection
> and fever.. Today only i got some power to fix it after seeing Dirk's mail.
> 
> Your tested-by may help me to recover quickly :)
> 
> @Rafael: I will probably be down for one more week and so not doing any
> reviews for now... I do check important mails sent directly to me though.
> 
> ------------x----------------------x------------------
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 15 Apr 2013 22:43:57 +0530
> Subject: [PATCH] cpufreq: Don't call __cpufreq_governor() for drivers without
>  target()
> 
> Some cpufreq drivers implement their own governor and so don't need us to call
> generic governors interface via __cpufreq_governor(). Few recent commits haven't
> obeyed this law well and we saw some regressions.
> 
> This patch tries to fix this issue.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied to linux-pm.git/linux-next, although please check the result, because
the patchwork version of the patch wasn't quite applicable and I fixed it up
manually.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 3564947..a6f6595 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -858,13 +858,18 @@ static int cpufreq_add_policy_cpu(unsigned int
> cpu, unsigned int sibling,
>  				  struct device *dev)
>  {
>  	struct cpufreq_policy *policy;
> -	int ret = 0;
> +	int ret = 0, has_target = 0;
>  	unsigned long flags;
> 
>  	policy = cpufreq_cpu_get(sibling);
>  	WARN_ON(!policy);
> 
> -	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> +	rcu_read_lock();
> +	has_target = !!rcu_dereference(cpufreq_driver)->target;
> +	rcu_read_unlock();
> +
> +	if (has_target)
> +		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> 
>  	lock_policy_rwsem_write(sibling);
> 
> @@ -877,8 +882,10 @@ static int cpufreq_add_policy_cpu(unsigned int
> cpu, unsigned int sibling,
> 
>  	unlock_policy_rwsem_write(sibling);
> 
> -	__cpufreq_governor(policy, CPUFREQ_GOV_START);
> -	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +	if (has_target) {
> +		__cpufreq_governor(policy, CPUFREQ_GOV_START);
> +		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +	}
> 
>  	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>  	if (ret) {
> @@ -1146,7 +1153,8 @@ static int __cpufreq_remove_dev(struct device
> *dev, struct subsys_interface *sif
> 
>  	/* If cpu is last user of policy, free policy */
>  	if (cpus == 1) {
> -		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
> +		if (has_target)
> +			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
> 
>  		lock_policy_rwsem_read(cpu);
>  		kobj = &data->kobj;
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
