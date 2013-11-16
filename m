Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3KPQC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:02:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3KPQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:02:19 -0500
Date: Sat, 16 Nov 2013 17:03:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: raven@themaw.net, sukadev@us.ibm.com, ebiederm@xmission.com,
        mszeredi@suse.cz, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] autofs4: allow autofs to work outside the initial
	PID namespace
Message-ID: <20131116160334.GA19309@redhat.com>
References: <20131115222222.6F70A1CA1A1@corp2gmr1-1.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115222222.6F70A1CA1A1@corp2gmr1-1.eem.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Andrew Morton wrote:
>
> Enable autofs4 to work in a "container".  oz_pgrp is converted from pid_t
> to struct pid and this is stored at mount time based on the "pgrp=" option
> or if the option is missing then the current pgrp.

I don't understand this code, so I am probably wrong. And this is minor
anyway, but...

> @@ -357,7 +358,17 @@ static int autofs_dev_ioctl_setpipefd(st
>  		mutex_unlock(&sbi->wq_mutex);
>  		return -EBUSY;
>  	} else {
> -		struct file *pipe = fget(pipefd);
> +		struct file *pipe;
> +
> +		new_pid = get_task_pid(current, PIDTYPE_PGID);
> +
> +		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
> +			AUTOFS_WARN("Not allowed to change PID namespace");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		pipe = fget(pipefd);
>  		if (!pipe) {
>  			err = -EBADF;
>  			goto out;
> @@ -367,12 +378,13 @@ static int autofs_dev_ioctl_setpipefd(st
>  			fput(pipe);
>  			goto out;
>  		}
> -		sbi->oz_pgrp = task_pgrp_nr(current);
> +		swap(sbi->oz_pgrp, new_pid);
>  		sbi->pipefd = pipefd;
>  		sbi->pipe = pipe;
>  		sbi->catatonic = 0;
>  	}
>  out:
> +	put_pid(new_pid);

This looks suspicious, put_pid() can actually kfree the old sbi->oz_pgrp
swapped above. IOW, this assumes we can't race with any user of ->oz_pgrp.

For example,

> @@ -80,7 +83,7 @@ static int autofs4_show_options(struct s
>  	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
>  		seq_printf(m, ",gid=%u",
>  			from_kgid_munged(&init_user_ns, root_inode->i_gid));
> -	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
> +	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));

Can't this race with autofs_dev_ioctl_setpipefd() above?

Oleg.

