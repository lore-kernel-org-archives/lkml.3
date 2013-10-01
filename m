Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JANnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:43:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54575 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3JANm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:42:58 -0400
Date: Tue, 1 Oct 2013 06:42:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
Message-ID: <20131001134251.GA5534@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380581522.6396.20.camel@pasglop>
 <23118.1380587771@ale.ozlabs.ibm.com>
 <CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
 <1380593103.6396.38.camel@pasglop>
 <20131001031356.GP19582@linux.vnet.ibm.com>
 <CAEjGV6xuscOh=t6BhbdRKAPcZ1DOJkD6ZcB1wgTf9-AedKSaxA@mail.gmail.com>
 <20131001121654.GX19582@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001121654.GX19582@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100113-1542-0000-0000-000001E69C93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:16:54AM -0700, Paul E. McKenney wrote:
> On Tue, Oct 01, 2013 at 02:52:28PM +1000, Michael Neuling wrote:
> > >> Well we don't have to, I think Mikey wasn't totally clear about that
> > >> "making all registers volatile" business :-) This is just something we
> > >> need to handle in assembly if we are going to reclaim the suspended
> > >> transaction.
> > 
> > Yeah, sorry.  The slow path with all registers as volatile is only
> > needed if we get pre-empted during the transaction.
> > 
> > >>
> > >> So basically, what we need is something along the lines of
> > >> enable_kernel_tm() which checks if there's a suspended user transaction
> > >> and if yes, kills/reclaims it.
> > >>
> > >> Then we also need to handle in our interrupt handlers that we have an
> > >> active/suspended transaction from a kernel state, which we don't deal
> > >> with at this point, and do whatever has to be done to kill it... we
> > >> might get away with something simple if we can state that we only allow
> > >> kernel transactions at task level and not from interrupt/softirq
> > >> contexts, at least initially.
> > >
> > > Call me a coward, but this is starting to sound a bit scary.  ;-)
> > 
> > We are just wanting to prototype it for now to see if we could make it
> > go faster.  If it's worth it, then we'd consider the additional
> > complexity this would bring.
> > 
> > I don't think it'll be that bad, but I'd certainly want to make sure
> > it's worth it before trying :-)
> 
> OK, fair point.  ;-)

That is, a fair point -assuming- that we also try the memory-barrier-free
cmpxchg that Linus suggested...

							Thanx, Paul

