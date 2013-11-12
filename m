Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3KLVa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:30:27 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44947 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3KLVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:30:24 -0500
Date: Tue, 12 Nov 2013 13:30:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131112213019.GS4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
 <20131112182617.GG21461@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112182617.GG21461@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111221-6688-0000-0000-0000036C04FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:26:17PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 06:00:26PM +0000, Luck, Tony wrote:
> > > Does Itanium permit speculative stores?  For example, on Itanium what are
> > > the permitted outcomes of the following litmus test, where both x and y
> > > are initially zero?
> > 
> > We have a complier visible speculative read via the "ld.s" and "chk" instructions. But
> > there is no speculative write ("st.s") instruction.  I think you are asking "can out of order
> > writes become visible in this scenario?"
> > 
> > 	CPU 0				CPU 1
> > 
> > 	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
> > 	if (r1)				if (r2)
> > 		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;
> > 
> > > In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> > > given this litmus test?
> > 
> > The "ACCESS_ONCE" macro casts to volatile - which will make gcc generate
> > ordered "ld.acq" and "st.rel" instructions for your code snippets. So I think
> > you should be fine.
> 
> Cute that volatile generates barrier instructions.
> 
> But no; I think Paul accidentally formulated his question in C (since we
> all speak C) but meant to ask an architectural question.

I got both answers, so I am good.  ;-)

> So the point we're having a discussion on is if any architecture has
> visible speculative STORES and if there's an architecture that doesn't
> have control dependencies.
> 
> On the visible speculative STORES; can, if in the above example we have
> regular loads/stores:
> 
>   LOAD r1, x			LOAD r2, y
>   IF (r1)			IF (r2)
> 	STORE y, 1			STORE x, 1
> 
> we observe: r1==1 && r2==1
> 
> In order for that to be true; we must be able to observe the stores
> before the loads are complete -- and therefore before the branches are a
> certainty.
> 
> Typically if an architecture speculates on branches the result doesn't
> become visible/committed until the branch is a certainty -- ie. linear
> branch history.
> 
> Alternatively:
> 
> 	x:=0
> 
> 	IF (cond)			LOAD r1,x
> 		STORE x,1
> 	STORE x,2
> 
> Can r1 ever be 1 if we know 'cond' will never be true (runtime
> constraint, not compile time so the branch cannot be omitted).

I would have been OK mandating use of ACCESS_ONCE() to prevent speculative
stores, but it is even nicer that it is not necessary.

							Thanx, Paul

