Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaFXHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:25:26 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36127 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaFXHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:25:25 -0400
X-Auth-Info: uljASq7ZkCqtqY+H2xS7hzHpIwLIB5zpGWyrhmutZdk=
From: Heiko Schocher <hs@denx.de>
To: linux-mtd@lists.infradead.org
Cc: Heiko Schocher <hs@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Wolfgang Denk <wd@denx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ubi: fix correct rb_tree node comparison in add_vol
Date: Tue, 24 Jun 2014 09:25:18 +0200
Message-Id: <1403594718-20595-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 604b592e6fd3c98f21435e1181ba7723ffc24715 ("UBI: fix rb_tree node comparison in add_map")

introduced problems with attaching ubi fastmap images,
created with older kernel.

As in ubi_find_av() from attach.c is
[...]
                if (vol_id > av->vol_id)
                        p = p->rb_left;
                else
                        p = p->rb_right;

sync this logic also in add_vol() with this.

With this patch attaching older ubi images works again.

Signed-off-by: Heiko Schocher <hs@denx.de>

---

Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Wolfgang Denk <wd@denx.de>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

 drivers/mtd/ubi/fastmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index b04e7d0..72f39da 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -125,7 +125,7 @@ static struct ubi_ainf_volume *add_vol(struct ubi_attach_info *ai, int vol_id,
 		parent = *p;
 		av = rb_entry(parent, struct ubi_ainf_volume, rb);
 
-		if (vol_id < av->vol_id)
+		if (vol_id > av->vol_id)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-- 
1.8.3.1

