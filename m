Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3FYUii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab3FYUhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:37:08 -0400
Date: Tue, 25 Jun 2013 22:32:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: eventpoll: set ->saved_sigmask at the
	start
Message-ID: <20130625203245.GA16451@redhat.com>
References: <20130625195738.GA15231@redhat.com> <20130625195759.GA15252@redhat.com> <20130625202343.GA4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625202343.GA4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Al Viro wrote:
>
> On Tue, Jun 25, 2013 at 09:57:59PM +0200, Oleg Nesterov wrote:
> > +		current->saved_sigmask = current->blocked;
> >  		set_current_blocked(&ksigmask);
> >  	}
> >  
> >  	error = sys_epoll_wait(epfd, events, maxevents, timeout);
> > -
> >  	/*
> >  	 * If we changed the signal mask, we need to restore the original one.
> >  	 * In case we've got a signal while waiting, we do not restore the
> > @@ -1988,12 +1988,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
> >  	 * the way back to userspace, before the signal mask is restored.
> >  	 */
> >  	if (sigmask) {
> > -		if (error == -EINTR) {
> > -			memcpy(&current->saved_sigmask, &sigsaved,
> > -			       sizeof(sigsaved));
> > +		if (error == -EINTR)
> >  			set_restore_sigmask();
> > -		} else
> > -			set_current_blocked(&sigsaved);
> > +		else
> > +			__set_current_blocked(&current->saved_sigmask);
> 
> I don't like that.  If anything, we have
> static inline void restore_saved_sigmask(void)
> {
>         if (test_and_clear_restore_sigmask())
>                 __set_current_blocked(&current->saved_sigmask);
> }
> which means that the last part can be turned into
> 		set_restore_sigmask();
> 		if (error != -EINTR)
> 			restore_saved_sigmask();

set_restore_sigmask() does WARN_ON(!TIF_SIGPENDING).

> and I'd pulled set_restore_sigmask() call next to setting the sucker.

Sorry, can't understand...

Anyway, I agree we can make this more clean. From 0/2

	Perhaps it also makes sense to add the new helper which does
	copy_from_user + set saved_sigmask + set_current_blocked() ?

and perhaps we can add another helper which does set_restore_sigmask()
_or_ set_current_blocked(saved_sigmask), this can simplify more callers.
I think we can do this on top of this change.

Or I misunderstood and you dislike the very fact we rely on the already
initialized ->saved_sigmask ?

Oleg.

