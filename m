Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3G3JwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:52:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab3G3Jcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andi Kleen <ak@linux.intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/106] [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Tue, 30 Jul 2013 10:30:58 +0100
Message-Id: <1375176725-5825-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 16da05b1158d1bcb31656e636a8736a663b1cf1f upstream.

gcc 4.8 warns because the memset only clears sizeof(char *) bytes, not
the whole buffer. Use the correct buffer size and clear the whole sense
buffer.

/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c: In
function 'bnx2fc_parse_fcp_rsp':
/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c:1810:41:
warning: argument to 'sizeof' in 'memset' call is the same expression as
the destination; did you mean to provide an explicit length?
[-Wsizeof-pointer-memaccess]
   memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
                                         ^

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4f7453b..557cfd3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1814,7 +1814,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 
-- 
1.8.3.2

