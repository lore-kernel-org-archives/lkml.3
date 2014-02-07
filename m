Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaBGLvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaBGLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 171/233] tracing: Check if tracing is enabled in trace_puts()
Date: Fri,  7 Feb 2014 11:46:30 +0000
Message-Id: <1391773652-25214-172-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 3132e107d608f8753240d82d61303c500fd515b4 upstream.

If trace_puts() is used very early in boot up, it can crash the machine
if it is called before the ring buffer is allocated. If a trace_printk()
is used with no arguments, then it will be converted into a trace_puts()
and suffer the same fate.

Fixes: 09ae72348ecc "tracing: Add trace_puts() for even faster trace_printk() tracing"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 878785b..f788ecf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	unsigned long irq_flags;
 	int alloc;
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	local_save_flags(irq_flags);
@@ -475,6 +478,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-- 
1.8.3.2

