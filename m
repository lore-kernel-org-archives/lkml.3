Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3GYPsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab3GYPsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:48:32 -0400
From: Peter Jones <pjones@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        linux-fbdev@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] Release efifb's colormap in efifb_destroy()
Date: Thu, 25 Jul 2013 11:48:11 -0400
Message-Id: <1374767291-2874-1-git-send-email-pjones@redhat.com>
In-Reply-To: <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com>
References: <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found by Alexandra Kossovsky, who noted this traceback from
kmemleak:

> unreferenced object 0xffff880216fcfe00 (size 512):
>   comm "swapper/0", pid 1, jiffies 4294895429 (age 1415.320s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 aa aa aa aa aa aa aa aa  ................
>     55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff  UUUUUUUU........
>   backtrace:
>     [<ffffffff813e415c>] kmemleak_alloc+0x21/0x3e
>     [<ffffffff8111c17f>]
>     kmemleak_alloc_recursive.constprop.57+0x16/0x18
>     [<ffffffff8111e63b>] __kmalloc+0xf9/0x144
>     [<ffffffff8123d9cf>] fb_alloc_cmap_gfp+0x47/0xe1
>     [<ffffffff8123da77>] fb_alloc_cmap+0xe/0x10
>     [<ffffffff81aff40a>] efifb_probe+0x3e9/0x48f
>     [<ffffffff812c566f>] platform_drv_probe+0x34/0x5e
>     [<ffffffff812c3e6d>] driver_probe_device+0x98/0x1b4
>     [<ffffffff812c3fd7>] __driver_attach+0x4e/0x6f
>     [<ffffffff812c25bf>] bus_for_each_dev+0x57/0x8a
>     [<ffffffff812c3984>] driver_attach+0x19/0x1b
>     [<ffffffff812c362b>] bus_add_driver+0xde/0x201
>     [<ffffffff812c453f>] driver_register+0x8c/0x110
>     [<ffffffff812c510d>] platform_driver_register+0x41/0x43
>     [<ffffffff812c5127>] platform_driver_probe+0x18/0x8a
>     [<ffffffff81aff002>] efifb_init+0x276/0x295
---
 drivers/video/efifb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 390b61b..1f3eab3 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -289,6 +289,7 @@ static void efifb_destroy(struct fb_info *info)
 	if (request_mem_succeeded)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
-- 
1.8.3.1

