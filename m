Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3FYUKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3FYUKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:10:44 -0400
Date: Tue, 25 Jun 2013 22:06:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll_[p]wait: fix spurious -EINTR on ptrace attach
Message-ID: <20130625200623.GA15267@redhat.com>
References: <1372172737-18726-1-git-send-email-dvlasenk@redhat.com> <20130625184619.GA4003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625184619.GA4003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Oleg Nesterov wrote:
>
> On 06/25, Denys Vlasenko wrote:
> >
> > Before this change, epoll_wait and epoll_pwait
> > spuriously return with -EINTR on ptrace attach.
> >
> > By analogy with poll syscall family, epoll_[p]wait should be interruptible
> > by signals regardless of SA_RESTART, therefore, this change
> > makes them return -ERESTARTNOHAND if timeout has expired.
>
> Denys, I am not even going to actuallu read this patch, but I think
> you should redo it in any case... And you need to cc maintainers.

Yes... but when I look at it again I think that "timeout" logic is
still wrong.

	restart_block->epoll.timeout = rem_msec;

this obviously means the remaining timeout, yes?

If yes, this is not right. Suppose that we return ERESTART_RESTARTBLOCK
due to SIGSTOP. The task can sleep in TASK_STOPPED "forever", we should
not restart with "timeout = rem_msec" after that.

You need the end_time logic like sys_poll() does.

> Because I believe we should cleanup fs/eventpoll.c first, I'll try
> to send the patch(es) soon.

Please see the patches I sent.

> > In order to define a "sigset_t ksigmask" member,
>
> You do not need it. But the reason is not clear until the cleanup.

I take this back, this is not as simple as I thought... and perhaps even
not right.

However. Probably you can replace has_ksigmask + ksigmask by
"sigset_t __user *sigmask" pointer?

Oleg.

