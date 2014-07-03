Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbaGCNXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:23:37 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63552 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbaGCNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:14 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 09/11] MIPS: Alchemy: au1200fb: use clk framework
Date: Thu,  3 Jul 2014 15:22:40 +0200
Message-Id: <1404393762-858019-10-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minimal patch to replace direct clock register hackery with clock
framework calls.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
v2: initial version, new

 drivers/video/fbdev/au1200fb.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 230cfa8..3c8cf71 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -30,6 +30,7 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
@@ -829,11 +830,19 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 	 */
 	if (!(panel->mode_clkcontrol & LCD_CLKCONTROL_EXT))
 	{
-		uint32 sys_clksrc;
-		AU1X_WRSYS(panel->mode_auxpll, AU1000_SYS_AUXPLL);
-		sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC) & ~0x0000001f;
-		sys_clksrc |= panel->mode_toyclksrc;
-		AU1X_WRSYS(sys_clksrc, AU1000_SYS_CLKSRC);
+		struct clk *a, *c = clk_get(NULL, "lcd_intclk");
+
+		if (!IS_ERR(c)) {
+			if ((panel->mode_toyclksrc & 7) == 4) {
+				a = clk_get(NULL, ALCHEMY_AUXPLL_CLK);
+				if (!IS_ERR(a)) {
+					clk_set_parent(c, a);
+					clk_put(a);
+				}
+			}
+			clk_prepare_enable(c);
+			clk_put(c);
+		}
 	}
 
 	/*
-- 
2.0.0

