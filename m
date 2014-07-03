Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbaGCNYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:24:17 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38096 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbaGCNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:11 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 08/11] MIPS: Alchemy: au1100fb: use clk framework
Date: Thu,  3 Jul 2014 15:22:39 +0200
Message-Id: <1404393762-858019-9-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the clock framework to en/disable the clock to the au1100
framebuffer device.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 arch/mips/alchemy/devboards/db1000.c | 14 ++++++++++++++
 drivers/video/fbdev/au1100fb.c       | 36 ++++++++++++++++++++++--------------
 drivers/video/fbdev/au1100fb.h       |  1 +
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/mips/alchemy/devboards/db1000.c b/arch/mips/alchemy/devboards/db1000.c
index 6e55bcc..5b4f81b 100644
--- a/arch/mips/alchemy/devboards/db1000.c
+++ b/arch/mips/alchemy/devboards/db1000.c
@@ -19,6 +19,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
@@ -496,6 +497,7 @@ int __init db1000_dev_setup(void)
 	int board = BCSR_WHOAMI_BOARD(bcsr_read(BCSR_WHOAMI));
 	int c0, c1, d0, d1, s0, s1, flashsize = 32,  twosocks = 1;
 	unsigned long pfc;
+	struct clk *c, *p;
 
 	if (board == BCSR_WHOAMI_DB1500) {
 		c0 = AU1500_GPIO2_INT;
@@ -525,6 +527,18 @@ int __init db1000_dev_setup(void)
 		spi_register_board_info(db1100_spi_info,
 					ARRAY_SIZE(db1100_spi_info));
 
+		/* link LCD clock to AUXPLL */
+		p = clk_get(NULL, "auxpll_clk");
+		c = clk_get(NULL, "lcd_intclk");
+		if (!IS_ERR(c) && !IS_ERR(p)) {
+			clk_set_parent(c, p);
+			clk_set_rate(c, clk_get_rate(p));
+		}
+		if (!IS_ERR(c))
+			clk_put(c);
+		if (!IS_ERR(p))
+			clk_put(p);
+
 		platform_add_devices(db1100_devs, ARRAY_SIZE(db1100_devs));
 		platform_device_register(&db1100_spi_dev);
 	} else if (board == BCSR_WHOAMI_DB1000) {
diff --git a/drivers/video/fbdev/au1100fb.c b/drivers/video/fbdev/au1100fb.c
index 2c2804b..a7145ce 100644
--- a/drivers/video/fbdev/au1100fb.c
+++ b/drivers/video/fbdev/au1100fb.c
@@ -41,6 +41,7 @@
  *  with this program; if not, write  to the Free Software Foundation, Inc.,
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -434,7 +435,7 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	struct au1100fb_device *fbdev = NULL;
 	struct resource *regs_res;
 	unsigned long page;
-	u32 sys_clksrc;
+	struct clk *c;
 
 	/* Allocate new device private */
 	fbdev = devm_kzalloc(&dev->dev, sizeof(struct au1100fb_device),
@@ -473,6 +474,13 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	print_dbg("Register memory map at %p", fbdev->regs);
 	print_dbg("phys=0x%08x, size=%d", fbdev->regs_phys, fbdev->regs_len);
 
+	c = clk_get(NULL, "lcd_intclk");
+	if (!IS_ERR(c)) {
+		fbdev->lcdclk = c;
+		clk_set_rate(c, 48000000);
+		clk_prepare_enable(c);
+	}
+
 	/* Allocate the framebuffer to the maximum screen size * nbr of video buffers */
 	fbdev->fb_len = fbdev->panel->xres * fbdev->panel->yres *
 		  	(fbdev->panel->bpp >> 3) * AU1100FB_NBR_VIDEO_BUFFERS;
@@ -506,11 +514,6 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	print_dbg("Framebuffer memory map at %p", fbdev->fb_mem);
 	print_dbg("phys=0x%08x, size=%dK", fbdev->fb_phys, fbdev->fb_len / 1024);
 
-	/* Setup LCD clock to AUX (48 MHz) */
-	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC) &
-			~(SYS_CS_ML_MASK | SYS_CS_DL | SYS_CS_CL);
-	AU1X_WRSYS((sys_clksrc | (1 << SYS_CS_ML_BIT)), AU1000_SYS_CLKSRC);
-
 	/* load the panel info into the var struct */
 	au1100fb_var.bits_per_pixel = fbdev->panel->bpp;
 	au1100fb_var.xres = fbdev->panel->xres;
@@ -547,6 +550,10 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	return 0;
 
 failed:
+	if (fbdev->lcdclk) {
+		clk_disable_unprepare(fbdev->lcdclk);
+		clk_put(fbdev->lcdclk);
+	}
 	if (fbdev->fb_mem) {
 		dma_free_noncoherent(&dev->dev, fbdev->fb_len, fbdev->fb_mem,
 				     fbdev->fb_phys);
@@ -577,11 +584,15 @@ int au1100fb_drv_remove(struct platform_device *dev)
 
 	fb_dealloc_cmap(&fbdev->info.cmap);
 
+	if (fbdev->lcdclk) {
+		clk_disable_unprepare(fbdev->lcdclk);
+		clk_put(fbdev->lcdclk);
+	}
+
 	return 0;
 }
 
 #ifdef CONFIG_PM
-static u32 sys_clksrc;
 static struct au1100fb_regs fbregs;
 
 int au1100fb_drv_suspend(struct platform_device *dev, pm_message_t state)
@@ -591,14 +602,11 @@ int au1100fb_drv_suspend(struct platform_device *dev, pm_message_t state)
 	if (!fbdev)
 		return 0;
 
-	/* Save the clock source state */
-	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC);
-
 	/* Blank the LCD */
 	au1100fb_fb_blank(VESA_POWERDOWN, &fbdev->info);
 
-	/* Stop LCD clocking */
-	AU1X_WRSYS(sys_clksrc & ~SYS_CS_ML_MASK, AU1000_SYS_CLKSRC);
+	if (fbdev->lcdclk)
+		clk_disable(fbdev->lcdclk);
 
 	memcpy(&fbregs, fbdev->regs, sizeof(struct au1100fb_regs));
 
@@ -614,8 +622,8 @@ int au1100fb_drv_resume(struct platform_device *dev)
 
 	memcpy(fbdev->regs, &fbregs, sizeof(struct au1100fb_regs));
 
-	/* Restart LCD clocking */
-	AU1X_WRSYS(sys_clksrc, AU1000_SYS_CLKSRC);
+	if (fbdev->lcdclk)
+		clk_enable(fbdev->lcdclk);
 
 	/* Unblank the LCD */
 	au1100fb_fb_blank(VESA_NO_BLANKING, &fbdev->info);
diff --git a/drivers/video/fbdev/au1100fb.h b/drivers/video/fbdev/au1100fb.h
index 12d9642..9af1993 100644
--- a/drivers/video/fbdev/au1100fb.h
+++ b/drivers/video/fbdev/au1100fb.h
@@ -109,6 +109,7 @@ struct au1100fb_device {
 	size_t	      		fb_len;
 	dma_addr_t    		fb_phys;
 	int			panel_idx;
+	struct clk		*lcdclk;
 };
 
 /********************************************************************/
-- 
2.0.0

