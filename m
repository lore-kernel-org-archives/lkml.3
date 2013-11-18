Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3KRGpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 01:45:50 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15267 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3KRGpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 01:45:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 17 Nov 2013 22:43:52 -0800
Message-ID: <5289B855.4080800@nvidia.com>
Date: Mon, 18 Nov 2013 08:48:53 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Erik Faye-Lund <kusmabite@gmail.com>
Subject: Re: Why have another variable deciding a tracepoint?
References: <20131114234812.3bf7bce9@gandalf.local.home>
 <5285D8A5.6030903@nvidia.com> <20131115095240.334c9f6b@gandalf.local.home>
In-Reply-To: <20131115095240.334c9f6b@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2013 16:52, Steven Rostedt wrote:
> So let me get this straight. The recording of the cdma_push() data is
> slow, correct? What mapping are you talking about?
> 
> 	trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
> 				       op1, op2);
> 
> #define cdma_to_channel(cdma) container_of(cdma, struct host1x_channel, cdma)
> 
> That just references the cdma field of struct host1x_channel, to get
> the dev field, which does dev_name() that just gets the dev->init_name
> (if defined, or kobject_name() if not). And the two u32 fields that are
> passed in.
> 
> The tracepoint assigns with:
> 
> 	TP_fast_assign(
> 		__entry->name = name;
> 		__entry->op1 = op1;
> 		__entry->op2 = op2;
> 	),
> 
> So I still have to ask; what do you have to set up and take down here?

Oops, there's a piece missing that I didn't mention. What we want is a
full trace of what we're sending to the push buffer. See
hw/channel_hw.c/trace_write_gather(). It maps the buffer handed from
user space, dumps it to ftrace and unmaps it. That costs a lot of time
that we don't want to spend in normal operation and hence the special
condition.

trace_host1x_cdma_push() in the code you refer to just makes the dump
complete by adding some overhead opcodes that kernel needs to add. It
doesn't make sense to output that if we don't get the bulk from
trace_write_gather() and that's why it's also checking the same
conditional. It'd just make the trace look corrupted.

> It's documented in the code ;-)  (kidding)
> 
> Yeah, I need to get that out a bit more. That's actually how I found
> this code, I'm doing searches for all the locations that can benefit
> from TRACE_EVENT_CONDITION(), and I'm trying to fix them up. I'm still
> not convinced that this extra variable checking is required for this
> tracepoint.
> 
> As you state though, I'll have to get time to document CONDITION() and
> how and when to use it.

Sounds good. :-)

Terje

