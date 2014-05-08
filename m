Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaEHURI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:17:08 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34758 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaEHURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:17:04 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/3] clk: berlin: add clock tree driver for BG2/BG2CD
Date: Thu,  8 May 2014 22:16:50 +0200
Message-Id: <1399580212-30183-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver beast dealing with the clock tree of Berlin BG2
and BG2CD SoCs.

The include already contains structs for PLL and DIV, send in the
two following patches.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/berlin/bg2.c    | 615 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/berlin/common.h | 124 +++++++++
 2 files changed, 739 insertions(+)
 create mode 100644 drivers/clk/berlin/bg2.c
 create mode 100644 drivers/clk/berlin/common.h

diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
new file mode 100644
index 000000000000..c6eb4e180ca7
--- /dev/null
+++ b/drivers/clk/berlin/bg2.c
@@ -0,0 +1,615 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "common.h"
+
+/*
+ * BG2/BG2CD SoCs have the following audio/video I/O units:
+ *
+ * audiohd: HDMI TX audio
+ * audio0:  7.1ch TX
+ * audio1:  2ch TX
+ * audio2:  2ch RX
+ * audio3:  SPDIF TX
+ * video0:  HDMI video
+ * video1:  Secondary video
+ * video2:  SD auxiliary video
+ *
+ * There are no external audio clocks (ACLKI0, ACLKI1) and
+ * only one external video clock (VCLKI0).
+ *
+ * Currently missing bits and pieces:
+ * - audio_fast_pll is unknown
+ * - audiohd_pll is unknown
+ * - video0_pll is unknown
+ * - audio[023], audiohd parent pll is assumed to be audio_fast_pll
+ * - pll bypass switches are ignored
+ *
+ * To do:
+ * - avpll clock driver
+ *
+ */
+
+/* PLL/Clock registers start at 0x0014 of Global Register base */
+#define GLOBAL_OFFSET(x) ((x) - 0x0014)
+
+#define REG_SYSPLL		GLOBAL_OFFSET(0x0014)
+#define REG_MEMPLL		GLOBAL_OFFSET(0x0028)
+#define REG_CPUPLL		GLOBAL_OFFSET(0x003c)
+
+#define REG_CLKENABLE		GLOBAL_OFFSET(0x0150)
+#define REG_CLKSELECT0		GLOBAL_OFFSET(0x0154)
+#define REG_CLKSELECT1		GLOBAL_OFFSET(0x0158)
+#define REG_CLKSELECT2		GLOBAL_OFFSET(0x015c)
+#define REG_CLKSELECT3		GLOBAL_OFFSET(0x0160)
+#define REG_CLKSWITCH0		GLOBAL_OFFSET(0x0164)
+#define REG_CLKSWITCH1		GLOBAL_OFFSET(0x0168)
+
+#define REG_GFX3D_CORE		GLOBAL_OFFSET(0x022c)
+#define REG_GFX3D_SYS		GLOBAL_OFFSET(0x0230)
+#define REG_ARC			GLOBAL_OFFSET(0x0234)
+#define REG_VIP			GLOBAL_OFFSET(0x0238)
+#define REG_SDIO0XIN		GLOBAL_OFFSET(0x023c)
+#define REG_SDIO1XIN		GLOBAL_OFFSET(0x0240)
+#define REG_GFX3D_EXTRA		GLOBAL_OFFSET(0x0244)
+
+#define REG_GC360		GLOBAL_OFFSET(0x024c)
+#define REG_SDIO_DLLMST		GLOBAL_OFFSET(0x0250)
+
+static const struct berlin2_pll_map bg2_pll_map __initdata = {
+	.vcodiv		= {10, 15, 20, 25, 30, 40, 50, 60, 80},
+	.mult		= 10,
+	.fbdiv_shift	= 6,
+	.rfdiv_shift	= 1,
+	.divsel_shift	= 7,
+};
+
+static const struct berlin2_pll_data bg2_plls[] __initdata = {
+	{ .name = "syspll", .offset = REG_SYSPLL, },
+	{ .name = "mempll", .offset = REG_MEMPLL, },
+	{ .name = "cpupll", .offset = REG_CPUPLL, },
+};
+
+static const char *audio1_pll_mux[] __initconst = { "avpll_b3", "avpll_a3" };
+static const char *video1_pll_mux[] __initconst = { "avpll_a2", "avpll_b2" };
+static const char *video2_pll_mux[] __initconst = { "avpll_b1", "avpll_a5" };
+
+static const char *video0_in_mux[] __initconst = { "video0_pll", "video_ext0" };
+static const char *video1_in_mux[] __initconst = { "video1_pll", "video_ext0" };
+static const char *video2_in_mux[] __initconst = { "video2_pll", "video_ext0" };
+
+static const struct berlin2_mux_data bg2_muxes[] __initdata = {
+	/*
+	 * CLKSELECT2
+	 *
+	 * AUDIO_FAST_EXT, bit 15: 0 = ACLKI0, 1 = ACLKI1
+	 * AUDIO_FAST_IN,  bit 16: 0 = Audio Fast PLL, 1 = Audio Fast Ext
+	 * -> always selects Audio Fast PLL because of missing external clocks
+	 *
+	 * AUDIOHD_EXT, bit 26: 0 = ACLKI0, 1 = ACLKI1
+	 * AUDIOHD_IN,  bit 27: 0 = AudioHD PLL, 1 = AudioHD Ext
+	 * -> always selects AudioHD PLL because of missing external clocks
+	 *
+	 * AUDIO1_EXT, bit 28: 0 = ACLKI0, 1 = ACLKI1
+	 * AUDIO1_IN,  bit 30: 0 = Audio1 PLL, 1 = Audio1 Ext
+	 * -> always selects Audio1 PLL because of missing external clocks
+	 */
+	{
+		.name = "audio1_pll",
+		.offset = REG_CLKSELECT2, .shift = 29, .width = 1,
+		.parent_names = audio1_pll_mux,
+		.num_parents = ARRAY_SIZE(audio1_pll_mux),
+	},
+	/*
+	 * CLKSELECT3
+	 *
+	 * VIDEO0_EXT, bit 3: 0 = VCLKI0, 1 = VCLKI1
+	 * VIDEO0_IN,  bit 4: 0 = Video0 PLL, 1 = Video0 Ext
+	 * -> always selects Video0 PLL or VCLKI0 because of missing VCLKI1
+	 *
+	 * VIDEO1_EXT, bit 5: 0 = VCLKI0, 1 = VCLKI1
+	 * VIDEO1_IN,  bit 6: 0 = Video1 PLL, 1 = Video1 Ext
+	 * -> always selects Video1 PLL or VCLKI0 because of missing VCLKI1
+	 *
+	 * VIDEO2_EXT, bit 8: 0 = VCLKI0, 1 = VCLKI1
+	 * VIDEO2_IN,  bit 9: 0 = Video2 PLL, 1 = Video2 Ext
+	 * -> always selects Video2 PLL or VCLKI0 because of missing VCLKI1
+	 *
+	 */
+	{
+		.name = "video0_in",
+		.offset = REG_CLKSELECT3, .shift = 4, .width = 1,
+		.parent_names = video0_in_mux,
+		.num_parents = ARRAY_SIZE(video0_in_mux),
+	},
+	{
+		.name = "video1_in",
+		.offset = REG_CLKSELECT3, .shift = 6, .width = 1,
+		.parent_names = video1_in_mux,
+		.num_parents = ARRAY_SIZE(video1_in_mux),
+	},
+	{
+		.name = "video1_pll",
+		.offset = REG_CLKSELECT3, .shift = 7, .width = 1,
+		.parent_names = video1_pll_mux,
+		.num_parents = ARRAY_SIZE(video1_pll_mux),
+	},
+	{
+		.name = "video2_in",
+		.offset = REG_CLKSELECT3, .shift = 9, .width = 1,
+		.parent_names = video2_in_mux,
+		.num_parents = ARRAY_SIZE(video2_in_mux),
+	},
+	{
+		.name = "video2_pll",
+		.offset = REG_CLKSELECT3, .shift = 10, .width = 1,
+		.parent_names = video2_pll_mux,
+		.num_parents = ARRAY_SIZE(video2_pll_mux),
+	},
+};
+
+static const char *default_div_sel[] __initconst = {
+	"syspll", "avpll_b4", "avpll_b5", "avpll_b6", "avpll_b7",
+};
+
+static const char *cpu_div_sel[] __initconst = {
+	"cpupll", "avpll_b4", "avpll_b5", "avpll_b6", "avpll_b7", "mempll",
+};
+
+static const char *audio_fast_div_sel[] __initconst = { "audio_fast_pll" };
+static const char *audio1_div_sel[] __initconst = { "audio1_pll" };
+
+static const struct berlin2_div_data bg2_divs[] __initdata = {
+	{
+		.name = "sys",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 0),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 0),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 3),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 3),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 4),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 5),
+		},
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	{
+		.name = "cpu",
+		.parent_names = cpu_div_sel,
+		.num_parents = ARRAY_SIZE(cpu_div_sel),
+		.map = {
+			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 6),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 9),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 6),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 7),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 8),
+		},
+	},
+	{
+		.name = "drmfigo",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 16),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 17),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 20),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 12),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 13),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 14),
+		},
+	},
+	{
+		.name = "cfg",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 1),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 23),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 26),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 15),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 16),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 17),
+		},
+	},
+	{
+		.name = "gfx",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 4),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 29),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 0),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 18),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 19),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 20),
+		},
+	},
+	{
+		.name = "zsp",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 5),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 3),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 6),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 21),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 22),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 23),
+		},
+	},
+	{
+		.name = "perif",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 6),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 9),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 12),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 24),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 25),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 26),
+		},
+		.flags = CLK_IGNORE_UNUSED,
+	},
+	{
+		.name = "pcube",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 2),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 15),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 18),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 27),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 28),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 29),
+		},
+	},
+	{
+		.name = "vscope",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 3),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 21),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 24),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 30),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 31),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 0),
+		},
+	},
+	{
+		.name = "nfc_ecc",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 18),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 27),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 0),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH1, 1),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 2),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 3),
+		},
+	},
+	{
+		.name = "vpp",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 21),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT2, 3),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 6),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH1, 4),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 5),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 6),
+		},
+	},
+	{
+		.name = "app",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 20),
+			BERLIN2_PLL_SELECT(REG_CLKSELECT2, 9),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 12),
+			BERLIN2_PLL_SWITCH(REG_CLKSWITCH1, 7),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 8),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 9),
+		},
+	},
+	{
+		.name = "audio0",
+		.parent_names = audio_fast_div_sel,
+		.num_parents = ARRAY_SIZE(audio_fast_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 22),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 17),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 10),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 11),
+		},
+	},
+	{
+		.name = "audio2",
+		.parent_names = audio_fast_div_sel,
+		.num_parents = ARRAY_SIZE(audio_fast_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 24),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 20),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 14),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 15),
+		},
+	},
+	{
+		.name = "audio3",
+		.parent_names = audio_fast_div_sel,
+		.num_parents = ARRAY_SIZE(audio_fast_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 25),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 23),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 16),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 17),
+		},
+	},
+	{
+		.name = "audio1",
+		.parent_names = audio1_div_sel,
+		.num_parents = ARRAY_SIZE(audio1_div_sel),
+		.map = {
+			BERLIN2_DIV_GATE(REG_CLKENABLE, 23),
+			BERLIN2_DIV_SELECT(REG_CLKSELECT3, 0),
+			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 12),
+			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 13),
+		},
+	},
+	{
+		.name = "gfx3d_core",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_GFX3D_CORE) },
+	},
+	{
+		.name = "gfx3d_sys",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_GFX3D_SYS) },
+	},
+	{
+		.name = "arc",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_ARC) },
+	},
+	{
+		.name = "vip",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_VIP) },
+	},
+	{
+		.name = "sdio0xin",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_SDIO0XIN) },
+	},
+	{
+		.name = "sdio1xin",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_SDIO1XIN) },
+	},
+	{
+		.name = "gfx3d_extra",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_GFX3D_EXTRA) },
+	},
+	{
+		.name = "gc360",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_GC360) },
+	},
+	{
+		.name = "sdio_dllmst",
+		.parent_names = default_div_sel,
+		.num_parents = ARRAY_SIZE(default_div_sel),
+		.map = { BERLIN2_SINGLE_DIV(REG_SDIO_DLLMST) },
+	},
+};
+
+static const struct berlin2_gate_data bg2_gates[] __initdata = {
+	{ "geth0",	"perif",	7 },
+	{ "geth1",	"perif",	8 },
+	{ "sata",	"perif",	9 },
+	{ "ahbapb",	"perif",	10, CLK_IGNORE_UNUSED },
+	{ "usb0",	"perif",	11 },
+	{ "usb1",	"perif",	12 },
+	{ "pbridge",	"perif",	13, CLK_IGNORE_UNUSED },
+	{ "sdio0",	"perif",	14 },
+	{ "sdio1",	"perif",	15 },
+	{ "nfc",	"perif",	17 },
+	{ "smemc",	"perif",	19 },
+	{ "audiohd",	"audiohd_pll",	26 },
+	{ "video0",	"video0_in",	27 },
+	{ "video1",	"video1_in",	28 },
+	{ "video2",	"video2_in",	29 },
+};
+
+static const char *bg2_clocks[] __initconst = {
+	[0] = "ahbapb",
+	[1] = "app",
+	[2] = "arc",
+	[3] = "audio0",
+	[4] = "audio1",
+	[5] = "audio2",
+	[6] = "audio3",
+	[7] = "audiohd",
+	[8] = "cfg",
+	[9] = "cpu",
+	[10] = "drmfigo",
+	[11] = "gc360",
+	[12] = "geth0",
+	[13] = "geth1",
+	[14] = "gfx",
+	[15] = "gfx3d_core",
+	[16] = "gfx3d_extra",
+	[17] = "gfx3d_sys",
+	[18] = "nfc",
+	[19] = "nfc_ecc",
+	[20] = "pbridge",
+	[21] = "perif",
+	[22] = "pcube",
+	[23] = "sata",
+	[24] = "sdio_dllmst",
+	[25] = "sdio0",
+	[26] = "sdio0xin",
+	[27] = "sdio1",
+	[28] = "sdio1xin",
+	[29] = "smemc",
+	[30] = "sys",
+	[31] = "usb0",
+	[32] = "usb1",
+	[33] = "video0",
+	[34] = "video1",
+	[35] = "video2",
+	[36] = "vip",
+	[37] = "vpp",
+	[38] = "vscope",
+	[39] = "zsp",
+};
+
+static spinlock_t lock;
+static struct clk_onecell_data clk_data;
+
+static void __init bg2_clock_tree_setup(struct device_node *np)
+{
+	void __iomem *base;
+	struct clk *iclk;
+	const char *refclk_name;
+	int n;
+
+	clk_data.clk_num = ARRAY_SIZE(bg2_clocks);
+	clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk *),
+				GFP_KERNEL);
+	if (!clk_data.clks)
+		return;
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		pr_err("Unable to map clock tree register base\n");
+		kfree(clk_data.clks);
+		return;
+	}
+
+	iclk = of_clk_get_by_name(np, "refclk");
+	if (IS_ERR(iclk)) {
+		pr_err("Missing reference clock\n");
+		iounmap(base);
+		kfree(clk_data.clks);
+		return;
+	}
+
+	refclk_name = __clk_get_name(iclk);
+	clk_put(iclk);
+	spin_lock_init(&lock);
+
+	/* register clk alias for optional external video clock */
+	iclk = of_clk_get_by_name(np, "video_ext0");
+	if (!IS_ERR(iclk)) {
+		clk_add_alias(__clk_get_name(iclk), NULL, "video_ext0", NULL);
+		clk_put(iclk);
+	}
+
+	/* Standard PLLs */
+	for (n = 0; n < ARRAY_SIZE(bg2_plls); n++) {
+		const struct berlin2_pll_data *data = &bg2_plls[n];
+		struct clk *pll;
+
+		pll = berlin2_pll_register(&bg2_pll_map, base + data->offset,
+				   data->name, refclk_name, data->flags);
+		if (IS_ERR(pll))
+			pr_err("Failed to register pll %s\n", data->name);
+	}
+
+	/* AV PLL */
+	clk_register_fixed_rate(NULL, "avpll_a2", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_a3", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_a5", NULL, 0, 648000000);
+
+	clk_register_fixed_rate(NULL, "avpll_b1", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b2", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b3", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b4", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b5", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b6", NULL, 0, 648000000);
+	clk_register_fixed_rate(NULL, "avpll_b7", NULL, 0, 648000000);
+
+	/* clock mux cells */
+	for (n = 0; n < ARRAY_SIZE(bg2_muxes); n++) {
+		const struct berlin2_mux_data *data = &bg2_muxes[n];
+		struct clk *mux;
+
+		mux = clk_register_mux(NULL, data->name, data->parent_names,
+				       data->num_parents, data->flags,
+				       base + data->offset, data->shift,
+				       data->width, 0, &lock);
+		if (IS_ERR(mux))
+			pr_err("Failed to register mux %s\n", data->name);
+	}
+
+	/* clock divider cells */
+	for (n = 0; n < ARRAY_SIZE(bg2_divs); n++) {
+		const struct berlin2_div_data *data = &bg2_divs[n];
+		struct clk *div;
+
+		div = berlin2_div_register(&data->map, base, data->name,
+				   data->parent_names, data->num_parents,
+				   data->flags, &lock);
+		if (IS_ERR(div))
+			pr_err("Failed to register div %s\n", data->name);
+	}
+
+	/* clock gate cells */
+	for (n = 0; n < ARRAY_SIZE(bg2_gates); n++) {
+		const struct berlin2_gate_data *data = &bg2_gates[n];
+		struct clk *gate;
+
+		gate = clk_register_gate(NULL, data->name, data->parent_name,
+					 data->flags, base + REG_CLKENABLE,
+					 data->bit_idx, 0, &lock);
+		if (IS_ERR(gate))
+			pr_err("Failed to register gate %s\n", data->name);
+	}
+
+	/* register clk-provider */
+	for (n = 0; n < ARRAY_SIZE(bg2_clocks); n++)
+		clk_data.clks[n] = __clk_lookup(bg2_clocks[n]);
+
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+}
+CLK_OF_DECLARE(bg2_clktree, "marvell,berlin2-clock-tree",
+	       bg2_clock_tree_setup);
diff --git a/drivers/clk/berlin/common.h b/drivers/clk/berlin/common.h
new file mode 100644
index 000000000000..1d8f179d9690
--- /dev/null
+++ b/drivers/clk/berlin/common.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __BERLIN_CLK_COMMON_H
+#define __BERLIN_CLK_COMMON_H
+
+#include <linux/clk.h>
+
+struct berlin2_pll_map {
+	const u8 vcodiv[16];
+	u8 mult;
+	u8 fbdiv_shift;
+	u8 rfdiv_shift;
+	u8 divsel_shift;
+};
+
+struct berlin2_pll_data {
+	const char *name;
+	u32 offset;
+	unsigned long flags;
+};
+
+struct berlin2_div_map {
+	u16 pll_select_offs;
+	u16 pll_switch_offs;
+	u16 div_select_offs;
+	u16 div_switch_offs;
+	u16 div3_switch_offs;
+	u16 gate_offs;
+	u8 pll_select_shift;
+	u8 pll_switch_shift;
+	u8 div_select_shift;
+	u8 div_switch_shift;
+	u8 div3_switch_shift;
+	u8 gate_shift;
+	u8 has_pll_select:1;
+	u8 has_pll_switch:1;
+	u8 has_gate:1;
+};
+
+struct berlin2_div_data {
+	const char *name;
+	const char **parent_names;
+	int num_parents;
+	struct berlin2_div_map map;
+	unsigned long flags;
+};
+
+struct berlin2_mux_data {
+	const char *name;
+	const char **parent_names;
+	int num_parents;
+	u16 offset;
+	u8 shift;
+	u8 width;
+	unsigned long flags;
+};
+
+struct berlin2_gate_data {
+	const char *name;
+	const char *parent_name;
+	u8 bit_idx;
+	unsigned long flags;
+};
+
+#define BERLIN2_PLL_SELECT(_off, _sh)	\
+	.pll_select_offs = _off,	\
+	.pll_select_shift = _sh,	\
+	.has_pll_select = 1
+
+#define BERLIN2_PLL_SWITCH(_off, _sh)	\
+	.pll_switch_offs = _off,	\
+	.pll_switch_shift = _sh,	\
+	.has_pll_switch = 1
+
+#define BERLIN2_DIV_SELECT(_off, _sh)	\
+	.div_select_offs = _off,	\
+	.div_select_shift = _sh		\
+
+#define BERLIN2_DIV_SWITCH(_off, _sh)	\
+	.div_switch_offs = _off,	\
+	.div_switch_shift = _sh
+
+#define BERLIN2_DIV_D3SWITCH(_off, _sh)	\
+	.div3_switch_offs = _off,	\
+	.div3_switch_shift = _sh
+
+#define BERLIN2_DIV_GATE(_off, _sh)	\
+	.gate_offs = _off,		\
+	.gate_shift = _sh,		\
+	.has_gate = 1
+
+#define BERLIN2_SINGLE_DIV(_reg)	\
+	BERLIN2_DIV_GATE(_reg, 0),	\
+	BERLIN2_PLL_SELECT(_reg, 1),	\
+	BERLIN2_PLL_SWITCH(_reg, 4),	\
+	BERLIN2_DIV_SWITCH(_reg, 5),	\
+	BERLIN2_DIV_D3SWITCH(_reg, 6),	\
+	BERLIN2_DIV_SELECT(_reg, 7)
+
+struct clk * __init
+berlin2_pll_register(const struct berlin2_pll_map *map,
+		     void __iomem *base, const char *name,
+		     const char *parent_name, unsigned long flags);
+
+struct clk * __init
+berlin2_div_register(const struct berlin2_div_map *map,
+		     void __iomem *base,  const char *name,
+		     const char **parent_names, int num_parents,
+		     unsigned long flags,  spinlock_t *lock);
+
+#endif /* BERLIN_CLK_COMMON_H */
-- 
1.9.1

