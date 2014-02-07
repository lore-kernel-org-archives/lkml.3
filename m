Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBGJOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaBGJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:14:18 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140207040628.GK4250@linux.vnet.ibm.com>
References: <20140206134825.305510953@infradead.org>
	 <21984.1391711149@warthog.procyon.org.uk> <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <1391720965.23421.3884.camel@triegel.csb>
	 <20140206215521.GI4250@linux.vnet.ibm.com>
	 <1391727502.23421.4017.camel@triegel.csb>
	 <20140207040628.GK4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Feb 2014 10:13:40 +0100
Message-ID: <1391764420.23421.4226.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 20:06 -0800, Paul E. McKenney wrote:
> On Thu, Feb 06, 2014 at 11:58:22PM +0100, Torvald Riegel wrote:
> > On Thu, 2014-02-06 at 13:55 -0800, Paul E. McKenney wrote:
> > > On Thu, Feb 06, 2014 at 10:09:25PM +0100, Torvald Riegel wrote:
> > > > On Thu, 2014-02-06 at 18:59 +0000, Will Deacon wrote:
> > > > > To answer that question, you need to go and look at the definitions of
> > > > > synchronises-with, happens-before, dependency_ordered_before and a whole
> > > > > pile of vaguely written waffle to realise that you don't know.
> > > > 
> > > > Are you familiar with the formalization of the C11/C++11 model by Batty
> > > > et al.?
> > > > http://www.cl.cam.ac.uk/~mjb220/popl085ap-sewell.pdf
> > > > http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> > > > 
> > > > They also have a nice tool that can run condensed examples and show you
> > > > all allowed (and forbidden) executions (it runs in the browser, so is
> > > > slow for larger examples), including nice annotated graphs for those:
> > > > http://svr-pes20-cppmem.cl.cam.ac.uk/cppmem/
> > > > 
> > > > It requires somewhat special syntax, but the following, which should be
> > > > equivalent to your example above, runs just fine:
> > > > 
> > > > int main() {
> > > >   atomic_int foo = 0; 
> > > >   atomic_int bar = 0; 
> > > >   atomic_int baz = 0; 
> > > >   {{{ {
> > > >         foo.store(42, memory_order_relaxed);
> > > >         bar.store(1, memory_order_seq_cst);
> > > >         baz.store(42, memory_order_relaxed);
> > > >       }
> > > >   ||| {
> > > >         r1=baz.load(memory_order_seq_cst).readsvalue(42);
> > > >         r2=foo.load(memory_order_seq_cst).readsvalue(0);
> > > >       }
> > > >   }}};
> > > >   return 0; }
> > > > 
> > > > That yields 3 consistent executions for me, and likewise if the last
> > > > readsvalue() is using 42 as argument.
> > > > 
> > > > If you add a "fence(memory_order_seq_cst);" after the store to foo, the
> > > > program can't observe != 42 for foo anymore, because the seq-cst fence
> > > > is adding a synchronizes-with edge via the baz reads-from.
> > > > 
> > > > I think this is a really neat tool, and very helpful to answer such
> > > > questions as in your example.
> > > 
> > > Hmmm...  The tool doesn't seem to like fetch_add().  But let's assume that
> > > your substitution of store() for fetch_add() is correct.  Then this shows
> > > that we cannot substitute fetch_add() for atomic_add_return().
> > 
> > It should be in this example, I believe.
> 
> You lost me on this one.

I mean that in this example, substituting fetch_add() with store()
should not change meaning, given that what the fetch_add reads-from
seems irrelevant.

