Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBOXd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:33:27 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:54575 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaBOXdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:33:23 -0500
Subject: [PATCH v6 1/8] clk: sunxi: factors: automatic reparenting support
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?utf-8?b?TMOzcGV6?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Sun, 16 Feb 2014 00:33:19 +0100
Message-ID: <20140215233319.30460.86023.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20140215233011.30460.27261.stgit@dizzy-6.o2s.ch>
References: <20140215233011.30460.27261.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

This commit implements .determine_rate, so that our factor clocks can be
reparented when needed.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/clk/sunxi/clk-factors.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 9e23264..3806d97 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -77,6 +77,41 @@ static long clk_factors_round_rate(struct clk_hw *hw, unsigned long rate,
 	return rate;
 }
 
+static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *best_parent_rate,
+				       struct clk **best_parent_p)
+{
+	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
+	int i, num_parents;
+	unsigned long parent_rate, best = 0, child_rate, best_child_rate = 0;
+
+	/* find the parent that can help provide the fastest rate <= rate */
+	num_parents = __clk_get_num_parents(clk);
+	for (i = 0; i < num_parents; i++) {
+		parent = clk_get_parent_by_index(clk, i);
+		if (!parent)
+			continue;
+		if (__clk_get_flags(clk) & CLK_SET_RATE_PARENT)
+			parent_rate = __clk_round_rate(parent, rate);
+		else
+			parent_rate = __clk_get_rate(parent);
+
+		child_rate = clk_factors_round_rate(hw, rate, &parent_rate);
+
+		if (child_rate <= rate && child_rate > best_child_rate) {
+			best_parent = parent;
+			best = parent_rate;
+			best_child_rate = child_rate;
+		}
+	}
+
+	if (best_parent)
+		*best_parent_p = best_parent;
+	*best_parent_rate = best;
+
+	return best_child_rate;
+}
+
 static int clk_factors_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
@@ -113,6 +148,7 @@ static int clk_factors_set_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 const struct clk_ops clk_factors_ops = {
+	.determine_rate = clk_factors_determine_rate,
 	.recalc_rate = clk_factors_recalc_rate,
 	.round_rate = clk_factors_round_rate,
 	.set_rate = clk_factors_set_rate,

