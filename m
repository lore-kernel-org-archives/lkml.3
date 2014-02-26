Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaBZVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:36:17 -0500
Received: from mail.efficios.com ([78.47.125.74]:43642 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaBZVgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:36:16 -0500
Date: Wed, 26 Feb 2014 21:36:18 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <1677033958.31194.1393450578584.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140226190140.590029589@goodmis.org>
References: <20140226190140.590029589@goodmis.org>
Subject: Re: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint
 code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.172.26]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Request for acks on fixing tracepoint code
Thread-Index: lk69puXfSK52c5WtUNjVyBqb5wvPrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: linux-kernel@vger.kernel.org
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Mathieu Desnoyers"
> <mathieu.desnoyers@efficios.com>
> Sent: Wednesday, February 26, 2014 2:01:40 PM
> Subject: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint code
> 
> [ Request for Acks ]
> 
> Due to module tainting, we have tracepoints that silently do not work.
> That will be solved another way. But the trace event infrastructure should
> not be created for tainted modules. That is, the debugfs files should
> not exist for them.
> 
> By moving the tracepoint module taint test into tracepoint.h, we can
> reuse that same test when creating the module tracepoint events.
> 
> Note, I had to remove the tracepoint.h include from module.h as there
> was nothing in module.h that required tracepoint.h, but this broke
> a couple of event files (migrate.h and writeback.h) because they did
> not include tracepoint.h, and were just lucky that it was included
> by module.h.

When designing tracepoint.h, a lot of care went into making sure it did
not have needless dependency on other headers, since this header is
expected to be included into many other files and headers, thus posing
a clear risk of becoming yet another root of an include dependency hell.

While I agree on adding the API you propose, why made it a static inline ?
This adds this dependency from tracepoint.h on module.h. Instead, we could
just declare a symbol, and implement a tracepoint_module_has_bad_taint()
within kernel/tracepoint.c. It should not be a fast path anyway, so I don't
see the point it making it a static inline.

I also recommend sticking to the tracepoint_*() API (rather than trace_*).

Thoughts ?

Thanks,

Mathieu

> 
> Steven Rostedt (Red Hat) (4):
>       tracing: Fix event header writeback.h to include tracepoint.h
>       tracing: Fix event header migrate.h to include tracepoint.h
>       tracing/module: Remove include of tracepoint.h from module.h
>       tracing: Do not add event files for modules that fail tracepoints
> 
> ----
>  include/linux/module.h           |  1 -
>  include/linux/tracepoint.h       |  7 +++++++
>  include/trace/events/migrate.h   |  2 ++
>  include/trace/events/writeback.h |  1 +
>  kernel/trace/trace_events.c      |  4 ++++
>  kernel/tracepoint.c              |  2 +-
>  6 files changed, 23 insertions(+), 21 deletions(-)
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
