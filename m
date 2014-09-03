Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaICPma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:42:30 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41933 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbaICPm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:42:28 -0400
Date: Wed, 3 Sep 2014 11:42:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v3 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140903154219.GA30011@mtj.dyndns.org>
References: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140816122028.GC9305@htj.dyndns.org>
 <CAM_iQpVaWR-jZN3RByZgGsytRnv0NBxbXh_Y1WSdJqhasuygaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVaWR-jZN3RByZgGsytRnv0NBxbXh_Y1WSdJqhasuygaQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cong.

On Tue, Sep 02, 2014 at 03:52:40PM -0700, Cong Wang wrote:
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 33cbcb0..b06a059 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -56,7 +56,8 @@ static bool should_thaw_current(bool check_kthr_stop)
>  {
>         if (!freezing(current) ||
>             (check_kthr_stop && kthread_should_stop()) ||
> -           test_thread_flag(TIF_MEMDIE))
> +           /* It might not be safe to check TIF_MEMDIE for pm freeze */
> +           (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE)))
>                 return true;
>         else
>                 return false;
> 
> Are you happy now, Tejun? :)

Yes, this should be a lot safer.  The function still looks weird to me
tho.

	if (cond)
		return true;
	else
		return false;

is equivalent to

	return cond;

If you're worried that the conditional is too complex and harms
readability you can do

	/* explain cond0 */
	if (cond0)
		return true;

	/* explain cond1 */
	if (cond1)
		return true;

	return false;

Thanks.

-- 
tejun
