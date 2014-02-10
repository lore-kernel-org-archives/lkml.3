Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaBJSDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:03:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56747 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753665AbaBJSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:03:20 -0500
Date: Mon, 10 Feb 2014 13:03:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: yogesh tillu <tillu.yogesh@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [Ftrace][Bug] Failed on adding breakpoints, when used with
 kgdboc
Message-ID: <20140210130317.24019a4d@gandalf.local.home>
In-Reply-To: <CAAH=MDydEbG-iDC92G18U4iDtD6vMcegGSuzK4Kihq+vz7eQQA@mail.gmail.com>
References: <CAAH=MDxg22r78x0szzr_gjqxgfL5ZCGehRxSqAmNcfxiP390QA@mail.gmail.com>
	<20140207093452.0ecab55f@gandalf.local.home>
	<CAAH=MDydEbG-iDC92G18U4iDtD6vMcegGSuzK4Kihq+vz7eQQA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 22:59:24 +0530
yogesh tillu <tillu.yogesh@gmail.com> wrote:

> Hi Steve,
>      Thanks for the reply.
> Can we follow the approach of using api ftrace_set_notrace_ip (like
> ftrace_set_filter_ip ), and register ip for the notrace hash list from
> kgdb x86 arch code at the time of adding/removing breakpoint.
> 
> 

I'm not sure that will work. I have no problem skipping ftrace tests if
kgdb is enabled on boot up. That's just self test debugging anyway, and
pretty much useless for most people but those developing ftrace.

The reason I say it wont work, is that the filters are not global. That
is, you can call those "don't trace this function" API, and it will
only work for the ftrace function tracer. There's other users of ftrace
(perf, kprobes, stack-tracer, etc) that will still trace whatever it
wanted to trace.

As the bug only happens when function tracing is being enabled or
disabled when the kgdb breakpoint exists, I don't think this is
that much of a problem. I'm sure you could cause it to fail again, but
this always requires root privilege, for both ftrace and kgdb, and the
worse thing that happens is you get that splat and the function tracer
is disabled. It wont crash the kernel or do any other harm.

By skipping the start up tests, it is highly unlikely kgdb will trip up
function tracing unless you still have those break points around.

Now, if kgdb always keeps a breakpoint at do_page_fault() handler, then
perhaps we can do one of two things. The one, is like you said, don't
do function tracing on that function (skip it if kgdb is enabled).

The other is to be more like kprobes, and have kgdb hook into the
ftrace infrastructure. That is, if you find that you are about to add a
breakpoint to the start of a function, and that address happens to have
an ftrace _fentry_ call to it (or nop). Then just register your own
ftrace handler with the "REGS" flag, and the call back will act just
like a breakpoint, but only faster :-)

-- Steve
