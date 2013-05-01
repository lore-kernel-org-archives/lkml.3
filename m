Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968Ab3EALN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:13:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759557Ab3EALNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:13:52 -0400
Date: Wed, 1 May 2013 13:12:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130501111219.GF28253@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
 <20130501090718.GA28253@dyad.programming.kicks-ass.net>
 <m261z3uipb.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m261z3uipb.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 02:56:32AM -0700, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> >
> > So you're saying that if two SMT siblings count the same MEM_*_RETIRED event
> > (on the same counter?) events can get accounted to the wrong sibling?
> 
> It can happen regardless of what event is enabled on the other counter.

What I was trying to ask is.. where does it leak to. Does it leak to whatever
event the other counter is counting? Or does it explicitly leak to any sibilng
counter also counting MEM_*_RETIRED?

    SMT0   SMT1

C0   MR     MR
C1
C2
C3

So here SMT[01]-C0 will cross count their events.


    SMT0   SMT1

C0   MR     
C1          MR
C2
C3

Will they too here?


    SMT0   SMT1

C0   MR     Cycles
C1
C2
C3

What about here?


So again; do they specifically leak between the same counters of siblings or
between the same events of siblings. Your initial explanation wasn't clear on
when and where exactly the leak happens.


> > This begs the question what happens when the sibling does have the (same?)
> > counter enabled but counting an all together different event; do we then still
> > 'loose' events from the one sibling and add then to the other counter?
> 
> Yes, that is what the patch fixes.

Well, it very much depends on the above answer; if case-3 leaks samples from
SMT0-C0 to SMT1-C0 then the patch doesn't fix anything as the SMT1-C0 event
(cycles) doesn't bother with the shared register.


