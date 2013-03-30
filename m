Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3C3VtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 17:49:24 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63714 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3C3VtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 17:49:23 -0400
From: Gwendal Grignou <gwendal@google.com>
To: ronald645@gmail.com
Cc: krzysiek@podlesie.net, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Gwendal Grignou <gwendal@google.com>
Subject: [PATCH v3] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Date: Sat, 30 Mar 2013 14:43:49 -0700
Message-Id: <1364679829-13607-1-git-send-email-gwendal@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <5155F320.2020004@cogentembedded.com>
References: <5155F320.2020004@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 84a9a8 "Set proper SK when CK_COND is set" changed the sense key
used for returning task registers, but HDIO_DRIVE_CMD ioctl was
not changed accordingly.

Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
instead of EIO.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 318b413..5eae74b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 					     &sshdr);
-			if (sshdr.sense_key == 0 &&
-			    sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1D)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -618,8 +618,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 						&sshdr);
-			if (sshdr.sense_key == 0 &&
-				sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1D)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
-- 
1.8.1.3

