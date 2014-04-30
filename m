Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbaD3KQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:16:05 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:52710
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751702AbaD3KQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:16:04 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Wed, 30 Apr 2014 17:31:08 +0800
Message-ID: <1398850268-22258-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(84676001)(83072002)(62966002)(92726001)(85852003)(89996001)(77156001)(47776003)(74502001)(87936001)(76482001)(87286001)(88136002)(80022001)(36756003)(74662001)(31966008)(50226001)(79102001)(46102001)(92566001)(81542001)(99396002)(20776003)(77096999)(80976001)(19580395003)(19580405001)(86362001)(2009001)(93916002)(97736001)(81342001)(48376002)(44976005)(50466002)(77982001)(83322001)(101416001)(50986999)(6806004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB512;H:tx30smr01.am.freescale.net;FPR:74BFD35C.30E82621.F9D62958.8BD60AD1.2018B;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we cannot make sure the 'len = pair_size * num_regs' will always
be none zero from the users, and then if 'num_regs' equals to zero by
mistake or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which
equals to ((void *)16).

So this patch fix this with just doing the 'len' zero check before calling
kzalloc().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 18d193f..4ef7a24 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1685,6 +1685,9 @@ static int _regmap_raw_multi_reg_write(struct regmap *map,
 	size_t pair_size = reg_bytes + pad_bytes + val_bytes;
 	size_t len = pair_size * num_regs;
 
+	if (!len)
+		return -EINVAL;
+
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
1.8.4

