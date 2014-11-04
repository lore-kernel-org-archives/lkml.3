Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaKDHzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:55:22 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34684 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaKDHzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:55:19 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, fzf@rock-chips.com, ykk@rock-chips.com,
        yzq@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] clk: rockchip: introduce the div_ops handling for composite branches
Date: Tue,  4 Nov 2014 15:52:37 +0800
Message-Id: <1415087559-19444-4-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rockchip Socs have a lot of clock node registered as composite
branch which include mux, divider and gate, most of them use
the same ops handling callback, we still need special ops
handling for some special clock node and this patch make it
possible.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk.c | 13 +++++++++----
 drivers/clk/rockchip/clk.h | 24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 1e68bff..0917c2b 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -42,6 +42,7 @@ static struct clk *rockchip_clk_register_branch(const char *name,
 		const char **parent_names, u8 num_parents, void __iomem *base,
 		int muxdiv_offset, u8 mux_shift, u8 mux_width, u8 mux_flags,
 		u8 div_shift, u8 div_width, u8 div_flags,
+		const struct clk_ops *divops,
 		struct clk_div_table *div_table, int gate_offset,
 		u8 gate_shift, u8 gate_flags, unsigned long flags,
 		spinlock_t *lock)
@@ -90,9 +91,12 @@ static struct clk *rockchip_clk_register_branch(const char *name,
 		div->width = div_width;
 		div->lock = lock;
 		div->table = div_table;
-		div_ops = (div_flags & CLK_DIVIDER_READ_ONLY)
-						? &clk_divider_ro_ops
-						: &clk_divider_ops;
+		if (divops)
+			div_ops = divops;
+		else if (div_flags & CLK_DIVIDER_READ_ONLY)
+			div_ops = &clk_divider_ro_ops;
+		else
+			div_ops = &clk_divider_ops;
 	}
 
 	clk = clk_register_composite(NULL, name, parent_names, num_parents,
@@ -275,7 +279,8 @@ void __init rockchip_clk_register_branches(
 				reg_base, list->muxdiv_offset, list->mux_shift,
 				list->mux_width, list->mux_flags,
 				list->div_shift, list->div_width,
-				list->div_flags, list->div_table,
+				list->div_flags,
+				list->div_ops, list->div_table,
 				list->gate_offset, list->gate_shift,
 				list->gate_flags, flags, &clk_lock);
 			break;
diff --git a/drivers/clk/rockchip/clk.h b/drivers/clk/rockchip/clk.h
index 6baf665..2cf263b 100644
--- a/drivers/clk/rockchip/clk.h
+++ b/drivers/clk/rockchip/clk.h
@@ -185,6 +185,7 @@ struct rockchip_clk_branch {
 	u8				div_shift;
 	u8				div_width;
 	u8				div_flags;
+	const struct clk_ops		*div_ops;
 	struct clk_div_table		*div_table;
 	int				gate_offset;
 	u8				gate_shift;
@@ -212,6 +213,29 @@ struct rockchip_clk_branch {
 		.gate_flags	= gf,				\
 	}
 
+#define COMPOSITE_DIVOPS(_id, cname, pnames, f, mo, ms, mw, mf, \
+			ds, dw, df, dops, go, gs, gf)		\
+	{							\
+		.id		= _id,				\
+		.branch_type	= branch_composite,		\
+		.name		= cname,			\
+		.parent_names	= pnames,			\
+		.num_parents	= ARRAY_SIZE(pnames),		\
+		.flags		= f,				\
+		.muxdiv_offset	= mo,				\
+		.mux_shift	= ms,				\
+		.mux_width	= mw,				\
+		.mux_flags	= mf,				\
+		.div_shift	= ds,				\
+		.div_width	= dw,				\
+		.div_flags	= df,				\
+		.div_ops	= dops,				\
+		.gate_offset	= go,				\
+		.gate_shift	= gs,				\
+		.gate_flags	= gf,				\
+	}
+
+
 #define COMPOSITE_NOMUX(_id, cname, pname, f, mo, ds, dw, df,	\
 			go, gs, gf)				\
 	{							\
-- 
1.9.1

