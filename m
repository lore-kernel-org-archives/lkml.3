Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936735Ab3DJOJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:09:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936542Ab3DJOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:09:30 -0400
Date: Wed, 10 Apr 2013 09:09:25 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
Message-ID: <20130410140925.GD3672@sgi.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
 <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
 <20130408124223.GA10093@gmail.com>
 <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 07:38:39AM -0700, Linus Torvalds wrote:
> On Mon, Apr 8, 2013 at 5:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > AFAICS the main performance trade-off is the following: when the owner CPU unlocks
> > the mutex, we'll poll it via a read first, which turns the cacheline into
> > shared-read MESI state. Then we notice that its content signals 'lock is
> > available', and we attempt the trylock again.
> >
> > This increases lock latency in the few-contended-tasks case slightly - and we'd
> > like to know by precisely how much, not just for a generic '10-100 users' case
> > which does not tell much about the contention level.
> 
> We had this problem for *some* lock where we used a "read + cmpxchg"
> in the hotpath and it caused us problems due to two cacheline state
> transitions (first to shared, then to exclusive). It was faster to
> just assume it was unlocked and try to do an immediate cmpxchg.
> 
> But iirc it is a non-issue for this case, because this is only about
> the contended slow path.
> 
> I forget where we saw the case where we should *not* read the initial
> value, though. Anybody remember?

I think you might be remembering ia64.  Fairly early on, I recall there
being a change in the spinlocks where we did not check them before just
trying to acquire.

Thanks,
Robin
