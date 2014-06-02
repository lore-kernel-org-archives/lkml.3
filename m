Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaFBUZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:25:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56146 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaFBUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:25:17 -0400
Message-ID: <1401740685.12939.49.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, chegu_vinod@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Date: Mon, 02 Jun 2014 13:24:45 -0700
In-Reply-To: <20140602200525.GD13930@laptop.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
	 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
	 <538CB56E.5010709@hp.com>
	 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 22:05 +0200, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 01:33:34PM -0400, Waiman Long wrote:
> > On 06/02/2014 12:30 PM, Peter Zijlstra wrote:
> > >On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
> > >>I'm almost inclined to just exclude parisc from using opt spinning.
> > >>
> > >>That said, this patch still doesn't address the far more interesting
> > >>problem of actually finding these issues for these few weird archs.
> > >So why do these archs provide xchg() and cmpxchg() at all? Wouldn't it
> > >be much simpler if archs that cannot sanely do this, not provide these
> > >primitives at all?
> > 
> > I believe xchg() and cmpxchg() are used in quite a number of places within
> > the generic kernel code. So kernel compilation will fail if those APIs
> > aren't provided by an architecture.
> 
> Yep.. so this is going to be painful for a while. But given their
> (parisc, sparc32, metag-lock1) constraints, who knows how many of those
> uses are actually broken.
> 
> So the question is, do you prefer subtly broken code or hard compile
> fails? Me, I go for the compile fail.

The failure is only when a variable that will have an atomic exchange
done on it is updated by a simple operation.  To do this properly, we'd
probably need an update macro we could supply the locking to, and a way
of marking the variable to get the compiler to cause a build error if it
was ever updated improperly, but that's starting to look very similar to
Mikulas' proposal.

James


