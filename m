Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbaJCWRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:17:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbaJCWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3.14 237/238] clk: qcom: Fix MN frequency tables, parent map, and jpegd
Date: Fri,  3 Oct 2014 14:32:32 -0700
Message-Id: <20141003212921.254232753@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit ff20783f7b9f35b29e768d8ecc7076c1ca1a60ca upstream.

Clocks that don't have a pre-divider don't list any pre-divider
in their frequency tables, but their tables are initialized using
aggregate initializers. Use tagged initializers so we properly
assign the m and n values for each frequency. Furthermore, the
mmcc_pxo_pll8_pll2_pll3 array improperly mapped the second
element to pll2 instead of pll8, causing the clock driver to
recalculate the wrong rate for any clocks using this array along
with a rate that uses pll2. Plus the .num_parents field is 3
instead of 4 so you can't even switch the parent to pll3. Finally
I noticed that the jpegd clock improperly indicates that the
pre-divider width is only 2, when it's actually 4 bits wide.

Fixes: 6d00b56fe "clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)"
Tested-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/mmcc-msm8960.c |   82 ++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -37,6 +37,8 @@
 #define P_PLL2	2
 #define P_PLL3	3
 
+#define F_MN(f, s, _m, _n) { .freq = f, .src = s, .m = _m, .n = _n }
+
 static u8 mmcc_pxo_pll8_pll2_map[] = {
 	[P_PXO]		= 0,
 	[P_PLL8]	= 2,
@@ -58,8 +60,8 @@ static u8 mmcc_pxo_pll8_pll2_pll3_map[]
 
 static const char *mmcc_pxo_pll8_pll2_pll3[] = {
 	"pxo",
-	"pll2",
 	"pll8_vote",
+	"pll2",
 	"pll3",
 };
 
@@ -709,18 +711,18 @@ static struct clk_branch csiphy2_timer_c
 };
 
 static struct freq_tbl clk_tbl_gfx2d[] = {
-	{  27000000, P_PXO,  1,  0 },
-	{  48000000, P_PLL8, 1,  8 },
-	{  54857000, P_PLL8, 1,  7 },
-	{  64000000, P_PLL8, 1,  6 },
-	{  76800000, P_PLL8, 1,  5 },
-	{  96000000, P_PLL8, 1,  4 },
-	{ 128000000, P_PLL8, 1,  3 },
-	{ 145455000, P_PLL2, 2, 11 },
-	{ 160000000, P_PLL2, 1,  5 },
-	{ 177778000, P_PLL2, 2,  9 },
-	{ 200000000, P_PLL2, 1,  4 },
-	{ 228571000, P_PLL2, 2,  7 },
+	F_MN( 27000000, P_PXO,  1,  0),
+	F_MN( 48000000, P_PLL8, 1,  8),
+	F_MN( 54857000, P_PLL8, 1,  7),
+	F_MN( 64000000, P_PLL8, 1,  6),
+	F_MN( 76800000, P_PLL8, 1,  5),
+	F_MN( 96000000, P_PLL8, 1,  4),
+	F_MN(128000000, P_PLL8, 1,  3),
+	F_MN(145455000, P_PLL2, 2, 11),
+	F_MN(160000000, P_PLL2, 1,  5),
+	F_MN(177778000, P_PLL2, 2,  9),
+	F_MN(200000000, P_PLL2, 1,  4),
+	F_MN(228571000, P_PLL2, 2,  7),
 	{ }
 };
 
@@ -841,22 +843,22 @@ static struct clk_branch gfx2d1_clk = {
 };
 
 static struct freq_tbl clk_tbl_gfx3d[] = {
-	{  27000000, P_PXO,  1,  0 },
-	{  48000000, P_PLL8, 1,  8 },
-	{  54857000, P_PLL8, 1,  7 },
-	{  64000000, P_PLL8, 1,  6 },
-	{  76800000, P_PLL8, 1,  5 },
-	{  96000000, P_PLL8, 1,  4 },
-	{ 128000000, P_PLL8, 1,  3 },
-	{ 145455000, P_PLL2, 2, 11 },
-	{ 160000000, P_PLL2, 1,  5 },
-	{ 177778000, P_PLL2, 2,  9 },
-	{ 200000000, P_PLL2, 1,  4 },
-	{ 228571000, P_PLL2, 2,  7 },
-	{ 266667000, P_PLL2, 1,  3 },
-	{ 300000000, P_PLL3, 1,  4 },
-	{ 320000000, P_PLL2, 2,  5 },
-	{ 400000000, P_PLL2, 1,  2 },
+	F_MN( 27000000, P_PXO,  1,  0),
+	F_MN( 48000000, P_PLL8, 1,  8),
+	F_MN( 54857000, P_PLL8, 1,  7),
+	F_MN( 64000000, P_PLL8, 1,  6),
+	F_MN( 76800000, P_PLL8, 1,  5),
+	F_MN( 96000000, P_PLL8, 1,  4),
+	F_MN(128000000, P_PLL8, 1,  3),
+	F_MN(145455000, P_PLL2, 2, 11),
+	F_MN(160000000, P_PLL2, 1,  5),
+	F_MN(177778000, P_PLL2, 2,  9),
+	F_MN(200000000, P_PLL2, 1,  4),
+	F_MN(228571000, P_PLL2, 2,  7),
+	F_MN(266667000, P_PLL2, 1,  3),
+	F_MN(300000000, P_PLL3, 1,  4),
+	F_MN(320000000, P_PLL2, 2,  5),
+	F_MN(400000000, P_PLL2, 1,  2),
 	{ }
 };
 
@@ -896,7 +898,7 @@ static struct clk_dyn_rcg gfx3d_src = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gfx3d_src",
 			.parent_names = mmcc_pxo_pll8_pll2_pll3,
-			.num_parents = 3,
+			.num_parents = 4,
 			.ops = &clk_dyn_rcg_ops,
 		},
 	},
@@ -994,7 +996,7 @@ static struct clk_rcg jpegd_src = {
 	.ns_reg = 0x00ac,
 	.p = {
 		.pre_div_shift = 12,
-		.pre_div_width = 2,
+		.pre_div_width = 4,
 	},
 	.s = {
 		.src_sel_shift = 0,
@@ -1341,15 +1343,15 @@ static struct clk_branch hdmi_app_clk =
 };
 
 static struct freq_tbl clk_tbl_vcodec[] = {
-	{  27000000, P_PXO,  1,  0 },
-	{  32000000, P_PLL8, 1, 12 },
-	{  48000000, P_PLL8, 1,  8 },
-	{  54860000, P_PLL8, 1,  7 },
-	{  96000000, P_PLL8, 1,  4 },
-	{ 133330000, P_PLL2, 1,  6 },
-	{ 200000000, P_PLL2, 1,  4 },
-	{ 228570000, P_PLL2, 2,  7 },
-	{ 266670000, P_PLL2, 1,  3 },
+	F_MN( 27000000, P_PXO,  1,  0),
+	F_MN( 32000000, P_PLL8, 1, 12),
+	F_MN( 48000000, P_PLL8, 1,  8),
+	F_MN( 54860000, P_PLL8, 1,  7),
+	F_MN( 96000000, P_PLL8, 1,  4),
+	F_MN(133330000, P_PLL2, 1,  6),
+	F_MN(200000000, P_PLL2, 1,  4),
+	F_MN(228570000, P_PLL2, 2,  7),
+	F_MN(266670000, P_PLL2, 1,  3),
 	{ }
 };
 


