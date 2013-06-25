Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3FYR2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FYR2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:28:32 -0400
Date: Tue, 25 Jun 2013 19:23:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/uprobes: disallow unregister trace_uprobe
	when trace_uprobe is in use
Message-ID: <20130625172359.GA8523@redhat.com>
References: <51C951CD.50701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C951CD.50701@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, zhangwei(Jovi) wrote:
>
> We cannot unregister trace_uprobe when trace_uprobe is in use,
> otherwise resource will leak.
>
> Just return -EBUSY if user want to unregister a trace_uprobe
> which in use.

Hmm. Afaics, this is not that simple. This patch copies the similar
logic from trace_kprobe.c. I'll recheck later but so far I strongly
believe that code is wrong.

So please forget about trace_uprobe.c for the moment. Let's look at
release_all_trace_probes().

It checks trace_probe_is_enabled(), but how can we trust this check?
We can race with enable_trace_probe() which is going to set
TP_FLAG_TRACE/TP_FLAG_PROFILE.

And no, we can't change enable_trace_probe() to take probe_lock,
this can ABBA with unregister_trace_probe() called under this lock
because of trace_remove_event_call() which takes event_mutex.

At the same time, the fact that trace_remove_event_call() takes
event_mutex can probably help, because __trace_remove_event_call()
should do TRACE_REG_UNREGISTER and this should serialize us with
TRACE_REG_REGISTER.

But TRACE_REG_PERF_REGISTER is different, and does not look safe.
In fact I suspect there are more serious problems, but I need to
recheck.

Oleg.

