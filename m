Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaANTHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaANTHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:35 -0500
Date: Tue, 14 Jan 2014 20:07:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, nschichan@freebox.fr, keescook@chromium.org,
        james.l.morris@oracle.com, akpm@linux-foundation.org, holt@sgi.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and
	SECCOMP_EXT_ACT_TSYNC
Message-ID: <20140114190756.GA30680@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org> <1389645028-17157-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389645028-17157-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Will Drewry wrote:
>
> When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0) is called, it
> will attempt to synchronize all threads in current's threadgroup to its
> seccomp filter program.

TBH, I do not understand what this patch actually does ;) I'll try to
read it later. Still a couple of nits.

> +static pid_t seccomp_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +	pid_t failed = 0;
> +	thread = caller = current;
> +
> +	read_lock(&tasklist_lock);
> +	if (thread_group_empty(caller))
> +		goto done;

You can check thread_group_empty() before tasklist_lock, otherwise
this fast-path before while_each_thread() makes no sense.

> +	while_each_thread(caller, thread) {
> +		task_lock(thread);

Could you remind what task_lock() protects wrt seccomp?

> +		} else {
> +			/* Keep the last sibling that failed to return. */
> +			struct pid *pid = get_task_pid(thread, PIDTYPE_PID);
> +			failed = pid_vnr(pid);
> +			put_pid(pid);
> +			/* If the pid cannot be resolved, then return -ESRCH */
> +			if (failed == 0)
> +				failed = -ESRCH;

You can just do

	failed = task_pid_vnr(thread);

"failed == 0" is not possible either way (we are doing while_each_thread
under tasklist, the task can't do detach_pid).

Oleg.

