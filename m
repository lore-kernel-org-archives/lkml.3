Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaK3MWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:22:49 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaK3MWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:22:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/4] UBI: Fastmap: Optimize anchor PEB search
Date: Sun, 30 Nov 2014 13:22:37 +0100
Message-Id: <1417350157-9373-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417350157-9373-1-git-send-email-richard@nod.at>
References: <1417350157-9373-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UBI RB trees are sorted by the PEB number, hence
we don't have to traverse the whole tree because ubi_rb_for_each_entry()
walks the tree in sort order.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index b2a6653..c7ad2a7 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -39,7 +39,10 @@ static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
 	int max_ec = UBI_MAX_ERASECOUNTER;
 
 	ubi_rb_for_each_entry(p, e, root, u.rb) {
-		if (e->pnum < UBI_FM_MAX_START && e->ec < max_ec) {
+		if (e->pnum >= UBI_FM_MAX_START)
+			break;
+
+		if (e->ec < max_ec) {
 			victim = e;
 			max_ec = e->ec;
 		}
@@ -74,6 +77,8 @@ static int anchor_pebs_avalible(struct rb_root *root)
 	ubi_rb_for_each_entry(p, e, root, u.rb)
 		if (e->pnum < UBI_FM_MAX_START)
 			return 1;
+		else
+			break;
 
 	return 0;
 }
-- 
1.8.4.5

