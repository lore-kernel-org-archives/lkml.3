Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaCDTAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:00:42 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59140 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaCDTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:00:38 -0500
Date: Tue, 4 Mar 2014 11:00:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140304190032.GY11910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <1393515453.28840.9961.camel@triegel.csb>
 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
 <20140227190611.GU8264@linux.vnet.ibm.com>
 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
 <20140227205312.GX8264@linux.vnet.ibm.com>
 <20140301005047.GA14777@linux.vnet.ibm.com>
 <1393872908.28840.11660.camel@triegel.csb>
 <20140303192026.GO11910@linux.vnet.ibm.com>
 <1393879579.28840.11949.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393879579.28840.11949.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030419-8236-0000-0000-0000006E7117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 09:46:19PM +0100, Torvald Riegel wrote:
> xagsmtp2.20140303204700.3556@vmsdvma.vnet.ibm.com
> X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGSMTP2 at VMSDVMA)
> 
> On Mon, 2014-03-03 at 11:20 -0800, Paul E. McKenney wrote:
> > On Mon, Mar 03, 2014 at 07:55:08PM +0100, Torvald Riegel wrote:
> > > xagsmtp2.20140303190831.9500@uk1vsc.vnet.ibm.com
> > > X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP2 at UK1VSC)
> > > 
> > > On Fri, 2014-02-28 at 16:50 -0800, Paul E. McKenney wrote:
> > > > +o	Do not use the results from the boolean "&&" and "||" when
> > > > +	dereferencing.	For example, the following (rather improbable)
> > > > +	code is buggy:
> > > > +
> > > > +		int a[2];
> > > > +		int index;
> > > > +		int force_zero_index = 1;
> > > > +
> > > > +		...
> > > > +
> > > > +		r1 = rcu_dereference(i1)
> > > > +		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
> > > > +
> > > > +	The reason this is buggy is that "&&" and "||" are often compiled
> > > > +	using branches.  While weak-memory machines such as ARM or PowerPC
> > > > +	do order stores after such branches, they can speculate loads,
> > > > +	which can result in misordering bugs.
> > > > +
> > > > +o	Do not use the results from relational operators ("==", "!=",
> > > > +	">", ">=", "<", or "<=") when dereferencing.  For example,
> > > > +	the following (quite strange) code is buggy:
> > > > +
> > > > +		int a[2];
> > > > +		int index;
> > > > +		int flip_index = 0;
> > > > +
> > > > +		...
> > > > +
> > > > +		r1 = rcu_dereference(i1)
> > > > +		r2 = a[r1 != flip_index];  /* BUGGY!!! */
> > > > +
> > > > +	As before, the reason this is buggy is that relational operators
> > > > +	are often compiled using branches.  And as before, although
> > > > +	weak-memory machines such as ARM or PowerPC do order stores
> > > > +	after such branches, but can speculate loads, which can again
> > > > +	result in misordering bugs.
> > > 
> > > Those two would be allowed by the wording I have recently proposed,
> > > AFAICS.  r1 != flip_index would result in two possible values (unless
> > > there are further constraints due to the type of r1 and the values that
> > > flip_index can have).
> > 
> > And I am OK with the value_dep_preserving type providing more/better
> > guarantees than we get by default from current compilers.
> > 
> > One question, though.  Suppose that the code did not want a value
> > dependency to be tracked through a comparison operator.  What does
> > the developer do in that case?  (The reason I ask is that I have
> > not yet found a use case in the Linux kernel that expects a value
> > dependency to be tracked through a comparison.)
> 
> Hmm.  I suppose use an explicit cast to non-vdp before or after the
> comparison?

That should work well assuming that things like "if", "while", and "?:"
conditions are happy to take a vdp.  This assumes that p->a only returns
vdp if field "a" is declared vdp, otherwise we have vdps running wild
through the program.  ;-)

The other thing that can happen is that a vdp can get handed off to
another synchronization mechanism, for example, to reference counting:

	p = atomic_load_explicit(&gp, memory_order_consume);
	if (do_something_with(p->a)) {
		/* fast path protected by RCU. */
		return 0;
	}
	if (atomic_inc_not_zero(&p->refcnt) {
		/* slow path protected by reference counting. */
		return do_something_else_with((struct foo *)p);  /* CHANGE */
	}
	/* Needed slow path, but raced with deletion. */
	return -EAGAIN;

I am guessing that the cast ends the vdp.  Is that the case?

							Thanx, Paul

