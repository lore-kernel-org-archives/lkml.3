Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3I0MwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:52:23 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53081 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3I0MwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:52:21 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: fastmap: fix backward compatibility with image_seq
Date: Fri, 27 Sep 2013 14:51:55 +0200
Message-Id: <1380286316-29911-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some old UBI implementations (e.g. U-Boot) have not implemented the image
sequence feature.
So, when erase blocks are written, the image sequence in the ec header
is lost (set to zero).
UBI scan_all() takes this case into account (commits
32bc4820287a1a03982979515949e8ea56eac641 and
2eadaad67b2b6bd132eda105128d2d466298b8e3)

But fastmap scan functions (ubi_scan_fastmap() and scan_pool()) didn't.

This patch fixes the issue.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/fastmap.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 9b42add..05067f5 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -407,6 +407,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	 */
 	for (i = 0; i < pool_size; i++) {
 		int scrub = 0;
+		int image_seq;
 
 		pnum = be32_to_cpu(pebs[i]);
 
@@ -425,7 +426,13 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		} else if (ret == UBI_IO_BITFLIPS)
 			scrub = 1;
 
-		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
+		/*
+		 * Older UBI implementations have image_seq set to zero, so
+		 * we shouldn't fail if image_seq == 0.
+		 */
+		image_seq = be32_to_cpu(ech->image_seq);
+
+		if (image_seq && (image_seq != ubi->image_seq)) {
 			ubi_err("bad image seq: 0x%x, expected: 0x%x",
 				be32_to_cpu(ech->image_seq), ubi->image_seq);
 			ret = UBI_BAD_FASTMAP;
@@ -923,6 +930,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	}
 
 	for (i = 0; i < used_blocks; i++) {
+		int image_seq;
+
 		pnum = be32_to_cpu(fmsb->block_loc[i]);
 
 		if (ubi_io_is_bad(ubi, pnum)) {
@@ -940,10 +949,17 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		} else if (ret == UBI_IO_BITFLIPS)
 			fm->to_be_tortured[i] = 1;
 
+		image_seq = be32_to_cpu(ech->image_seq);
 		if (!ubi->image_seq)
-			ubi->image_seq = be32_to_cpu(ech->image_seq);
+			ubi->image_seq = image_seq;
 
-		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
+		/*
+		 * Older UBI implementations have image_seq set to zero, so
+		 * we shouldn't fail if image_seq == 0.
+		 */
+		if (image_seq && (image_seq != ubi->image_seq)) {
+			ubi_err("wrong image seq:%d instead of %d",
+				be32_to_cpu(ech->image_seq), ubi->image_seq);
 			ret = UBI_BAD_FASTMAP;
 			goto free_hdr;
 		}
-- 
1.7.10.4

