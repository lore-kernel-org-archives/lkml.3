Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaKHBHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:07:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51186 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaKHBHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:07:06 -0500
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] clk: Propagate prepare and enable when reparenting orphans
Date: Fri,  7 Nov 2014 17:06:58 -0800
Message-Id: <1415408818-28028-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the existing code, if you find a parent for an orhpan that has
already been prepared / enabled, you won't enable the parent.  That
can cause later problems since the clock tree isn't in a consistent
state.  Fix by propagating the prepare and enable.

NOTE: this does bring up the question about whether the enable of the
orphan actually made sense.  If the orphan's parent wasn't enabled by
default (by the bootloader or the default state of the hardware) then
the original enable of the orphan probably didn't do what the caller
though it would.  Some users of the orphan might have preferred an
EPROBE_DEFER be returned until we had a full path to a root clock.
This patch doesn't address those concerns and really just syncs up the
state.

Tested on rk3288-evb-rk808 by temporarily considering "sclk_tsadc" as
a critical clock (to simulate a driver enabling it at bootup).

Before:

   clock                         enable_cnt  prepare_cnt        rate   accuracy   phase
----------------------------------------------------------------------------------------
 xin32k                                   0            0       32768          0 0
    sclk_hdmi_cec                         0            0       32768          0 0
    sclk_otg_adp                          0            0       32768          0 0
    sclk_tsadc                            1            1         993          0 0

After:

   clock                         enable_cnt  prepare_cnt        rate   accuracy   phase
----------------------------------------------------------------------------------------
 xin32k                                   1            1       32768          0 0
    sclk_hdmi_cec                         0            0       32768          0 0
    sclk_otg_adp                          0            0       32768          0 0
    sclk_tsadc                            1            1         993          0 0

Note that xin32k on rk808 is a clock that cannot be disabled in
hardware (it's an always on clock), so really all we needed to do was
to sync up the state.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Only do the work for orphans, not for other users of __clk_reparent().

 drivers/clk/clk.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..0f04b7c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1652,6 +1652,22 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
 
+static void __clk_reparent_orphan(struct clk *clk, struct clk *new_parent)
+{
+	__clk_reparent(clk, new_parent);
+
+	if (clk->prepare_count) {
+		unsigned long flags;
+
+		__clk_prepare(new_parent);
+
+		flags = clk_enable_lock();
+		if (clk->enable_count)
+			__clk_enable(new_parent);
+		clk_enable_unlock(flags);
+	}
+}
+
 /**
  * clk_set_parent - switch the parent of a mux clk
  * @clk: the mux clk whose input we are switching
@@ -1953,13 +1969,13 @@ int __clk_init(struct device *dev, struct clk *clk)
 		if (orphan->num_parents && orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (!strcmp(clk->name, orphan->parent_names[i]))
-				__clk_reparent(orphan, clk);
+				__clk_reparent_orphan(orphan, clk);
 			continue;
 		}
 
 		for (i = 0; i < orphan->num_parents; i++)
 			if (!strcmp(clk->name, orphan->parent_names[i])) {
-				__clk_reparent(orphan, clk);
+				__clk_reparent_orphan(orphan, clk);
 				break;
 			}
 	 }
-- 
2.1.0.rc2.206.gedb03e5

