Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3A1PzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:55:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1937 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A1PzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:55:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Jan 2013 07:54:51 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] clk: tegra: adapt tegra periph clk to mux table/mask
Date: Mon, 28 Jan 2013 17:54:22 +0200
Message-ID: <1359388467-32386-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com>
References: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tegra peripheral clock type uses struct clk_mux directly, so it needs to
be updated to handle the new mask and table fields. Also the macros need
to be updated

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.h |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 0744731..a09d7dc 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -355,15 +355,16 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset);
 
-#define TEGRA_CLK_PERIPH(_mux_shift, _mux_width, _mux_flags,		\
+#define TEGRA_CLK_PERIPH(_mux_shift, _mux_mask, _mux_flags,		\
 			 _div_shift, _div_width, _div_frac_width,	\
 			 _div_flags, _clk_num, _enb_refcnt, _regs,	\
-			 _gate_flags)					\
+			 _gate_flags, _table)				\
 	{								\
 		.mux = {						\
 			.flags = _mux_flags,				\
 			.shift = _mux_shift,				\
-			.width = _mux_width,				\
+			.mask = _mux_mask,				\
+			.table = _table,				\
 		},							\
 		.divider = {						\
 			.flags = _div_flags,				\
@@ -393,26 +394,36 @@ struct tegra_periph_init_data {
 	const char *dev_id;
 };
 
-#define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset, \
-			_mux_shift, _mux_width, _mux_flags, _div_shift,	\
+#define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
+			_mux_shift, _mux_mask, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id)	\
+			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table) \
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
 		.parent_names = _parent_names,				\
 		.num_parents = ARRAY_SIZE(_parent_names),		\
-		.periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_width,	\
+		.periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_mask,	\
 					   _mux_flags, _div_shift,	\
 					   _div_width, _div_frac_width,	\
 					   _div_flags, _clk_num,	\
 					   _enb_refcnt, _regs,		\
-					   _gate_flags),		\
+					   _gate_flags, _table),	\
 		.offset = _offset,					\
 		.con_id = _con_id,					\
 		.dev_id = _dev_id,					\
 	}
 
+#define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset,\
+			_mux_shift, _mux_width, _mux_flags, _div_shift,	\
+			_div_width, _div_frac_width, _div_flags, _regs,	\
+			_clk_num, _enb_refcnt, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
+			_mux_shift, BIT(_mux_width) - 1, _mux_flags,	\
+			_div_shift, _div_width, _div_frac_width, _div_flags, \
+			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
+			NULL)
+
 /**
  * struct clk_super_mux - super clock
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

