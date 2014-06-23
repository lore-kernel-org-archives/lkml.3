Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaFWInI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:43:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaFWInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:43:04 -0400
Date: Mon, 23 Jun 2014 10:42:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jmario@redhat.com, dzickus@redhat.com, jolsa@redhat.com,
        acme@redhat.com
Subject: Re: [PATCH 2/2] perf/x86: fix constraints for load latency and
 precise events
Message-ID: <20140623084254.GK19860@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403193509-22393-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-MIME-Error: demime acl condition: uuencoded line length is not a multiple of 4 characters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:58:29PM +0200, Stephane Eranian wrote:
> The load latency does not have to be constrained to counter 3
> on any of SNB, IVB, HSW. It operates fine on any PEBS-capable
> counter.
> 
> The precise store event for SNB, IVB needs to be on counter 3.
> But on Haswell, precise store is implemented differently and
> the constraint is not needed anymore, so we remove it.
> 
> The artificial constraint on counter 3 was used to ease
> scheduling because the load latency events rely on an
> extra MSR which is shared for all the counters. But
> perf_events has an infrastructure to handle shared_regs
> and does not need to constrain the load latency event to
> a single counter. It was already using that infrastructure
> with the constraint on counter 3. By eliminating the constraint
> on load latency, it becomes possible to measure loads and stores
> precisely without multiplexing.

So that all makes sense, except why did they pick the same constraint to
begin with? If they'd picked cnt2 for ll and cnt3 (as per the hardware
constraint) for st, this would've already been possible right?

Except of course, that the SDM states that no other PEBS event should be
active when using ll; we don't enforce that (although userspace could
request exclusive). What about this constraint? Is the SDM wrong about
this?
