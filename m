Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaANTVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:21:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaANTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:20:58 -0500
Date: Tue, 14 Jan 2014 20:21:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, nschichan@freebox.fr, keescook@chromium.org,
        james.l.morris@oracle.com, akpm@linux-foundation.org, holt@sgi.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and
	SECCOMP_EXT_ACT_TSYNC
Message-ID: <20140114192118.GA31411@redhat.com>
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
> +static pid_t seccomp_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +	pid_t failed = 0;
> +	thread = caller = current;
> +
> +	read_lock(&tasklist_lock);
> +	if (thread_group_empty(caller))
> +		goto done;
> +	while_each_thread(caller, thread) {
> +		task_lock(thread);

perhaps we take task_lock() to serialize with another caller of
seccomp_sync_threads()...

If yes, then perhaps you can use ->siglock instead of tasklist_lock
and do not use task_lock(). It would be even better to rely on rcu,
but:

> +			get_seccomp_filter(caller);
> +			/*
> +			 * Drop the task reference to the shared ancestor since
> +			 * current's path will hold a reference.  (This also
> +			 * allows a put before the assignment.)
> +			 */
> +			put_seccomp_filter(thread);
> +			thread->seccomp.filter = caller->seccomp.filter;

As I said, I do not understand this patch yet, but this looks suspicious.

Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
not the the new thread yet, but its ->seccomp can be already copied
by copy_process(), no?

Oleg.

