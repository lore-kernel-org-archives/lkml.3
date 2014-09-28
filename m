Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaI1JKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:10:19 -0400
Received: from mail-bn1bon0135.outbound.protection.outlook.com ([157.56.111.135]:1382
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbaI1JKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:10:17 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Sun, 28 Sep 2014 17:09:54 +0800
Message-ID: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(76482002)(90102001)(19580405001)(19580395003)(10300001)(21056001)(50466002)(83322001)(62966002)(68736004)(69596002)(6806004)(44976005)(102836001)(77982003)(74662003)(46102003)(81542003)(81342003)(74502003)(79102003)(80022003)(99396003)(77156001)(85306004)(120916001)(105606002)(64706001)(81156004)(229853001)(106466001)(95666004)(20776003)(36756003)(31966008)(26826002)(4396001)(48376002)(50226001)(88136002)(110136001)(93916002)(2351001)(107046002)(84676001)(92726001)(86362001)(92566001)(47776003)(50986999)(87286001)(85852003)(104166001)(104016003)(83072002)(89996001)(97736003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we cannot make sure the 'val_count' will always be none zero
here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 455a877..3d93e38 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1716,6 +1716,9 @@ out:
 	} else {
 		void *wval;
 
+		if (!val_count)
+			return -EINVAL;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			dev_err(map->dev, "Error in memory allocation\n");
-- 
2.1.0.27.g96db324

