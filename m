Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3KNQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:18 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58280 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3KNQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:29 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 16/40] staging/lustre/lov: convert magic to host-endian in lov_dump_lmm()
Date: Fri, 15 Nov 2013 00:13:18 +0800
Message-Id: <1384445622-12346-17-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In lov_dump_lmm(), convert the lmm_magic from little-endian to
host-endian byte order before the switch statement, as the other
lov_dump_xxx() and lov_verify_xxx() functions already do.  Remove the
unused macro LMM_ASSERT().

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3297
Lustre-change: http://review.whamcloud.com/6290
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Li Wei <wei.g.li@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lov/lov_pack.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index ec6f6e0..27ed27e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -105,24 +105,22 @@ void lov_dump_lmm(int level, void *lmm)
 {
 	int magic;
 
-	magic = ((struct lov_mds_md_v1 *)(lmm))->lmm_magic;
+	magic = le32_to_cpu(((struct lov_mds_md *)lmm)->lmm_magic);
 	switch (magic) {
 	case LOV_MAGIC_V1:
-		return lov_dump_lmm_v1(level, (struct lov_mds_md_v1 *)(lmm));
+		lov_dump_lmm_v1(level, (struct lov_mds_md_v1 *)lmm);
+		break;
 	case LOV_MAGIC_V3:
-		return lov_dump_lmm_v3(level, (struct lov_mds_md_v3 *)(lmm));
+		lov_dump_lmm_v3(level, (struct lov_mds_md_v3 *)lmm);
+		break;
 	default:
-		CERROR("Cannot recognize lmm_magic %x", magic);
+		CDEBUG(level, "unrecognized lmm_magic %x, assuming %x\n",
+		       magic, LOV_MAGIC_V1);
+		lov_dump_lmm_common(level, lmm);
+		break;
 	}
-	return;
 }
 
-#define LMM_ASSERT(test)						\
-do {								    \
-	if (!(test)) lov_dump_lmm(D_ERROR, lmm);			\
-	LASSERT(test); /* so we know what assertion failed */	   \
-} while (0)
-
 /* Pack LOV object metadata for disk storage.  It is packed in LE byte
  * order and is opaque to the networking layer.
  *
-- 
1.7.9.5

