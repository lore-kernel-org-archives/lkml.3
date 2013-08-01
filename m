Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3HAOeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:34:20 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:32834 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3HAOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:34:17 -0400
Message-ID: <51FA71E2.6010501@fastmail.fm>
Date: Thu, 01 Aug 2013 16:34:10 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Nix <nix@esperi.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi disk: Use its own buffer for the vpd request
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
In-Reply-To: <51F95A2E.60805@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once I noticed that scsi_get_vpd_page() works fine from other function
calls and that it is not 0x89, but already 0x0 that fails fixing it became
easy.

Nix, any chance you could verify it also works for you?


From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Somehow older areca firmware versions have issues with
scsi_get_vpd_page() and a large buffer.
Even scsi_get_vpd_page(, page=0,)  failed in sd_read_write_same(),
while a similar request from sd_read_block_limits() worked fine.
Limiting the buf-size to 64-bytes fixes the issue with F/W V1.46.

Fixes a regression with areca controllers and older firmware versions
introduced by commit: 66c28f97120e8a621afd5aa7a31c4b85c547d33d

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: stable@vger.kernel.org
---
 drivers/scsi/sd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 80f39b8..02e50ae 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2651,13 +2651,16 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
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
 

