Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbaDBPoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:44:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48657 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaDBPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:44:14 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [RFC v2 01/10] sysrq: Implement __handle_sysrq_nolock to avoid recursive locking in kdb
Date: Wed,  2 Apr 2014 16:43:51 +0100
Message-Id: <1396453440-16445-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kdb is triggered using SysRq-g then any use of the sr command results
in the SysRq key table lock being recursively acquired, killing the debug
session. That patch resolves the problem by introducing a _nolock
alternative for __handle_sysrq.

Strictly speaking this approach risks racing on the key table when kdb is
triggered by something other than SysRq-g however in that case any other
CPU involved should release the spin lock before kgdb parks the slave
CPUs.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/sysrq.c         | 11 ++++++++---
 include/linux/sysrq.h       |  1 +
 kernel/debug/kdb/kdb_main.c |  2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index ce396ec..7b47b2d 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -505,14 +505,12 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
                 sysrq_key_table[i] = op_p;
 }
 
-void __handle_sysrq(int key, bool check_mask)
+void __handle_sysrq_nolock(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -554,6 +552,13 @@ void __handle_sysrq(int key, bool check_mask)
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
+}
+
+void __handle_sysrq(int key, bool check_mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	__handle_sysrq_nolock(key, check_mask);
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 387fa7d..1d51d64 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -44,6 +44,7 @@ struct sysrq_key_op {
 
 void handle_sysrq(int key);
 void __handle_sysrq(int key, bool check_mask);
+void __handle_sysrq_nolock(int key, bool check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0b097c8..f39f926 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1924,7 +1924,7 @@ static int kdb_sr(int argc, const char **argv)
 	if (argc != 1)
 		return KDB_ARGCOUNT;
 	kdb_trap_printk++;
-	__handle_sysrq(*argv[1], false);
+	__handle_sysrq_nolock(*argv[1], false);
 	kdb_trap_printk--;
 
 	return 0;
-- 
1.9.0

