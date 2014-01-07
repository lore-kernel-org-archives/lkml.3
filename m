Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaAGBB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:01:26 -0500
Received: from one.firstfloor.org ([193.170.194.197]:33988 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaAGBBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:01:24 -0500
Date: Tue, 7 Jan 2014 02:01:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20140107010123.GA20765@two.firstfloor.org>
References: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106220509.GI30183@twins.programming.kicks-ass.net>
 <20140107005231.GZ20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107005231.GZ20765@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:52:31AM +0100, Andi Kleen wrote:
> > > Also of course it requires disabling/enabling PT explicitly for 
> > > every perf message, which is slow. So you add at least 2*WRMSR cost
> > > (thousands of cycles).
> > 
> > That's just dumb, no flush the entire PT buffer into a few large
> > records.
> 
> How would that work?
> 
> You mean a separate buffer and then copy or map?
> 
> ------
> 
> Also here are some more problems with interleaving: 
> 
> A common PT config is to just run it as a ring buffer in the background
> and only take the data out when something happens (sample, crash etc.)
> 
> But the side band still needs to be logged and at arbitary times.
> 
> So the PT wrapping will happen much more often than the perf wrapping.
> 
> If you interleave you may actually end up with lots of small rings 
> in a single buffer, unless you stop every time the buffer fills up
> (which would add a lot more overhead)
> 
> I suppose it could be somehow parsed, but it would very different 
> from what perf does today.

Thinking about it more it's likely very hard to parse. Dropping instructions is
fine, dropping perf metadata is not (or only as last resort). 

If we miss a MMAP we may never be able to parse that code region.
If we miss a context switch we may be also completely lost until the
next switch.

That means PT couldn't overwrite perf metadata normally.

So you could easily get into situations where the interleaved PT buffer
is between two perf metadata statements and ends up really small, while
large other parts of the buffer are unused.

The only way around it would be likely to move entries around -- to 
garbage collect so to say -- but doing that non-blocking from a NMI will be
challenging.

With the separate buffers we don't have any of these problems.

-Andi
