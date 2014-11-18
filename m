Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaKRV0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:26:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKRV0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:26:02 -0500
Date: Tue, 18 Nov 2014 16:25:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118212553.GX108701@redhat.com>
References: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <CA+55aFxttmjXJX4wtwSpTOdDCMwpSopAsL3MJ1n8mJSJOEpyhQ@mail.gmail.com>
 <alpine.DEB.2.11.1411182023360.3909@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411182023360.3909@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 08:28:01PM +0100, Thomas Gleixner wrote:
> On Tue, 18 Nov 2014, Linus Torvalds wrote:
> > On Tue, Nov 18, 2014 at 6:52 AM, Dave Jones <davej@redhat.com> wrote:
> > >
> > > Here's the first hit. Curiously, one cpu is missing.
> > 
> > That might be the CPU3 that isn't responding to IPIs due to some bug..
> > 
> > > NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c180:17837]
> > > RIP: 0010:[<ffffffffa91a0db0>]  [<ffffffffa91a0db0>] bad_range+0x0/0x90
> > 
> > Hmm. Something looping in the page allocator? Not waiting for a lock,
> > but livelocked? I'm not seeing anything here that should trigger the
> > NMI watchdog at all.
> > 
> > Can the NMI watchdog get confused somehow?
> 
> That's the soft lockup detector which runs from the timer interrupt
> not from NMI.
>  
> > So it does look like CPU3 is the problem, but sadly, CPU3 is
> > apparently not listening, and doesn't even react to the NMI, much less
> 
> As I said in the other mail. It gets the NMI and reacts on it. It's
> just mangled into the CPU0 backtrace. 

I was going to reply about both points too. :-)  Though the mangling looks
odd because we have spin_locks serializing the output for each cpu.

Another thing I wanted to ask DaveJ, did you recently turn on
CONFIG_PREEMPT?  That would explain why you are seeing the softlockups
now.  If you disable CONFIG_PREEMPT does the softlockups disappear.

Cheers,
Don
