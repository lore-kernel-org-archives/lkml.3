Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaANAzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:55:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaANA1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nix <nix@esperi.org.uk>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 56/62] SCSI: sd: Reduce buffer size for vpd request
Date: Mon, 13 Jan 2014 16:27:21 -0800
Message-Id: <20140114002712.055839616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2634,13 +2634,16 @@ static void sd_read_write_same(struct sc
 	}
 
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
 


