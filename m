Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaEBQjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:39:44 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47264 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEBQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:39:41 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 12:43:17 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140502162234.GX11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
References: <20140430184437.GH17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
 <20140502154217.GW11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu> <20140502162234.GX11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Peter Zijlstra wrote:

> In principle the vfs file refcounting should be responsible for that.
> But I'll go over it in a bit.

The poll code is ancient and the C-parser in my head really can't handle 
it very well.

Anyway for completeness this is the kind of thing I'm seeing.
The poll() manpage isn't very clear about what is supposed to happen if 
you poll() on a closed file descriptor.


FD#3 closed
	perf_fuzzer-2293  [003]   286.500137: sys_enter:            NR 3 (3, 7fff841b9eac, 0, 22, 7ff17078110c, 7ff170781120)

Child killed:
	perf_fuzzer-2293  [003]   286.505587: sys_exit:             NR 62 = 0

Poll started, seems to have freed fd #3 as an argument:
	perf_fuzzer-2293  [003]   286.505703: sys_enter:            NR 7 (7fff841b9b00, 55, 3, 40e3e3, 7ff1707810dc, 7ff170781120)

(child is still closing out at this point)


Event freed:
	<...>-2701  [004]   286.505904: bprint:               _free_event: freeing with 0 refs; ptr=0x0xffff8800ce88e000

fd#3 is still being polled despite the event being completely gone now:
	perf_fuzzer-2293  [003]   286.508846: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508847: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508848: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508849: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508850: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508846: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508847: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508848: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508849: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508850: bprint:               do_sys_poll: VMW: poll 3
	perf_fuzzer-2293  [003]   286.508850: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508851: bprint:               do_sys_poll: VMW: poll 12
	perf_fuzzer-2293  [003]   286.508850: function:             perf_poll
	perf_fuzzer-2293  [003]   286.508851: bprint:               do_sys_poll: VMW: poll 12

Finally done polling:
	perf_fuzzer-2293  [003]   286.509002: sys_exit:             NR 7 = 0

