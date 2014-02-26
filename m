Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaBZKv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:51:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaBZKvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:51:49 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, abgupta@microsoft.com, haiyangz@microsoft.com,
        jasowang@redhat.com, tomi.valkeinen@ti.com,
        devel@linuxdriverproject.org, Gerd Hoffmann <kraxel@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH v5 2/2] hyperv-fb: kick off efifb early
Date: Wed, 26 Feb 2014 11:51:25 +0100
Message-Id: <1393411885-14895-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove firmware framebuffer before initializing hyperv-fb.  Needed
on gen2 virtual machines.   Letting register_framebuffer handle the
switchover results in efifb still being active while hyperv graphics
are initialized, which in turn can make the linux kernel hang.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/video/hyperv_fb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index b7b3dd0..e23392e 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -679,6 +679,8 @@ static int hvfb_getmem(struct fb_info *info)
 	if (gen2vm) {
 		info->apertures->ranges[0].base = screen_info.lfb_base;
 		info->apertures->ranges[0].size = screen_info.lfb_size;
+		remove_conflicting_framebuffers(info->apertures,
+						KBUILD_MODNAME, false);
 	} else {
 		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
 		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
-- 
1.8.3.1

