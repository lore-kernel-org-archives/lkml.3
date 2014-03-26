Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaCZOVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:21:48 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51220 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaCZOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:21:46 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, chad@dahc.us, viro@zeniv.linux.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH v2] staging: silicom: remove BP_PROC_SUPPORT dependant code
Date: Wed, 26 Mar 2014 23:24:06 +0900
Message-Id: <1395843846-3550-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395813530-2684-1-git-send-email-sj38.park@gmail.com>
References: <1395813530-2684-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code is hide inside #ifdef BP_PROC_SUPPORT and it never defined
anywhere. And, it made defined but not used function which calling
code was hide inside #ifdef BP_PROC_SUPPORT and caused following
build warning:

drivers/staging/silicom/bpctl_mod.c:6786:12: warning:
‘bp_proc_create’ defined but not used [-Wunused-function]
 static int bp_proc_create(void)
            ^

Fix the warning and remove code complexity by remove whole code
inside #ifdef BP_PROC_SUPPORT.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c | 39 -------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6b9365b..530d621 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -119,7 +119,6 @@ static void if_scan_init(void);
 
 static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
 static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
-static int bp_proc_create(void);
 
 static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 static int get_dev_idx_bsf(int bus, int slot, int func);
@@ -6399,25 +6398,6 @@ static int __init bypass_init_module(void)
 	}
 
 	register_netdevice_notifier(&bp_notifier_block);
-#ifdef BP_PROC_SUPPORT
-	{
-		int i = 0;
-		/* unsigned long flags; */
-		/* rcu_read_lock(); */
-		bp_proc_create();
-		for (i = 0; i < device_num; i++) {
-			if (bpctl_dev_arr[i].ifindex) {
-				/* spin_lock_irqsave(&bpvm_lock, flags); */
-				bypass_proc_remove_dev_sd(&bpctl_dev_arr[i]);
-				bypass_proc_create_dev_sd(&bpctl_dev_arr[i]);
-				/* spin_unlock_irqrestore(&bpvm_lock, flags); */
-			}
-
-		}
-		/* rcu_read_unlock(); */
-	}
-#endif
-
 	return 0;
 }
 
@@ -6431,13 +6411,6 @@ static void __exit bypass_cleanup_module(void)
 
 	for (i = 0; i < device_num; i++) {
 		/* unsigned long flags; */
-#ifdef BP_PROC_SUPPORT
-/*	spin_lock_irqsave(&bpvm_lock, flags);
-	rcu_read_lock(); */
-		bypass_proc_remove_dev_sd(&bpctl_dev_arr[i]);
-/*	spin_unlock_irqrestore(&bpvm_lock, flags);
-	rcu_read_unlock(); */
-#endif
 		remove_bypass_wd_auto(&bpctl_dev_arr[i]);
 		bpctl_dev_arr[i].reset_time = 0;
 
@@ -6783,18 +6756,6 @@ EXPORT_SYMBOL(bp_if_scan_sd);
 
 static struct proc_dir_entry *bp_procfs_dir;
 
-static int bp_proc_create(void)
-{
-	bp_procfs_dir = proc_mkdir(BP_PROC_DIR, init_net.proc_net);
-	if (bp_procfs_dir == (struct proc_dir_entry *)0) {
-		printk(KERN_DEBUG
-		       "Could not create procfs nicinfo directory %s\n",
-		       BP_PROC_DIR);
-		return -1;
-	}
-	return 0;
-}
-
 static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
 {
-- 
1.8.3.2

