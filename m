Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaESIBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:01:08 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:23222
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752870AbaESIBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:01:07 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Mon, 19 May 2014 15:13:45 +0800
Message-ID: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(81542001)(86362001)(76482001)(74662001)(31966008)(92566001)(92726001)(62966002)(81342001)(77982001)(74502001)(99396002)(50986999)(46102001)(48376002)(77096999)(88136002)(19580405001)(44976005)(85852003)(80022001)(83072002)(77156001)(83322001)(89996001)(19580395003)(6806004)(79102001)(102836001)(87286001)(4396001)(50226001)(64706001)(50466002)(93916002)(84676001)(21056001)(87936001)(47776003)(81156002)(36756003)(69596002)(20776003)(68736004)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB511;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we cannot make sure the 'chip->num_regs' will always be none zero
from the users, and then if 'chip->num_regs' equals to zero by mistake
or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which equals
to ((void *)16).

So this patch fix this with just checking the 'chip->num_regs' before
calling kzalloc().

This also sorts the header files in alphabetical order at the same time.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-irq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index edf88f2..6299a50 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -10,13 +10,13 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/export.h>
 #include <linux/device.h>
-#include <linux/regmap.h>
-#include <linux/irq.h>
+#include <linux/export.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/pm_runtime.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 
 #include "internal.h"
@@ -347,6 +347,9 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	int ret = -ENOMEM;
 	u32 reg;
 
+	if (chip->num_regs <= 0)
+		return -EINVAL;
+
 	for (i = 0; i < chip->num_irqs; i++) {
 		if (chip->irqs[i].reg_offset % map->reg_stride)
 			return -EINVAL;
-- 
1.8.4

