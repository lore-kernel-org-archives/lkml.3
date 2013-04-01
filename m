Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008Ab3DAQLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab3DAQLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:11:02 -0400
Date: Mon, 1 Apr 2013 18:08:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] uprobes/tracing: uretprobes
Message-ID: <20130401160827.GA19206@redhat.com>
References: <20130329181520.GA20670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181520.GA20670@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Oleg Nesterov wrote:
>
> uretprobes code is almost ready, we need to teach trace_uprobe.c
> to support them.
>
> This looks simple, but there is a nasty complication. We do not
> want to copy-and-paste the code like trace_kprobe.c does. Just look
> at kprobe_event_define_fields() and kretprobe_event_define_fields().
> They are non-trivial but almost identical. And there are a lot more
> examples.
>
> So I'd like to send 4/4 for review before I'll do other changes.
> The patch itself doesn't make sense and complicates the source code a
> bit. But note how easy we can change, say, uprobe_event_define_fields(),
>
> 	-	DEFINE_FIELD(vaddr[0], FIELD_STRING_IP);
> 	-	size = SIZEOF_TRACE_ENTRY(1);
> 	+	if (!trace_probe_is_return(tu)) {
> 	+		DEFINE_FIELD(vaddr[0], FIELD_STRING_IP);
> 	+		size = SIZEOF_TRACE_ENTRY(1);
> 	+	} else {
> 	+		DEFINE_FIELD(vaddr[0], FIELD_STRING_FUNC);
> 	+		DEFINE_FIELD(vaddr[1], FIELD_STRING_RETIP);
> 	+		size = SIZEOF_TRACE_ENTRY(2);
> 	+	}
>
> without copy-and-paste. The same simple change is possible for other
> helpers playing with uprobe_trace_entry_head.

And the rest of the necessary changes to support uretprobes.

To remind, this is on top of Anton's uretprobes implementation which is
not finished yet. This series can't be even compiled, but I think it can
be already reviewed. All it needs to compile is the new
uprobe_consumer->ret_handler().

Oleg.

 kernel/trace/trace_uprobe.c |  152 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 124 insertions(+), 28 deletions(-)

