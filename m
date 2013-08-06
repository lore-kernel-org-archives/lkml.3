Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3HFG07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:26:59 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3HFG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:26:58 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Weber <thomas@tomweber.eu>, wang bo <wang.bo116@zte.com.cn>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: Fastmap: Fix memory leak
Date: Tue,  6 Aug 2013 08:26:43 +0200
Message-Id: <1375770403-32762-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Weber <thomas@tomweber.eu>

Tested with linux-v3.10-rc3 on Devkit8000.

The discussion about this patch can be found:
https://lkml.org/lkml/2013/5/2/118

This patches fixes the following bug for me:
When CONFIG_DEBUG_VM is active and making
ubiattach ... ; ubidetach...; ubiattach ...
the second ubiattach stops with:

[   37.918304] UBI: default fastmap pool size: 95
[   37.923004] UBI: default fastmap WL pool size: 25
[   37.928741] UBI: attaching mtd4 to ubi0
[   37.933197] kmem_cache_sanity_check (ubi_aeb_slab_cache): Cache name already exists.
[   37.941864] CPU: 0 PID: 757 Comm: ubiattach Not tainted 3.10.0-rc3 #66
[   37.949066] [<c0013d90>] (unwind_backtrace+0x0/0xec) from [<c0011660>] (show_stack+0x20/0x24)
[   37.958343] [<c0011660>] (show_stack+0x20/0x24) from [<c041527c>] (dump_stack+0x20/0x28)
[   37.967163] [<c041527c>] (dump_stack+0x20/0x28) from [<c00d70b4>] (kmem_cache_create_memcg+0x120/0x2a4)
[   37.977478] [<c00d70b4>] (kmem_cache_create_memcg+0x120/0x2a4) from [<c00d7280>] (kmem_cache_create+0x48/0x50)
[   37.988281] [<c00d7280>] (kmem_cache_create+0x48/0x50) from [<c02fa090>] (alloc_ai+0x84/0xb0)
[   37.997528] [<c02fa090>] (alloc_ai+0x84/0xb0) from [<c02fbde4>] (ubi_attach+0x28/0x34c)
[   38.006225] [<c02fbde4>] (ubi_attach+0x28/0x34c) from [<c02f07c8>] (ubi_attach_mtd_dev+0x69c/0xca4)
[   38.016021] [<c02f07c8>] (ubi_attach_mtd_dev+0x69c/0xca4) from [<c02f1078>] (ctrl_cdev_ioctl+0xe4/0x190)
[   38.026275] [<c02f1078>] (ctrl_cdev_ioctl+0xe4/0x190) from [<c00fee00>] (do_vfs_ioctl+0x554/0x5c4)
[   38.035980] [<c00fee00>] (do_vfs_ioctl+0x554/0x5c4) from [<c00feebc>] (SyS_ioctl+0x4c/0x6c)
[   38.045043] [<c00feebc>] (SyS_ioctl+0x4c/0x6c) from [<c000dca0>] (ret_fast_syscall+0x0/0x48)
[   38.054168] UBI error: ubi_attach_mtd_dev: failed to attach mtd4, error -12
ubiattach: error!: cannot attach "/dev/mtd4"
           error 12 (Cannot allocate memory)

Signed-off-by: wang bo <wang.bo116@zte.com.cn>
Signed-off-by: Thomas Weber <thomas@tomweber.eu>
[Thomas: fix whitespace errors]
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index c071d41..e9f64bc 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1212,6 +1212,30 @@ static void destroy_ai(struct ubi_attach_info *ai)
 	kfree(ai);
 }
 
+static struct ubi_attach_info *alloc_ai(const char *slab_name)
+{
+	struct ubi_attach_info *ai;
+
+	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (!ai)
+		return ai;
+
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+	ai->aeb_slab_cache = kmem_cache_create(slab_name,
+					       sizeof(struct ubi_ainf_peb),
+					       0, 0, NULL);
+	if (!ai->aeb_slab_cache) {
+		kfree(ai);
+		ai = NULL;
+	}
+
+	return ai;
+}
+
 /**
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
@@ -1315,8 +1339,13 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	int err, pnum, fm_anchor = -1;
 	unsigned long long max_sqnum = 0;
 
+	struct ubi_attach_info *fm_temp_ai = NULL;
 	err = -ENOMEM;
 
+	fm_temp_ai = alloc_ai("ubi_scan_fastmap_slab_cache");
+	if (!fm_temp_ai)
+		goto out;
+
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
 		goto out;
@@ -1331,7 +1360,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		cond_resched();
 
 		dbg_gen("process PEB %d", pnum);
-		err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum);
+		err = scan_peb(ubi, fm_temp_ai, pnum, &vol_id, &sqnum);
 		if (err < 0)
 			goto out_vidh;
 
@@ -1343,6 +1372,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	ubi_free_vid_hdr(ubi, vidh);
 	kfree(ech);
+	destroy_ai(fm_temp_ai);
 
 	if (fm_anchor < 0)
 		return UBI_NO_FASTMAP;
@@ -1351,6 +1381,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
+	destroy_ai(fm_temp_ai);
 out_ech:
 	kfree(ech);
 out:
@@ -1359,29 +1390,6 @@ out:
 
 #endif
 
-static struct ubi_attach_info *alloc_ai(const char *slab_name)
-{
-	struct ubi_attach_info *ai;
-
-	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-	if (!ai)
-		return ai;
-
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
-	ai->aeb_slab_cache = kmem_cache_create(slab_name,
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache) {
-		kfree(ai);
-		ai = NULL;
-	}
-
-	return ai;
-}
 
 /**
  * ubi_attach - attach an MTD device.
@@ -1419,7 +1427,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 					return -ENOMEM;
 			}
 
-			err = scan_all(ubi, ai, UBI_FM_MAX_START);
+			err = scan_all(ubi, ai, 0);
 		}
 	}
 #else
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 1542751..6935f0c 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -552,21 +552,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	INIT_LIST_HEAD(&used);
 	INIT_LIST_HEAD(&free);
 	INIT_LIST_HEAD(&eba_orphans);
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
 	ai->min_ec = UBI_MAX_ERASECOUNTER;
 
-	ai->aeb_slab_cache = kmem_cache_create("ubi_ainf_peb_slab",
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
 	fmsb = (struct ubi_fm_sb *)(fm_raw);
 	ai->max_sqnum = fmsb->sqnum;
 	fm_pos += sizeof(struct ubi_fm_sb);
-- 
1.8.3.1

