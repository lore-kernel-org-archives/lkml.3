Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3KRDEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:04:54 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42678 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab3KRDEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:04:48 -0500
X-Sasl-enc: 4m2D9+xzzg1SWS1I3OV/OdpDnS5mWo6/IX49iS63zMqr 1384743886
Message-ID: <1384743883.2380.23.camel@perseus.fritz.box>
Subject: Re: [patch 1/2] autofs4: allow autofs to work outside the initial
 PID namespace
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, sukadev@us.ibm.com, ebiederm@xmission.com,
        mszeredi@suse.cz, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Nov 2013 11:04:43 +0800
In-Reply-To: <20131116160334.GA19309@redhat.com>
References: <20131115222222.6F70A1CA1A1@corp2gmr1-1.eem.corp.google.com>
	 <20131116160334.GA19309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-16 at 17:03 +0100, Oleg Nesterov wrote:
> On 11/15, Andrew Morton wrote:
> >
> > Enable autofs4 to work in a "container".  oz_pgrp is converted from pid_t
> > to struct pid and this is stored at mount time based on the "pgrp=" option
> > or if the option is missing then the current pgrp.
> 
> I don't understand this code, so I am probably wrong. And this is minor
> anyway, but...

And I don't understand the namespace code myself but I think you are
correct about the raceand I'm not sure what to do about it either just
yet.

The sbi->wq_mutex will prevent user space daemon notifications and wait
releases but it won't prevent lookups or umounts, the sbi->fs_lock would
be needed for that.

I'm not sure that matters though since there can be only one user space
daemon handling an automount point and the case below here requires
there is no current process owner of the mount the pipe fd is to be set
for (ie. the "if (!sbi->catatonic) { ... }"). That just means a new
process is attempting to "reconnect" to the mount, so umount shouldn't
be a problem. I guess there is a chance that the root user or an errant
pre-existing process might try and umount the mount ...

It might be sufficient to surround the contents of show_options() with a
lock on wq_mutex and update the check at the top to

"lock; if (!sbi || sbi->catatonic) {unlock, return 0; } ..."

but it might be necessary to use the sbi->fs_lock in both locations,
since a catatonic automount has no outstanding waits and can't create
new waits (and hence there can't be any valid wait release ioctls).

I'll think a bit more about the potential umount issue before offering a
patch.

> 
> > @@ -357,7 +358,17 @@ static int autofs_dev_ioctl_setpipefd(st
> >  		mutex_unlock(&sbi->wq_mutex);
> >  		return -EBUSY;
> >  	} else {
> > -		struct file *pipe = fget(pipefd);
> > +		struct file *pipe;
> > +
> > +		new_pid = get_task_pid(current, PIDTYPE_PGID);
> > +
> > +		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
> > +			AUTOFS_WARN("Not allowed to change PID namespace");
> > +			err = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		pipe = fget(pipefd);
> >  		if (!pipe) {
> >  			err = -EBADF;
> >  			goto out;
> > @@ -367,12 +378,13 @@ static int autofs_dev_ioctl_setpipefd(st
> >  			fput(pipe);
> >  			goto out;
> >  		}
> > -		sbi->oz_pgrp = task_pgrp_nr(current);
> > +		swap(sbi->oz_pgrp, new_pid);
> >  		sbi->pipefd = pipefd;
> >  		sbi->pipe = pipe;
> >  		sbi->catatonic = 0;
> >  	}
> >  out:
> > +	put_pid(new_pid);
> 
> This looks suspicious, put_pid() can actually kfree the old sbi->oz_pgrp
> swapped above. IOW, this assumes we can't race with any user of ->oz_pgrp.
> 
> For example,
> 
> > @@ -80,7 +83,7 @@ static int autofs4_show_options(struct s
> >  	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
> >  		seq_printf(m, ",gid=%u",
> >  			from_kgid_munged(&init_user_ns, root_inode->i_gid));
> > -	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
> > +	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
> 
> Can't this race with autofs_dev_ioctl_setpipefd() above?
> 
> Oleg.
> 


