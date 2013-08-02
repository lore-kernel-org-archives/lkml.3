Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3HBXkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:40:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HBXkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:40:08 -0400
Date: Fri, 2 Aug 2013 16:39:57 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-df0960ab2d95543a7c162b04b2064991666adbad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        swarren@nvidia.com, tglx@linutronix.de, hpa@linux.intel.com,
        dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, swarren@nvidia.com, dh.herrmann@gmail.com,
        hpa@linux.intel.com
In-Reply-To: <1375445127-15480-3-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-3-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: simplefb: mark as fw and allocate apertures
Git-Commit-ID: df0960ab2d95543a7c162b04b2064991666adbad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:40:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df0960ab2d95543a7c162b04b2064991666adbad
Gitweb:     http://git.kernel.org/tip/df0960ab2d95543a7c162b04b2064991666adbad
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:21 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:45 -0700

fbdev: simplefb: mark as fw and allocate apertures

fbdev-core uses FBINFO_MISC_FIRMWARE to mark drivers that use firmware
framebuffers. Furthermore, we now allocate apertures for the fbinfo
device.
Both information is used by remove_conflicting_framebuffers() to remove a
fbdev device whenever a real driver is loaded. This is used heavily on x86
for VGA/vesa/EFI framebuffers, but is also of great use for all other
systems.

Especially with x86 support for simplefb, this information is needed to
unload simplefb before a real hw-driver (like i915, radeon, nouveau) is
loaded.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1375445127-15480-3-git-send-email-dh.herrmann@gmail.com
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/video/simplefb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index 5886989..8d78106 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -202,8 +202,16 @@ static int simplefb_probe(struct platform_device *pdev)
 	info->var.blue = params.format->blue;
 	info->var.transp = params.format->transp;
 
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		framebuffer_release(info);
+		return -ENOMEM;
+	}
+	info->apertures->ranges[0].base = info->fix.smem_start;
+	info->apertures->ranges[0].size = info->fix.smem_len;
+
 	info->fbops = &simplefb_ops;
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
 	info->screen_base = devm_ioremap(&pdev->dev, info->fix.smem_start,
 					 info->fix.smem_len);
 	if (!info->screen_base) {
