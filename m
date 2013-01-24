Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3AXTgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:36:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AXTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:36:53 -0500
Date: Thu, 24 Jan 2013 11:36:04 -0800
From: tip-bot for Shan Wei <davidshan@tencent.com>
Message-ID: <tip-d8a0349c0cea477322c66ea9362f10c62fad5f62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, cl@linux.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, tglx@linutronix.de,
        cl@linux.com
In-Reply-To: <50A1A800.3020102@gmail.com>
References: <50A1A800.3020102@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Use this_cpu_ptr per-cpu helper
Git-Commit-ID: d8a0349c0cea477322c66ea9362f10c62fad5f62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:36:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8a0349c0cea477322c66ea9362f10c62fad5f62
Gitweb:     http://git.kernel.org/tip/d8a0349c0cea477322c66ea9362f10c62fad5f62
Author:     Shan Wei <davidshan@tencent.com>
AuthorDate: Tue, 13 Nov 2012 09:53:04 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jan 2013 13:22:30 -0500

tracing: Use this_cpu_ptr per-cpu helper

typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
As well-known, the value of &buffer is equal to &buffer[0].
so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast.

Link: http://lkml.kernel.org/r/50A1A800.3020102@gmail.com

Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/blktrace.c | 2 +-
 kernel/trace/trace.c    | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		return;
 
 	local_irq_save(flags);
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c13e46..f8b7c62 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1517,7 +1517,6 @@ static struct trace_buffer_struct *trace_percpu_nmi_buffer;
 static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *percpu_buffer;
-	struct trace_buffer_struct *buffer;
 
 	/*
 	 * If we have allocated per cpu buffers, then we do not
@@ -1535,9 +1534,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
 
-	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
-
-	return buffer->buffer;
+	return this_cpu_ptr(&percpu_buffer->buffer[0]);
 }
 
 static int alloc_percpu_trace_buffer(void)
