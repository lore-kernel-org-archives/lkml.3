Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaBEUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:54121 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBEUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "George G. Davis" <george_davis@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 002/213] udf: fix udf_error build warnings
Date: Wed, 5 Feb 2014 14:59:17 -0500
Message-ID: <1391630568-49251-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "George G. Davis" <george_davis@mentor.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

The v2.6.34.14 commit "d7542a6 udf: Avoid run away loop when partition
table length is corrupted" introduced the following build warning due
to a change in the number of args in udf_error/udf_err for v2.6.34.14:

 CC      fs/udf/super.o
fs/udf/super.c: In function 'udf_load_sparable_map':
fs/udf/super.c:1259: warning: passing argument 3 of 'udf_error' makes pointer from integer without a cast
fs/udf/super.c:1265: warning: passing argument 3 of 'udf_error' makes pointer from integer without a cast
fs/udf/super.c: In function 'udf_load_logicalvol':
fs/udf/super.c:1313: warning: passing argument 3 of 'udf_error' makes pointer from integer without a cast

The above warnings are due to a missing __func__ argument in the above
udf_error function calls.  This is because of commit 8076c363da15e7
("udf: Rename udf_error to udf_err") which removed the __func__ arg.

Restore the missing __func__ argument to fix the build warnings.

Signed-off-by: George G. Davis <george_davis@mentor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1d36fdd4ae56..5ece6d6721f8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1254,13 +1254,15 @@ static int udf_load_sparable_map(struct super_block *sb,
 	map->s_partition_type = UDF_SPARABLE_MAP15;
 	sdata->s_packet_len = le16_to_cpu(spm->packetLength);
 	if (!is_power_of_2(sdata->s_packet_len)) {
-		udf_error(sb, "error loading logical volume descriptor: "
+		udf_error(sb, __func__,
+			  "error loading logical volume descriptor: "
 			  "Invalid packet length %u\n",
 			  (unsigned)sdata->s_packet_len);
 		return -EIO;
 	}
 	if (spm->numSparingTables > 4) {
-		udf_error(sb, "error loading logical volume descriptor: "
+		udf_error(sb, __func__,
+			  "error loading logical volume descriptor: "
 			  "Too many sparing tables (%d)\n",
 			  (int)spm->numSparingTables);
 		return -EIO;
@@ -1308,7 +1310,8 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	lvd = (struct logicalVolDesc *)bh->b_data;
 	table_len = le32_to_cpu(lvd->mapTableLength);
 	if (table_len > sb->s_blocksize - sizeof(*lvd)) {
-		udf_error(sb, "error loading logical volume descriptor: "
+		udf_error(sb, __func__,
+			  "error loading logical volume descriptor: "
 			  "Partition table too long (%u > %lu)\n", table_len,
 			  sb->s_blocksize - sizeof(*lvd));
 		goto out_bh;
-- 
1.8.5.2

