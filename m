Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaD2Ocd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:32:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47397 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbaD2ObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:31:14 -0400
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
Subject: [PATCH 2/3] proc: Provide access to /proc/interrupts from kdb
Date: Tue, 29 Apr 2014 15:30:40 +0100
Message-Id: <1398781841-15152-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
References: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contents of /proc/interrupts is useful to diagnose problems during
boot up or when the system becomes unresponsive (or at least it can be if
failure is causes by interrupt problems). This command is also seen in
out-of-tree debug systems such as Android's FIQ debugger.

This change allows the file to be displayed from kdb.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 fs/proc/interrupts.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index a352d57..1f8eeaf 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -4,6 +4,7 @@
 #include <linux/irqnr.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/kdb.h>
 
 /*
  * /proc/interrupts
@@ -45,9 +46,18 @@ static const struct file_operations proc_interrupts_operations = {
 	.release	= seq_release,
 };
 
+#ifdef CONFIG_KGDB_KDB
+static int kdb_interrupts(int argc, const char **argv)
+{
+	return kdb_print_seq_file(&int_seq_ops);
+}
+#endif
+
 static int __init proc_interrupts_init(void)
 {
 	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
+	kdb_register("interrupts", kdb_interrupts, "",
+		     "Show /proc/interrupts", 3);
 	return 0;
 }
 fs_initcall(proc_interrupts_init);
-- 
1.9.0

