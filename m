Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaEEUr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:47:59 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56928 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaEEUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:47:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/4] printk: Disable preemption for printk_sched
Date: Mon,  5 May 2014 13:47:41 -0700
Message-Id: <1399322864-22861-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
References: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier change in -mm (printk: remove separate printk_sched
buffers...), removed the printk_sched irqsave/restore lines
since it was safe for current users. Since we may be expanding
usage of printk_sched(), disable preepmtion for this function
to make it more generally safe to call.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/printk/printk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 82d19e6..57467df 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2589,12 +2589,14 @@ int printk_sched(const char *fmt, ...)
 	va_list args;
 	int r;
 
+	preempt_disable();
 	va_start(args, fmt);
 	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	preempt_enable();
 
 	return r;
 }
-- 
1.9.1

