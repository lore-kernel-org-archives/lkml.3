Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030979Ab3DSQlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:41:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53300 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967882Ab3DSQlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:41:08 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com,
        James.Bottomley@HansenPartnership.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 3/9] sd: use generic helper to set max_discard_sectors
Date: Sat, 20 Apr 2013 01:41:00 +0900
Message-Id: <1366389660-19417-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

It is better to use blk_queue_max_discard_sectors helper
function to set max_discard_sectors as it checks
max_discard_sectors upper limit UINT_MAX >> 9

similar issue was reported for mmc in below link
https://lkml.org/lkml/2013/4/1/292

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..93c26b3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -632,7 +632,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 	}
 
-	q->limits.max_discard_sectors = max_blocks * (logical_block_size >> 9);
+	blk_queue_max_discard_sectors(q,
+				max_blocks * (logical_block_size >> 9));
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
-- 
1.7.9.5

