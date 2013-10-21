Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3JUOS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:18:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3JUOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:18:53 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-04-526537cc78a4
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 01/12] clk: propagate parent change up one level
Date: Mon, 21 Oct 2013 16:18:20 +0200
Message-id: <1382365111-6533-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd0z5qlBBjOPa1nMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG3st3WAqO8lfMvTKDuYHxJE8XIyeHhICJxNEXb5kgbDGJC/fWs3UxcnEICSxilDh0
	6BkLhNPFJPH+1Qx2kCo2oI5jSz4zgtgiAokSv5rvMoMUMQscYpLY3TKFGSQhLGAnse/EXVYQ
	m0VAVWLaoX0sIDavgLvEzyWr2CHWyUs8vd/HBmJzCnhInHq5FmyoEFDNu2/zWCYw8i5gZFjF
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyoz6R2MK5ssDjEKMDBqMTDG+CSEiTEmlhWXJl7
	iFGCg1lJhLfKNDVIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwT
	B6dUAyPvl1lrDol8k76XVFnyk/PTXbmrgvOOGvRZSZv+c9z35PuOv2v4eVRTAtO+z9RaX2/U
	LSVnXKx0qOnGxVXPGI8Vxm5m5lD9FyQS8Oe62pSbrZsVvXfMVL72pMf+2xL9ql0vctxtrXKE
	1vgk7m7YZL5g141bJ1LD24LuS/46/OeQ0wXjS15PVlsosRRnJBpqMRcVJwIABgX0b1ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for propagation of setup of clock's parent one level
up.

This feature is helpful when a driver changes topology of its clocks using
clk_set_parent().  The problem occurs when on one platform/SoC driver's clock
is located at MUX output but on the other platform/SoC there is a gated proxy
clock between the MUX and driver's clock.  In such a case, driver's code has to
be modified to use one clock for enabling and the other clock for setup of a
parent.

The code updates are avoided by propagating setup of a parent up one level.

Additionally, this patch adds CLK_SET_PARENT_PARENT (sorry for naming) flag to
inform clk-core that clk_set_parent() should be propagated.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/clk/clk.c            |    6 ++++++
 include/linux/clk-provider.h |    1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a004769..14eda80 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1595,6 +1595,12 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 
 	/* try finding the new parent index */
 	if (parent) {
+		if ((clk->flags & CLK_SET_PARENT_PARENT)
+		    && clk->num_parents == 1) {
+			ret = clk_set_parent(clk->parent, parent);
+			goto out;
+		}
+
 		p_index = clk_fetch_parent_index(clk, parent);
 		p_rate = parent->rate;
 		if (p_index == clk->num_parents) {
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 73bdb69..83c98d5 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -29,6 +29,7 @@
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
+#define CLK_SET_PARENT_PARENT	BIT(8) /* propagate parent change up one level */
 
 struct clk_hw;
 
-- 
1.7.9.5

