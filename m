Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbaGSNRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11706 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755504AbaGSNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:16 -0400
Message-Id: <20140719131614.491912148@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stanislav Meduna <stano@meduna.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: [for-next][PATCH 29/32] ring-buffer: Always run per-cpu ring buffer resize with
 schedule_work_on()
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0029-ring-buffer-Always-run-per-cpu-ring-buffer-resize-wi.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The code for resizing the trace ring buffers has to run the per-cpu
resize on the CPU itself.  The code was using preempt_off() and
running the code for the current CPU directly, otherwise calling
schedule_work_on().

At least on RT this could result in the following:

|BUG: sleeping function called from invalid context at kernel/rtmutex.c:673
|in_atomic(): 1, irqs_disabled(): 0, pid: 607, name: bash
|3 locks held by bash/607:
|CPU: 0 PID: 607 Comm: bash Not tainted 3.12.15-rt25+ #124
|(rt_spin_lock+0x28/0x68)
|(free_hot_cold_page+0x84/0x3b8)
|(free_buffer_page+0x14/0x20)
|(rb_update_pages+0x280/0x338)
|(ring_buffer_resize+0x32c/0x3dc)
|(free_snapshot+0x18/0x38)
|(tracing_set_tracer+0x27c/0x2ac)

probably via
|cd /sys/kernel/debug/tracing/
|echo 1 > events/enable ; sleep 2
|echo 1024 > buffer_size_kb

If we just always use schedule_work_on(), there's no need for the
preempt_off().  So do that.

Link: http://lkml.kernel.org/p/1405537633-31518-1-git-send-email-cminyard@mvista.com

Reported-by: Stanislav Meduna <stano@meduna.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c56c3d06943..35825a87d6a3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1693,22 +1693,14 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			/* The update must run on the CPU that is being updated. */
-			preempt_disable();
-			if (cpu == smp_processor_id() || !cpu_online(cpu)) {
+			/* Can't run something on an offline CPU. */
+			if (!cpu_online(cpu)) {
 				rb_update_pages(cpu_buffer);
 				cpu_buffer->nr_pages_to_update = 0;
 			} else {
-				/*
-				 * Can not disable preemption for schedule_work_on()
-				 * on PREEMPT_RT.
-				 */
-				preempt_enable();
 				schedule_work_on(cpu,
 						&cpu_buffer->update_pages_work);
-				preempt_disable();
 			}
-			preempt_enable();
 		}
 
 		/* wait for all the updates to complete */
@@ -1746,22 +1738,14 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		get_online_cpus();
 
-		preempt_disable();
-		/* The update must run on the CPU that is being updated. */
-		if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
+		/* Can't run something on an offline CPU. */
+		if (!cpu_online(cpu_id))
 			rb_update_pages(cpu_buffer);
 		else {
-			/*
-			 * Can not disable preemption for schedule_work_on()
-			 * on PREEMPT_RT.
-			 */
-			preempt_enable();
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
 			wait_for_completion(&cpu_buffer->update_done);
-			preempt_disable();
 		}
-		preempt_enable();
 
 		cpu_buffer->nr_pages_to_update = 0;
 		put_online_cpus();
-- 
2.0.1


