Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbbAXOEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:31 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53361 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAXOEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 21/32] wireless: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:27 -0500
Message-Id: <1422108218-25398-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 23 ++++++-----------------
 drivers/net/wireless/ath/carl9170/debug.c      | 24 ++++++------------------
 2 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 8cef1ed..dc79afd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -291,26 +291,15 @@ static ssize_t read_file_slot(struct file *file, char __user *user_buf,
 {
 	struct ath9k_htc_priv *priv = file->private_data;
 	char buf[512];
-	unsigned int len = 0;
+	unsigned int len;
 
 	spin_lock_bh(&priv->tx.tx_lock);
-
-	len += scnprintf(buf + len, sizeof(buf) - len, "TX slot bitmap : ");
-
-	len += bitmap_scnprintf(buf + len, sizeof(buf) - len,
-			       priv->tx.tx_slot, MAX_TX_BUF_NUM);
-
-	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
-
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "Used slots     : %d\n",
-			 bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
-
+	len = scnprintf(buf, sizeof(buf),
+			"TX slot bitmap : %*pb\n"
+			"Used slots     : %d\n",
+			MAX_TX_BUF_NUM, priv->tx.tx_slot,
+			bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
 	spin_unlock_bh(&priv->tx.tx_lock);
-
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 1c0af9c..6808db4 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -214,14 +214,10 @@ DEBUGFS_DECLARE_RO_FILE(name, _read_bufsize)
 static char *carl9170_debugfs_mem_usage_read(struct ar9170 *ar, char *buf,
 					     size_t bufsize, ssize_t *len)
 {
-	ADD(buf, *len, bufsize, "jar: [");
-
 	spin_lock_bh(&ar->mem_lock);
 
-	*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-				  ar->mem_bitmap, ar->fw.mem_blocks);
-
-	ADD(buf, *len, bufsize, "]\n");
+	ADD(buf, *len, bufsize, "jar: [%*pb]\n",
+	    ar->fw.mem_blocks, ar->mem_bitmap);
 
 	ADD(buf, *len, bufsize, "cookies: used:%3d / total:%3d, allocs:%d\n",
 	    bitmap_weight(ar->mem_bitmap, ar->fw.mem_blocks),
@@ -316,17 +312,13 @@ static char *carl9170_debugfs_ampdu_state_read(struct ar9170 *ar, char *buf,
 		    cnt, iter->tid, iter->bsn, iter->snx, iter->hsn,
 		    iter->max, iter->state, iter->counter);
 
-		ADD(buf, *len, bufsize, "\tWindow:  [");
-
-		*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-			iter->bitmap, CARL9170_BAW_BITS);
+		ADD(buf, *len, bufsize, "\tWindow:  [%*pb,W]\n",
+		    CARL9170_BAW_BITS, iter->bitmap);
 
 #define BM_STR_OFF(offset)					\
 	((CARL9170_BAW_BITS - (offset) - 1) / 4 +		\
 	 (CARL9170_BAW_BITS - (offset) - 1) / 32 + 1)
 
-		ADD(buf, *len, bufsize, ",W]\n");
-
 		offset = BM_STR_OFF(0);
 		ADD(buf, *len, bufsize, "\tBase Seq: %*s\n", offset, "T");
 
@@ -448,12 +440,8 @@ static char *carl9170_debugfs_vif_dump_read(struct ar9170 *ar, char *buf,
 	ADD(buf, *len, bufsize, "registered VIFs:%d \\ %d\n",
 	    ar->vifs, ar->fw.vif_num);
 
-	ADD(buf, *len, bufsize, "VIF bitmap: [");
-
-	*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-				 &ar->vif_bitmap, ar->fw.vif_num);
-
-	ADD(buf, *len, bufsize, "]\n");
+	ADD(buf, *len, bufsize, "VIF bitmap: [%*pb]\n",
+	    ar->fw.vif_num, &ar->vif_bitmap);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(iter, &ar->vif_list, list) {
-- 
2.1.0

