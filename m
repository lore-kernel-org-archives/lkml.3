Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3IWRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:25:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55660 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3IWRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:25:28 -0400
Date: Mon, 23 Sep 2013 19:24:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130923172458.GE9326@twins.programming.kicks-ass.net>
References: <CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
 <20130910142942.GB8388@gmail.com>
 <CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
 <20130910171449.GA10812@gmail.com>
 <CAMsRxfKdpK7Mmt=BSPnGCGGERTFbqTG0qe_cFDTvxsdLCO-A9g@mail.gmail.com>
 <20130916154146.GA6470@gmail.com>
 <20130916162926.GA12926@twins.programming.kicks-ass.net>
 <CAMsRxfKyXnep+uAyJcjy0SKVQkA6M-QCogVYnq4+PrCtw8B20Q@mail.gmail.com>
 <20130923153357.GB9326@twins.programming.kicks-ass.net>
 <CAMsRxfJxbnoFFkwCc3geOb579UpSaVxLc-Cp7mQES250daci-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfJxbnoFFkwCc3geOb579UpSaVxLc-Cp7mQES250daci-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 07:11:21PM +0200, Stephane Eranian wrote:
> Ok so what you are saying is that the ovfl_status is not maintained private
> to each counter but shared among all PEBS counters by ucode. That's
> how you end up leaking between counters like that.

I only remember asking for clarification because the SDM isn't clear on
this subject; the answer was that it simply copies whatever is in
MSR_CORE_PERF_GLOBAL_STATUS.

I explained how this would be a problem and it was agreed this needed
fixing -- not sure if that ever happened.

> But the other thing I remember is that if two PEBS events overflow
> at the same time, PEBS only write one record with 2 bits set  in the
> ovfl_status field. No point in creating two because the machine state
> will be the same for both. The kernel would just need to dispatch the
> same PEBS record to all the events that overflowed.

Hurm.. that makes life more interesting still. The current code only
delivers the event to the first bit set. Changing this would be simple
though.

> Now, your case appears like that, except this is not what happened.
> So you're misled to believe both counter overflowed at the same time
> when they did not in reality.
> 
> I'd like to have a test case where I could reproduce this.

Agreed, I've never tried to actually reproduce this. I suppose it would
be easiest to trigger where the one event is very rare and controlled.
