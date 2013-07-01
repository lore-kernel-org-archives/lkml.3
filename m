Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3GAWjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:39:09 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:63286 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3GAWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:39:07 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 18:39:07 EDT
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 2/3] tracing: Make trace_marker use the correct per-instance buffer
Date: Mon,  1 Jul 2013 15:31:24 -0700
Message-Id: <1372717885-4543-2-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1372717885-4543-1-git-send-email-azl@google.com>
References: <1372717885-4543-1-git-send-email-azl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_marker file was present for each new instance created, but it
added the trace mark to the global trace buffer instead of to
the instance's buffer.

Cc: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e0b0d2a..2f7307e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4351,6 +4351,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	unsigned long addr = (unsigned long)ubuf;
+	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct print_entry *entry;
@@ -4410,7 +4411,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 
 	local_save_flags(irq_flags);
 	size = sizeof(*entry) + cnt + 2; /* possible \n added */
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  irq_flags, preempt_count());
 	if (!event) {
-- 
1.8.3

