Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3CZWoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3CZWoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 38/98] tracing: Fix race in snapshot swapping
Date: Tue, 26 Mar 2013 15:42:27 -0700
Message-Id: <20130326224246.411780126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -703,7 +703,7 @@ __update_max_tr(struct trace_array *tr,
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -715,6 +715,7 @@ update_max_tr(struct trace_array *tr, st
 	}
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 


