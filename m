Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3C2PyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:54:09 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:62686 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3C2PyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:54:07 -0400
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Mar 2013 11:54:07 EDT
From: Gwendal Grignou <gwendal@google.com>
To: ronald645@gmail.com
Cc: krzysiek@podlesie.net, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@google.com>
Subject: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Date: Fri, 29 Mar 2013 08:26:41 -0700
Message-Id: <1364570801-6515-1-git-send-email-gwendal@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
References: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63 changed the sense key
used for returning task registers, but HDIO_DRIVE_CMD ioctl was
not changed accordingly.

Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
instead of EIO.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 318b413..e05bf4c 100644
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
 
-- 
1.8.1.3

