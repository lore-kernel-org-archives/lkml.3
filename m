Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3KLS0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:26:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3KLS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:26:32 -0500
Date: Tue, 12 Nov 2013 19:26:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131112182617.GG21461@twins.programming.kicks-ass.net>
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:00:26PM +0000, Luck, Tony wrote:
> > Does Itanium permit speculative stores?  For example, on Itanium what are
> > the permitted outcomes of the following litmus test, where both x and y
> > are initially zero?
> 
> We have a complier visible speculative read via the "ld.s" and "chk" instructions. But
> there is no speculative write ("st.s") instruction.  I think you are asking "can out of order
> writes become visible in this scenario?"
> 
> 	CPU 0				CPU 1
> 
> 	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
> 	if (r1)				if (r2)
> 		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;
> 
> > In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> > given this litmus test?
> 
> The "ACCESS_ONCE" macro casts to volatile - which will make gcc generate
> ordered "ld.acq" and "st.rel" instructions for your code snippets. So I think
> you should be fine.

Cute that volatile generates barrier instructions.

But no; I think Paul accidentally formulated his question in C (since we
all speak C) but meant to ask an architectural question.

So the point we're having a discussion on is if any architecture has
visible speculative STORES and if there's an architecture that doesn't
have control dependencies.

On the visible speculative STORES; can, if in the above example we have
regular loads/stores:

  LOAD r1, x			LOAD r2, y
  IF (r1)			IF (r2)
	STORE y, 1			STORE x, 1

we observe: r1==1 && r2==1

In order for that to be true; we must be able to observe the stores
before the loads are complete -- and therefore before the branches are a
certainty.

Typically if an architecture speculates on branches the result doesn't
become visible/committed until the branch is a certainty -- ie. linear
branch history.

Alternatively:

	x:=0

	IF (cond)			LOAD r1,x
		STORE x,1
	STORE x,2

Can r1 ever be 1 if we know 'cond' will never be true (runtime
constraint, not compile time so the branch cannot be omitted).
