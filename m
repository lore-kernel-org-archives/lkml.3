Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaIRIV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:21:59 -0400
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:48576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbaIRIV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:21:56 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] mfd: core: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Thu, 18 Sep 2014 16:21:39 +0800
Message-ID: <1411028499-44474-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(81342003)(83322001)(20776003)(19580405001)(77982003)(46102003)(79102003)(74662003)(74502003)(229853001)(107046002)(88136002)(86362001)(62966002)(31966008)(64706001)(26826002)(50986999)(4396001)(106466001)(85852003)(50226001)(105606002)(104016003)(50466002)(81542003)(76482002)(84676001)(87286001)(83072002)(19580395003)(97736003)(87936001)(104166001)(6806004)(85306004)(92566001)(93916002)(95666004)(102836001)(21056001)(92726001)(48376002)(68736004)(80022003)(36756003)(47776003)(99396002)(89996001)(90102001)(44976005)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0609;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we cannot make sure the 'cell->num_resources' will always be none
zero here, and then if either equal to zero, the kzalloc() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kzalloc().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/mfd/mfd-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 892d343..54c7e35 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -89,6 +89,9 @@ static int mfd_add_device(struct device *parent, int id,
 	int ret = -ENOMEM;
 	int r;
 
+	if (!cell->num_resources)
+		return -EINVAL;
+
 	pdev = platform_device_alloc(cell->name, id + cell->id);
 	if (!pdev)
 		goto fail_alloc;
-- 
2.1.0.27.g96db324

