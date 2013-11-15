Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3KOIOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:14:48 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14035 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3KOIOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:14:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 15 Nov 2013 00:12:58 -0800
Message-ID: <5285D8A5.6030903@nvidia.com>
Date: Fri, 15 Nov 2013 10:17:41 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Erik Faye-Lund <kusmabite@gmail.com>
Subject: Re: Why have another variable deciding a tracepoint?
References: <20131114234812.3bf7bce9@gandalf.local.home>
In-Reply-To: <20131114234812.3bf7bce9@gandalf.local.home>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2013 06:48, Steven Rostedt wrote:
> I've been reviewing different users of tracepoints and I stumbled
> across this:
> 
> drivers/gpu/host1x/cdma.c: host1x_cdma_push()
> 
> 	if (host1x_debug_trace_cmdbuf)
> 		trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
> 				       op1, op2);
> 
> That host1x_debug_trace_cmdbuf is a variable that gets set by another
> debugfs file "trace_cmdbuf" that is custom to this driver.
> 
> Why?

This is because it takes a lot of time to prepare for dumping the cmdbuf
data, like mapping buffer and unmapping after tracing. We want to avoid
all that preparation time.

> The tracepoint host1x_cdma_push is already controlled by either ftrace
> or perf. If it gets enabled by perf or ftrace, it still wont be traced
> unless we also enable this trace_cmdbuf. Is there some reason for this?
> I can't figure it out from the change log: 6236451d83a720 ("gpu:
> host1x: Add debug support").
> 
> As tracepoints uses jump labels, there is no branch cost associated
> with them. That is, they are either a direct jump, or a nop (in most
> cases a nop). But here you added the overhead of a conditional branch
> depending on this variable.
> 
> If this is truly needed, then use TRACE_EVENT_CONDITION() for that
> tracepoint.

TRACE_EVENT_CONDITION() isn't documented, so I don't know how that would
help.

Terje
