Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab3GSPlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619Ab3GSPlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:41:49 -0400
Date: Fri, 19 Jul 2013 17:36:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Kill the unbalanced tr->ref++ in
	tracing_buffers_open()
Message-ID: <20130719153644.GA18899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_buffers_open() does trace_array_get() and then it wrongly
inrcements tr->ref again under trace_types_lock. This means that
every caller leaks trace_array:

	# cd /sys/kernel/debug/tracing/
	# mkdir instances/X
	# true < instances/X/per_cpu/cpu0/trace_pipe_raw
	# rmdir instances/X
	rmdir: failed to remove `instances/X': Device or resource busy

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee471fb..278c5f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4944,8 +4944,6 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	mutex_lock(&trace_types_lock);
 
-	tr->ref++;
-
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
 	info->iter.trace	= tr->current_trace;
-- 
1.5.5.1


