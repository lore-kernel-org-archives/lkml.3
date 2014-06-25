Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaFYLIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:08:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41116 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -repost 19/21] kgr: expose global 'in_progress' state through procfs
Date: Wed, 25 Jun 2014 13:07:13 +0200
Message-Id: <1403694435-3180-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

In addition to having a per-process flag that shows which processess have
already been "migrated", it's useful to have a global-wide flag that will
show whether the patching operation is currently undergoing without having
to traverse all /proc entries.

js: handle error

Reported-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/kgraft.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 5ec0c1abe0d6..1247f1c60b09 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -26,6 +26,8 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
 
 static int kgr_patch_code(const struct kgr_patch *patch,
 		struct kgr_patch_fun *patch_fun, bool final);
@@ -382,6 +384,25 @@ unlock_free:
 }
 EXPORT_SYMBOL_GPL(kgr_start_patching);
 
+static int kgr_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", kgr_in_progress);
+	return 0;
+}
+
+static int kgr_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kgr_show, NULL);
+}
+
+static const struct file_operations kgr_fops = {
+	.owner      = THIS_MODULE,
+	.open       = kgr_open,
+	.read       = seq_read,
+	.llseek     = seq_lseek,
+	.release    = single_release,
+};
+
 static int __init kgr_init(void)
 {
 	if (ftrace_is_dead()) {
@@ -398,6 +419,9 @@ static int __init kgr_init(void)
 	kgr_initialized = true;
 	pr_info("kgr: successfully initialized\n");
 
+	if (!proc_create("kgr_in_progress", 0, NULL, &kgr_fops))
+		pr_warn("kgr: cannot create kgr_in_progress in procfs\n");
+
 	return 0;
 }
 module_init(kgr_init);
-- 
2.0.0

