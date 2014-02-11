Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbaBKUZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:25:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaBKTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.12 003/107] tracing: Check if tracing is enabled in trace_puts()
Date: Tue, 11 Feb 2014 11:04:29 -0800
Message-Id: <20140211184748.297026505@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 3132e107d608f8753240d82d61303c500fd515b4 upstream.

If trace_puts() is used very early in boot up, it can crash the machine
if it is called before the ring buffer is allocated. If a trace_printk()
is used with no arguments, then it will be converted into a trace_puts()
and suffer the same fate.

Fixes: 09ae72348ecc "tracing: Add trace_puts() for even faster trace_printk() tracing"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,9 @@ int __trace_puts(unsigned long ip, const
 	unsigned long irq_flags;
 	int alloc;
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	local_save_flags(irq_flags);
@@ -475,6 +478,9 @@ int __trace_bputs(unsigned long ip, cons
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,


