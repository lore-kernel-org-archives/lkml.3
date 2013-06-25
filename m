Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3FYSup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab3FYSul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:50:41 -0400
Date: Tue, 25 Jun 2013 20:46:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll_[p]wait: fix spurious -EINTR on ptrace attach
Message-ID: <20130625184619.GA4003@redhat.com>
References: <1372172737-18726-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372172737-18726-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Denys Vlasenko wrote:
>
> Before this change, epoll_wait and epoll_pwait
> spuriously return with -EINTR on ptrace attach.
>
> By analogy with poll syscall family, epoll_[p]wait should be interruptible
> by signals regardless of SA_RESTART, therefore, this change
> makes them return -ERESTARTNOHAND if timeout has expired.

Denys, I am not even going to actuallu read this patch, but I think
you should redo it in any case... And you need to cc maintainers.

Because I believe we should cleanup fs/eventpoll.c first, I'll try
to send the patch(es) soon.

> In order to define a "sigset_t ksigmask" member,

You do not need it. But the reason is not clear until the cleanup.

> +	if (sigmask) {
> +		ksigmask = *sigmask;
> +		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> +		sigprocmask(SIG_SETMASK, &ksigmask, &ksigsaved);

sigprocmask() should not be used. Again, we need cleanup.

> +	}
> +	else
> +	/*
> +	 * If we changed the signal mask, we need to restore the original one.
> +	 */
> +	if (sigmask) {
> +		sigprocmask(SIG_SETMASK, &ksigsaved, NULL);
> +	}

cough.. in this case you should also update Documentation/CodingStyle ;)

Oleg.

