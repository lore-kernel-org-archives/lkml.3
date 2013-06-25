Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3FYUtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3FYUtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:49:10 -0400
Date: Tue, 25 Jun 2013 22:44:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: eventpoll: set ->saved_sigmask at the
	start
Message-ID: <20130625204447.GA17001@redhat.com>
References: <20130625195738.GA15231@redhat.com> <20130625195759.GA15252@redhat.com> <20130625202343.GA4165@ZenIV.linux.org.uk> <20130625203245.GA16451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625203245.GA16451@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Oleg Nesterov wrote:
>
> On 06/25, Al Viro wrote:
> >
> > On Tue, Jun 25, 2013 at 09:57:59PM +0200, Oleg Nesterov wrote:
> > > +		if (error == -EINTR)
> > >  			set_restore_sigmask();
> > > -		} else
> > > -			set_current_blocked(&sigsaved);
> > > +		else
> > > +			__set_current_blocked(&current->saved_sigmask);
> >
> > I don't like that.  If anything, we have
> > static inline void restore_saved_sigmask(void)
> > {
> >         if (test_and_clear_restore_sigmask())
> >                 __set_current_blocked(&current->saved_sigmask);
> > }
> > which means that the last part can be turned into
> > 		set_restore_sigmask();
> > 		if (error != -EINTR)
> > 			restore_saved_sigmask();
>
> set_restore_sigmask() does WARN_ON(!TIF_SIGPENDING).

But if we remove this WARN_ON() we can probably change
set_restore_sigmask() to set TS_RESTORE_SIGMASK and
do saved_mask = blocked.

Perhaps it can even acccept "sigset_t *newmask" and do
set_current_blocked().

Then we can move it up and change the code above to simply as you
suggested. But imho this needs a separate change.

Oleg.

