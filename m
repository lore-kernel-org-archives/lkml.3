Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3HBKuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3HBKJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arend van Spril <arend@broadcom.com>, Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 21/99] tracing: Remove locking trace_types_lock from tracing_reset_all_online_cpus()
Date: Fri,  2 Aug 2013 18:07:34 +0800
Message-Id: <20130802100228.992543620@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 09d8091c024ec88d1541d93eb8ddb2bd5cf10c39 upstream.

Commit a82274151af "tracing: Protect ftrace_trace_arrays list in trace_events.c"
added taking the trace_types_lock mutex in trace_events.c as there were
several locations that needed it for protection. Unfortunately, it also
encapsulated a call to tracing_reset_all_online_cpus() which also takes
the trace_types_lock, causing a deadlock.

This happens when a module has tracepoints and has been traced. When the
module is removed, the trace events module notifier will grab the
trace_types_lock, do a bunch of clean ups, and also clears the buffer
by calling tracing_reset_all_online_cpus. This doesn't happen often
which explains why it wasn't caught right away.

Commit a82274151af was marked for stable, which means this must be
sent to stable too.

Link: http://lkml.kernel.org/r/51EEC646.7070306@broadcom.com

Reported-by: Arend van Spril <arend@broadcom.com>
Tested-by: Arend van Spriel <arend@broadcom.com>
Cc: Alexander Z Lam <azl@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1163,18 +1163,17 @@ void tracing_reset_current(int cpu)
 	tracing_reset(&global_trace.trace_buffer, cpu);
 }
 
+/* Must have trace_types_lock held */
 void tracing_reset_all_online_cpus(void)
 {
 	struct trace_array *tr;
 
-	mutex_lock(&trace_types_lock);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		tracing_reset_online_cpus(&tr->trace_buffer);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		tracing_reset_online_cpus(&tr->max_buffer);
 #endif
 	}
-	mutex_unlock(&trace_types_lock);
 }
 
 #define SAVED_CMDLINES 128


