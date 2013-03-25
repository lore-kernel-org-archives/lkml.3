Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3CYB0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:26:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057Ab3CYBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:08 -0400
Message-Id: <20130325010529.642960311@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Subject: [ 054/104] tracing: Fix race in snapshot swapping
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 2721e72dd10f71a3ba90f59781becf02638aa0d9 upstream.

Although the swap is wrapped with a spin_lock, the assignment
of the temp buffer used to swap is not within that lock.
It needs to be moved into that lock, otherwise two swaps
happening on two different CPUs, can end up using the wrong
temp buffer to assign in the swap.

Luckily, all current callers of the swap function appear to have
their own locks. But in case something is added that allows two
different callers to call the swap, then there's a chance that
this race can trigger and corrupt the buffers.

New code is coming soon that will allow for this race to trigger.

I've Cc'd stable, so this bug will not show up if someone backports
one of the changes that can trigger this bug.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -652,7 +652,7 @@ __update_max_tr(struct trace_array *tr,
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -664,6 +664,7 @@ update_max_tr(struct trace_array *tr, st
 	}
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 


