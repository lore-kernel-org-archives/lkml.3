Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3KDKxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:53:01 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57950 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab3KDKxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:53:00 -0500
Date: Mon, 4 Nov 2013 02:52:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131104105252.GM3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103170759.GC6871@mudshark.cambridge.arm.com>
 <20131103224712.GH3947@linux.vnet.ibm.com>
 <20131104095717.GB8419@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104095717.GB8419@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110410-0320-0000-0000-0000019CEDE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:57:17AM +0000, Will Deacon wrote:
> Hi Paul,
> 
> On Sun, Nov 03, 2013 at 10:47:12PM +0000, Paul E. McKenney wrote:
> > On Sun, Nov 03, 2013 at 05:07:59PM +0000, Will Deacon wrote:
> > > On Sun, Nov 03, 2013 at 02:40:17PM +0000, Paul E. McKenney wrote:
> > > > On Sat, Nov 02, 2013 at 10:32:39AM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Nov 01, 2013 at 03:56:34PM +0100, Peter Zijlstra wrote:
> > > > > > On Wed, Oct 30, 2013 at 11:40:15PM -0700, Paul E. McKenney wrote:
> > > > > > > > Now the whole crux of the question is if we need barrier A at all, since
> > > > > > > > the STORES issued by the @buf writes are dependent on the ubuf->tail
> > > > > > > > read.
> > > > > > > 
> > > > > > > The dependency you are talking about is via the "if" statement?
> > > > > > > Even C/C++11 is not required to respect control dependencies.
> > > > > > > 
> > > > > > > This one is a bit annoying.  The x86 TSO means that you really only
> > > > > > > need barrier(), ARM (recent ARM, anyway) and Power could use a weaker
> > > > > > > barrier, and so on -- but smp_mb() emits a full barrier.
> > > > > > > 
> > > > > > > Perhaps a new smp_tmb() for TSO semantics, where reads are ordered
> > > > > > > before reads, writes before writes, and reads before writes, but not
> > > > > > > writes before reads?  Another approach would be to define a per-arch
> > > > > > > barrier for this particular case.
> > > > > > 
> > > > > > I suppose we can only introduce new barrier primitives if there's more
> > > > > > than 1 use-case.
> > > 
> > > Which barrier did you have in mind when you refer to `recent ARM' above? It
> > > seems to me like you'd need a combination if dmb ishld and dmb ishst, since
> > > the former doesn't order writes before writes.
> > 
> > I heard a rumor that ARM had recently added a new dmb variant that acted
> > similarly to PowerPC's lwsync, and it was on my list to follow up.
> > 
> > Given your response, I am guessing that there is no truth to this rumor...
> 
> I think you're talking about the -ld option to dmb, which was introduced in
> ARMv8. That option orders loads against loads and stores, but doesn't order
> writes against writes. So you could do:
> 
> 	dmb ishld
> 	dmb ishst
> 
> but it's questionable whether that performs better than a dmb ish.

If Linus's smp_store_with_release_semantics() approach works out, ARM
should be able to use its shiny new ldar and stlr instructions.

							Thanx, Paul

