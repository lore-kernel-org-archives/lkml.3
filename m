Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925Ab3CZPvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:51:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065Ab3CZPWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 067/150] tracing: Fix race in snapshot swapping
Date: Tue, 26 Mar 2013 15:19:26 +0000
Message-Id: <1364311249-14454-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a7fa070..bd1df78 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -693,7 +693,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -705,6 +705,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	}
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
-- 
1.8.1.2

