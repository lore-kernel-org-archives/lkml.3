Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaDBReV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbaDBReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:34:19 -0400
Date: Wed, 2 Apr 2014 19:34:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH v2 1/2] procfs: make
	/proc/*/{stack,syscall,personality} 0400
Message-ID: <20140402173429.GA31668@redhat.com>
References: <1395495460-7652-1-git-send-email-tixxdz@opendz.org> <1395495460-7652-2-git-send-email-tixxdz@opendz.org> <20140328153231.93bcad089d9ccc670ee6cc17@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328153231.93bcad089d9ccc670ee6cc17@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Andrew Morton wrote:
>
> Now for a six-year-late code review:
>
> - How the heck can target==current in task_current_syscall()?
>
> - Less talk, more action:
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/syscall.c: unexport task_current_syscall()
>
> It is only used by procfs and procfs cannot be a module.
>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  lib/syscall.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff -puN lib/syscall.c~a lib/syscall.c
> --- a/lib/syscall.c~a
> +++ a/lib/syscall.c
> @@ -72,4 +72,3 @@ int task_current_syscall(struct task_str
>
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(task_current_syscall);

Well, I guess it was added for external tracing modules like systemtap.
And in this case target==current is very likely. And for utrace modules,
but it is dead.

I do not see any usage of task_current_syscall() in
git://sourceware.org/git/systemtap.git, so this change should not upset
systemtap at least.

And if we unexport task_current_syscall(), perhaps we should actually
lib/syscall.c. proc_pid_syscall() can use syscall_get_*() instead.
Or at least we can simplify it, I don't think /proc/ actually needs
wait_task_inactive().

Oleg.

