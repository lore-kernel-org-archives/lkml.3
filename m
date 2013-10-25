Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3JYV21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:28:27 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46589 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3JYV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:28:26 -0400
Date: Fri, 25 Oct 2013 17:36:15 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
In-Reply-To: <alpine.DEB.2.10.1310250906110.22710@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1310251726001.31246@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu> <1382695687.12254.4.camel@pippen.local.home>
 <alpine.DEB.2.10.1310250906110.22710@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, Vince Weaver wrote:

> 
> I'm not sure how tracepoints work exactly, but the problem code is setting
> 	pe[5].type=PERF_TYPE_TRACEPOINT;
> 	pe[5].config=0x7fffffff00000001;
> 
> The config is being truncated to 32-bits by the perf/ftrace code so I 
> think this means the tracepoint being enabled is
> 
> 	tracing/events/ftrace/function/id:1
> 

I've wasted much of the day playing with this and adding printks, etc.

The key things that cause the problem are:

  tracepoint event
  config is 1 (tracing/events/ftrace/function)
  PERF_SAMPLE_PERIOD set in the sample type
  no user mmap buffer
  period (not frequency) enabled

What this means is there is pretty high number of kernel calls happening.
Every kernel function entry ends up calling the
perf_swevent_overflow() overflow handler, which calls perf_event_output()
which attempts to dump the buffer, but it can't because no user buffer is 
mmap'd.

This causes some sort of storm and eventually the system just stops 
responding and the watchdog kicks in, although the traces it gives back 
are different each time.  

It's possible the kernel is making forward progress (though very slowly)
and this is just some sort of throttling issue.

I don't know if there are any better ways to try to debug things than the 
printk route.  Though that has its own problems as the printk's themselves 
start showing up in the ftrace traces.

Vince

