Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3DPHnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:43:53 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:41648 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754034Ab3DPHnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:43:52 -0400
To: linux-mtd@lists.infradead.org
Cc: richard.weinberger@gmail.com, linux-kernel@vger.kernel.org,
        liu.dong3@zte.com.cn, cui.yunfeng@zte.com.cn, wang.bo116@zte.com.cn
Subject: [PATCH] UBI: fix memory leak when use fastmap
MIME-Version: 1.0
X-KeepSent: 5B457772:5235C9A1-48257B4F:002A2C13;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 6.5.6 March 06, 2007
Message-ID: <OF5B457772.5235C9A1-ON48257B4F.002A2C13-48257B4F.002A691B@zte.com.cn>
From: wang.bo116@zte.com.cn
Date: Tue, 16 Apr 2013 15:43:07 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-16 15:42:57,
	Serialize complete at 2013-04-16 15:42:57
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r3G7hAwu014177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    Sorry, there is something wrong with the previous patch's format, try 
to submit it again.
When use ubi fastmap, there is a memory leak which will make destroy_ai() 
fail to free the slab.
The following patch base on linux-3.9-rc6 fix this problem.


diff -uprN old_ubi/attach.c new_ubi/attach.c
--- old_ubi/attach.c    2013-04-08 03:49:54.000000000 +0000
+++ new_ubi/attach.c    2013-04-16 03:22:47.343750000 +0000
@@ -1212,6 +1212,30 @@ static void destroy_ai(struct ubi_attach
        kfree(ai);
 }
 
+static struct ubi_attach_info *alloc_ai(const char *slab_name)
+{
+       struct ubi_attach_info *ai;
+
+       ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+       if (!ai)
+               return ai;
+
+       INIT_LIST_HEAD(&ai->corr);
+       INIT_LIST_HEAD(&ai->free);
+       INIT_LIST_HEAD(&ai->erase);
+       INIT_LIST_HEAD(&ai->alien);
+       ai->volumes = RB_ROOT;
+       ai->aeb_slab_cache = kmem_cache_create(slab_name,
+                                          sizeof(struct ubi_ainf_peb),
+                                              0, 0, NULL);
+       if (!ai->aeb_slab_cache) {
+               kfree(ai);
+               ai = NULL;
+       }
+
+       return ai;
+}
+
 /**
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
@@ -1315,8 +1339,13 @@ static int scan_fast(struct ubi_device *
        int err, pnum, fm_anchor = -1;
        unsigned long long max_sqnum = 0;
 
+       struct ubi_attach_info *fm_temp_ai = NULL;
        err = -ENOMEM;
 
+       fm_temp_ai = alloc_ai("ubi_scan_fastmap_slab_cache");
+       if (!fm_temp_ai)
+               goto out;
+
        ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
        if (!ech)
                goto out;
@@ -1331,7 +1360,7 @@ static int scan_fast(struct ubi_device *
                cond_resched();
 
                dbg_gen("process PEB %d", pnum);
-               err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum);
+               err = scan_peb(ubi, fm_temp_ai, pnum, &vol_id, &sqnum);
                if (err < 0)
                        goto out_vidh;
 
@@ -1343,6 +1372,7 @@ static int scan_fast(struct ubi_device *
 
        ubi_free_vid_hdr(ubi, vidh);
        kfree(ech);
+       destroy_ai(fm_temp_ai);
 
        if (fm_anchor < 0)
                return UBI_NO_FASTMAP;
@@ -1351,6 +1381,7 @@ static int scan_fast(struct ubi_device *
 
 out_vidh:
        ubi_free_vid_hdr(ubi, vidh);
+       destroy_ai(fm_temp_ai);
 out_ech:
        kfree(ech);
 out:
@@ -1359,29 +1390,6 @@ out:
 
 #endif
 
-static struct ubi_attach_info *alloc_ai(const char *slab_name)
-{
-       struct ubi_attach_info *ai;
-
-       ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-       if (!ai)
-               return ai;
-
-       INIT_LIST_HEAD(&ai->corr);
-       INIT_LIST_HEAD(&ai->free);
-       INIT_LIST_HEAD(&ai->erase);
-       INIT_LIST_HEAD(&ai->alien);
-       ai->volumes = RB_ROOT;
-       ai->aeb_slab_cache = kmem_cache_create(slab_name,
-                                          sizeof(struct ubi_ainf_peb),
-                                              0, 0, NULL);
-       if (!ai->aeb_slab_cache) {
-               kfree(ai);
-               ai = NULL;
-       }
-
-       return ai;
-}
 
 /**
  * ubi_attach - attach an MTD device.
@@ -1419,7 +1427,7 @@ int ubi_attach(struct ubi_device *ubi, i
                                        return -ENOMEM;
                        }
 
-                       err = scan_all(ubi, ai, UBI_FM_MAX_START);
+                       err = scan_all(ubi, ai, 0);
                }
        }
 #else
 
 
diff -uprN old_ubi/fastmap.c new_ubi/fastmap.c
--- old_ubi/fastmap.c   2013-04-08 03:49:54.000000000 +0000
+++ new_ubi/fastmap.c   2013-04-16 03:22:17.468750000 +0000
@@ -552,21 +552,8 @@ static int ubi_attach_fastmap(struct ubi
        INIT_LIST_HEAD(&used);
        INIT_LIST_HEAD(&free);
        INIT_LIST_HEAD(&eba_orphans);
-       INIT_LIST_HEAD(&ai->corr);
-       INIT_LIST_HEAD(&ai->free);
-       INIT_LIST_HEAD(&ai->erase);
-       INIT_LIST_HEAD(&ai->alien);
-       ai->volumes = RB_ROOT;
        ai->min_ec = UBI_MAX_ERASECOUNTER;
 
-       ai->aeb_slab_cache = kmem_cache_create("ubi_ainf_peb_slab",
-                                          sizeof(struct ubi_ainf_peb),
-                                              0, 0, NULL);
-       if (!ai->aeb_slab_cache) {
-               ret = -ENOMEM;
-               goto fail;
-       }
-
        fmsb = (struct ubi_fm_sb *)(fm_raw);
        ai->max_sqnum = fmsb->sqnum;
        fm_pos += sizeof(struct ubi_fm_sb);

 

Signed-off-by: Wang bo <wang.bo116@zte.com.cn>
Tested-by: Wang bo <wang.bo116@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
