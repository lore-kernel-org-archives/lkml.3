Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbbAVLVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:21:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:21:44 -0500
From: Colin King <colin.king@canonical.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scsi_debug: test always evaluates to false, || should be used instead
Date: Thu, 22 Jan 2015 11:20:40 +0000
Message-Id: <1421925640-9894-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck found the following issue:
(warning) Logical conjunction always evaluates to false:
  alloc_len < 4 && alloc_len > 65535.

..the test should be instead:

  if (alloc_len < 4 || alloc_len > 65536)

This error was introduced by recent commit 38d5c8336e60bf6e53a1da9
("scsi_debug: add Report supported opcodes+tmfs; Compare and write")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7b8b51b..63a2e1f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1623,7 +1623,7 @@ resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	req_opcode = cmd[3];
 	req_sa = get_unaligned_be16(cmd + 4);
 	alloc_len = get_unaligned_be32(cmd + 6);
-	if (alloc_len < 4 && alloc_len > 0xffff) {
+	if (alloc_len < 4 || alloc_len > 0xffff) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
 	}
-- 
2.1.4

