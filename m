Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3GBBfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:35:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3GBBfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:35:36 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mAbLp22spWkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4rANEwmd3YMA:10 a=3iw64-i24F7ZQmIt37oA:9 a=QEXdDO2ut3YA:10 a=yq1h8oO2JGwMkBpr:21 a=V8PbgwdBiPzrlIjo:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372728935.22688.36.camel@gandalf.local.home>
Subject: Re: Fwd: [draft] Tracing multibuffer support concurrency issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Lam <lambchop468@gmail.com>
Date: Mon, 01 Jul 2013 21:35:35 -0400
In-Reply-To: <CANiYik6h0_xnUYqCRHZU75az9YS=ySUHaqgMayW-Ffj5Jey6_g@mail.gmail.com>
References: <CANiYik6PbwRkH1vK4B4cFhY0MEJAoF=MBggkvgBYGfyCw2ny-w@mail.gmail.com>
	 <CANiYik6h0_xnUYqCRHZU75az9YS=ySUHaqgMayW-Ffj5Jey6_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 15:33 -0700, Alexander Lam wrote:

> To fix this we could go through the ftrace_trace_arrays list and use
> addresses to check if a particular pointer to a trace_array is still
> valid, but this is vulnerable to the ABA problem if a trace_array is
> freed and another is reallocated at the same address. This method is
> used by subsystem_open() in trace_events.c

And what's so bad about that? If it is freed and a new one is allocated
at the same address, let it return crap. I'm much more interested in not
letting it crash then caring about inconsistent data from someone that's
doing crazy things to the system.

> 
> An ugly way to get around the ABA issue is to use a monotonically
> increasing ID # for each trace_array instance. Those IDs could be used
> instead of pointers when creating debugfs files.

Not worth it.

> 
> Is there a better way to fix this problem?
> 
> Also unaddressed are all of the other files which use a trace_array,
> trace_cpu, or ftrace_event_file in their operation - these would need
> the same fix.

Hmm, really? Just the initiator. That is, when an event is enabled or
anything gets opened, we block deletion from happening. That way we
don't need to care about the rest. Only open and enabling events.

-- Steve



