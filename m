Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaJHWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:49:50 -0400
Received: from mail-bn1on0076.outbound.protection.outlook.com ([157.56.110.76]:19015
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbaJHWtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:49:46 -0400
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <atull@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] reset: add reset_control_status helper function
Date: Wed, 8 Oct 2014 17:45:51 -0500
Message-ID: <1412808351-4598-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0042.namprd05.prod.outlook.com (10.141.20.12) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(50466002)(102836001)(31966008)(50226001)(64706001)(93916002)(99396003)(77156001)(110136001)(21056001)(48376002)(85306004)(85852003)(77096002)(76482002)(107046002)(229853001)(66066001)(19580395003)(97736003)(47776003)(19580405001)(122386002)(92566001)(69596002)(20776003)(86152002)(101416001)(4396001)(42186005)(50986999)(88136002)(62966002)(33646002)(106356001)(81156004)(105586002)(87286001)(92726001)(87976001)(89996001)(53416004)(120916001)(46102003)(86362001)(2351001)(40100002)(104166001)(95666004)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0838;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

There are cases where a system will want to read a reset status bit before
doing any other toggling. Add a reset_control_status helper function to the
reset controller API.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/reset/core.c             | 13 +++++++++++++
 include/linux/reset-controller.h |  1 +
 include/linux/reset.h            |  7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index baeaf82..06387a4 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -126,6 +126,19 @@ int reset_control_deassert(struct reset_control *rstc)
 EXPORT_SYMBOL_GPL(reset_control_deassert);
 
 /**
+ * reset_control_status - returns a status of a reset bit
+ * @rstc: reset controller
+ */
+unsigned int reset_control_status(struct reset_control *rstc)
+{
+	if (rstc->rcdev->ops->status)
+		return rstc->rcdev->ops->status(rstc->rcdev, rstc->id);
+
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(reset_control_status);
+
+/**
  * of_reset_control_get - Lookup and obtain a reference to a reset controller.
  * @node: device to be reset by the controller
  * @id: reset line name
diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index 41a4695..8e659d5 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -17,6 +17,7 @@ struct reset_control_ops {
 	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
 	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
 	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
+	unsigned int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
 };
 
 struct module;
diff --git a/include/linux/reset.h b/include/linux/reset.h
index 349f150..09233ee 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -10,6 +10,7 @@ struct reset_control;
 int reset_control_reset(struct reset_control *rstc);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
+unsigned int reset_control_status(struct reset_control *rstc);
 
 struct reset_control *reset_control_get(struct device *dev, const char *id);
 void reset_control_put(struct reset_control *rstc);
@@ -57,6 +58,12 @@ static inline int reset_control_deassert(struct reset_control *rstc)
 	return 0;
 }
 
+static inline unsigned int reset_control_status(struct reset_control *rstc)
+{
+	WARN_ON(1);
+	return 0;
+}
+
 static inline void reset_control_put(struct reset_control *rstc)
 {
 	WARN_ON(1);
-- 
2.0.3

