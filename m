Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3C2SRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab3C2SRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:17:45 -0400
Date: Fri, 29 Mar 2013 19:15:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes/tracing: uretprobes, initial preparations
Message-ID: <20130329181520.GA20670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

uretprobes code is almost ready, we need to teach trace_uprobe.c
to support them.

This looks simple, but there is a nasty complication. We do not
want to copy-and-paste the code like trace_kprobe.c does. Just look
at kprobe_event_define_fields() and kretprobe_event_define_fields().
They are non-trivial but almost identical. And there are a lot more
examples.

So I'd like to send 4/4 for review before I'll do other changes.
The patch itself doesn't make sense and complicates the source code a
bit. But note how easy we can change, say, uprobe_event_define_fields(),

	-	DEFINE_FIELD(vaddr[0], FIELD_STRING_IP);
	-	size = SIZEOF_TRACE_ENTRY(1);
	+	if (!trace_probe_is_return(tu)) {
	+		DEFINE_FIELD(vaddr[0], FIELD_STRING_IP);
	+		size = SIZEOF_TRACE_ENTRY(1);
	+	} else {
	+		DEFINE_FIELD(vaddr[0], FIELD_STRING_FUNC);
	+		DEFINE_FIELD(vaddr[1], FIELD_STRING_RETIP);
	+		size = SIZEOF_TRACE_ENTRY(2);
	+	}

without copy-and-paste. The same simple change is possible for other
helpers playing with uprobe_trace_entry_head.

In fact personally I think that trace_kprobe.c should be cleanuped
this way.



Off-topic question... Why uprobe_perf_func() passes "addr = ip" to
perf_trace_buf_submit() ? This just sets perf_sample_data->addr for
PERF_SAMPLE_ADDR, do we really need this? and we already have
perf_sample_data->ip initialized by perf. Just curious.

Oleg.

 kernel/trace/trace.h        |    5 ---
 kernel/trace/trace_uprobe.c |   77 +++++++++++++++++++++----------------------
 2 files changed, 38 insertions(+), 44 deletions(-)

