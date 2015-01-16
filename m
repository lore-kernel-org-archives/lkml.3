Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbbAPMtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:49:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:44364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbbAPMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:49:47 -0500
Date: Fri, 16 Jan 2015 13:49:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: drop module reference on event init failure
Message-ID: <20150116124942.GX23965@worktop.programming.kicks-ass.net>
References: <1420642611-22667-1-git-send-email-mark.rutland@arm.com>
 <20150116122603.GJ21809@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116122603.GJ21809@leverpostej>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:26:03PM +0000, Mark Rutland wrote:
> On Wed, Jan 07, 2015 at 02:56:51PM +0000, Mark Rutland wrote:
> > When initialising an event, perf_init_event will call try_module_get to
> > ensure that the PMU's module cannot be removed for the lifetime of the
> > event, with __free_event dropping the reference when the event is
> > finally destroyed. If something fails after the event has been
> > initialised, but before the event is installed, perf_event_alloc will
> > drop the reference on the module.
> > 
> > However, if we fail to initialise an event for some reason (e.g. we ask
> > an uncore PMU to perform sampling, and it refuses to initialise the
> > event), we do not drop the refcount. If we try to open such a bogus
> > event without a precise IDR type, we will loop over each PMU in the pmus
> > list, incrementing each of their refcounts without decrementing them.
> > 
> > This patch adds a module_put when pmu->event_init(event) fails, ensuring
> > that the refcounts are balanced in failure cases. As the innards of the
> > precise and search based initialisation look very similar, this logic is
> > hoisted out into a new helper function. While the early return for the
> > failed try_module_get is removed from the search case, this is handled
> > by the remaining return when ret is not -ENOENT.
> 
> I hate to ping, but is anyone going to look at this?
> 

Thanks for reminding me; the inbox is still a horrid mess.

Looks good, thanks!
