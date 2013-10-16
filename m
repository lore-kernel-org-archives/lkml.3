Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178Ab3JPVDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:03:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761953Ab3JPVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:03:30 -0400
Date: Wed, 16 Oct 2013 23:03:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Don Zickus <dzickus@redhat.com>, dave.hansen@linux.intel.com,
        eranian@google.com, jmario@redhat.com, linux-kernel@vger.kernel.org,
        acme@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131016210319.GI10651@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016205227.GJ7456@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016205227.GJ7456@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 01:52:27PM -0700, Andi Kleen wrote:
> > So avoid having to call copy_from_user_nmi() for every instruction.
> > Since we already limit the max basic block size, we can easily
> > pre-allocate a piece of memory to copy the entire thing into in one
> > go.
> 
> It would be better/more generic if you split copy_from_user_nmi() into
> init() copy() end() 
> 
> (and some state that checks if the underlying page changes)
> 
> Then first you don't need the buffer and it could be also
> be applied to the other cases, like the stack unwinding,
> where copying everything is likely too slow.

You'd need to make an iterator interface because of the kmap_atomic crap
needed for 32bit.

But yes, something like that might work, it shouldn't be that hard to
cobble on top of that GUP patch I send out the other day.

The only real nasty part is where an instruction straddles a page
boundary, in that case the iterator stuff fails to be fully transparant
and you need a temp copy of sorts.

Anyway; if you want to have a go at this, feel free.
