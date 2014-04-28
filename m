Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaD1TfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:35:11 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:50625 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaD1TfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:35:07 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 28 Apr 2014 15:38:38 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu> <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, this is my current theory as to what's going on.  I'd appreciate any 
comments.


We have an event, let's call it #16.

Event #16 is a SW event created and running in the parent on CPU0.

CPU0 (parent): calls fork()

CPU6 (child): SW Event #16 is still running on CPU0 but is visible
	on CPU6 because the fd passed through with fork

CPU0 (parent) close #16.  Event not deallocated because
        still visible in child

CPU0 (parent) kill child

CPU6 (child) shutting down.
   last user of event #16
   perf_release() called on event
   which eventually calls event_sched_out()
   which calls pmu->del which removes event from swevent_htable
   *but only on CPU6*

**** some sort of race happens with CPU0 (possibly with 
	event_sched_in() and event->state==PERF_EVENT_STATE_INACTIVE)
	That has event #16 in the cpu0 swevent_htable but not
	freed the next time ctx_sched_out() happens ****


CPU6 (idle) grace period expires, kfree happens

the CPU0 hlist still has in the list the now freed (and poisoned)
  event which causes problems, especially as new events added to
  the list over-write bytes starting at 0x48 with pprev values.


Vince
