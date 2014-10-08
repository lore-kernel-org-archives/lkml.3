Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbaJHMKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:10:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37282 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbaJHMKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:10:47 -0400
Date: Wed, 8 Oct 2014 13:10:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/11] perf/x86/intel: Support task events with Intel CQM
Message-ID: <20141008121044.GS14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-11-git-send-email-matt@console-pimps.org>
 <20141008110743.GF4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008110743.GF4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 01:07:43PM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:14PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > Add support for task events as well as system-wide events. This change
> > has a big impact on the way that we gather LLC occupancy values in
> > intel_cqm_event_read().
> > 
> > Currently, for system-wide (per-cpu) events we defer processing to
> > userspace which knows how to discard all but one cpu result per package.
> > 
> > Things aren't so simple for task events because we need to do the value
> > aggregation ourselves. To do this, we defer updating the LLC occupancy
> > value in event->count from intel_cqm_event_read() and do an SMP
> > cross-call to read values for all packages in intel_cqm_event_count().
> > We need to ensure that we only do this for one task event per cache
> > group, otherwise we'll report duplicate values.
> > 
> > If we're a system-wide event we want to fallback to the default
> > perf_event_count() implementation. Refactor this into a common function
> > so that we don't duplicate the code.
> 
> So it looks like these events will be classified as regular HW events,
> this means they'll be mixed with the other HW events, and we'll stop
> scheduling the moment either one returns a fail.
> 
> There are two alternatives;
>  1) create an extra task context to keep them in
>  2) pretend to be a software event and do the scheduling yourself
> 
> I think my initial proposal was 2, can you clarify why you've changed
> that? Lemme go read the next patch though, maybe that'll clarify things
> further.

Ah, interesting.

I dropped the internal scheduling because I preferred the idea of
"failing fast", in the sense that if we can't schedule multiple events
simultaneously because they conflict, we should report that to the user
at event init time, rather than trying to manage the conflict ourselves,
with the resultant loss of accuracy.

But I wasn't aware of the issue you've brought up, and it sounds like we
need to do the scheduling anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
