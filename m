Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaJ2MxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:53:07 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbaJ2MqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:14 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/35] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
Date: Wed, 29 Oct 2014 13:45:34 +0100
Message-Id: <1414586758-9972-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to allocate new ones every time, we can reuse
the existing ones.
This makes the code cleaner and more easy to follow.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 31 +++++--------------------------
 drivers/mtd/ubi/wl.c      | 11 +++++++----
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8cce6f8..09a97ad 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1529,19 +1529,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	new_fm->used_blocks = ubi->fm_size / ubi->leb_size;
-
-	for (i = 0; i < new_fm->used_blocks; i++) {
-		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
-		if (!new_fm->e[i]) {
-			while (i--)
-				kfree(new_fm->e[i]);
-
-			kfree(new_fm);
-			mutex_unlock(&ubi->fm_mutex);
-			return -ENOMEM;
-		}
-	}
-
 	old_fm = ubi->fm;
 	ubi->fm = NULL;
 
@@ -1577,12 +1564,9 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				ubi_err("could not erase old fastmap PEB");
 				goto err;
 			}
-
-			new_fm->e[i]->pnum = old_fm->e[i]->pnum;
-			new_fm->e[i]->ec = old_fm->e[i]->ec;
+			new_fm->e[i] = old_fm->e[i];
 		} else {
-			new_fm->e[i]->pnum = tmp_e->pnum;
-			new_fm->e[i]->ec = tmp_e->ec;
+			new_fm->e[i] = tmp_e;
 
 			if (old_fm)
 				ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
@@ -1607,16 +1591,13 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 							  i, 0);
 				goto err;
 			}
-
-			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
+			new_fm->e[0] = old_fm->e[0];
 			new_fm->e[0]->ec = ret;
 		} else {
 			/* we've got a new anchor PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0,
 					  old_fm->to_be_tortured[0]);
-
-			new_fm->e[0]->pnum = tmp_e->pnum;
-			new_fm->e[0]->ec = tmp_e->ec;
+			new_fm->e[0] = tmp_e;
 		}
 	} else {
 		if (!tmp_e) {
@@ -1629,9 +1610,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			ret = -ENOSPC;
 			goto err;
 		}
-
-		new_fm->e[0]->pnum = tmp_e->pnum;
-		new_fm->e[0]->ec = tmp_e->ec;
+		new_fm->e[0] = tmp_e;
 	}
 
 	down_write(&ubi->work_sem);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 73ff40a..ac19f75 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -995,9 +995,6 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 		e = fm_e;
 		ubi_assert(e->ec >= 0);
 		ubi->lookuptbl[pnum] = e;
-	} else {
-		e->ec = fm_e->ec;
-		kfree(fm_e);
 	}
 
 	spin_unlock(&ubi->wl_lock);
@@ -1999,9 +1996,15 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	dbg_wl("found %i PEBs", found_pebs);
 
-	if (ubi->fm)
+	if (ubi->fm) {
 		ubi_assert(ubi->good_peb_count == \
 			   found_pebs + ubi->fm->used_blocks);
+
+		for (i = 0; i < ubi->fm->used_blocks; i++) {
+			e = ubi->fm->e[i];
+			ubi->lookuptbl[e->pnum] = e;
+		}
+	}
 	else
 		ubi_assert(ubi->good_peb_count == found_pebs);
 
-- 
1.8.4.5

