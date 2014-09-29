Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaI2WVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:21:05 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaI2WU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:20:59 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
Date: Tue, 30 Sep 2014 00:20:47 +0200
Message-Id: <1412029248-22454-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412029248-22454-1-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fastmap can miss a PEB if it is in the protection queue
and not jet in the used tree.
Treat every protected PEB as used.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2b0d8d6..2853a69 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1195,6 +1195,19 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		fm_pos += sizeof(*fec);
 		ubi_assert(fm_pos <= ubi->fm_size);
 	}
+
+	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
+		list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
+			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+
+			fec->pnum = cpu_to_be32(wl_e->pnum);
+			fec->ec = cpu_to_be32(wl_e->ec);
+
+			used_peb_count++;
+			fm_pos += sizeof(*fec);
+			ubi_assert(fm_pos <= ubi->fm_size);
+		}
+	}
 	fmh->used_peb_count = cpu_to_be32(used_peb_count);
 
 	for (node = rb_first(&ubi->scrub); node; node = rb_next(node)) {
-- 
2.1.0

