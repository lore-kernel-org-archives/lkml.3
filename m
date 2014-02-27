Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaB0UxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:53:18 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35400 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaB0UxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:53:17 -0500
Date: Thu, 27 Feb 2014 12:53:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140227205312.GX8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <1393515453.28840.9961.camel@triegel.csb>
 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
 <20140227190611.GU8264@linux.vnet.ibm.com>
 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022720-9332-0000-0000-0000033F2DFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:47:08AM -0800, Linus Torvalds wrote:
> On Thu, Feb 27, 2014 at 11:06 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > 3.      The comparison was against another RCU-protected pointer,
> >         where that other pointer was properly fetched using one
> >         of the RCU primitives.  Here it doesn't matter which pointer
> >         you use.  At least as long as the rcu_assign_pointer() for
> >         that other pointer happened after the last update to the
> >         pointed-to structure.
> >
> > I am a bit nervous about #3.  Any thoughts on it?
> 
> I think that it might be worth pointing out as an example, and saying
> that code like
> 
>    p = atomic_read(consume);
>    X;
>    q = atomic_read(consume);
>    Y;
>    if (p == q)
>         data = p->val;
> 
> then the access of "p->val" is constrained to be data-dependent on
> *either* p or q, but you can't really tell which, since the compiler
> can decide that the values are interchangeable.
> 
> I cannot for the life of me come up with a situation where this would
> matter, though. If "X" contains a fence, then that fence will be a
> stronger ordering than anything the consume through "p" would
> guarantee anyway. And if "X" does *not* contain a fence, then the
> atomic reads of p and q are unordered *anyway*, so then whether the
> ordering to the access through "p" is through p or q is kind of
> irrelevant. No?

I can make a contrived litmus test for it, but you are right, the only
time you can see it happen is when X has no barriers, in which case
you don't have any ordering anyway -- both the compiler and the CPU can
reorder the loads into p and q, and the read from p->val can, as you say,
come from either pointer.

For whatever it is worth, hear is the litmus test:

T1:	p = kmalloc(...);
	if (p == NULL)
		deal_with_it();
	p->a = 42;  /* Each field in its own cache line. */
	p->b = 43;
	p->c = 44;
	atomic_store_explicit(&gp1, p, memory_order_release);
	p->b = 143;
	p->c = 144;
	atomic_store_explicit(&gp2, p, memory_order_release);

T2:	p = atomic_load_explicit(&gp2, memory_order_consume);
	r1 = p->b;  /* Guaranteed to get 143. */
	q = atomic_load_explicit(&gp1, memory_order_consume);
	if (p == q) {
		/* The compiler decides that q->c is same as p->c. */
		r2 = p->c; /* Could get 44 on weakly order system. */
	}

The loads from gp1 and gp2 are, as you say, unordered, so you get what
you get.

And publishing a structure via one RCU-protected pointer, updating it,
then publishing it via another pointer seems to me to be asking for
trouble anyway.  If you really want to do something like that and still
see consistency across all the fields in the structure, please put a lock
in the structure and use it to guard updates and accesses to those fields.

							Thanx, Paul

