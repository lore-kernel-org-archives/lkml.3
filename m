Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbaEaBj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:39:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932229AbaEaBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:27 -0400
Message-Id: <20140531013926.012483232@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:39:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/7] tracing: Print nasty banner when trace_printk() is in use
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Print-nasty-banner-when-trace_printk-is-in-u.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

trace_printk() is used to debug fast paths within the kernel. Places
that gets called in any context (interrupt or NMI) or thousands of
times a second. Something you do not want to do with a printk().

In order to make it completely lockless as it needs a temporary buffer
to handle some of the string formatting, a page is created per cpu for
every context (four per cpu; normal, softirq, irq, NMI).

Since trace_printk() should only be used for debugging purposes,
there's no reason to waste memory on these buffers on a production
system. That means, trace_printk() should never be used unless a
developer is debugging their kernel. There's macro magic to allocate
the buffers if trace_printk() is used anywhere in the kernel.

To help enforce that trace_printk() isn't used outside of development,
when it is used, a nasty banner is displayed on bootup (or when a module
is loaded that uses trace_printk() and the kernel core does not).

Here's the banner:

 **********************************************************
 **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
 **                                                      **
 ** trace_printk() being used. Allocating extra memory.  **
 **                                                      **
 ** This means that this is a DEBUG kernel and it is     **
 ** unsafe for produciton use.                           **
 **                                                      **
 ** If you see this message and you are not debugging    **
 ** the kernel, report this immediately to your vendor!  **
 **                                                      **
 **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
 **********************************************************

That should hopefully keep developers from trying to sneak in a
trace_printk() or two.

Link: http://lkml.kernel.org/p/20140528131440.2283213c@gandalf.local.home

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 05431696b10c..eb228b9de170 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1975,7 +1975,21 @@ void trace_printk_init_buffers(void)
 	if (alloc_percpu_trace_buffer())
 		return;
 
-	pr_info("ftrace: Allocated trace_printk buffers\n");
+	/* trace_printk() is for debug use only. Don't use it in production. */
+
+	pr_warning("\n**********************************************************\n");
+	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
+	pr_warning("** unsafe for produciton use.                           **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** If you see this message and you are not debugging    **\n");
+	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warning("**********************************************************\n");
 
 	/* Expand the buffers to set size */
 	tracing_update_buffers();
-- 
2.0.0.rc2


