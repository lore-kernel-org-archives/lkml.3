Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3HXNhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 09:37:22 -0400
Received: from numidia.opendz.org ([98.142.220.152]:47948 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3HXNhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 09:37:20 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH v2] iwlwifi: mvm: make debugfs write() operations write up to count bytes
Date: Sat, 24 Aug 2013 14:35:53 +0100
Message-Id: <1377351353-18588-1-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugfs write() operations of the MVM Firmware will ignore the
count argument, and will copy more bytes than what was specified.
Fix this by getting the right count of bytes.

This will honor restrictions put on the number of bytes to write and
avoid strcmp() calls on garbage data.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Cc: "Berg, Johannes" <johannes.berg@intel.com>
---
Patch compile tested only.
v2 Clean patch and use min_t() as noted by Berg Johannes

 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index aac81b8..299966a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -257,7 +257,8 @@ static ssize_t iwl_dbgfs_power_down_allow_write(struct file *file,
 	if (!mvm->ucode_loaded)
 		return -EIO;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &allow) != 1)
@@ -281,7 +282,8 @@ static ssize_t iwl_dbgfs_power_down_d3_allow_write(struct file *file,
 	char buf[8] = {};
 	int allow;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &allow) != 1)
@@ -371,7 +373,8 @@ static ssize_t iwl_dbgfs_pm_params_write(struct file *file,
 	int val;
 	int ret;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (!strncmp("keep_alive=", buf, 11)) {
@@ -968,7 +971,8 @@ static ssize_t iwl_dbgfs_d3_sram_write(struct file *file,
 	char buf[8] = {};
 	int store;
 
-	if (copy_from_user(buf, user_buf, sizeof(buf)))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &store) != 1)
-- 
1.7.11.7

