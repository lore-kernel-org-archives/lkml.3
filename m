Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaDXLBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:01:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaDXLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:01:39 -0400
Date: Thu, 24 Apr 2014 04:01:21 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-637247403abff8c963bc7be8002b3f49ea604563@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140417081849.26341.11609.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081849.26341.11609.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes: Show blacklist entries via debugfs
Git-Commit-ID: 637247403abff8c963bc7be8002b3f49ea604563
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  637247403abff8c963bc7be8002b3f49ea604563
Gitweb:     http://git.kernel.org/tip/637247403abff8c963bc7be8002b3f49ea604563
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:18:49 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:26:41 +0200

kprobes: Show blacklist entries via debugfs

Show blacklist entries (function names with the address
range) via /sys/kernel/debug/kprobes/blacklist.

Note that at this point the blacklist supports only
in vmlinux, not module. So the list is fixed and
not updated.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20140417081849.26341.11609.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/kprobes.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++--------
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
