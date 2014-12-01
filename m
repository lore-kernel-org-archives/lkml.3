Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaLAUFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:05:34 -0500
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:37120
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932101AbaLAUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:05:32 -0500
From: <dinguyen@opensource.altera.com>
To: <davem@davemloft.net>, <peppe.cavallaro@st.com>
CC: <dinh.linux@gmail.com>, <maxime.ripard@free-electrons.com>,
        <olof@lixom.net>, <vbridger@opensource.altera.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] stmmac: platform: fix stmmac probe failure
Date: Mon, 1 Dec 2014 14:00:54 -0600
Message-ID: <1417464054-8777-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0050.namprd02.prod.outlook.com (10.141.56.50) To
 CY1PR0301MB1194.namprd03.prod.outlook.com (25.160.165.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1194;
X-Forefront-PRVS: 0412A98A59
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(101416001)(102836001)(86152002)(92726001)(48376002)(92566001)(50986999)(42186005)(66066001)(87286001)(95666004)(104166001)(20776003)(88136002)(68736005)(47776003)(53416004)(87976001)(81156004)(40100003)(106356001)(46102003)(89996001)(64706001)(105586002)(19580405001)(19580395003)(99396003)(77096004)(97736003)(69596002)(107046002)(120916001)(50226001)(122386002)(4396001)(229853001)(31966008)(33646002)(93916002)(86362001)(21056001)(575784001)(62966003)(77156002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1194;H:linux-builds1.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1194;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

The commit 571dcfde23712b ("stmmac: platform: fix default values of the filter
bins setting") broke support for stmmac probe for all CONFIG_OF platforms.

[    0.743567] Unable to handle kernel NULL pointer dereference at virtual address 00000048
[    0.751679] pgd = c0004000
[    0.754384] [00000048] *pgd=00000000
[    0.757983] Internal error: Oops: 805 [#1] SMP ARM
[    0.762774] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc7 #1
[    0.769034] task: ee86c000 ti: ee870000 task.ti: ee870000
[    0.774429] PC is at stmmac_pltfr_probe+0x40/0x5d0
[    0.779217] LR is at devm_ioremap_nocache+0x54/0x74
...
[    0.951644] [<c0287938>] (stmmac_pltfr_probe) from [<c0234c4c>] (platform_drv_probe+0x44/0xa4)
[    0.960250] [<c0234c4c>] (platform_drv_probe) from [<c023390c>] (driver_probe_device+0x10c/0x240)
[    0.969113] [<c023390c>] (driver_probe_device) from [<c0233b10>] (__driver_attach+0x8c/0x90)
[    0.977544] [<c0233b10>] (__driver_attach) from [<c02320fc>] (bus_for_each_dev+0x6c/0xa0)

The reason is that in stmmac_pltfr_probe(), the plat_dat on a CONFIG_OF
platform is NULL until devm_kzalloc() is called to allocate plat_dat.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5b0da39..62c9e75 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -265,12 +265,6 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 
 	plat_dat = dev_get_platdata(&pdev->dev);
 
-	/* Set default value for multicast hash bins */
-	plat_dat->multicast_filter_bins = HASH_TABLE_SIZE;
-
-	/* Set default value for unicast filter entries */
-	plat_dat->unicast_filter_entries = 1;
-
 	if (pdev->dev.of_node) {
 		if (!plat_dat)
 			plat_dat = devm_kzalloc(&pdev->dev,
@@ -288,6 +282,12 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Set default value for multicast hash bins */
+	plat_dat->multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat_dat->unicast_filter_entries = 1;
+
 	/* Custom setup (if needed) */
 	if (plat_dat->setup) {
 		plat_dat->bsp_priv = plat_dat->setup(pdev);
-- 
2.0.3

