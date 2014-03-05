Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaCEQRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:17:20 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42300 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaCEQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:17:18 -0500
Date: Thu, 6 Mar 2014 00:16:11 +0800
From: Wang YanQing <udknight@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, fengguang.wu@intel.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: uvesafb: use CONFIG_X86_PAE surround _PAGE_NX
 check code
Message-ID: <20140305161611.GA32461@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tomi.valkeinen@ti.com,
	plagnioj@jcrosoft.com, fengguang.wu@intel.com,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because _PAGE_NX check will always false when we don't define
CONFIG_X86_PAE for CONFIG_X86_32, so use CONFIG_X86_PAE surround
the check code.

Although I believe "smart" compile will optimize out and generate
the same code, but use CONFIG_X86_PAE surround check code will
clear it and prohibit warning from static source code analyze tool.

[ This patch fix warning report by fengguang.wu@intel.com
  "drivers/video/fbdev/uvesafb.c:816 uvesafb_vbe_init()
   warn: bitwise AND condition is false here" ]

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/fbdev/uvesafb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 509d452..102858c 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -813,6 +813,7 @@ static int uvesafb_vbe_init(struct fb_info *info)
 	par->ypan = ypan;
 
 	if (par->pmi_setpal || par->ypan) {
+#ifdef CONFIG_X86_PAE
 		if (__supported_pte_mask & _PAGE_NX) {
 			par->pmi_setpal = par->ypan = 0;
 			printk(KERN_WARNING "uvesafb: NX protection is active, "
@@ -820,6 +821,9 @@ static int uvesafb_vbe_init(struct fb_info *info)
 		} else {
 			uvesafb_vbe_getpmi(task, par);
 		}
+#else
+		uvesafb_vbe_getpmi(task, par);
+#endif
 	}
 #else
 	/* The protected mode interface is not available on non-x86. */
-- 
1.8.3.4.8.g69490f3.dirty
