Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3LJUdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:33:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:51246 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3LJUdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:33:33 -0500
Date: Tue, 10 Dec 2013 21:33:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312102130580.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Linus Torvalds wrote:

> On Tue, Dec 10, 2013 at 11:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > So this is pretty unlikely. The retry requires:
> >
> >    get_futex_value_locked() == EFAULT;
> >
> > Now we drop the hash bucket locks and do:
> >
> >    get_user();
> >
> > And if that get_user() faults again, we bail out.
> 
> I think you need to look closer.
> 
> We have at least also that "futex_proxy_trylock_atomic() returns
> -EAGAIN" case. Which triggers at some exit condition. Another thread
> in the same group, perhaps never completing the exit because it's
> waiting for this one? I dunno, I didn't look any closer (but this does
> make me think "Hey, we should add Oleg to the Cc too", since
> PF_EXITING is involved).. So maybe there is some situation where that
> EAGAIN will keep happening, forever..
> 
> Now, I'm *not* saying that that is it. It's quite possible/likely some
> other loop, but I do have to say that it sure isn't _obvious_. And
> that whole EAGAIN return case is quite deep and special, so ...

The -EAGAIN is when the user value changed, simplified:

    oldval = *uval;
    sys_futex(....., oldval)
      do_futex(...) {		     
	if (oldval != *uval)
	   return -EAGAIN;
      }
    sys_exit();

And user space loops on that.

Thanks,

	tglx
	
	
