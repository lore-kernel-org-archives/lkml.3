Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaEPVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:44:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:20987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaEPVnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="512987832"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 2/8] radeonfb: Out of line errata workarounds
Date: Fri, 16 May 2014 14:43:09 -0700
Message-Id: <1400276595-6965-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Out of lining _radeon_msleep and radeon_pll_errata_* saves about 40k text.

14193673	2003976	1507328	17704977	10e2811	vmlinux-before-radeon
14152713	2003976	1507328	17664017	10d8811	vmlinux-radeon

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/video/fbdev/aty/radeon_base.c | 57 ++++++++++++++++++++++++++++++++++
 drivers/video/fbdev/aty/radeonfb.h    | 58 ++---------------------------------
 2 files changed, 60 insertions(+), 55 deletions(-)

diff --git a/drivers/video/fbdev/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
index 26d80a4..abd89a9 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -282,6 +282,63 @@ static int backlight = 1;
 static int backlight = 0;
 #endif
 
+/* Note about this function: we have some rare cases where we must not schedule,
+ * this typically happen with our special "wake up early" hook which allows us to
+ * wake up the graphic chip (and thus get the console back) before everything else
+ * on some machines that support that mechanism. At this point, interrupts are off
+ * and scheduling is not permitted
+ */
+void _radeon_msleep(struct radeonfb_info *rinfo, unsigned long ms)
+{
+	if (rinfo->no_schedule || oops_in_progress)
+		mdelay(ms);
+	else
+		msleep(ms);
+}
+
+/*
+ * Note about PLL register accesses:
+ *
+ * I have removed the spinlock on them on purpose. The driver now
+ * expects that it will only manipulate the PLL registers in normal
+ * task environment, where radeon_msleep() will be called, protected
+ * by a semaphore (currently the console semaphore) so that no conflict
+ * will happen on the PLL register index.
+ *
+ * With the latest changes to the VT layer, this is guaranteed for all
+ * calls except the actual drawing/blits which aren't supposed to use
+ * the PLL registers anyway
+ *
+ * This is very important for the workarounds to work properly. The only
+ * possible exception to this rule is the call to unblank(), which may
+ * be done at irq time if an oops is in progress.
+ */
+void radeon_pll_errata_after_index(struct radeonfb_info *rinfo)
+{
+	if (!(rinfo->errata & CHIP_ERRATA_PLL_DUMMYREADS))
+		return;
+
+	(void)INREG(CLOCK_CNTL_DATA);
+	(void)INREG(CRTC_GEN_CNTL);
+}
+
+void radeon_pll_errata_after_data(struct radeonfb_info *rinfo)
+{
+	if (rinfo->errata & CHIP_ERRATA_PLL_DELAY) {
+		/* we can't deal with posted writes here ... */
+		_radeon_msleep(rinfo, 5);
+	}
+	if (rinfo->errata & CHIP_ERRATA_R300_CG) {
+		u32 save, tmp;
+		save = INREG(CLOCK_CNTL_INDEX);
+		tmp = save & ~(0x3f | PLL_WR_EN);
+		OUTREG(CLOCK_CNTL_INDEX, tmp);
+		tmp = INREG(CLOCK_CNTL_DATA);
+		OUTREG(CLOCK_CNTL_INDEX, save);
+	}
+}
+
+
 /*
  * prototypes
  */
diff --git a/drivers/video/fbdev/aty/radeonfb.h b/drivers/video/fbdev/aty/radeonfb.h
index cb84604..bb73446 100644
--- a/drivers/video/fbdev/aty/radeonfb.h
+++ b/drivers/video/fbdev/aty/radeonfb.h
@@ -370,20 +370,7 @@ struct radeonfb_info {
  * IO macros
  */
 
-/* Note about this function: we have some rare cases where we must not schedule,
- * this typically happen with our special "wake up early" hook which allows us to
- * wake up the graphic chip (and thus get the console back) before everything else
- * on some machines that support that mechanism. At this point, interrupts are off
- * and scheduling is not permitted
- */
-static inline void _radeon_msleep(struct radeonfb_info *rinfo, unsigned long ms)
-{
-	if (rinfo->no_schedule || oops_in_progress)
-		mdelay(ms);
-	else
-		msleep(ms);
-}
-
+void _radeon_msleep(struct radeonfb_info *rinfo, unsigned long ms);
 
 #define INREG8(addr)		readb((rinfo->mmio_base)+addr)
 #define OUTREG8(addr,val)	writeb(val, (rinfo->mmio_base)+addr)
@@ -408,47 +395,8 @@ static inline void _OUTREGP(struct radeonfb_info *rinfo, u32 addr,
 
 #define OUTREGP(addr,val,mask)	_OUTREGP(rinfo, addr, val,mask)
 
-/*
- * Note about PLL register accesses:
- *
- * I have removed the spinlock on them on purpose. The driver now
- * expects that it will only manipulate the PLL registers in normal
- * task environment, where radeon_msleep() will be called, protected
- * by a semaphore (currently the console semaphore) so that no conflict
- * will happen on the PLL register index.
- *
- * With the latest changes to the VT layer, this is guaranteed for all
- * calls except the actual drawing/blits which aren't supposed to use
- * the PLL registers anyway
- *
- * This is very important for the workarounds to work properly. The only
- * possible exception to this rule is the call to unblank(), which may
- * be done at irq time if an oops is in progress.
- */
-static inline void radeon_pll_errata_after_index(struct radeonfb_info *rinfo)
-{
-	if (!(rinfo->errata & CHIP_ERRATA_PLL_DUMMYREADS))
-		return;
-
-	(void)INREG(CLOCK_CNTL_DATA);
-	(void)INREG(CRTC_GEN_CNTL);
-}
-
-static inline void radeon_pll_errata_after_data(struct radeonfb_info *rinfo)
-{
-	if (rinfo->errata & CHIP_ERRATA_PLL_DELAY) {
-		/* we can't deal with posted writes here ... */
-		_radeon_msleep(rinfo, 5);
-	}
-	if (rinfo->errata & CHIP_ERRATA_R300_CG) {
-		u32 save, tmp;
-		save = INREG(CLOCK_CNTL_INDEX);
-		tmp = save & ~(0x3f | PLL_WR_EN);
-		OUTREG(CLOCK_CNTL_INDEX, tmp);
-		tmp = INREG(CLOCK_CNTL_DATA);
-		OUTREG(CLOCK_CNTL_INDEX, save);
-	}
-}
+void radeon_pll_errata_after_index(struct radeonfb_info *rinfo);
+void radeon_pll_errata_after_data(struct radeonfb_info *rinfo);
 
 static inline u32 __INPLL(struct radeonfb_info *rinfo, u32 addr)
 {
-- 
1.9.0

