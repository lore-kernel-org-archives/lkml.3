Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaKFV0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:26:43 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35277 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaKFV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:26:41 -0500
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 2/2] tracing: don't risk busy looping in buffer splice
Date: Thu,  6 Nov 2014 22:26:07 +0100
Message-Id: <1415309167-2373-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415309167-2373-1-git-send-email-rabin@rab.in>
References: <1415309167-2373-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the read loop in trace_buffers_splice_read() keeps failing due to
memory allocation failures without reading even a single page then this
function will keep busy looping.

Remove the risk for that by exiting the function if memory allocation
failures are seen.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/trace/trace.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e67d0de..e838c96 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5501,7 +5501,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	};
 	struct buffer_ref *ref;
 	int entries, size, i;
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	mutex_lock(&trace_types_lock);
 
@@ -5539,13 +5539,16 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		int r;
 
 		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
-		if (!ref)
+		if (!ref) {
+			ret = -ENOMEM;
 			break;
+		}
 
 		ref->ref = 1;
 		ref->buffer = iter->trace_buffer->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
 		if (!ref->page) {
+			ret = -ENOMEM;
 			kfree(ref);
 			break;
 		}
@@ -5583,6 +5586,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
+		if (ret)
+			goto out;
+
 		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK)) {
 			ret = -EAGAIN;
 			goto out;
-- 
2.1.1

