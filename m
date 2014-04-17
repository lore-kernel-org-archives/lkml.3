Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbaDQAFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:05:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45221 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061AbaDQADw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:03:52 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 4/9] ARM: OMAP: dmtimer: Add function to check if timer is running
Date: Wed, 16 Apr 2014 19:03:14 -0500
Message-ID: <1397692999-7800-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397692999-7800-1-git-send-email-joelf@ti.com>
References: <1397692999-7800-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inorder to move non-DM timer specific code that modifies the "idlect"
mask on OMAP1, from dmtimer code, to OMAP1 specific timer initialization code,
we introduce a new function that can possibly be reused for other purposes in
the future. The function just checks if a timer is running based on the timer ID
which should be same as pdev->id. This allows us to cleanly separate the timer vs
non-timer bits and keep the timer bits in the dmtimer code.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c              |   29 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/dmtimer.h |    2 ++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 4debb3d..86b2641 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -187,6 +187,35 @@ int omap_dm_timer_reserve_systimer(int id)
 	return 0;
 }
 
+/*
+ * Check if a timer is running based on timer_id, used for OMAP1 currently.
+ */
+int omap_dm_timer_is_running(int timer_id)
+{
+	int i = 1, ret = 0;
+	struct omap_dm_timer *timer = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dm_timer_lock, flags);
+	list_for_each_entry(timer, &omap_timer_list, node) {
+		if (i == timer_id) {
+			u32 l;
+			l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+			if (l & OMAP_TIMER_CTRL_ST) {
+				ret = 1;
+				goto done;
+			} else {
+				goto done;
+			}
+		}
+		i++;
+	}
+done:
+	spin_unlock_irqrestore(&dm_timer_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_is_running);
+
 static struct omap_dm_timer *_omap_dm_timer_request(int req_type, void *data)
 {
 	struct omap_dm_timer *timer = NULL, *t;
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 2861b15..41df0a6 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -135,6 +135,8 @@ void omap_dm_timer_disable(struct omap_dm_timer *timer);
 
 int omap_dm_timer_get_irq(struct omap_dm_timer *timer);
 
+int omap_dm_timer_is_running(int timer_id);
+
 u32 omap_dm_timer_modify_idlect_mask(u32 inputmask);
 struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer);
 
-- 
1.7.9.5

