Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3LFXYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:24:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423032Ab3LFXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 023/152] [SCSI] sd: Reduce buffer size for vpd request
Date: Fri,  6 Dec 2013 15:09:07 -0800
Message-Id: <1386371476-2477-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit af73623f5f10eb3832c87a169b28f7df040a875b upstream.

Somehow older areca firmware versions have issues with
scsi_get_vpd_page() and a large buffer, the firmware
seems to crash and the scsi error-handler will start endless
recovery retries.
Limiting the buf-size to 64-bytes fixes this issue with older
firmware versions (<1.49 for my controller).

Fixes a regression with areca controllers and older firmware versions
introduced by commit: 66c28f97120e8a621afd5aa7a31c4b85c547d33d

Reported-by: Nix <nix@esperi.org.uk>
Tested-by: Nix <nix@esperi.org.uk>
Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/sd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bc108d2..a4dc067 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2640,13 +2640,16 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_device *sdev = sdkp->device;
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+		/* too large values might cause issues with arcmsr */
+		int vpd_buf_len = 64;
+
 		sdev->no_report_opcodes = 1;
 
 		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
 			sdev->no_write_same = 1;
 	}
 
-- 
1.8.3.2

