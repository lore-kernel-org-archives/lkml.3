Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3EWMBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:01:22 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:48261 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758727Ab3EWMBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:01:20 -0400
In-Reply-To: <CAFLxGvzKw1_L3Nm4J5GM_wr0sFe6umN0yLzDnK=DM_AJ7GpaaQ@mail.gmail.com>
References: <CAFLxGvxfzHudUMRc7VkgWMO9RJAkyh1iuouRAV-0s-5eaLqfEQ@mail.gmail.com>	<OFE7F9663A.1F3DE1BE-ON48257B60.00045684-48257B60.001360DF@zte.com.cn> <CAFLxGvzKw1_L3Nm4J5GM_wr0sFe6umN0yLzDnK=DM_AJ7GpaaQ@mail.gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: cui.yunfeng@zte.com.cn, wang.bo116@zte.com.cn,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        liu.dong3@zte.com.cn
Subject: Re: Re: Re: Re: [PATCH] UBI: fix memory leak when use fastmap
MIME-Version: 1.0
X-KeepSent: 6992CC88:316C799B-48257B74:0040CED8;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF6992CC88.316C799B-ON48257B74.0040CED8-48257B74.0041FF6F@zte.com.cn>
From: wang.bo116@zte.com.cn
Date: Thu, 23 May 2013 20:00:33 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-05-23 20:00:45,
	Serialize complete at 2013-05-23 20:00:45
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r4NC0lCH002002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com>  2013-05-13 
16:08:35:

> 
> I tried to apply/test your patch.
> It has lots of white spaces damages.
> Can you please resend it using git send-email?
> And also run checkpatch.pl before sending.
> 
> --
> Thanks,
> //richard

hello:
        I use git to remake a patch, and pass the checkpatch.pl's test.
But my email client is lotus notes, and the patch's format may be damage 
by the client.



Subject: [PATCH] Fix ubi fastmap memory leak
Signed-off-by: wang bo <wang.bo116@zte.com.cn>
---
 linux-3.9-rc6/drivers/mtd/ubi/attach.c  |   58 
+++++++++++++++++-------------
 linux-3.9-rc6/drivers/mtd/ubi/fastmap.c |   13 -------
 2 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/linux-3.9-rc6/drivers/mtd/ubi/attach.c 
b/linux-3.9-rc6/drivers/mtd/ubi/attach.c
index c071d41..e9f64bc
--- a/linux-3.9-rc6/drivers/mtd/ubi/attach.c
+++ b/linux-3.9-rc6/drivers/mtd/ubi/attach.c
@@ -1212,6 +1212,30 @@ static void destroy_ai(struct ubi_attach_info *ai)
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
+                                              sizeof(struct 
ubi_ainf_peb),
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
@@ -1315,8 +1339,13 @@ static int scan_fast(struct ubi_device *ubi, struct 
ubi_attach_info *ai)
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
@@ -1331,7 +1360,7 @@ static int scan_fast(struct ubi_device *ubi, struct 
ubi_attach_info *ai)
                cond_resched();
 
                dbg_gen("process PEB %d", pnum);
-               err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum);
+               err = scan_peb(ubi, fm_temp_ai, pnum, &vol_id, &sqnum);
                if (err < 0)
                        goto out_vidh;
 
@@ -1343,6 +1372,7 @@ static int scan_fast(struct ubi_device *ubi, struct 
ubi_attach_info *ai)
 
        ubi_free_vid_hdr(ubi, vidh);
        kfree(ech);
+       destroy_ai(fm_temp_ai);
 
        if (fm_anchor < 0)
                return UBI_NO_FASTMAP;
@@ -1351,6 +1381,7 @@ static int scan_fast(struct ubi_device *ubi, struct 
ubi_attach_info *ai)
 
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
-                                              sizeof(struct 
ubi_ainf_peb),
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
@@ -1419,7 +1427,7 @@ int ubi_attach(struct ubi_device *ubi, int 
force_scan)
                                        return -ENOMEM;
                        }
 
-                       err = scan_all(ubi, ai, UBI_FM_MAX_START);
+                       err = scan_all(ubi, ai, 0);
                }
        }
 #else
diff --git a/linux-3.9-rc6/drivers/mtd/ubi/fastmap.c 
b/linux-3.9-rc6/drivers/mtd/ubi/fastmap.c
index 0648c69..7b73d23
--- a/linux-3.9-rc6/drivers/mtd/ubi/fastmap.c
+++ b/linux-3.9-rc6/drivers/mtd/ubi/fastmap.c
@@ -552,21 +552,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
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
-                                              sizeof(struct 
ubi_ainf_peb),
-                                              0, 0, NULL);
-       if (!ai->aeb_slab_cache) {
-               ret = -ENOMEM;
-               goto fail;
-       }
-
        fmsb = (struct ubi_fm_sb *)(fm_raw);
        ai->max_sqnum = fmsb->sqnum;
        fm_pos += sizeof(struct ubi_fm_sb);
-- 
1.7.1

