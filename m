Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaEFNEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:04:42 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59010 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaEFNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:39 -0400
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
Subject: [PATCH v4 1/9] sysrq: Implement __handle_sysrq_nolock to avoid recursive locking in kdb
Date: Tue,  6 May 2014 14:03:41 +0100
Message-Id: <1399381429-16194-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
 <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kdb is triggered using SysRq-g then any use of the sr command results
in the SysRq key table lock being recursively acquired, killing the debug
session. That patch resolves the problem by introducing a _nolock
alternative for __handle_sysrq.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/sysrq.c         | 11 ++++++++---
 include/linux/sysrq.h       |  1 +
 kernel/debug/kdb/kdb_main.c |  9 ++++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

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
index 0b097c8..de439bb 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1918,13 +1918,20 @@ static int kdb_rm(int argc, const char **argv)
  * kdb_sr - This function implements the 'sr' (SYSRQ key) command
  *	which interfaces to the soi-disant MAGIC SYSRQ functionality.
  *		sr <magic-sysrq-code>
+ *
+ * Remarks:
+ *     This command calls into the sysrq code without locking. The sysrq
+ *     code is protected using spin_lock_irqsave meaning this command,
+ *     whilst normally safe, must be used very carefully if kdb is entered
+ *     using a mechanism, such as the NMI, which is immune to the interrupt
+ *     mask.
  */
 static int kdb_sr(int argc, const char **argv)
 {
 	if (argc != 1)
 		return KDB_ARGCOUNT;
 	kdb_trap_printk++;
-	__handle_sysrq(*argv[1], false);
+	__handle_sysrq_nolock(*argv[1], false);
 	kdb_trap_printk--;
 
 	return 0;
-- 
1.9.0

