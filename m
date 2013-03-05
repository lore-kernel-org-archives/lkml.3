Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3CEWRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:17:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3CEWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:17:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 6/9] [media] ir-rx51: fix clock API related build issues
Date: Tue,  5 Mar 2013 23:16:46 +0100
Message-Id: <1362521809-22989-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0f1ymUE2bI44fe9cSVKZLUG1EMIMuOixCjUXBoQdjsR
 alHl1PPwYjRR5bkiaerG8qdxfRynuexOO5A+2UQipIx+f4GPFz
 l3GxPA7xjAa7EpoG7QnGAIQEKBPULcgPUgeT1tUp30MUbcBklY
 tAQXIOnQUDGD9TfG0fKxXwLb9jeB4Et8y640rOx9CFUXcsOTuV
 NZ89fzDayfUUUrQIg+uWZjfCRvdpbw2x+n0L/k5AwD8xmXULYW
 Kh44U+++foOp+d6a6dH/5GrKgDGnV/OSDfXukD81JJRT94xEAU
 E3zq+GVE3A4D+KuPCP7PmIkxgggmU6b5h2GZbh9iYUe38MWcB/
 94XUw3eurOjhZzpfbU1IMlyPei/abKOu3bQ8LnfJz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP1 no longer provides its own clock interfaces since patch
a135eaae52 "ARM: OMAP: remove plat/clock.h". This is great, but
we now have to convert the ir-rx51 driver to use the generic
interface from linux/clk.h.

The driver also uses the omap_dm_timer_get_fclk() function,
which is not exported for OMAP1, so we have to move the
definition out of the OMAP2 specific section.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
---
 arch/arm/plat-omap/dmtimer.c | 16 ++++++++--------
 drivers/media/rc/ir-rx51.c   |  4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index a0daa2f..ea133e5 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -333,6 +333,14 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_get_irq);
 
+struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
+{
+	if (timer)
+		return timer->fclk;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
+
 #if defined(CONFIG_ARCH_OMAP1)
 #include <mach/hardware.h>
 /**
@@ -371,14 +379,6 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
 
 #else
 
-struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
-{
-	if (timer)
-		return timer->fclk;
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
-
 __u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
 {
 	BUG();
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 8ead492..d1364a1 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -25,9 +25,9 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/clk.h>
 
 #include <plat/dmtimer.h>
-#include <plat/clock.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
@@ -209,7 +209,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 	}
 
 	clk_fclk = omap_dm_timer_get_fclk(lirc_rx51->pwm_timer);
-	lirc_rx51->fclk_khz = clk_fclk->rate / 1000;
+	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
 
 	return 0;
 
-- 
1.8.1.2

