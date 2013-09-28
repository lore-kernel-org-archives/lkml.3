Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3I1N4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:56:22 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62411 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3I1Nza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:30 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/7] UBI: Call scan_all() with correct offset in error case
Date: Sat, 28 Sep 2013 15:55:12 +0200
Message-Id: <1380376516-30144-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find an invalid fastmap we have to scan from the very beginning.
Otherwise we leak the first 64 PEBs.

Reported-and-tested-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index c071d41..03b32b0 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1417,9 +1417,11 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 				ai = alloc_ai("ubi_aeb_slab_cache2");
 				if (!ai)
 					return -ENOMEM;
-			}
 
-			err = scan_all(ubi, ai, UBI_FM_MAX_START);
+				err = scan_all(ubi, ai, 0);
+			} else {
+				err = scan_all(ubi, ai, UBI_FM_MAX_START);
+			}
 		}
 	}
 #else
-- 
1.8.3.1

