Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaCZEIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:08:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:12178 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487AbaCZEIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:08:06 -0400
Message-Id: <20140326040803.923522970@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Mar 2014 00:07:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>
Subject: [for-next][PATCH 2/2] tracing: Add BUG_ON when stack end location is over written
References: <20140326040731.610462407@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Add-BUG_ON-when-stack-end-location-is-over-w.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

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

Link: http://lkml.kernel.org/r/1395669837-30209-1-git-send-email-atomlin@redhat.com

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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


