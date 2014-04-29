Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbaD2Ob6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:31:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60608 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbaD2ObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:31:16 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Hedi Berriche <hedi@sgi.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH 3/3] kdb: Implement seq_file command
Date: Tue, 29 Apr 2014 15:30:41 +0100
Message-Id: <1398781841-15152-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
References: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combining the kdb seq_file infrastructure with its symbolic lookups allows
a good sub-set of files held in pseudo filesystems to be displayed by
kdb. The seq_file command does exactly this and allows a significant
subset of pseudo files to be safely examined whilst debugging (and in
the hands of a brave expert an even bigger subset can be unsafely
examined).

Good arguments to try with this command include: cpuinfo_op,
gpiolib_seq_ops and vmalloc_op.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0b097c8..d87731c 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1734,6 +1734,32 @@ static int kdb_mm(int argc, const char **argv)
 }
 
 /*
+ * kdb_seq_file - This function implements the 'seq_file' command.
+ *	seq_file address-expression
+ */
+static int kdb_seq_file(int argc, const char **argv)
+{
+	int diag;
+	unsigned long addr;
+	int nextarg;
+	long offset;
+	char *name;
+	const struct seq_operations *ops;
+
+	nextarg = 1;
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, &name);
+	if (diag)
+		return diag;
+
+	if (nextarg != argc+1)
+		return KDB_ARGCOUNT;
+
+	ops = (const struct seq_operations *) (addr + offset);
+	kdb_printf("Using sequence_ops at 0x%p (%s)\n", ops, name);
+	return kdb_print_seq_file(ops);
+}
+
+/*
  * kdb_go - This function implements the 'go' command.
  *	go [address-expression]
  */
@@ -2838,6 +2864,8 @@ static void __init kdb_inittab(void)
 	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
 	kdb_register_repeat("grephelp", kdb_grep_help, "",
 	  "Display help on | grep", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("seq_file", kdb_seq_file, "",
+	  "Show a seq_file using struct seq_operations", 3, KDB_REPEAT_NONE);
 }
 
 /* Execute any commands defined in kdb_cmds.  */
-- 
1.9.0

