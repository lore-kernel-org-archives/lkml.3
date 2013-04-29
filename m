Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab3D2VwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:52:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52190 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2VwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:52:03 -0400
Date: Mon, 29 Apr 2013 14:51:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP
 set
Message-ID: <20130429215157.GA2395@htj.dyndns.org>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367271946-7239-3-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 29, 2013 at 02:45:38PM -0700, Colin Cross wrote:
> If a task has called freezer_do_not_count(), don't bother waking it
> up.  If it happens to wake up later it will call freezer_count() and
> immediately enter the refrigerator.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  kernel/cgroup_freezer.c | 5 ++++-
>  kernel/power/process.c  | 4 ++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 75dda1e..406dd71 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -331,8 +331,11 @@ static void freeze_cgroup(struct freezer *freezer)
>  	struct task_struct *task;
>  
>  	cgroup_iter_start(cgroup, &it);
> -	while ((task = cgroup_iter_next(cgroup, &it)))
> +	while ((task = cgroup_iter_next(cgroup, &it))) {
> +		if (freezer_should_skip(task))
> +			continue;
>  		freeze_task(task);
> +	}
>  	cgroup_iter_end(cgroup, &it);

I feel a bit weary of changes which try to optimize state checks for
freezer because the synchronization rules are kinda fragile and things
may not work reliably depending on who's testing the flag, and it has
been subtly broken in various ways in the past (maybe even now).  Can
you please explain the benefits of this patch (in terms of actual
overhead because not many use freezer_do_not_count()) and why this is
correct?

Thanks.

-- 
tejun
