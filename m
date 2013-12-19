Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3LSJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:14:32 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59263 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3LSJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:10:20 -0500
Subject: [PATCH -tip v6 17/22] kprobes: Show blacklist entries via debugfs
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 19 Dec 2013 09:04:35 +0000
Message-ID: <20131219090435.14309.6218.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show blacklist entries (function names with the address
range) via /sys/kernel/debug/kprobes/blacklist.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 8 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a21b4e6..3214289 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2249,6 +2249,46 @@ static const struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
+/* kprobes/blacklist -- shows which functions can not be probed */
+static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return seq_list_start(&kprobe_blacklist, *pos);
+}
+
+static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &kprobe_blacklist, pos);
+}
+
+static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
+{
+	struct kprobe_blacklist_entry *ent =
+		list_entry(v, struct kprobe_blacklist_entry, list);
+
+	seq_printf(m, "0x%p-0x%p\t%ps\n", (void *)ent->start_addr,
+		   (void *)ent->end_addr, (void *)ent->start_addr);
+	return 0;
+}
+
+static const struct seq_operations kprobe_blacklist_seq_ops = {
+	.start = kprobe_blacklist_seq_start,
+	.next  = kprobe_blacklist_seq_next,
+	.stop  = kprobe_seq_stop,	/* Reuse void function */
+	.show  = kprobe_blacklist_seq_show,
+};
+
+static int kprobe_blacklist_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobe_blacklist_seq_ops);
+}
+
+static const struct file_operations debugfs_kprobe_blacklist_ops = {
+	.open           = kprobe_blacklist_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
 static void arm_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -2372,19 +2412,24 @@ static int __init debugfs_kprobe_init(void)
 
 	file = debugfs_create_file("list", 0444, dir, NULL,
 				&debugfs_kprobes_operations);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
+	if (!file)
+		goto error;
 
 	file = debugfs_create_file("enabled", 0600, dir,
 					&value, &fops_kp);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
+	if (!file)
+		goto error;
+
+	file = debugfs_create_file("blacklist", 0444, dir, NULL,
+				&debugfs_kprobe_blacklist_ops);
+	if (!file)
+		goto error;
 
 	return 0;
+
+error:
+	debugfs_remove(dir);
+	return -ENOMEM;
 }
 
 late_initcall(debugfs_kprobe_init);


