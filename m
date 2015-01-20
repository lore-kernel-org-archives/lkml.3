Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbbATSsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:48:33 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:14527
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbbATSsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:48:31 -0500
Date: Tue, 20 Jan 2015 12:43:10 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Tudor Ambarus <tudor.ambarus@freescale.com>,
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        Horia Geanta <horia.geanta@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: caam - don't emit ICV check failures to dmesg
Message-ID: <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
In-Reply-To: <20141211193018.2465016d545334a76c0f4bab@freescale.com>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
	<1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
	<20141106151714.GE4544@gondor.apana.org.au>
	<20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
	<20141211193018.2465016d545334a76c0f4bab@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(87936001)(64706001)(47776003)(86362001)(97736003)(46102003)(23726002)(93886004)(2950100001)(110136001)(46406003)(92566002)(19580395003)(6806004)(19580405001)(85426001)(77156002)(229853001)(106466001)(50226001)(76176999)(50986999)(36756003)(105606002)(68736005)(62966003)(77096005)(50466002)(100306002)(33646002)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB395;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR03MB395;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB395;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB395;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 18:48:26.4623
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB395
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICV check failures are part of normal operation;
leave user notification up to the higher levels,
as is done in s/w algorithm implementations.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/error.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 66d73bf..33e41ea 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -151,10 +151,15 @@ static void report_ccb_status(struct device *jrdev, const u32 status,
 	else
 		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
 
-	dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
-		status, error, idx_str, idx,
-		cha_str, cha_err_code,
-		err_str, err_err_code);
+	/*
+	 * CCB ICV check failures are part of normal operation life;
+	 * we leave the upper layers to do what they want with them.
+	 */
+	if (err_id != JRSTA_CCBERR_ERRID_ICVCHK)
+		dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
+			status, error, idx_str, idx,
+			cha_str, cha_err_code,
+			err_str, err_err_code);
 }
 
 static void report_jump_status(struct device *jrdev, const u32 status,
-- 
2.2.2

