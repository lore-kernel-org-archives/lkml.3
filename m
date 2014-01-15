Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaAOWKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:10:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41337 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaAOV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 096/166] target/file: Update hw_max_sectors based on current block_size
Date: Wed, 15 Jan 2014 13:51:50 -0800
Message-Id: <1389822780-4729-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 95cadace8f3959282e76ebf8b382bd0930807d2c upstream.

This patch allows FILEIO to update hw_max_sectors based on the current
max_bytes_per_io.  This is required because vfs_[writev,readv]() can accept
a maximum of 2048 iovecs per call, so the enforced hw_max_sectors really
needs to be calculated based on block_size.

This addresses a >= v3.5 bug where block_size=512 was rejecting > 1M
sized I/O requests, because FD_MAX_SECTORS was hardcoded to 2048 for
the block_size=4096 case.

(v2: Use max_bytes_per_io instead of ->update_hw_max_sectors)

Reported-by: Henrik Goldman <hg@x-formation.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_device.c | 5 +++++
 drivers/target/target_core_file.c   | 8 ++++----
 drivers/target/target_core_file.h   | 5 ++++-
 include/target/target_core_base.h   | 1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 96f4981..c461180 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1048,6 +1048,11 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 	dev->dev_attrib.block_size = block_size;
 	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
 			dev, block_size);
+
+	if (dev->dev_attrib.max_bytes_per_io)
+		dev->dev_attrib.hw_max_sectors =
+			dev->dev_attrib.max_bytes_per_io / block_size;
+
 	return 0;
 }
 
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 89aa3b2a..9bfe625 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -64,9 +64,8 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 	pr_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
 		" Target Core Stack %s\n", hba->hba_id, FD_VERSION,
 		TARGET_CORE_MOD_VERSION);
-	pr_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic"
-		" MaxSectors: %u\n",
-		hba->hba_id, fd_host->fd_host_id, FD_MAX_SECTORS);
+	pr_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic\n",
+		hba->hba_id, fd_host->fd_host_id);
 
 	return 0;
 }
@@ -174,7 +173,8 @@ static int fd_configure_device(struct se_device *dev)
 	fd_dev->fd_block_size = dev->dev_attrib.hw_block_size;
 
 	dev->dev_attrib.hw_block_size = FD_BLOCKSIZE;
-	dev->dev_attrib.hw_max_sectors = FD_MAX_SECTORS;
+	dev->dev_attrib.max_bytes_per_io = FD_MAX_BYTES;
+	dev->dev_attrib.hw_max_sectors = FD_MAX_BYTES / fd_dev->fd_block_size;
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 37ffc5b..d7772c1 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -7,7 +7,10 @@
 #define FD_DEVICE_QUEUE_DEPTH	32
 #define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
-#define FD_MAX_SECTORS		2048
+/*
+ * Limited by the number of iovecs (2048) per vfs_[writev,readv] call
+ */
+#define FD_MAX_BYTES		8388608
 
 #define RRF_EMULATE_CDB		0x01
 #define RRF_GOT_LBA		0x02
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 663e34a..55bf359 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -615,6 +615,7 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		max_bytes_per_io;
 	struct se_device *da_dev;
 	struct config_group da_group;
 };
-- 
1.8.3.2

