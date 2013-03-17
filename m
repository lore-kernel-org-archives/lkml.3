Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3CQRJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 13:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3CQRJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 13:09:40 -0400
Date: Sun, 17 Mar 2013 18:07:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: lockdep splat with prepare_bprm_creds
Message-ID: <20130317170736.GA4487@redhat.com>
References: <51429E72.7090405@oracle.com> <20130315042628.GV21522@ZenIV.linux.org.uk> <20130315181956.GA9315@redhat.com> <20130316194128.GC21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316194128.GC21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Al Viro wrote:
>
> On Fri, Mar 15, 2013 at 07:19:56PM +0100, Oleg Nesterov wrote:
>
> > Cough... I am shy to disclose my ignorance, but could you explain how
> > open_exec()->do_filp_open(MAY_EXEC) can succeed in this case? At least
> > acl_permission_check() looks as if open_exec() should fail...
>
> Umm... point.  It might be a false positive, actually - some other
> seq_file-based sucker (while chmod +x /proc/self/stack will fail,
> chmod +x /proc/vmstat won't) that could be fed to execve(), leading to
> 	1) kernel_read() from execve() can grab m.lock for *some* seq_file m,
> while holding ->cred_guard_mutex

Yes, thanks.

I am wondering if lock_trace() is really useful...

Lets ignore proc_pid_syscall() and proc_pid_personality(). Suppose we
change proc_pid_stack()

	int proc_pid_stack(...)
	{
		...

		save_stack_trace_tsk(task, &trace);
		if (!ptrace_may_access(task, PTRACE_MODE_ATTACH))
			goto return -EPERM;

		for (i = 0; i < trace.nr_entries; i++)
			seq_printf(...);

		return 0;
	}

Sure, without cred_guard_mutex we can race with install_exec_creds(). But
is it a problem in practice? In any case lock_trace() can't protect against
commit_creds()...

We can even do

		task_lock(task);
		err = __ptrace_may_access(task, mode);
		if (!err)
			save_stack_trace_tsk(...);
		task_unlock(task);

This way task_lock() protects us against exec_mmap(). And even exec_mmap()
was already called and the task is going to do install_exec_creds() we can't
show the stack of this process "after" exec.

Oleg.

