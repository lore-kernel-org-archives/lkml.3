Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbaD3VEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:04:34 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51001 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaD3VEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:04:32 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 30 Apr 2014 17:08:00 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140430184437.GH17778@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
References: <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Peter Zijlstra wrote:

> 
> Vince, could you add the below to whatever tracing muck you already
> have?
> 
> After staring at your traces all day with Thomas, we have doubts about
> the refcount integrity.

I've been staring at traces all day too.  Will try your patch tomorrow.

>From my staring, what looks like is happening in the trace is:

task_sched_in in parent adds our freed (but alive in child) event:
	perf_fuzzer-2517  [001]   215.228165: bprint:               perf_swevent_add: VMW add_rcu: 0xffff880036cbb000
This adds the event to the swevent_hlist


the child is in the process of exiting, eventually frees the event
     perf_fuzzer-3634  [006]   215.228250: function:             perf_release
     perf_fuzzer-3634  [006]   215.228250: function:             perf_event_release_kernel
     perf_fuzzer-3634  [006]   215.228251: function:                perf_group_detach
     perf_fuzzer-3634  [006]   215.228251: function:                   perf_event__header_size
     perf_fuzzer-3634  [006]   215.228251: function:                perf_remove_from_context

	Which then does
        list_del_event()
        event->state=PERF_EVENT_STATE_OFF;

Soon after the parent does task_sched_out
	which gets to event_sched_out()
	which hits 
		if (event->state != PERF_EVENT_STATE_ACTIVE)
			return;
	So it never hits the
		event->pmu->del(event, 0);

	We need to get the value off the hlist.

This analysis is probably wrong though because if it's as simple as that 
above then I'm not sure why it isn't easier to hit the bug.

Vince
