Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbbAWPHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:07:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbbAWPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:07:29 -0500
Date: Fri, 23 Jan 2015 16:07:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/3] perf: Tighten (and fix) the grouping condition
Message-ID: <20150123150716.GN2896@worktop.programming.kicks-ass.net>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.090683288@infradead.org>
 <20150123150211.GA6091@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123150211.GA6091@leverpostej>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:02:12PM +0000, Mark Rutland wrote:
> On Fri, Jan 23, 2015 at 12:52:00PM +0000, Peter Zijlstra wrote:
> > The fix from 9fc81d87420d ("perf: Fix events installation during
> > moving group") was incomplete in that it failed to recognise that
> > creating a group with events for different CPUs is semantically
> > broken -- they cannot be co-scheduled.
> > 
> > Furthermore, it leads to real breakage where, when we create an event
> > for CPU Y and then migrate it to form a group on CPU X, the code gets
> > confused where the counter is programmed -- triggered by the fuzzer.
> > 
> > Fix this by tightening the rules for creating groups. Only allow
> > grouping of counters that can be co-scheduled in the same context.
> > This means for the same task and/or the same cpu.
> 
> It seems this would still allow you to group CPU-affine software and
> uncore events, which also doesn't make sense: the software events will
> count on a single CPU while the uncore events aren't really CPU-affine.
> 
> Which isn't anything against this patch, but probably something we
> should tighten up too.

Indeed, that would need a wee bit of extra infrastructure though; as we
cannot currently distinguish between regular cpuctx and uncore like
things.

Good spotting though.
