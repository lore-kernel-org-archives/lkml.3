Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3B0ATG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:19:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab3B0AJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 51/86] target: Fix divide by zero bug in fabric_max_sectors for unconfigured devices
Date: Tue, 26 Feb 2013 16:07:59 -0800
Message-Id: <20130226235918.195820918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7a3cf6ca1ab2a2f7161c6dec5a787fc7a5de864e upstream

This patch fixes a possible divide by zero bug when the fabric_max_sectors
device attribute is written and backend se_device failed to be successfully
configured -> enabled.

Go ahead and use block_size=512 within se_dev_set_fabric_max_sectors()
in the event of a target_configure_device() failure case, as no valid
dev->dev_attrib.block_size value will have been setup yet.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1230,6 +1230,8 @@ int se_dev_set_max_sectors(struct se_dev
 
 int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 {
+	int block_size = dev->se_sub_dev->se_dev_attrib.block_size;
+
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
 		pr_err("dev[%p]: Unable to change SE Device"
 			" fabric_max_sectors while dev_export_obj: %d count exists\n",
@@ -1267,8 +1269,12 @@ int se_dev_set_fabric_max_sectors(struct
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


