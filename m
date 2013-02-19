Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576Ab3BSTLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:11:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985Ab3BSSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 26/81] target: Fix divide by zero bug in fabric_max_sectors for unconfigured devices
Date: Tue, 19 Feb 2013 15:48:49 -0300
Message-Id: <1361299784-8830-27-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7a3cf6ca1ab2a2f7161c6dec5a787fc7a5de864e upstream.

This patch fixes a possible divide by zero bug when the fabric_max_sectors
device attribute is written and backend se_device failed to be successfully
configured -> enabled.

Go ahead and use block_size=512 within se_dev_set_fabric_max_sectors()
in the event of a target_configure_device() failure case, as no valid
dev->dev_attrib.block_size value will have been setup yet.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: adjust context, block size is dev->se_sub_dev->se_dev_attrib.block_size ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_device.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8542099..0208baa 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1167,6 +1167,8 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 
 int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 {
+	int block_size = dev->se_sub_dev->se_dev_attrib.block_size;
+
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
 		pr_err("dev[%p]: Unable to change SE Device"
 			" fabric_max_sectors while dev_export_obj: %d count exists\n",
@@ -1204,8 +1206,12 @@ int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 	/*
 	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
 	 */
+	if (!block_size) {
+		block_size = 512;
+		pr_warn("Defaulting to 512 for zero block_size\n");
+	}
 	fabric_max_sectors = se_dev_align_max_sectors(fabric_max_sectors,
-						      dev->se_sub_dev->se_dev_attrib.block_size);
+						      block_size);
 
 	dev->se_sub_dev->se_dev_attrib.fabric_max_sectors = fabric_max_sectors;
 	pr_debug("dev[%p]: SE Device max_sectors changed to %u\n",
-- 
1.7.9.5

