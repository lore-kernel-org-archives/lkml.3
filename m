Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbaKMVbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:17 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35078 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000AbaKMVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:15 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 47/56] kenel/trace: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:24 +0100
Message-Id: <1415913813-362-48-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from trace when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 kernel/trace/trace.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a52839..e672979 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -938,6 +938,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
@@ -953,6 +954,7 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	s->readpos += cnt;
 	return cnt;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 unsigned long __read_mostly	tracing_thresh;
 
@@ -4552,6 +4554,7 @@ out:
 	return sret;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
 				     unsigned int idx)
 {
@@ -4690,6 +4693,7 @@ out_err:
 	mutex_unlock(&iter->mutex);
 	goto out;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
@@ -5164,8 +5168,11 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp);
 static ssize_t tracing_buffers_read(struct file *filp, char __user *ubuf,
 				    size_t count, loff_t *ppos);
 static int tracing_buffers_release(struct inode *inode, struct file *file);
+
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		   struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static int snapshot_raw_open(struct inode *inode, struct file *filp)
 {
@@ -5217,7 +5224,7 @@ static const struct file_operations tracing_pipe_fops = {
 	.open		= tracing_open_pipe,
 	.poll		= tracing_poll_pipe,
 	.read		= tracing_read_pipe,
-	.splice_read	= tracing_splice_read_pipe,
+	SPLICE_READ_INIT(tracing_splice_read_pipe)
 	.release	= tracing_release_pipe,
 	.llseek		= no_llseek,
 };
@@ -5271,7 +5278,7 @@ static const struct file_operations snapshot_raw_fops = {
 	.open		= snapshot_raw_open,
 	.read		= tracing_buffers_read,
 	.release	= tracing_buffers_release,
-	.splice_read	= tracing_buffers_splice_read,
+	SPLICE_READ_INIT(tracing_buffers_splice_read)
 	.llseek		= no_llseek,
 };
 
@@ -5464,6 +5471,7 @@ static const struct pipe_buf_operations buffer_pipe_buf_ops = {
 	.get			= buffer_pipe_buf_get,
 };
 
+#ifdef CONFIG_SYSCALL_SPLICE
 /*
  * Callback from splice_to_pipe(), if we need to release some pages
  * at the end of the spd in case we error'ed out in filling the pipe.
@@ -5605,13 +5613,14 @@ out:
 
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static const struct file_operations tracing_buffers_fops = {
 	.open		= tracing_buffers_open,
 	.read		= tracing_buffers_read,
 	.poll		= tracing_buffers_poll,
 	.release	= tracing_buffers_release,
-	.splice_read	= tracing_buffers_splice_read,
+	SPLICE_READ_INIT(tracing_buffers_splice_read)
 	.llseek		= no_llseek,
 };
 
-- 
1.9.1

