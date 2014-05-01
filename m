Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaEASpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:45:34 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:60223 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaEASpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:45:31 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 14:49:01 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, humor me a bit here.

I'm looking at the buggy trace and comparing against a "good" trace where 
the bug doesn't happen.

It is a rance condition of sorts, because it's just a 10us or so 
interleaving of calls that causes the bug to happen or not.

In the good trace:

	[parent] __perf_event_task_sched_out (and hence perf_swevent_del)
	[child]  perf_release

In the buggy trace:

	[child] perf_release
	[parent] __perf_event_task_sched_out (perf_swevent_del never happens)


perf_swevent_del calls
	hlist_del_rcu(event->hlist_entry)
to remove the event from the swevent hlist.

Now in theory perf_release() calls sw_perf_event_destroy() which you
would think would also call the above.  Instead it does
	 swevent_hlist_put_cpu(event, cpu);
which does all kinds of weird hash stuff that I don't follow.

Should the above two be equivelent?  Is it reference counting in there 
with if (!--swhash->hlist_refcount) causing the issue?

Anyway I'm tired of staring at traces for the moment.

Vince
