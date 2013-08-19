Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab3HSGs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:48:29 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862Ab3HSGs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:48:27 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        <stable@vger.kernel.org>
Subject: [PATCH] UBI: Fix PEB leak in wear_leveling_worker()
Date: Mon, 19 Aug 2013 08:48:12 +0200
Message-Id: <1376894892-31519-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_peb_for_wl() removes the PEB from the free list.
If the WL subsystem detects that no wear leveling is needed
it cancels the operation and drops the gained PEB.
In this case we have to put the PEB back into the free list.

This issue was introduced with commit ed4b7021c
(UBI: remove PEB from free tree in get_peb_for_wl()).

Cc: <stable@vger.kernel.org> # 3.7.x
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 5df49d3..c95bfb1 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1069,6 +1069,9 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD)) {
 			dbg_wl("no WL needed: min used EC %d, max free EC %d",
 			       e1->ec, e2->ec);
+
+			/* Give the unused PEB back */
+			wl_tree_add(e2, &ubi->free);
 			goto out_cancel;
 		}
 		self_check_in_wl_tree(ubi, e1, &ubi->used);
-- 
1.8.1.4

