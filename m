Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaFXRyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaFXRyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:54:43 -0400
Date: Tue, 24 Jun 2014 19:08:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Message-ID: <20140624170800.GA30480@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-8-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403560693-21809-8-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Kees Cook wrote:
>
> +static pid_t seccomp_can_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +
> +	BUG_ON(write_can_lock(&tasklist_lock));
> +	BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +
> +	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
> +		return -EACCES;
> +
> +	/* Validate all threads being eligible for synchronization. */
> +	thread = caller = current;
> +	for_each_thread(caller, thread) {

You only need to initialize "caller" for for_each_thread(). Same for
seccomp_sync_threads().

> @@ -586,6 +701,17 @@ static long seccomp_set_mode_filter(unsigned int flags,
>  	if (IS_ERR(prepared))
>  		return PTR_ERR(prepared);
>
> +	/*
> +	 * If we're doing thread sync, we must hold tasklist_lock
> +	 * to make sure seccomp filter changes are stable on threads
> +	 * entering or leaving the task list. And we must take it
> +	 * before the sighand lock to avoid deadlocking.
> +	 */
> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
> +		write_lock_irqsave(&tasklist_lock, taskflags);
> +	else
> +		__acquire(&tasklist_lock); /* keep sparse happy */
> +

Why? ->siglock should be enough, it seems.

It obviously does not protect the global process list, but *sync_threads()
only care about current's thread group list, no?

Oleg.

