Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaKGSwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:52:03 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36563 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaKGSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:52:00 -0500
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: Propagate prepare and enable when reparenting orphans
Date: Fri,  7 Nov 2014 10:51:52 -0800
Message-Id: <1415386312-23741-1-git-send-email-dianders@chromium.org>
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
 drivers/clk/clk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..a3d3d58 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1650,6 +1650,17 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 	clk_reparent(clk, new_parent);
 	__clk_recalc_accuracies(clk);
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
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
 }
 
 /**
-- 
2.1.0.rc2.206.gedb03e5

