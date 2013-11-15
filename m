Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3KOOws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:52:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7485 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751185Ab3KOOwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:52:41 -0500
Date: Fri, 15 Nov 2013 09:52:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Terje =?UTF-8?B?QmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Erik Faye-Lund <kusmabite@gmail.com>
Subject: Re: Why have another variable deciding a tracepoint?
Message-ID: <20131115095240.334c9f6b@gandalf.local.home>
In-Reply-To: <5285D8A5.6030903@nvidia.com>
References: <20131114234812.3bf7bce9@gandalf.local.home>
 <5285D8A5.6030903@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 10:17:41 +0200
Terje Bergström <tbergstrom@nvidia.com> wrote:

> On 15.11.2013 06:48, Steven Rostedt wrote:
> > I've been reviewing different users of tracepoints and I stumbled
> > across this:
> > 
> > drivers/gpu/host1x/cdma.c: host1x_cdma_push()
> > 
> > 	if (host1x_debug_trace_cmdbuf)
> > 		trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
> > 				       op1, op2);
> > 
> > That host1x_debug_trace_cmdbuf is a variable that gets set by another
> > debugfs file "trace_cmdbuf" that is custom to this driver.
> > 
> > Why?
> 
> This is because it takes a lot of time to prepare for dumping the cmdbuf
> data, like mapping buffer and unmapping after tracing. We want to avoid
> all that preparation time.
> 

So let me get this straight. The recording of the cdma_push() data is
slow, correct? What mapping are you talking about?

	trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
				       op1, op2);

#define cdma_to_channel(cdma) container_of(cdma, struct host1x_channel, cdma)

That just references the cdma field of struct host1x_channel, to get
the dev field, which does dev_name() that just gets the dev->init_name
(if defined, or kobject_name() if not). And the two u32 fields that are
passed in.

The tracepoint assigns with:

	TP_fast_assign(
		__entry->name = name;
		__entry->op1 = op1;
		__entry->op2 = op2;
	),

So I still have to ask; what do you have to set up and take down here?



> > The tracepoint host1x_cdma_push is already controlled by either ftrace
> > or perf. If it gets enabled by perf or ftrace, it still wont be traced
> > unless we also enable this trace_cmdbuf. Is there some reason for this?
> > I can't figure it out from the change log: 6236451d83a720 ("gpu:
> > host1x: Add debug support").
> > 
> > As tracepoints uses jump labels, there is no branch cost associated
> > with them. That is, they are either a direct jump, or a nop (in most
> > cases a nop). But here you added the overhead of a conditional branch
> > depending on this variable.
> > 
> > If this is truly needed, then use TRACE_EVENT_CONDITION() for that
> > tracepoint.
> 
> TRACE_EVENT_CONDITION() isn't documented, so I don't know how that would
> help.
> 

It's documented in the code ;-)  (kidding)

Yeah, I need to get that out a bit more. That's actually how I found
this code, I'm doing searches for all the locations that can benefit
from TRACE_EVENT_CONDITION(), and I'm trying to fix them up. I'm still
not convinced that this extra variable checking is required for this
tracepoint.

As you state though, I'll have to get time to document CONDITION() and
how and when to use it.

Thanks,

-- Steve
