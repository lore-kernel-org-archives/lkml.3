Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab3HBKI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:08:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758874Ab3HBKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 20/99] tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()
Date: Fri,  2 Aug 2013 18:07:33 +0800
Message-Id: <20130802100228.858921044@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e70e78e3c83b536730e31231dd9b979768d8df3c upstream.

tracing_buffers_open() does trace_array_get() and then it wrongly
inrcements tr->ref again under trace_types_lock. This means that
every caller leaks trace_array:

	# cd /sys/kernel/debug/tracing/
	# mkdir instances/X
	# true < instances/X/per_cpu/cpu0/trace_pipe_raw
	# rmdir instances/X
	rmdir: failed to remove `instances/X': Device or resource busy

Link: http://lkml.kernel.org/r/20130719153644.GA18899@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4907,8 +4907,6 @@ static int tracing_buffers_open(struct i
 
 	mutex_lock(&trace_types_lock);
 
-	tr->ref++;
-
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
 	info->iter.trace	= tr->current_trace;


