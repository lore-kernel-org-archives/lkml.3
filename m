Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaDWQzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaDWQzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:55:00 -0400
Date: Wed, 23 Apr 2014 12:53:52 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: joern@logfs.org, peterz@infradead.org, akpm@linux-foundation.org,
        cxie@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
Message-ID: <20140423125352.704f9fb2@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index ce396ec..3c61e9b 100644
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
+	 * A concurrent __handle_sysrq eitehr got the old op or the new op.
+	 * Wait for it to go away before returning, so the code for an old
+	 * op is not freed (eg. on module unload) while it is in use.
+	 */
+	synchronize_rcu();
+
 	return retval;
 }
 

