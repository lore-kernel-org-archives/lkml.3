Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3LJU2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:28:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3LJU2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:28:52 -0500
Date: Tue, 10 Dec 2013 15:27:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210202752.GA27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
	Oleg Nesterov <oleg@redhat.com>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:55:06AM -0800, Linus Torvalds wrote:
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
 > 
 >                  Linus
 > 
 > PS: Oleg - the whole thread is on lkml. Ping me if you need more context.

btw, I've left the machine in that state, and will for as long as necesary
in case someone has any ideas for further tracing experiments.

	Dave

