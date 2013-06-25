Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3FYUXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:23:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46779 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3FYUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:23:46 -0400
Date: Tue, 25 Jun 2013 21:23:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: eventpoll: set ->saved_sigmask at the start
Message-ID: <20130625202343.GA4165@ZenIV.linux.org.uk>
References: <20130625195738.GA15231@redhat.com>
 <20130625195759.GA15252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625195759.GA15252@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 09:57:59PM +0200, Oleg Nesterov wrote:
> +		current->saved_sigmask = current->blocked;
>  		set_current_blocked(&ksigmask);
>  	}
>  
>  	error = sys_epoll_wait(epfd, events, maxevents, timeout);
> -
>  	/*
>  	 * If we changed the signal mask, we need to restore the original one.
>  	 * In case we've got a signal while waiting, we do not restore the
> @@ -1988,12 +1988,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>  	 * the way back to userspace, before the signal mask is restored.
>  	 */
>  	if (sigmask) {
> -		if (error == -EINTR) {
> -			memcpy(&current->saved_sigmask, &sigsaved,
> -			       sizeof(sigsaved));
> +		if (error == -EINTR)
>  			set_restore_sigmask();
> -		} else
> -			set_current_blocked(&sigsaved);
> +		else
> +			__set_current_blocked(&current->saved_sigmask);

I don't like that.  If anything, we have
static inline void restore_saved_sigmask(void)
{
        if (test_and_clear_restore_sigmask())
                __set_current_blocked(&current->saved_sigmask);
}
which means that the last part can be turned into
		set_restore_sigmask();
		if (error != -EINTR)
			restore_saved_sigmask();
and I'd pulled set_restore_sigmask() call next to setting the sucker.
