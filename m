Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaE1ROn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:14:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17532 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518AbaE1ROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:14:42 -0400
Date: Wed, 28 May 2014 13:14:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is in
 use
Message-ID: <20140528131440.2283213c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

 ****************************************
 ** NOTICE NOTICE NOTICE NOTICE NOTICE **
 ** trace_printk() being used.         **
 ** Allocating extra memory for it     **
 ****************************************

Hmm, maybe I should add "Not for production use" to scare people even
more?

Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

Ted,

I noticed that in fs/ext4/inline.c you use trace_printk() if
INLINE_DIR_DEBUG is defined. I'm assuming that this is not a production
setting and this banner should not affect you at all. Am I correct?

There's some other places that use it, but those are obviously debug
only.

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0543169..068f453 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1975,7 +1975,11 @@ void trace_printk_init_buffers(void)
 	if (alloc_percpu_trace_buffer())
 		return;
 
-	pr_info("ftrace: Allocated trace_printk buffers\n");
+	pr_warning("****************************************\n");
+	pr_warning("** NOTICE NOTICE NOTICE NOTICE NOTICE **\n");
+	pr_warning("** trace_printk() being used.         **\n");
+	pr_warning("** Allocating extra memory for it     **\n");
+	pr_warning("****************************************\n");
 
 	/* Expand the buffers to set size */
 	tracing_update_buffers();
