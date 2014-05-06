Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaEFXtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:49:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60878 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEFXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:49:32 -0400
Date: Tue, 6 May 2014 18:49:12 -0500
From: David Fries <David@Fries.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] w1: do not unlock unheld list_mutex in
 __w1_remove_master_device()
Message-ID: <20140506234912.GT21508@spacedout.fries.net>
References: <1398890278-15319-1-git-send-email-khoroshilov@ispras.ru>
 <20140501034759.GG5096@spacedout.fries.net>
 <53695734.9040302@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53695734.9040302@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 06 May 2014 18:49:14 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 01:42:12AM +0400, Alexey Khoroshilov wrote:
> On 01.05.2014 07:48, David Fries wrote:
> > On Thu, May 01, 2014 at 12:37:58AM +0400, Alexey Khoroshilov wrote:
> >> w1_process_callbacks() expects to be called with dev->list_mutex held,
> >> but it is the fact only in w1_process(). __w1_remove_master_device()
> >> calls w1_process_callbacks() after it releases list_mutex.
> >>
> >> The patch fixes __w1_remove_master_device() to acquire list_mutex
> >> for w1_process_callbacks(). It is implemented by moving
> >> w1_process_callbacks() functionality to __w1_process_callbacks()
> >> and adding a wrapper with the old name.
> > Good catch.  I guess as it was in the shutdown path it failed the
> > unlock silently.
> >
> > I would prefer a different fix.  If w1_process_callbacks was more of a
> > public facing API called from multiple locations where the caller
> > doesn't have access to the locks, something like this would probably
> > be the way to go.  This is called from two areas of the code, and not
> > likely to be called from any new areas in the future.
> >
> > Adding a documentation comment is good.  I would be tempted in
> > __w1_remove_master_device to move the dev->list_mutex down after the
> > while loop, but I can't be sure that whatever has a refcnt wouldn't
> > need list_mutex.  The last w1_process_callbacks after the while loop
> > shouldn't be needed I wouldn't think, I was just being defensive.
> I do not understand all the details, but I am not sure.
> refcnt can became 0, but that does not mean all callbacks have been
> processed because they can be added before refcnt decrement but after
> previous w1_process_callbacks invocation.
> >   By
> > the time it completes the while loop the reference count is 0 so there
> > shouldn't be anything left for it to process and if there is, it's a
> > race condition and game over anyway.  So just sandwich
> > w1_process_callbacks with the lock/unlock in
> > __w1_remove_master_device please.
> Done.

Thanks for finding and fixing this bug.

> Another suspicious question for me is how safe is it to call
>   wake_up_process(dev->thread);
> after
>   kthread_stop(dev->thread);
> ?

Looks bad, but I would need to convince myself it could actually be a
problem.
int wake_up_process(struct task_struct *p)
{       
        WARN_ON(task_is_stopped_or_traced(p));
        return try_to_wake_up(p, TASK_NORMAL, 0);
}

But I think there are lower hanging fruit, like revisiting all the
locks in all the code and testing with the lock debugging code on and
get it all to pass or document that it really is correct.  Currently
it is detecting a locking order problem, but both code paths can only
be called from the w1_process function, which can only be called by
one thread, and one thread can't dead lock itself with a locking order
problem.

> >> Found by Linux Driver Verification project (linuxtesting.org).
> > Was this found with code inspection or hardware testing with lock
> > debugging enabled?
> It was found by static verification tools developed within Linux Driver
> Verification project.
> 
> 
> Best regards,
> Alexey

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
