Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaEMRao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:30:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:43078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaEMRag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:30:36 -0400
Date: Tue, 13 May 2014 19:30:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513173032.GD5226@laptop.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
 <5371BCF8.7030708@cn.fujitsu.com>
 <20140513100333.GW30445@twins.programming.kicks-ass.net>
 <20140513171436.GA8672@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140513171436.GA8672@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 07:14:36PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, May 13, 2014 at 03:34:32PM +0900, Dongsheng Yang wrote:
> > > On 05/13/2014 04:22 PM, Ingo Molnar wrote:
> > > >* Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > >>trace_sched_wakeup(.success) is a dead argument and has been for ages,
> > > >Always 0, or random value?
> > > 
> > > Hi Ingo,
> > > 
> > > It is always 1 currently.
> > > 
> > > Peter believe that .success is not useful and I pointed that perf 
> > > sched latency is using it now. Then he post this patch to remove 
> > > the usage here.
> > > 
> > > Please go to the following link for more about this issue.
> > 
> > It is _not_ usable. You're proposing to abuse the existing 
> > parameter. A wakeup doing an enqueue or not has nothing 
> > _WHAT_SO_EVER_ to do with success.
> > 
> > Now what I think you wanted to do is make it easier to match 
> > trace_sched_switch() statements with trace_sched_wakeup() 
> > statements. And since you only get the trace_sched_switch() on 
> > dequeue, you want to know which trace_sched_wakeup() calls did an 
> > enqueue.
> > 
> > But that's completely and utterly unrelated to success.
> 
> So I always considered it 'the enqueue was successful' - that's I 
> think why I added it to 'perf sched' originally - to be able to trace 
> wakeups from originator to target.

So back when it still sometimes returned 0 it was the try_to_wake_up()
return value, it still is, except when we re factored ttwu we moved the
tracepoint such that its not on the 0 return path.

I would've removed it then, except I couldn't because some crap
userspace was using it -- and that's the only reason its still in there,
its been a pointless rudiment for years.

Anyway, the return value is true if it (potentially) did an actual
wakeup, and that is unrelated to having done an enqueue.

And in general you want wakeups to happen before we do the dequeue, as
the enqueue-less wakeups are _way_ faster. I've tried optimistic
yield(), but since not all schedule() site can deal with spurious
wakeups that fell flat :/
