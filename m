Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaFHBm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 21:42:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:33761 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753184AbaFHBm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 21:42:26 -0400
Date: Sat, 7 Jun 2014 21:42:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH] tracing: Fix memory leak on instance deletion
Message-ID: <20140607214217.403e3b87@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ug, found a memory leak in instance deletion. Missed freeing the
snapshot buffer.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 17f83bffd1b41b5cd6fe08ad12c8a69341542ba2


Steven Rostedt (Red Hat) (1)
      tracing: Fix memory leak on instance deletion

----
 trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
---------------------------
commit a9fcaaac37b3baba1343f906f52aeb65c4d4e356
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Jun 6 23:17:28 2014 -0400

    tracing: Fix memory leak on instance deletion
    
    When an instance is created, it also gets a snapshot ring buffer
    allocated (with minimum of pages). But when it is deleted the snapshot
    buffer is not. There was a helper function added to match the allocation
    of these ring buffers to a way to free them, but it wasn't used by
    the deletion of an instance. Using that helper function solves this
    memory leak.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 26cfff38e2ab..16f7038d1f4d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6349,8 +6349,7 @@ static int instance_delete(const char *name)
 	event_trace_del_tracer(tr);
 	ftrace_destroy_function_files(tr);
 	debugfs_remove_recursive(tr->dir);
-	free_percpu(tr->trace_buffer.data);
-	ring_buffer_free(tr->trace_buffer.buffer);
+	free_trace_buffers(tr);
 
 	kfree(tr->name);
 	kfree(tr);
