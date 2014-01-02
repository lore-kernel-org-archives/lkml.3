Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830AbaABKIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:08:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaABKIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:08:48 -0500
Subject: Re: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rpeterso@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201312242051.ECA46103.MFFVFOtHSJOLQO@I-love.SAKURA.ne.jp>
References: <201312242051.ECA46103.MFFVFOtHSJOLQO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 02 Jan 2014 10:08:31 +0000
Message-ID: <1388657311.2746.10.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-12-24 at 20:51 +0900, Tetsuo Handa wrote:
> >From efee681e4ca6152d9549a50e93ca932b00f03014 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 24 Dec 2013 18:04:43 +0900
> Subject: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
> 
> Since we are not in RCU nor tasklist_lock held, we need to grab a reference on
> the returned task_struct. Use get_pid_task()/get_task_comm() to safely read the
> target task's comm name.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---

Well this is not entirely true... for 99.9% of calls to this function we
do have the rcu read lock held (when called from the seq file code). So
the only issue is when called from the GLOCK_BUG_ON() macro.

Since it appears that rcu_read_lock() will nest, then we could
presumably just add that around dump_holder or even around
gfs2_dump_glock ?

I think that is a neater solution than taking extra ref counts and
copying the string around,

Steve.

>  fs/gfs2/glock.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index c8420f7..7bda965 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -1654,15 +1654,22 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
>  {
>  	struct task_struct *gh_owner = NULL;
>  	char flags_buf[32];
> +	char name[TASK_COMM_LEN];
>  
>  	if (gh->gh_owner_pid)
> -		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
> +		gh_owner = get_pid_task(gh->gh_owner_pid, PIDTYPE_PID);
> +	if (gh_owner) {
> +		get_task_comm(name, gh_owner);
> +		put_task_struct(gh_owner);
> +	} else {
> +		strlcpy(name, "(ended)", sizeof(name));
> +	}
>  	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
>  		       state2str(gh->gh_state),
>  		       hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
>  		       gh->gh_error,
>  		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
> -		       gh_owner ? gh_owner->comm : "(ended)",
> +		       name,
>  		       (void *)gh->gh_ip);
>  	return 0;
>  }


