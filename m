Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaLOL2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:28:10 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:51442 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaLOLZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:25:52 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net: stmmac: sti: Fix uninitialized pointer dereference if !OF
Date: Mon, 15 Dec 2014 12:25:51 +0100
Message-Id: <1418642751-23308-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF is not set:

drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c: In function ‘sti_dwmac_parse_data’:
drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c:318: warning: ‘rs’ is used uninitialized in this function

of_property_read_string() will return -ENOSYS in this case, and rs will
be an uninitialized pointer.

While the fallback clock selection is already selected correctly in this
case, the string comparisons should be skipped too, else the system will
crash while dereferencing the uninitialized pointer.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index 0e137751e76e45b4..056b358b4a72441d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -309,16 +309,16 @@ static int sti_dwmac_parse_data(struct sti_dwmac *dwmac,
 
 	if (IS_PHY_IF_MODE_GBIT(dwmac->interface)) {
 		const char *rs;
-		dwmac->tx_retime_src = TX_RETIME_SRC_CLKGEN;
 
 		err = of_property_read_string(np, "st,tx-retime-src", &rs);
-		if (err < 0)
+		if (err < 0) {
 			dev_warn(dev, "Use internal clock source\n");
-
-		if (!strcasecmp(rs, "clk_125"))
+			dwmac->tx_retime_src = TX_RETIME_SRC_CLKGEN;
+		} else if (!strcasecmp(rs, "clk_125")) {
 			dwmac->tx_retime_src = TX_RETIME_SRC_CLK_125;
-		else if (!strcasecmp(rs, "txclk"))
+		} else if (!strcasecmp(rs, "txclk")) {
 			dwmac->tx_retime_src = TX_RETIME_SRC_TXCLK;
+		}
 
 		dwmac->speed = SPEED_1000;
 	}
-- 
1.9.1

