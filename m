Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3L2V7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:59:36 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31758 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab3L2Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:52 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832524"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/25] UBI: fix error return code
Date: Sun, 29 Dec 2013 23:47:19 +0100
Message-Id: <1388357260-4843-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/mtd/ubi/attach.c |    4 +++-
 drivers/mtd/ubi/build.c  |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 33bb1f2..6f27d9a 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1453,8 +1453,10 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		struct ubi_attach_info *scan_ai;
 
 		scan_ai = alloc_ai("ubi_ckh_aeb_slab_cache");
-		if (!scan_ai)
+		if (!scan_ai) {
+			err = -ENOMEM;
 			goto out_wl;
+		}
 
 		err = scan_all(ubi, scan_ai, 0);
 		if (err) {
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index e05dc62..57deae9 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1245,8 +1245,10 @@ static int __init ubi_init(void)
 	ubi_wl_entry_slab = kmem_cache_create("ubi_wl_entry_slab",
 					      sizeof(struct ubi_wl_entry),
 					      0, 0, NULL);
-	if (!ubi_wl_entry_slab)
+	if (!ubi_wl_entry_slab) {
+		err = -ENOMEM;
 		goto out_dev_unreg;
+	}
 
 	err = ubi_debugfs_init();
 	if (err)

