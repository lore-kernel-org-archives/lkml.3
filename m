Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3HTIzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:55:10 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:18643
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab3HTIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:55:08 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 04:55:08 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <kernel@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 3/3] staging: drm/imx: ldb: correct the ldb di clock trees
Date: Tue, 20 Aug 2013 16:38:52 +0800
Message-ID: <1376987932-5540-4-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ldb split mode, the ldb_di[0/1]_ipu_div dividers should
be configured as clock dividers of 1/3.5, while in others
ldb modes of 1/7. This patch gets the di[0/1]_div_3_5,
di[0/1]_div_7 and di[0/1]_div_sel clocks and sets the
di[0/1]_div_3_5 or di[0/1]_div_7 clocks to be the parents of
di[0/1]_div_sel clocks according to the ldb mode. The real
dividers are the two fixed factors bewteen the ldb_di[0/1] and
the pll clocks, so it's unnecessary to set the frequency for
the ldb_di[0/1] clocks again after pll clock frequency is set.
This patch removes the redundant clock frequency setting code
as well.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/staging/imx-drm/imx-ldb.c |   38 +++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index 8af7f3b..7c553b8 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -81,6 +81,9 @@ struct imx_ldb {
 	struct clk *clk[2]; /* our own clock */
 	struct clk *clk_sel[4]; /* parent of display clock */
 	struct clk *clk_pll[2]; /* upstream clock we can adjust */
+	struct clk *clk_div_3_5[2]; /* fixed factor of 1/3.5 */
+	struct clk *clk_div_7[2]; /* fixed factor of 1/7 */
+	struct clk *clk_div_sel[2]; /* 1/3.5 or 1/7 */
 	u32 ldb_ctrl;
 	const struct bus_mux *lvds_mux;
 };
@@ -150,6 +153,18 @@ static void imx_ldb_set_clock(struct imx_ldb *ldb, int mux, int chno,
 {
 	int ret;
 
+	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
+		ret = clk_set_parent(ldb->clk_div_sel[chno], ldb->clk_div_3_5[chno]);
+		if (ret)
+			dev_err(ldb->dev, "unable to set di%d_div_sel parent clock "
+				"to di%d_div_3_5\n", chno, chno);
+	} else {
+		ret = clk_set_parent(ldb->clk_div_sel[chno], ldb->clk_div_7[chno]);
+		if (ret)
+			dev_err(ldb->dev, "unable to set di%d_div_sel parent clock "
+				"to di%d_div_7\n", chno, chno);
+	}
+
 	dev_dbg(ldb->dev, "%s: now: %ld want: %ld\n", __func__,
 			clk_get_rate(ldb->clk_pll[chno]), serial_clk);
 	clk_set_rate(ldb->clk_pll[chno], serial_clk);
@@ -157,14 +172,6 @@ static void imx_ldb_set_clock(struct imx_ldb *ldb, int mux, int chno,
 	dev_dbg(ldb->dev, "%s after: %ld\n", __func__,
 			clk_get_rate(ldb->clk_pll[chno]));
 
-	dev_dbg(ldb->dev, "%s: now: %ld want: %ld\n", __func__,
-			clk_get_rate(ldb->clk[chno]),
-			(long int)di_clk);
-	clk_set_rate(ldb->clk[chno], di_clk);
-
-	dev_dbg(ldb->dev, "%s after: %ld\n", __func__,
-			clk_get_rate(ldb->clk[chno]));
-
 	/* set display clock mux to LDB input clock */
 	ret = clk_set_parent(ldb->clk_sel[mux], ldb->clk[chno]);
 	if (ret) {
@@ -362,6 +369,21 @@ static int imx_ldb_get_clk(struct imx_ldb *ldb, int chno)
 	if (IS_ERR(ldb->clk_pll[chno]))
 		return PTR_ERR(ldb->clk_pll[chno]);
 
+	sprintf(clkname, "di%d_div_3_5", chno);
+	ldb->clk_div_3_5[chno] = devm_clk_get(ldb->dev, clkname);
+	if (IS_ERR(ldb->clk_div_3_5[chno]))
+		return PTR_ERR(ldb->clk_div_3_5[chno]);
+
+	sprintf(clkname, "di%d_div_7", chno);
+	ldb->clk_div_7[chno] = devm_clk_get(ldb->dev, clkname);
+	if (IS_ERR(ldb->clk_div_7[chno]))
+		return PTR_ERR(ldb->clk_div_7[chno]);
+
+	sprintf(clkname, "di%d_div_sel", chno);
+	ldb->clk_div_sel[chno] = devm_clk_get(ldb->dev, clkname);
+	if (IS_ERR(ldb->clk_div_sel[chno]))
+		return PTR_ERR(ldb->clk_div_sel[chno]);
+
 	return 0;
 }
 
-- 
1.7.9.5


