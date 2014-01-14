Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaANK5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:57:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaANK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:57:30 -0500
Date: Tue, 14 Jan 2014 11:57:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Will Deacon <will.deacon@arm.com>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140114105721.GU7572@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
 <20140108225315.GG31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
 <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu>
 <20140110094056.GK31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:55:17PM -0500, Vince Weaver wrote:
> On Fri, 10 Jan 2014, Peter Zijlstra wrote:
> 
> > On Thu, Jan 09, 2014 at 11:08:47PM -0500, Vince Weaver wrote:
> > > On Thu, 9 Jan 2014, Will Deacon wrote:
> > > 
> > > > I'd rather see it in the generic code if at all possible. Maybe we could add
> > > > a flags field to perf_pmu_register?
> > > 
> > > I can look into adding the check in generic code.
> > 
> > Adding something like this to the generic code would mean adding a
> > struct pmu capabilities field and visiting all existing PMU
> > implementations to properly fill this out.
> 
> I don't see an existing pmu capabilities struct... or do you mean
> coming up with one?

Yeah, adding one.

> Would it only hold an "overflow_interrupt_available" flag, or are
> there other generic capabilities it would be handy to know about?

Possible (other) flags could be:

  PMU_HAS_INT      -- would allow sampling events
  PMU_HAS_PRECISE  -- would allow any ::precise value
  PMU_HAS_FILTER   -- would allow all os/user/etc. flags

> > There's a number of hardware PMU implementations that do not have an
> > interrupt and would need to set this flag.
> 
> Well that can be added gradually, right?  Things wouldn't get any worse if 
> we add a generic check without auditing all code, things will just behave 
> the same as before for those architectures.

Right, doing a sweep once every so often is useful to find more patterns
though.

> There is some subtlety here though.  On ARM (or at least rasp-pi) the 
> overflow hardware is there, just no interrupt is hooked up.  So things 
> like counter overflow are handled as long as overflows aren't faster than 
> context switch time.  It's just sampled events aren't possible.
> 
> On architectures without overflow support at all (I've had such hardware; 
> some SPARC machines, the Playstation 3 hypervisor) then counter overflow 
> isn't possible without a periodic timer (sort of like what is done with 
> Intel uncore).  Is that something that should be in generic code too?

Maybe yeah, if there's enough replication of this it certainly makes
sense to lift it into generic code.
