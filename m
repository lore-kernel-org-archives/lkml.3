Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3KCEFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 00:05:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50593 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3KCEEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 00:04:39 -0400
Date: Sat, 2 Nov 2013 10:32:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131102173239.GB3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101145634.GH19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110304-0928-0000-0000-0000030A8D4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:56:34PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 11:40:15PM -0700, Paul E. McKenney wrote:
> > > Now the whole crux of the question is if we need barrier A at all, since
> > > the STORES issued by the @buf writes are dependent on the ubuf->tail
> > > read.
> > 
> > The dependency you are talking about is via the "if" statement?
> > Even C/C++11 is not required to respect control dependencies.
> > 
> > This one is a bit annoying.  The x86 TSO means that you really only
> > need barrier(), ARM (recent ARM, anyway) and Power could use a weaker
> > barrier, and so on -- but smp_mb() emits a full barrier.
> > 
> > Perhaps a new smp_tmb() for TSO semantics, where reads are ordered
> > before reads, writes before writes, and reads before writes, but not
> > writes before reads?  Another approach would be to define a per-arch
> > barrier for this particular case.
> 
> I suppose we can only introduce new barrier primitives if there's more
> than 1 use-case.

There probably are others.

> > > If the read shows no available space, we simply will not issue those
> > > writes -- therefore we could argue we can avoid the memory barrier.
> > 
> > Proving that means iterating through the permitted combinations of
> > compilers and architectures...  There is always hand-coded assembly
> > language, I suppose.
> 
> I'm starting to think that while the C/C++ language spec says they can
> wreck the world by doing these silly optimization, real world users will
> push back for breaking their existing code.
> 
> I'm fairly sure the GCC people _will_ get shouted at _loudly_ when they
> break the kernel by doing crazy shit like that.
> 
> Given its near impossible to write a correct program in C/C++ and
> tagging the entire kernel with __atomic is equally not going to happen,
> I think we must find a practical solution.
> 
> Either that, or we really need to consider forking the language and
> compiler :-(

Depends on how much benefit the optimizations provide.  If they provide
little or no benefit, I am with you, otherwise we will need to bit some
bullet or another.  Keep in mind that there is a lot of code in the
kernel that runs sequentially (e.g., due to being fully protected by
locks), and aggressive optimizations for that sort of code are harmless.

Can't say I know the answer at the moment, though.

							Thanx, Paul

