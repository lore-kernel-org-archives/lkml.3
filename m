Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaBUOjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbaBUOjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:39:35 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, haiyangz@microsoft.com, jasowang@redhat.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...)
Subject: [PATCH] hyperv-fb: kick off efifb early
Date: Fri, 21 Feb 2014 15:39:15 +0100
Message-Id: <1392993555-650-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove firmware framebuffer before initializing hyperv-fb.  Needed
on gen2 virtual machines.   Letting register_framebuffer handle the
switchover results in efifb still being active while hyperv graphics
are initialized, which in turn can make the linux kernel hang.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/video/hyperv_fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index f956cd9..3901ffe 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -683,6 +683,7 @@ static int hvfb_getmem(struct fb_info *info)
 		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
 		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
 	}
+	remove_conflicting_framebuffers(info->apertures, "hyperv-fb", false);
 
 	info->fix.smem_start = par->mem.start;
 	info->fix.smem_len = screen_fb_size;
-- 
1.8.3.1

