Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaJJGt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:49:26 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:54336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbaJJGtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:49:21 -0400
From: Zhao Qiang <B45475@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <B07421@freescale.com>
CC: <R63061@freescale.com>, Zhao Qiang <B45475@freescale.com>
Subject: [PATCH 2/3] qe: run qe_init and qe_ic_init
Date: Fri, 10 Oct 2014 14:48:45 +0800
Message-ID: <1412923725-9611-1-git-send-email-B45475@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(99396003)(85306004)(97736003)(85852003)(62966002)(48376002)(87936001)(88136002)(87286001)(89996001)(107046002)(95666004)(31966008)(81156004)(105606002)(229853001)(106466001)(104016003)(50226001)(4396001)(36756003)(80022003)(46102003)(68736004)(44976005)(69596002)(64706001)(104166001)(21056001)(19580405001)(77156001)(19580395003)(84676001)(47776003)(20776003)(6806004)(2201001)(92566001)(93916002)(92726001)(575784001)(50466002)(26826002)(102836001)(50986999)(120916001)(76482002)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB340;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB340;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03607C04F0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=qiang.zhao@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qe and qe_ic need to be initialized before the
qe app drivers, using subsys_initcall to run
qe_init and qe_ic_init

Signed-off-by: Zhao Qiang <B45475@freescale.com>
---
 drivers/soc/qe/qe.c    | 15 +++++++++++++++
 drivers/soc/qe/qe_ic.c | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/soc/qe/qe.c b/drivers/soc/qe/qe.c
index 2aaa5b2..bfea0f8 100644
--- a/drivers/soc/qe/qe.c
+++ b/drivers/soc/qe/qe.c
@@ -683,6 +683,21 @@ unsigned int qe_get_num_of_snums(void)
 }
 EXPORT_SYMBOL(qe_get_num_of_snums);
 
+static int __init qe_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qe");
+	if (!np) {
+		pr_err("%s: Could not find Quicc Engine node\n", __func__);
+		return -ENODEV;
+	}
+	qe_reset();
+	of_node_put(np);
+	return 0;
+}
+subsys_initcall(qe_init);
+
 #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC_85xx)
 static int qe_resume(struct platform_device *ofdev)
 {
diff --git a/drivers/soc/qe/qe_ic.c b/drivers/soc/qe/qe_ic.c
index cc1b8d5..11fe98c 100644
--- a/drivers/soc/qe/qe_ic.c
+++ b/drivers/soc/qe/qe_ic.c
@@ -34,6 +34,7 @@
 #include <linux/fsl/qe_ic.h>
 
 #include "qe_ic.h"
+#include "../../irqchip/irqchip.h"
 
 static DEFINE_RAW_SPINLOCK(qe_ic_lock);
 
@@ -501,4 +502,18 @@ static int __init init_qe_ic_sysfs(void)
 	return 0;
 }
 
+static int __init qeic_of_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qe-ic");
+	if (np) {
+		qe_ic_init(np, 0, qe_ic_cascade_low_mpic,
+			   qe_ic_cascade_high_mpic);
+		of_node_put(np);
+	}
+	return 0;
+}
+subsys_initcall(qeic_of_init);
+
 subsys_initcall(init_qe_ic_sysfs);
-- 
2.1.0.27.g96db324

