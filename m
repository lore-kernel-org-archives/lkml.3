Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab3CHDG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:06:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3i6TJGG1RiYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ArjVyjqUlYsA:10 a=20KFwNOVAAAA:8 a=6EEvkdkcoNwE-etnRgYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030651.990309877@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 21:59:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 01/17] ring-buffer: Init waitqueue for blocked readers
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Init-waitqueue-for-blocked-readers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The move of blocked readers to the ring buffer left out the
init of the wait queue that is used. Tests missed this due to running
stress tests against the buffers, which didn't allow for any
readers to end up waiting. Running a simple read and wait triggered
a bug.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 56b6ea3..65fe2a4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1185,6 +1185,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
 	init_completion(&cpu_buffer->update_done);
 	init_irq_work(&cpu_buffer->irq_work.work, rb_wake_up_waiters);
+	init_waitqueue_head(&cpu_buffer->irq_work.waiters);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1281,6 +1282,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->reader_lock_key = key;
 
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
+	init_waitqueue_head(&buffer->irq_work.waiters);
 
 	/* need at least two pages */
 	if (nr_pages < 2)
-- 
1.7.10.4


