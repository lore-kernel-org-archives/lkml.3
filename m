Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaD1USt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaD1USs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:18:48 -0400
From: Florian Weimer <fweimer@redhat.com>
Date: Mon, 28 Apr 2014 21:52:11 +0200
Subject: [PATCH] random: Add "initialized" variable to proc
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Message-Id: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, you had to check kernel log messages to see if the
non-blocking pool had been properly initialized.  With this change, you
can consult the file /proc/sys/kernel/random/intialized instead.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 drivers/char/random.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..81d83e2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1592,6 +1592,19 @@ static int proc_do_entropy(ctl_table *table, int write,
 	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
 }
 
+/*
+ * Return whether the urandom pool has been initialized.
+ */
+static int proc_do_initialized(ctl_table *table, int write,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	ctl_table fake_table;
+	char ch = '0' + nonblocking_pool.initialized;
+	fake_table.data = &ch;
+	fake_table.maxlen = 1;
+	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
+}
+
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
@@ -1610,6 +1623,12 @@ struct ctl_table random_table[] = {
 		.data		= &input_pool.entropy_count,
 	},
 	{
+		.procname	= "initialized",
+		.maxlen		= 1,
+		.mode		= 0444,
+		.proc_handler	= proc_do_initialized,
+	},
+	{
 		.procname	= "read_wakeup_threshold",
 		.data		= &random_read_wakeup_bits,
 		.maxlen		= sizeof(int),
-- 
1.9.0

