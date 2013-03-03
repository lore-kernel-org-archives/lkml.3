Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3CCIil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 03:38:41 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:63175 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3CCIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 03:38:40 -0500
Date: Sun, 3 Mar 2013 16:38:29 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in
 exit_pi_state_list()
Message-ID: <20130303083829.GA18176@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
 <alpine.LFD.2.02.1303011047170.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303011047170.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 11:17:42AM +0100, Thomas Gleixner wrote:
> On Fri, 1 Mar 2013, Yong Zhang wrote:
> 
> > From: Yong Zhang <yong.zhang@windriver.com>
> > 
> > Otherwise, below warning is shown somtimes when running some test:
> > 
> > WARNING: at kernel/sched/core.c:3423 migrate_disable+0xbf/0xd0()
> > Hardware name: OptiPlex 755
> > Modules linked in: floppy parport parport_pc minix
> > Pid: 1800, comm: tst-robustpi8 Tainted: G        W    3.4.28-rt40 #1
> > Call Trace:
> >  [<ffffffff81031f3f>] warn_slowpath_common+0x7f/0xc0
> >  [<ffffffff81031f9a>] warn_slowpath_null+0x1a/0x20
> >  [<ffffffff81066eaf>] migrate_disable+0xbf/0xd0
> >  [<ffffffff81085d95>] exit_pi_state_list+0xa5/0x170
> >  [<ffffffff8102f71f>] mm_release+0x12f/0x170
> >  [<ffffffff81036906>] exit_mm+0x26/0x140
> >  [<ffffffff81090fc6>] ? acct_collect+0x186/0x1c0
> >  [<ffffffff81036b66>] do_exit+0x146/0x930
> >  [<ffffffff810658d1>] ? get_parent_ip+0x11/0x50
> >  [<ffffffff8103760d>] do_group_exit+0x4d/0xc0
> >  [<ffffffff8104828f>] get_signal_to_deliver+0x23f/0x6a0
> >  [<ffffffff810019e5>] do_signal+0x65/0x5e0
> >  [<ffffffff81047816>] ? group_send_sig_info+0x76/0x80
> >  [<ffffffff81002018>] do_notify_resume+0x98/0xd0
> >  [<ffffffff8165779b>] int_signal+0x12/0x17
> > ---[ end trace 0000000000000004 ]---
> > 
> > The reason is that spin_lock() is taken in atomic context, but
> > spin_unlock() is not.
> 
> This doesn't make sense. The spin_lock() happens in non atomic
> context.
> 
> 	spin_lock(&hb->lock);
> 	raw_spin_lock_irq(&curr->pi_lock);
> 
> The unlock is in atomic context and the unlock does not call
> migrate_disable().
> 
> Though on RT this is caused by the in_atomic check of migrate_enable()
> and this results in asymetry. See below.

Yeah, this is what I want to say. s/atomic/no-atomic/ in my words :)

> 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/futex.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 9e26e87..2b676a2 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -562,16 +562,17 @@ void exit_pi_state_list(struct task_struct *curr)
> >  
> >  		spin_lock(&hb->lock);
> >  
> > -		raw_spin_lock_irq(&curr->pi_lock);
> >  		/*
> >  		 * We dropped the pi-lock, so re-check whether this
> >  		 * task still owns the PI-state:
> >  		 */
> 
> Did you read and understand this comment ?
> 
> The logic here is
> 
>     raw_spin_lock_irq(&curr->pi_lock);
>     next = head->next;
>     raw_spin_unlock_irq(&curr->pi_lock);
>     spin_lock(&hb->lock);
>     raw_spin_lock_irq(&curr->pi_lock);
>     if (head->next != next)
> 
> We must drop pi_lock before locking the hash bucket lock. That opens a
> window for another task to modify head list. So we must relock pi_lock
> and verify whether head->next is unmodified. If it changed, we need to
> reevaluate.
> 
> >  		if (head->next != next) {
> >  			spin_unlock(&hb->lock);
> > +			raw_spin_lock_irq(&curr->pi_lock);
> >  			continue;
> >  		}
> >  
> > +		raw_spin_lock_irq(&curr->pi_lock);
> >  		WARN_ON(pi_state->owner != curr);
> >  		WARN_ON(list_empty(&pi_state->list));
> >  		list_del_init(&pi_state->list);
> 
> So both your patch description and your patch are patently wrong.
> Correct solution below.

Recognized it after sending my V1 out. So V2 is sent out to close the
race window and it happens to be the same patch with yours below.
http://marc.info/?l=linux-rt-users&m=136211763323758&w=2

Thanks,
Yong

> 
> Thanks,
> 
> 	tglx
> ---
> futex: Ensure lock/unlock symetry versus pi_lock and hash bucket lock
> 
> In exit_pi_state_list() we have the following locking construct:
> 
>    spin_lock(&hb->lock);
>    raw_spin_lock_irq(&curr->pi_lock);
>    
>    ...
>    spin_unlock(&hb->lock);
> 
> In !RT this works, but on RT the migrate_enable() function which is
> called from spin_unlock() sees atomic context due to the held pi_lock
> and just decrements the migrate_disable_atomic counter of the
> task. Now the next call to migrate_disable() sees the counter being
> negative and issues a warning. That check should be in
> migrate_enable() already.
> 
> Fix this by dropping pi_lock before unlocking hb->lock and reaquire
> pi_lock after that again. This is safe as the loop code reevaluates
> head again under the pi_lock.
> 
> Reported-by: Yong Zhang <yong.zhang@windriver.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f15f0e4..c795c9c 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -568,7 +568,9 @@ void exit_pi_state_list(struct task_struct *curr)
>  		 * task still owns the PI-state:
>  		 */
>  		if (head->next != next) {
> +			raw_spin_unlock_irq(&curr->pi_lock);
>  			spin_unlock(&hb->lock);
> +			raw_spin_lock_irq(&curr->pi_lock);
>  			continue;
>  		}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
