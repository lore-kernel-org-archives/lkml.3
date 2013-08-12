Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3HLAuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 20:50:13 -0400
Received: from numidia.opendz.org ([98.142.220.152]:51586 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3HLAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 20:50:08 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Aug 2013 20:50:08 EDT
From: Djalal Harouni <tixxdz@opendz.org>
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Cc: Djalal Harouni <tixxdz@opendz.org>, stable@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: make debugfs write() operations write up to count bytes
Date: Mon, 12 Aug 2013 01:39:32 +0100
Message-Id: <1376267972-5636-1-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugfs write() operations of the MVM Firmware will ignore the
count argument, and will copy more bytes than what was specified.
Fix this by getting the right count of bytes.

This will also honor restrictions put on the number of bytes to write.

To be consitant this patch also switches the initializer from
'char buf[x] = {}' to the explicit memset() as it is done in other
places of the same file.

Cc: stable@vger.kernel.org
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
Patch compile tested only.
Dual BSD/GPLv2 license: Ok

 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 56f6827..ca368db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -251,13 +251,16 @@ static ssize_t iwl_dbgfs_power_down_allow_write(struct file *file,
 						size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	char buf[8] = {};
+	char buf[8];
 	int allow;
 
 	if (!mvm->ucode_loaded)
 		return -EIO;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	memset(buf, 0, sizeof(buf));
+	if (count > sizeof(buf) - 1)
+		count = sizeof(buf) - 1;
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &allow) != 1)
@@ -278,10 +281,13 @@ static ssize_t iwl_dbgfs_power_down_d3_allow_write(struct file *file,
 						   size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	char buf[8] = {};
+	char buf[8];
 	int allow;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	memset(buf, 0, sizeof(buf));
+	if (count > sizeof(buf) - 1)
+		count = sizeof(buf) - 1;
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &allow) != 1)
@@ -363,11 +369,14 @@ static ssize_t iwl_dbgfs_pm_params_write(struct file *file,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
 	enum iwl_dbgfs_pm_mask param;
-	char buf[32] = {};
+	char buf[32];
 	int val;
 	int ret;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	memset(buf, 0, sizeof(buf));
+	if (count > sizeof(buf) - 1)
+		count = sizeof(buf) - 1;
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (!strncmp("keep_alive=", buf, 11)) {
@@ -824,10 +833,13 @@ static ssize_t iwl_dbgfs_d3_sram_write(struct file *file,
 				       size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	char buf[8] = {};
+	char buf[8];
 	int store;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	memset(buf, 0, sizeof(buf));
+	if (count > sizeof(buf) - 1)
+		count = sizeof(buf) - 1;
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &store) != 1)
-- 
1.7.11.7

