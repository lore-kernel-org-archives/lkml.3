Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3EJL3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:29:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58615
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab3EJL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:29:41 -0400
Date: Fri, 10 May 2013 13:27:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510112756.GH31235@dyad.programming.kicks-ass.net>
References: <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
 <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
 <20130510105536.GA18805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510105536.GA18805@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:55:36PM +0200, Ingo Molnar wrote:
> Look at the tools/perf/ patches, they don't actually need or use that 
> information to adjust for skid!
> 
> If user-space wants _that_ level of control because it wants to correct 
> for skid (if there's skid), or if it wants to display to the user how 
> precise the profiling is, then they can do the (much) more complex probing 
> dance.
> 
> What is absolutely indefensible is to not give a good shortcut for the 
> most common case of 'give me the most precise cycles event you got'...

That's not what I'm saying... the user (not userspace, but you and me) when
staring at perf output need to interpret the result.

If you don't know WTF the thing actually measured, how are you going to do
that?

> > I see such a feature only causing confusion; I told it to be precise, 
> > therefore this register op after the memory load really is the more 
> > expensive thing.
> 
> You are creating confusion where there's none: "give me the best profiling 
> you've got" is a pretty reasonable thing to ask.

Only if it then tells you what you got. It doesn't do that.

> The thing is, there's variations in the quality of profiling between CPUs, 
> sometimes even between CPU models. 99.999% of the people don't care about 
> that, because 99.9% of the time the profile is unambiguous: functions are 
> typically big enough, with the overhead somewhere in the middle, so skid 
> just doesn't matter.

Sure at function level it doesn't matter, but once you found your most
expensive function very often the next question is _why_ is it expensive.

At that point you're going to stare at asm output. The moment you do that you
need to know the type of output you're staring at.

Also, if you think function level output is the most relevant one, you
shouldn't use PEBS at all. PEBS has an issue with REP prefixes, it severely
under accounts the cycles spend on them. And since exact placement doesn't
matter (as you just argued) the little skid you have is irrelevant.

So either skid matters and you need to know what type of output you've got, or
it doesn't and the whole precise thing is irrelevant at best.
