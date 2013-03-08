Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3CHDHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760298Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3vqFFbMGYeIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=R_-9hwVTzhMA:10 a=20KFwNOVAAAA:8 a=ts78MXV-y6MweGnPnj0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030654.403815136@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 16/17] ring-buffer: Do not use schedule_work_on() for current CPU
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0016-ring-buffer-Do-not-use-schedule_work_on-for-current-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The ring buffer updates when done while the ring buffer is active,
needs to be completed on the CPU that is used for the ring buffer
per_cpu buffer. To accomplish this, schedule_work_on() is used to
schedule work on the given CPU.

Now there's no reason to use schedule_work_on() if the process
doing the update happens to be on the CPU that it is processing.
It has already filled the requirement. Instead, just do the work
and continue.

This is needed for tracing_snapshot_alloc() where it may be called
really early in boot, where the work queues have not been set up yet.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 65fe2a4..d1c85c5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1679,11 +1679,22 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			if (cpu_online(cpu))
+			/* The update must run on the CPU that is being updated. */
+			preempt_disable();
+			if (cpu == smp_processor_id() || !cpu_online(cpu)) {
+				rb_update_pages(cpu_buffer);
+				cpu_buffer->nr_pages_to_update = 0;
+			} else {
+				/*
+				 * Can not disable preemption for schedule_work_on()
+				 * on PREEMPT_RT.
+				 */
+				preempt_enable();
 				schedule_work_on(cpu,
 						&cpu_buffer->update_pages_work);
-			else
-				rb_update_pages(cpu_buffer);
+				preempt_disable();
+			}
+			preempt_enable();
 		}
 
 		/* wait for all the updates to complete */
@@ -1721,12 +1732,22 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		get_online_cpus();
 
-		if (cpu_online(cpu_id)) {
+		preempt_disable();
+		/* The update must run on the CPU that is being updated. */
+		if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
+			rb_update_pages(cpu_buffer);
+		else {
+			/*
+			 * Can not disable preemption for schedule_work_on()
+			 * on PREEMPT_RT.
+			 */
+			preempt_enable();
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
 			wait_for_completion(&cpu_buffer->update_done);
-		} else
-			rb_update_pages(cpu_buffer);
+			preempt_disable();
+		}
+		preempt_enable();
 
 		cpu_buffer->nr_pages_to_update = 0;
 		put_online_cpus();
-- 
1.7.10.4


