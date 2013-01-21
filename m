Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3AUVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:20:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21666 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3AUVRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:30 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nDJJWQbNfEgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=i74QEpWVu-0A:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=Z4Rwk6OoAAAA:8 a=CGfYiWR9EmVNqEt1IFkA:9 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211729.357828882@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/13 -next] tracing: Remove the extra 4 bytes of padding in events
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Remove-the-extra-4-bytes-of-padding-in-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Due to a userspace issue with PowerTop v1, which hardcoded
the offset of event fields that it was using, it broke when
we removed the Big Kernel Lock counter from the event header.

 (commit e6e1e2593 "tracing: Remove lock_depth from event entry")

Because this broke userspace, it was determined that we must
keep those 4 bytes around.

 (commit a3a4a5acd "Regression: partial revert "tracing: Remove lock_depth from event entry"")

This unfortunately wastes space in the ring buffer. 4 bytes per
event, where a lot of events are just 24 bytes. That's 16% of the
buffer wasted. A million events will add 4 megs of white space
into the buffer.

It was later noticed that PowerTop v1 could not work on systems
where the kernel was 64 bit but the userspace was 32 bits.
The reason was because the offsets are different between the
two and the hard coded offset of one would not work with the other.

With PowerTop v2, it implemented the same interface that both
perf and trace-cmd use. That is, it reads the format file of
the event to find the offsets of the fields it needs. This fixes
the problem with running powertop on a 32 bit userspace running
on a 64 bit kernel. It also no longer requires the 4 byte padding.

As PowerTop v2 has been out for a while, and is included in all
major distributions, it is time that we can safely remove the
4 bytes of padding. Users of PowerTop v1 should upgrade to
PowerTop v2.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 -
 kernel/trace/trace.c         |    1 -
 kernel/trace/trace_events.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 43ef8b6..6f8d0b7 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -49,7 +49,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			padding;
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d62248d..a387bd2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1173,7 +1173,6 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->padding			= 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 880073d..57e9b28 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -116,7 +116,6 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
-	__common_field(int, padding);
 
 	return ret;
 }
-- 
1.7.10.4


