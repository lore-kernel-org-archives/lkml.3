Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaCXOFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaCXOFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:05:16 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: rostedt@goodmis.org
Cc: mingo@redhat.com, dzickus@redhat.com, atomlin@redhat.com, jgh@redhat.com,
        mguzik@redhat.com, pzijlstr@redhat.com, peterz@infradead.org,
        hpa@linux.intel.com, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] tracing: Add BUG_ON when stack end location is over written
Date: Mon, 24 Mar 2014 14:03:57 +0000
Message-Id: <1395669837-30209-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is difficult to detect a stack overrun when it
actually occurs.

We have observed that this type of corruption is often
silent and can go unnoticed. Once the corrupted region
is examined, the outcome is undefined and often
results in sporadic system crashes.

When the stack tracing feature is enabled, let's check
for this condition and take appropriate action.

Note: init_task doesn't get its stack end location
set to STACK_END_MAGIC.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/trace/trace_stack.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e6be585..21b320e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,6 +13,7 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/magic.h>
 
 #include <asm/setup.h>
 
@@ -144,6 +145,8 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
+	BUG_ON(current != &init_task &&
+		*(end_of_stack(current)) != STACK_END_MAGIC);
  out:
 	arch_spin_unlock(&max_stack_lock);
 	local_irq_restore(flags);
-- 
1.8.5.3

