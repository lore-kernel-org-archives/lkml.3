Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3H3Omf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:42:35 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43075
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753881Ab3H3Ome (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:42:34 -0400
Date: Fri, 30 Aug 2013 14:42:33 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Make sure to wake reaper
Message-ID: <20130830144232.GA18281@mail.hallyn.com>
References: <20130829211114.GA20726@sergelap>
 <87mwo0xb9p.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwo0xb9p.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
> > possible to get into a situation where a pidns reaper is
> > <defunct>, reparented to host pid 1, but never reaped.  How to
> > reproduce this is documented at
> >
> > https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
> > (and see
> > https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
> > In short, run repeated starts of a container whose init is
> >
> > Process.exit(0);
> >
> > sysrq-t when such a task is playing zombie shows:
> >
> > [  131.132978] init            x ffff88011fc14580     0  2084   2039 0x00000000
> > [  131.132978]  ffff880116e89ea8 0000000000000002 ffff880116e89fd8 0000000000014580
> > [  131.132978]  ffff880116e89fd8 0000000000014580 ffff8801172a0000 ffff8801172a0000
> > [  131.132978]  ffff8801172a0630 ffff88011729fff0 ffff880116e14650 ffff88011729fff0
> > [  131.132978] Call Trace:
> > [  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
> > [  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
> > [  131.132978]  [<ffffffff81071eae>] ? signal_wake_up_state+0x1e/0x30
> > [  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
> > [  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
> > [  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6
> >
> > Further debugging showed that every time this happened, zap_pid_ns_processes()
> > started with nr_hashed being 3, while we were expecting it to drop to 2.
> > Any time it didn't happen, nr_hashed was 1 or 2.  So the reaper was
> > waiting for nr_hashed to become 2, but free_pid() only wakes the reaper
> > if nr_hashed hits 1.  This patch makes free_pid() wake the reaper any
> > time the reaper is PF_EXITING, to force it to re-test the
> > pidns->nr_hashed = init_pids test.  Note that this is more like what
> > __unhash_process() used to do before
> > af4b8a83add95ef40716401395b44a1b579965f4.
> >
> > Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > ---
> >  kernel/pid.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index 0db3e79..6b312c4 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -274,6 +274,10 @@ void free_pid(struct pid *pid)
> >  		case 0:
> >  			schedule_work(&ns->proc_work);
> >  			break;
> > +		default:
> > +			if (ns->child_reaper->flags & PF_EXITING)
> > +				wake_up_process(ns->child_reaper);
> > +			break;
> >  		}
> >  	}
> >  	spin_unlock_irqrestore(&pidmap_lock, flags);
> 
> qSo I think the change that we actually want is just to send a wake-up
> when we have two pids in the pid namespace as well as one pid.
> 
> - That can send one extraneous wake-up but that is relatively harmless.
> - We can detect the condition race free.
> - With only two pids remaining we are guaranteed that which ever task is
>   the child_reaper will persist through zap_pid_ns_processes.
> 
>   There are 3 cases.
>   init-tgleader other -- Single threaded init so of course we won't free the task
>   init-tgleader-dead init-thread -- The last living init thread will call zap_pid_ns_processes.
>   init-tgleader init-thread -- An init with two living threads child_reaper must be the init thread group leader
> 
> Which means at the cost of an extra wake-up we are guaranteed not to
> have races.
> 
> Serge does that look good to you?

Yeah, I haven't reproduced the defunct tasks with this patch.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>

thanks,
-serge

> 
> Eric
> 
> 
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 17755ae..ab75add 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -265,6 +265,7 @@ void free_pid(struct pid *pid)
>                 struct pid_namespace *ns = upid->ns;
>                 hlist_del_rcu(&upid->pid_chain);
>                 switch(--ns->nr_hashed) {
> +               case 2:
>                 case 1:
>                         /* When all that is left in the pid namespace
>                          * is the reaper wake up the reaper.  The reaper
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
