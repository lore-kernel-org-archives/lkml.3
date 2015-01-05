Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbbAENM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:12:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:46827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbbAENM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:12:57 -0500
Date: Mon, 5 Jan 2015 14:12:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/3] perf: Userspace event
Message-ID: <20150105131237.GR30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
 <1415292718-19785-3-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292718-19785-3-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:51:57PM +0000, Pawel Moll wrote:
> This patch adds a PR_TASK_PERF_UEVENT prctl call which can be used by
> any process to inject custom data into perf data stream as a new
> PERF_RECORD_UEVENT record, if such process is being observed or if it
> is running on a CPU being observed by the perf framework.
> 
> The prctl call takes the following arguments:
> 
>         prctl(PR_TASK_PERF_UEVENT, type, size, data, flags);
> 
> - type: a number meaning to describe content of the following data.
>   Kernel does not pay attention to it and merely passes it further in
>   the perf data, therefore its use must be agreed between the events
>   producer (the process being observed) and the consumer (performance
>   analysis tool). The perf userspace tool will contain a repository of
>   "well known" types and reference implementation of their decoders.
> - size: Length in bytes of the data.
> - data: Pointer to the data.
> - flags: Reserved for future use. Always pass zero.
> 
> Perf context that are supposed to receive events generated with the
> prctl above must be opened with perf_event_attr.uevent set to 1. The
> PERF_RECORD_UEVENT records consist of a standard perf event header,
> 32-bit type value, 32-bit data size and the data itself, followed by
> padding to align the overall record size to 8 bytes and optional,
> standard sample_id field.
> 
> Example use cases:
> 
> - "perf_printf" like mechanism to add logging messages to perf data;
>   in the simplest case it can be just
> 
>         prctl(PR_TASK_PERF_UEVENT, 0, 8, "Message", 0);
> 
> - synchronisation of performance data generated in user space with the
>   perf stream coming from the kernel. For example, the marker can be
>   inserted by a JIT engine after it generated portion of the code, but
>   before the code is executed for the first time, allowing the
>   post-processor to pick the correct debugging information.
> 

The think I remember being raised was a unified means of these msgs
across perf/ftrace/lttng. I am not seeing that mentioned.

Also, I would like a stronger rationale for the @type argument, if it
has no actual meaning why is it separate from the binary msg data?
