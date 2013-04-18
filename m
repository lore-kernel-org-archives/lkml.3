Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967439Ab3DRJfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:35:09 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48757 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967424Ab3DRJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:35:05 -0400
X-AuditID: 85900ec0-d42c9b900000151e-c8-516fbe46ab12
Subject: [PATCH -tip ] [BUGFIX] kprobes: Fix a double lock bug of kprobe_mutex
To: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 18 Apr 2013 18:33:18 +0900
Message-ID: <20130418093318.13070.29847.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a double locking bug caused when debug.kprobe-optimization=0.
While the proc_kprobes_optimization_handler locks kprobe_mutex,
wait_for_kprobe_optimizer locks it again and that causes a double lock.
To fix the bug, this introduces different mutex for protecting
sysctl parameter and locks it in proc_kprobes_optimization_handler.
Of course, since we need to lock kprobe_mutex when touching kprobes
resources, that is done in *optimize_all_kprobes().

This bug was from ad72b3bea744b4db01c89af0f86f3e8920d354df

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e35be53..3fed7f0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -794,16 +794,16 @@ out:
 }
 
 #ifdef CONFIG_SYSCTL
-/* This should be called with kprobe_mutex locked */
 static void __kprobes optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
 	unsigned int i;
 
+	mutex_lock(&kprobe_mutex);
 	/* If optimization is already allowed, just return */
 	if (kprobes_allow_optimization)
-		return;
+		goto out;
 
 	kprobes_allow_optimization = true;
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
@@ -813,18 +813,22 @@ static void __kprobes optimize_all_kprobes(void)
 				optimize_kprobe(p);
 	}
 	printk(KERN_INFO "Kprobes globally optimized\n");
+out:
+	mutex_unlock(&kprobe_mutex);
 }
 
-/* This should be called with kprobe_mutex locked */
 static void __kprobes unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
 	unsigned int i;
 
+	mutex_lock(&kprobe_mutex);
 	/* If optimization is already prohibited, just return */
-	if (!kprobes_allow_optimization)
+	if (!kprobes_allow_optimization) {
+		mutex_unlock(&kprobe_mutex);
 		return;
+	}
 
 	kprobes_allow_optimization = false;
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
@@ -834,11 +838,14 @@ static void __kprobes unoptimize_all_kprobes(void)
 				unoptimize_kprobe(p, false);
 		}
 	}
+	mutex_unlock(&kprobe_mutex);
+
 	/* Wait for unoptimizing completion */
 	wait_for_kprobe_optimizer();
 	printk(KERN_INFO "Kprobes globally unoptimized\n");
 }
 
+static DEFINE_MUTEX(kprobe_sysctl_mutex);
 int sysctl_kprobes_optimization;
 int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 				      void __user *buffer, size_t *length,
@@ -846,7 +853,7 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 {
 	int ret;
 
-	mutex_lock(&kprobe_mutex);
+	mutex_lock(&kprobe_sysctl_mutex);
 	sysctl_kprobes_optimization = kprobes_allow_optimization ? 1 : 0;
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 
@@ -854,7 +861,7 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 		optimize_all_kprobes();
 	else
 		unoptimize_all_kprobes();
-	mutex_unlock(&kprobe_mutex);
+	mutex_unlock(&kprobe_sysctl_mutex);
 
 	return ret;
 }

