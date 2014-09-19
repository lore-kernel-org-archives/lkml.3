Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaISPiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:38:09 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbaISPiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:38:06 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: Fix livelock in produce_free_peb()
Date: Fri, 19 Sep 2014 17:37:56 +0200
Message-Id: <1411141076-21489-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The while loop in produce_free_peb() assumes that each work will produce a
free PEB. This is not true.
If ubi->works_count is 1 and the only scheduled work is the
wear_leveling_worker() produce_free_peb() can loop forever in case
nobody schedules an erase work.
Fix this issue by checking in the while loop whether work is scheduled.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 0509c8a..6add739 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -272,7 +272,7 @@ static int produce_free_peb(struct ubi_device *ubi)
 {
 	int err;
 
-	while (!ubi->free.rb_node) {
+	while (!ubi->free.rb_node && ubi->works_count) {
 		spin_unlock(&ubi->wl_lock);
 
 		dbg_wl("do one work synchronously");
-- 
1.8.4.5

