Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3GVOVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:21:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3GVOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:29 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ogiG-pDpTuMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Z8yskFt4zokA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=3nbZYyFuAAAA:8 a=ZArbDTPQWvNnl0OUvIkA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722142126.542426716@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:20:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 14/14] tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()
References: <20130722141947.972915744@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Kill-the-unbalanced-tr-ref-in-tracing_buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_buffers_open() does trace_array_get() and then it wrongly
inrcements tr->ref again under trace_types_lock. This means that
every caller leaks trace_array:

	# cd /sys/kernel/debug/tracing/
	# mkdir instances/X
	# true < instances/X/per_cpu/cpu0/trace_pipe_raw
	# rmdir instances/X
	rmdir: failed to remove `instances/X': Device or resource busy

Link: http://lkml.kernel.org/r/20130719153644.GA18899@redhat.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d9ceab..3f24777 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4959,8 +4959,6 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	mutex_lock(&trace_types_lock);
 
-	tr->ref++;
-
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
 	info->iter.trace	= tr->current_trace;
-- 
1.7.10.4


