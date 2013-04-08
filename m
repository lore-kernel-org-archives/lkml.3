Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788Ab3DHDSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:18:48 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33703 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934745Ab3DHDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:18:47 -0400
Message-ID: <516236AE.60501@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 08:47:02 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v7 20/21] sched: don't do power balance on share cpu power
 domain
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <1365040862-8390-21-git-send-email-alex.shi@intel.com>
In-Reply-To: <1365040862-8390-21-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040803-1618-0000-0000-000003A44F32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 04/04/2013 07:31 AM, Alex Shi wrote:
> Packing tasks among such domain can't save power, just performance
> losing. So no power balance on them.

As far as my understanding goes, powersave policy is the one that tries
to pack tasks onto a SIBLING domain( domain where SD_SHARE_CPUPOWER is
set).balance policy does not do that,meaning it does not pack on the
domain that shares CPU power,but packs across all other domains.So the
change you are making below results in nothing but the default behaviour
of balance policy.

Correct me if I am wrong but my point is,looks to me,that the powersave
policy is introduced in this patchset,and with the below patch its
characteristic behaviour of packing onto domains sharing cpu power is
removed,thus making it default to balance policy.Now there are two
policies which behave the same way:balance and powersave.

> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 047a1b3..3a0284b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3503,7 +3503,7 @@ static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
> 
>  	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
>  	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
> -		if (wakeup)
> +		if (wakeup && !(sd->flags & SD_SHARE_CPUPOWER))
>  			new_cpu = find_leader_cpu(sds->group_leader,
>  							p, cpu, policy);
>  		/* for fork balancing and a little busy task */
> @@ -4410,8 +4410,9 @@ static unsigned long task_h_load(struct task_struct *p)
>  static inline void init_sd_lb_power_stats(struct lb_env *env,
>  						struct sd_lb_stats *sds)
>  {
> -	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE ||
> -				env->idle == CPU_NOT_IDLE) {
> +	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE
> +			|| env->sd->flags & SD_SHARE_CPUPOWER
> +			|| env->idle == CPU_NOT_IDLE) {
>  		env->flags &= ~LBF_POWER_BAL;
>  		env->flags |= LBF_PERF_BAL;
>  		return;
> 

Regards
Preeti U Murthy

