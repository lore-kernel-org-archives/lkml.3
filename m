Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaDWOQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:16:47 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:48308 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaDWOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:16:45 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 10:16:45 EDT
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.um.maine.edu>
Date: Wed, 23 Apr 2014 10:14:23 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
In-Reply-To: <20140423102254.GL11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404231013380.30238@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu> <20140423102254.GL11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Peter Zijlstra wrote:

> On Tue, Apr 22, 2014 at 11:40:07PM -0400, Vince Weaver wrote:
> > 
> > More fun found by the perf_fuzzer...
> > 
> > In kernel/events/core.c 
> > SYSCALL_DEFINE5(perf_event_open,
> > 
> > We check if flags is valid like this:
> > 
> >         /* for future expandability... */
> >         if (flags & ~PERF_FLAG_ALL)
> >                 return -EINVAL;
> > 
> > but flags is a 64-bit value but ~PERF_FLAG_ALL is 32-bit.
> > 
> > This means values like 0x800000000000ULL are treated as valid even though 
> > they aren't.
> > 
> > This is allowing events to be allocated memory but not being freed somehow
> > before returning EINVAL (a memory leak).
> > At least it looks like this is happening in the huge traces I have trying 
> > to track down the perf_fuzzer memory corruption bug.
> > 
> > I'd send a patch to fix the above, but it's late and I can't figure out 
> > where exactly to stick ULL to get PERF_FLAG_ALL to be upgraded to 64-bit.
> > 
> > Vince
> 
> Something like so should do I suppose.
> 
> ---
> Subject: perf: Fix perf_event_open(.flags) test
> 
> Vince noticed that we test the (unsigned long) flags field against an
> (unsigned int) constant. This would allow setting the high bits on 64bit
> platforms and not get an error.
> 
> There is nothing that uses the high bits, so it should be entirely
> harmless, but we don't want userspace to accidentally set them anyway,
> so fix the constants.

I suppose I should make a patch for attr->sample_type and 
attr->read_format which after a quick audit seem to exhibit the same 
problem?

Vince
