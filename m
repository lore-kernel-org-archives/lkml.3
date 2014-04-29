Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbaD2SGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:06:49 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48119 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaD2SGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:06:48 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, richard@nod.at, umgwanakikbuti@gmail.com
Subject: [PATCH 1/2] sysrq: rcu-ify __handle_sysrq
Date: Tue, 29 Apr 2014 14:06:35 -0400
Message-Id: <1398794796-17464-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398794796-17464-1-git-send-email-riel@redhat.com>
References: <1398794796-17464-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Echoing values into /proc/sysrq-trigger seems to be a popular way to
get information out of the kernel. However, dumping information about
thousands of processes, or hundreds of CPUs to serial console can
result in IRQs being blocked for minutes, resulting in various kinds
of cascade failures.

The most common failure is due to interrupts being blocked for a very
long time. This can lead to things like failed IO requests, and other
things the system cannot easily recover from.

This problem is easily fixable by making __handle_sysrq use RCU
instead of spin_lock_irqsave.

This leaves the warning that RCU grace periods have not elapsed for a
long time, but the system will come back from that automatically.

It also leaves sysrq-from-irq-context when the sysrq keys are pressed,
but that is probably desired since people want that to work in situations
where the system is already hosed.

The callers of register_sysrq_key and unregister_sysrq_key appear to be
capable of sleeping.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Madper Xie <cxie@redhat.com>
---
 drivers/tty/sysrq.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index ce396ec..fc67a89 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -510,9 +510,8 @@ void __handle_sysrq(int key, bool check_mask)
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -554,7 +553,7 @@ void __handle_sysrq(int key, bool check_mask)
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+	rcu_read_unlock();
 }
 
 void handle_sysrq(int key)
@@ -1043,16 +1042,23 @@ static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
                                 struct sysrq_key_op *remove_op_p)
 {
 	int retval;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	spin_lock(&sysrq_key_table_lock);
 	if (__sysrq_get_key_op(key) == remove_op_p) {
 		__sysrq_put_key_op(key, insert_op_p);
 		retval = 0;
 	} else {
 		retval = -1;
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+	spin_unlock(&sysrq_key_table_lock);
+
+	/*
+	 * A concurrent __handle_sysrq either got the old op or the new op.
+	 * Wait for it to go away before returning, so the code for an old
+	 * op is not freed (eg. on module unload) while it is in use.
+	 */
+	synchronize_rcu();
+
 	return retval;
 }
 
-- 
1.8.5.3

