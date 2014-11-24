Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKXNX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:23:57 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaKXNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] UBI: Fastmap: Care about the protection queue
Date: Mon, 24 Nov 2014 14:20:31 +0100
Message-Id: <1416835236-25185-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1416835236-25185-1-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
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
index b56672b..db3defd 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1196,6 +1196,19 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
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
1.8.4.5

