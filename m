Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbbALWMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:12:48 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49269 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbALWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:12:46 -0500
Date: Mon, 12 Jan 2015 14:12:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
Message-ID: <20150112221232.GG9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150108094102.GD29390@twins.programming.kicks-ass.net>
 <20150108152230.GL5280@linux.vnet.ibm.com>
 <1420785714.25454.1.camel@stgolabs.net>
 <20150109134954.GO5280@linux.vnet.ibm.com>
 <20150109135614.GI29390@twins.programming.kicks-ass.net>
 <54B04F1A.1060401@de.ibm.com>
 <20150112085957.GA25256@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112085957.GA25256@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011222-0009-0000-0000-000007EC9E99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:59:57AM +0100, Peter Zijlstra wrote:
> On Fri, Jan 09, 2015 at 10:58:50PM +0100, Christian Borntraeger wrote:
> > Am 09.01.2015 um 14:56 schrieb Peter Zijlstra:
> > > On Fri, Jan 09, 2015 at 05:49:54AM -0800, Paul E. McKenney wrote:
> > >>> That reminds me, I think the new conversion for stores will most likely
> > >>> introduce silly arg bugs:
> > >>>
> > >>> -       ACCESS_ONCE(a) = b;
> > >>> +       ASSIGN_ONCE(b, a);
> > >>
> > >> I was planning to do mine by hand for this sort of reason.
> > >>
> > >> Or are you thinking of something more subtle than the case where
> > >> "b" is an unparenthesized comma-separated expression?
> > > 
> > > I think he's revering to the wrong way around-ness of the thing.
> > > 
> > > Its a bit of a mixed bag on assignments, but for instance
> > > rcu_assign_pointer() takes them the right way around, as does
> > > atomic_set().
> > > 
> > > So yes, I think the ASSIGN_ONCE() thing got the arguments the wrong way
> > > around.
> > > 
> > > We could maybe still change it, before its in too long ?
> > 
> > Linus initial proposal was inspired by put_user model which is (val,
> > ptr) and I took that. 
> 
> Yeah, like I said, its a bit of a mixed bag. We've got plenty examples
> of the wrong way around.
> 
> > As my focus was on avoiding the volatile bug,
> > all my current conversions are READ_ONCE as no potential ASSIGN_ONCE
> > user was done on a non-scalar type, so I have no first hand
> > experience. 
> 
> So the implication there is that we'd preserve ACCESS_ONCE() for use on
> scalar types. I don't think we should do that, I think we should just
> en-mass convert to {READ,WRITE}/{LOAD,STORE}_ONCE() and kill off
> ACCESS_ONCE().

Yep.  For one thing, the proposed replacements work much better with
C11 than does ACCESS_ONCE().

> > I am fine with changing that, though, both ways have pros
> > and cons. Last time I checked in Linus tree there was no ASSIGN_ONCE
> > user.
> 
> Right, so Davidlohr just introduced a few in my tree :-), which is how I
> came to know we even had this stuff..
> 
> > When we talk about changing the parameters it might make sense to also
> > think about some comments from George Spelvin and consider a rename to
> > WRITE_ONCE or STORE_ONCE (READ_ONCE --> LOAD_ONCE). 
> 
> I'd be OK with that.
> 
> > Unfortunately
> > there doesnt seem to be a variant that is fool proof (in the sense of
> > Rustys guideline that a good interface cannot be used wrong). So any
> > proposal in that regard would be very welcome.
> 
> If you want fool proof, I think we should discard C ;-) Then again, I've
> yet to see a programming language that would not let a human make a
> proper idiot out of himself.

Limit NR_CPUS to zero!  It is the only way!!!

						Thanx, Paul

