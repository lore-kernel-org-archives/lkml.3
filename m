Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3FFXsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:48:36 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48936 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FFXsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:48:35 -0400
Date: Thu, 6 Jun 2013 16:48:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 07/11] sched: account guest time per-cgroup as well.
Message-ID: <20130606234832.GQ5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-8-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-8-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:03:18PM +0400, Glauber Costa wrote:
> We already track multiple tick statistics per-cgroup, using
> the task_group_account_field facility. This patch accounts
> guest_time in that manner as well.
> 
> Signed-off-by: Glauber Costa <glommer@openvz.org>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Turner <pjt@google.com>
> ---
>  kernel/sched/cputime.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 74a44ef..e653e52 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -183,8 +183,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>  static void account_guest_time(struct task_struct *p, cputime_t cputime,
>  			       cputime_t cputime_scaled)
>  {
> -	u64 *cpustat = kcpustat_this_cpu->cpustat;
> -
>  	/* Add guest time to process. */
>  	p->utime += cputime;
>  	p->utimescaled += cputime_scaled;
> @@ -193,11 +191,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>  
>  	/* Add guest time to cpustat. */
>  	if (TASK_NICE(p) > 0) {
> -		cpustat[CPUTIME_NICE] += (__force u64) cputime;
> -		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
> +		task_group_account_field(p, CPUTIME_NICE, (__force u64) cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
>  	} else {
> -		cpustat[CPUTIME_USER] += (__force u64) cputime;
> -		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
> +		task_group_account_field(p, CPUTIME_USER, (__force u64) cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);

This is a behavior change, right?  It seems sane to me but maybe the
patch description should be more explicit?

Thanks.

-- 
tejun
