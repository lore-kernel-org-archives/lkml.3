Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbbAJIxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:53:09 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54387 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbAJIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:53:07 -0500
Date: Sat, 10 Jan 2015 14:22:59 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: matthew.r.wilcox@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, axboe@fb.com
Subject: [PATCH v2] NVMe: Use put_unaligned_be64
Message-ID: <20150110085259.GA3120@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of function put_unaligned_be64.

This is done using Coccinelle and semantic patch used is as follows:

@a@
typedef u64, __be64, uint64_t;
{u64,__be64,uint64_t} e64;
identifier tmp;
expression ptr;
expression y,e;
type T;
@@

- tmp = cpu_to_be64(y);

<+... when != tmp
(
- memcpy(ptr, (T)&tmp, \(8\|sizeof(u64)\|sizeof(__be64)\|sizeof(uint64_t)\|sizeof(e64)\));
+ put_unaligned_be64(y,ptr);
|
- memcpy(ptr, (T)&tmp, ...);
+ put_unaligned_be64(y,ptr);
)
...+>
? tmp = e

@@ type T; identifier a.tmp; @@

- T tmp;
...when != tmp

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
--
Changes in v2:
   -Shorten commit message and change subject line
   -<asm/unaligned.h>  has arch-specific knowlege of which of
    the implementations needs to be used. So, include it instaed
    of <linux/unaligned/access_ok.h>.

 drivers/block/nvme-scsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index 5e78568..12893ef 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -43,6 +43,7 @@
 #include <linux/types.h>
 #include <scsi/sg.h>
 #include <scsi/scsi.h>
+#include <asm/unaligned.h>
 
 
 static int sg_version_num = 30534;	/* 2 digits for each component */
@@ -1417,7 +1418,6 @@ static void nvme_trans_fill_read_cap(u8 *response, struct nvme_id_ns *id_ns,
 	u64 rlba;
 	u8 prot_en;
 	u8 p_type_lut[4] = {0, 0, 1, 2};
-	__be64 tmp_rlba;
 	__be32 tmp_rlba_32;
 	__be32 tmp_len;
 
@@ -1434,9 +1434,8 @@ static void nvme_trans_fill_read_cap(u8 *response, struct nvme_id_ns *id_ns,
 		memcpy(response, &tmp_rlba_32, sizeof(u32));
 		memcpy(&response[4], &tmp_len, sizeof(u32));
 	} else {
-		tmp_rlba = cpu_to_be64(rlba);
 		tmp_len = cpu_to_be32(lba_length);
-		memcpy(response, &tmp_rlba, sizeof(u64));
+		put_unaligned_be64(rlba, response);
 		memcpy(&response[8], &tmp_len, sizeof(u32));
 		response[12] = (p_type_lut[id_ns->dps & 0x3] << 1) | prot_en;
 		/* P_I_Exponent = 0x0 | LBPPBE = 0x0 */
-- 
1.9.1

