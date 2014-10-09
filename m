Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaJITaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:30:08 -0400
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:20848
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbaJIT34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:29:56 -0400
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2014 15:29:55 EDT
From: Vince Bridgers <vbridger@opensource.altera.com>
To: <peppe.cavallaro@st.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <vbridger@altera.com>, <vbridger@opensource.altera.com>
Subject: [PATCH net] stmmac: correct mc_filter local variable in set_filter and set_mac_addr call
Date: Thu, 9 Oct 2014 10:10:36 -0500
Message-ID: <1412867436-22153-1-git-send-email-vbridger@opensource.altera.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0044.namprd08.prod.outlook.com (10.141.200.24) To
 BN1PR0301MB0626.namprd03.prod.outlook.com (25.160.171.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(50226001)(229853001)(102836001)(99396003)(85852003)(77096002)(88136002)(101416001)(2201001)(87286001)(92726001)(64706001)(47776003)(20776003)(76482002)(50466002)(85306004)(21056001)(92566001)(107046002)(86362001)(93916002)(48376002)(95666004)(87976001)(122386002)(19580405001)(19580395003)(89996001)(77156001)(106356001)(31966008)(97736003)(80022003)(50986999)(46102003)(69596002)(104166001)(81156004)(42186005)(62966002)(105586002)(40100002)(33646002)(53416004)(4396001)(120916001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR0301MB0626;H:vince-HP-Z620-Workstation2.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing revealed that the local variable mc_filter was dimensioned
incorrectly for all possible configurations and get_mac_addr should
have been set_mac_addr (a typo). Make sure mc_filter is dimensioned
to 8 32-bit unsigned longs - the largest size of the Synopsys
multicast filter register set.

Signed-off-by: Vince Bridgers <vbridger@opensource.altera.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 5efe60e..0adcf73 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -134,7 +134,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
 	unsigned int value = 0;
 	unsigned int perfect_addr_number = hw->unicast_filter_entries;
-	u32 mc_filter[2];
+	u32 mc_filter[8];
 	int mcbitslog2 = hw->mcast_bits_log2;
 
 	pr_debug("%s: # mcasts %d, # unicast %d\n", __func__,
@@ -182,7 +182,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 		struct netdev_hw_addr *ha;
 
 		netdev_for_each_uc_addr(ha, dev) {
-			stmmac_get_mac_addr(ioaddr, ha->addr,
+			stmmac_set_mac_addr(ioaddr, ha->addr,
 					    GMAC_ADDR_HIGH(reg),
 					    GMAC_ADDR_LOW(reg));
 			reg++;
-- 
1.9.1

