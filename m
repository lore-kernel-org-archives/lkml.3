Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3IYUcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:32:17 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755305Ab3IYUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:32:16 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, richard.genoud@gmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] UBI: Call scan_all() with correct offset in error case
Date: Wed, 25 Sep 2013 22:32:05 +0200
Message-Id: <1380141125-11063-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380141125-11063-1-git-send-email-richard@nod.at>
References: <1380141125-11063-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find an invalid fastmap we have to scan from the very beginning.
Otherwise we leak the first 64 PEBs.

Reported-by: Richard Genoud <richard.genoud@gmail.com>
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
1.8.1.4

