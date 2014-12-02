Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaLBRAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:00:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41821 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaLBRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:00:39 -0500
Date: Tue, 2 Dec 2014 17:00:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
Message-ID: <20141202170037.GG29748@ZenIV.linux.org.uk>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417494919-4577-2-git-send-email-oakad@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:35:18PM +1100, Alex Dubov wrote:
> +	dst_files = get_files_struct(dst_task);
> +	if (!dst_files) {
> +		rc = -EMFILE;
> +		goto out_put_dst_task;
> +	}
> +
> +	if (!lock_task_sighand(dst_task, &flags)) {
> +		rc = -EMFILE;
> +		goto out_put_dst_files;
> +	}
> +
> +	rlim = task_rlimit(dst_task, RLIMIT_NOFILE);
> +
> +	unlock_task_sighand(dst_task, &flags);
> +
> +	rc = __alloc_fd(dst_task->files, 0, rlim, O_CLOEXEC);
> +	if (rc < 0)
> +		goto out_put_dst_files;
> +
> +	s_info.si_int = rc;
> +
> +	get_file(src_file);
> +	__fd_install(dst_files, rc, src_file);
> +	rc = kill_pid_info(sig, &s_info, task_pid(dst_task));
> +
> +	if (rc < 0)
> +		__close_fd(dst_files, s_info.si_int);

Oh, lovely...  And we are guaranteed that it still the same file, because...?

Not to mention anything else, this stuff violates the assumption used in a lot
of places - that the *only* way for a process to modify a descriptor table is
to have a reference to it obtained by something that had it as its current
descriptor table and not dropped since then.  The way you do it might actually
turn out to be OK, but there's no way I'll take that without detailed analysis;
start with refcounting of struct file, for one thing - it does rely on the
assumption above in non-trivial ways.

Binder, shite as it is, satisfies that assumption.  Your "simpler" variant
does not.  Which means that you get to prove that you won't open any races
around fs/file.c.

And that's aside of the points other folks had brought up.
