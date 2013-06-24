Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3FXHrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:47:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3FXHrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:47:16 -0400
Date: Mon, 24 Jun 2013 09:46:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vincent.weaver@maine.edu,
        jolsa@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH v2] perf,x86: Fix shared register mutual exclusion
 enforcement
Message-ID: <20130624074656.GG28407@twins.programming.kicks-ass.net>
References: <20130620164254.GA3556@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620164254.GA3556@quad>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 06:42:54PM +0200, Stephane Eranian wrote:
> 
> This patch fixes a problem with the shared registers mutual
> exclusion code and incremental event scheduling by the
> generic perf_event code.
> 
> There was a bug whereby the mutual exclusion on the shared
> registers was not enforced because of incremental scheduling
> abort due to event constraints. As an example on Intel
> Nehalem, consider the following events:
> 
> group1= L1D_CACHE_LD:E_STATE,OFFCORE_RESPONSE_0:PF_RFO,L1D_CACHE_LD:I_STATE
> group2= L1D_CACHE_LD:I_STATE
> 
> The L1D_CACHE_LD event can only be measured by 2 counters. Yet, there
> are 3 instances here. The first group can be scheduled and is committed.
> Then, the generic code tries to schedule group2 and this fails (because
> there is no more counter to support the 3rd instance of L1D_CACHE_LD).
> But in x86_schedule_events() error path, put_event_contraints() is invoked
> on ALL the events and not just the ones that just failed. That causes the
> "lock" on the shared offcore_response MSR to be released. Yet the first group
> is actually scheduled and is exposed to reprogramming of that shared msr by
> the sibling HT thread. In other words, there is no guarantee on what is
> measured.
> 
> This patch fixes the problem by tagging committed events with the
> PERF_X86_EVENT_COMMITTED tag. In the error path of x86_schedule_events(),
> only the events NOT tagged have their constraint released. The tag
> is eventually removed when the event in descheduled.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

OK, so I 'accidentally' read the patch again; and noticed something.

In your case above; the get/put constraints are still fully matched.
That is; the first group, which was successful, will not have done a put
yet. So a subsequent get+put should still leave us with a positive 'ref'
count and not undo things.

Only once these events pass through x86_pmu_del() will they get a final
put and the 'ref' count will drop to 0.

Now the problem seems to be the get/put things don't actually count
properly.

However, if we look at __intel_shared_reg_{get,put}_constraints() there
is a refcount in there; namely era->ref; however we don't appear to
clear reg->alloc based on it.

Should we?
