Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaBEUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:16:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:55582 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaBEUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Nikola Pajkovsky <npajkovs@redhat.com>, Jan Kara <jack@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 190/213] udf: fix retun value on error path in udf_load_logicalvol
Date: Wed, 5 Feb 2014 15:02:25 -0500
Message-ID: <1391630568-49251-191-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikola Pajkovsky <npajkovs@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 68766a2edcd5cd744262a70a2f67a320ac944760 upstream.

In case we detect a problem and bail out, we fail to set "ret" to a
nonzero value, and udf_load_logicalvol will mistakenly report success.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5ece6d6721f8..325d4d6856b1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1314,6 +1314,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 			  "error loading logical volume descriptor: "
 			  "Partition table too long (%u > %lu)\n", table_len,
 			  sb->s_blocksize - sizeof(*lvd));
+		ret = 1;
 		goto out_bh;
 	}
 
@@ -1360,8 +1361,10 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
 				if (udf_load_sparable_map(sb, map,
-				    (struct sparablePartitionMap *)gpm) < 0)
+				    (struct sparablePartitionMap *)gpm) < 0) {
+					ret = 1;
 					goto out_bh;
+				}
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
-- 
1.8.5.2

