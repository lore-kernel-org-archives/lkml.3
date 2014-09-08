Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaIHMcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaIHMcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:32:50 -0400
Date: Mon, 8 Sep 2014 14:32:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908123200.GC17728@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908113958.GT3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908113958.GT3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:39:58PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
> > 
> > > > The thing is; I don't understand those reasons. That commit log doesn't
> > > > explain.
> > > 
> > > Ah wait, I finally see. I think we want to fix that exit path, not
> > > disallow the cloning.
> > > 
> > > The thing is, by not allowing this optimization simple things like eg.
> > > pipe-test say very expensive.
> > 
> > So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> > with exited task") that introduces the problem. Before that things would
> > work correctly afaict.
> > 
> > The exit would remove from the context but leave the event in existence.
> > Both the fd and the inherited events would have references to it, only
> > once those are gone do we destroy the actual event.
> 
> I have another 'problem' with 179033b3e064. What if you 'want' to
> continue monitoring after the initial task died? Eg. if you want to
> monitor crap that unconditionally daemonizes.
> 
> So at this point I would suggest we revert both 179033b3e064 and
> 1f9a7268c67f so that the context switch optimization works again for
> simple 2 task things (pipe-test).
> 
> If we re-introduce 179033b3e064 (which I think makes sense) we need to
> make sure it works with the context switch optimization (we could add
> perf_event::task I think, it would clean up a few other things iirc) and
> we'd have to make it conditional so we can still monitor daemons.
> 
> Or am I totally missing things again?

as I said in previous email I dont think the 179033b3e064 introduced
the issue and I think we should keep 1f9a7268c67f to have correct
numbers ;-)

I'll think about the fix to keep non-cloned context in optimized switch

jirka
