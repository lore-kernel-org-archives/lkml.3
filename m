Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3JHSDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833Ab3JHSDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:03:06 -0400
Date: Tue, 8 Oct 2013 19:56:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/pid.c: check pid whether be NULL in
	__change_pid()
Message-ID: <20131008175625.GA32220@redhat.com>
References: <52528CF7.8050405@asianux.com> <20131007124319.GA24450@redhat.com> <52532D74.1060408@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52532D74.1060408@asianux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Chen Gang wrote:
>
> On 10/07/2013 08:43 PM, Oleg Nesterov wrote:
> >
> >> but still recommend to check it
> >> in __change_pid() to let itself consistency.
> >
> > Why?
> >
> > Contrary, I think we should not hide the problem. If __change_pid() is
> > called when task->pids[type].pid is already NULL there is something
> > seriously wrong.
> >
>
> Hmm... In my opinion, it means need BUG_ON() for original 'link->pid'.
>
> --------------------------------patch begin-----------------------------
>
> [PATCH] kernel/pid.c: add BUG_ON() for "!pid" in __change_pid()
>
>   Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),

Yes, this is fine,

>   and 'link->pid' also may be NULL ("link->pid = new"),
> ...
>   the original 'link->pid' may be NULL, too.

Too? You mean, it becomes NULL after detach_pid().

>   But in real world, all related extern functions always assume "if
>   'link->pid' is already NULL, there must be something seriously wrong",
>   although __change_pid() can accept parameter 'new' as NULL.

I simply can't understand why you mix "new == NULL" and "link->pid == NULL".

>   So in __change_pid(), need add BUG_ON() for it: "it should not happen,
>   when it really happen, OS must be continuing blindly,

OS will crash a couple of lines below trying to dereference this pointer.

> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -396,6 +396,12 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
>  	link = &task->pids[type];
>  	pid = link->pid;
>
> +	/*
> +	 * If task->pids[type].pid is already NULL, there must be something
> +	 * seriously wrong
> +	 */
> +	BUG_ON(!pid);

Following this logic you should also add

	BUG_ON(!task);
	BUG_ON(!link->node.next);
	BUG_ON(!link->node.prev || link->node.prev == LIST_POISON2);
	...

Seriously, I do not understand the point. Yes, detach_pid() should not
be called twice. And it has a single caller. And this caller will crash
too if it is called twice. So you can also add BUG_ON() into
__unhash_process(). And so on.

Oleg.

