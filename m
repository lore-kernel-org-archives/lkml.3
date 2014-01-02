Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaABMV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:21:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaABMV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:21:27 -0500
Subject: Re: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rpeterso@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201401021952.HGF52137.FFOHMQFVOJLStO@I-love.SAKURA.ne.jp>
References: <201312242051.ECA46103.MFFVFOtHSJOLQO@I-love.SAKURA.ne.jp>
	 <1388657311.2746.10.camel@menhir>
	 <201401021952.HGF52137.FFOHMQFVOJLStO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 02 Jan 2014 12:21:11 +0000
Message-ID: <1388665271.2746.12.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks - that looks good. I've applied it to the GFS2 -nmw and -fixes
trees,

Steve.

On Thu, 2014-01-02 at 19:52 +0900, Tetsuo Handa wrote:
> Steven Whitehouse wrote:
> > > Subject: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
> > > 
> > > Since we are not in RCU nor tasklist_lock held, we need to grab a reference on
> > > the returned task_struct. Use get_pid_task()/get_task_comm() to safely read the
> > > target task's comm name.
> > > 
> > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > ---
> > 
> > Well this is not entirely true... for 99.9% of calls to this function we
> > do have the rcu read lock held (when called from the seq file code). So
> > the only issue is when called from the GLOCK_BUG_ON() macro.
> > 
> > Since it appears that rcu_read_lock() will nest, then we could
> > presumably just add that around dump_holder or even around
> > gfs2_dump_glock ?
> > 
> > I think that is a neater solution than taking extra ref counts and
> > copying the string around,
> 
> OK. I didn't check what lock protects this dereference. I just noticed this
> dereference when I was checking direct ->comm access which might fail to return
> consistent comm name. I might propose changing ->comm access to RCU in the
> future ( https://lkml.org/lkml/2013/12/25/21 ).
> 
> For now add only rcu_read_lock()/rcu_read_unlock(). Patch follows.
> ----------
> >From 63f41a384636be1acd1575ee9f9e0de317cbc131 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 2 Jan 2014 19:41:23 +0900
> Subject: [PATCH v2] GFS2: Fix unsafe dereference in dump_holder()
> 
> GLOCK_BUG_ON() might call this function without RCU read lock. Make sure that
> RCU read lock is held when using task_struct returned from pid_task().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/gfs2/glock.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index c8420f7..6f7a47c 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -1655,6 +1655,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
>  	struct task_struct *gh_owner = NULL;
>  	char flags_buf[32];
>  
> +	rcu_read_lock();
>  	if (gh->gh_owner_pid)
>  		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
>  	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
> @@ -1664,6 +1665,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
>  		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
>  		       gh_owner ? gh_owner->comm : "(ended)",
>  		       (void *)gh->gh_ip);
> +	rcu_read_unlock();
>  	return 0;
>  }
>  


