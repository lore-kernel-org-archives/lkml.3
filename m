Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaEBWJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:09:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34791 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaEBWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:09:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/4] printk: Re-add irqsave/restore in printk_sched
Date: Fri,  2 May 2014 15:09:15 -0700
Message-Id: <1399068558-2373-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A commit in akpm's tree (printk: remove separate printk_sched
buffers...), removed the printk_sched irqsave/restore lines
since it was safe for current users. Since we may be expanding
usage of printk_sched(), re-add the irqsave/restore logic
to make the functionality more generally safe.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/printk/printk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 82d19e6..bf62f2b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2586,15 +2586,18 @@ void wake_up_klogd(void)
 
 int printk_sched(const char *fmt, ...)
 {
+	unsigned long flags;
 	va_list args;
 	int r;
 
+	local_irq_save(flags);
 	va_start(args, fmt);
 	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	local_irq_restore(flags);
 
 	return r;
 }
-- 
1.9.1

