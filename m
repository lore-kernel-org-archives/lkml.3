Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3IISpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:45:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 10/24] lparcfg: don't bother saving pointer to proc_dir_entry
Date: Mon,  9 Sep 2013 11:45:00 -0700
Message-Id: <1378752314-2416-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit b177a29251081576df35cfbcb0f7d7c80deceb8b upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ kamal: 3.8.y-stable prereq for:
  "f5f6cbb powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/lparcfg.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index f5725bc..801a757 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -41,8 +41,6 @@
 
 /* #define LPARCFG_DEBUG */
 
-static struct proc_dir_entry *proc_ppc64_lparcfg;
-
 /*
  * Track sum of all purrs across all processors. This is used to further
  * calculate usage values by different applications
@@ -688,27 +686,22 @@ static const struct file_operations lparcfg_fops = {
 
 static int __init lparcfg_init(void)
 {
-	struct proc_dir_entry *ent;
 	umode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
 
 	/* Allow writing if we have FW_FEATURE_SPLPAR */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR))
 		mode |= S_IWUSR;
 
-	ent = proc_create("powerpc/lparcfg", mode, NULL, &lparcfg_fops);
-	if (!ent) {
+	if (!proc_create("powerpc/lparcfg", mode, NULL, &lparcfg_fops)) {
 		printk(KERN_ERR "Failed to create powerpc/lparcfg\n");
 		return -EIO;
 	}
-
-	proc_ppc64_lparcfg = ent;
 	return 0;
 }
 
 static void __exit lparcfg_cleanup(void)
 {
-	if (proc_ppc64_lparcfg)
-		remove_proc_entry("lparcfg", proc_ppc64_lparcfg->parent);
+	remove_proc_subtree("powerpc/lparcfg", NULL);
 }
 
 module_init(lparcfg_init);
-- 
1.8.1.2

