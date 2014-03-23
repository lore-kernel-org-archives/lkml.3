Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaCWXho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 19:37:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:59364 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCWXhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 19:37:43 -0400
Date: Mon, 24 Mar 2014 00:37:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julia Lawall <julia.lawall@lip6.fr>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/16] timers: Plug debugobject leaks and use del_timer_sync()
 in exit/teardown
In-Reply-To: <alpine.DEB.2.02.1403232328480.2019@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.02.1403240027020.18573@ionos.tec.linutronix.de>
References: <20140323150557.288925975@linutronix.de> <alpine.DEB.2.02.1403232328480.2019@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2014, Julia Lawall wrote:
> As far as I could tell, (part of) the issue is that any kind of exit or 
> close function should use del_timer_sync, because they could be called 
> from a different CPU than the one that started up the timer?
> 
> Here is a semantic patch that takes care of the case of simple module_exit 
> functions:
> 
> @r@
> declarer name module_exit;
> identifier ex;
> @@
> 
> module_exit(ex);
> 
> @@
> identifier r.ex;
> @@
> 
> ex(...) {
>   <...
> - del_timer
> + del_timer_sync
>     (...)
>   ...>
> }
> 
> The transformations it makes are below.  I haven't had a chance to check 
> which results overlap with what Thomas has already sent, but I could look 

Minimal overlap, but as I said I did just a few conversions.

> into it if this is the right idea.  I guess other kinds of close/exit 
> functions would have to be identified manually, to make more rules.

If you look through the examples I sent, you'll find the close()
callbacks of various devices. So everything which is a function
pointer to a ops->close(), ops->remove(), ops_>teardown() is dangerous
if using del_timer(). There are a few exceptions, but....

Another thing I saw is 

	del_timer(&bla->timer);
	....
	kfree(&bla);

That's also a potential source of trouble. You can't tell without
analyzing the code, whether it's a problem or not. But making the
responsible people to look at it is definitely a good thing.
 
> In what circumstance can one be sure that two instructions are executed on 
> the same CPU?

If interrupts or preemption are disabled. But that's not the issue at
hand.

The del_timer vs. del_timer_sync problem is:

CPU0	      	  		 CPU1

add_timer(&bla->timer);

				 close(bla)
timer expires		   	   del_timer(&bla->timer);
  callback is invoked
				   kfree(bla);
    derefernces bla

I'll look at your findings on Tuesday, but feel free to send them to
the relevant maintainers for review.

Thanks,

	tglx
