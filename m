Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaJIUsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:48:46 -0400
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:58461
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903AbaJIUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:48:44 -0400
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <atull@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv2] reset: add reset_control_status helper function
Date: Thu, 9 Oct 2014 15:44:54 -0500
Message-ID: <1412887494-16442-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0045.namprd02.prod.outlook.com (10.141.56.45) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(42186005)(81156004)(40100002)(105586002)(62966002)(31966008)(77156001)(106356001)(46102003)(104166001)(69596002)(50986999)(97736003)(80022003)(66066001)(120916001)(33646002)(4396001)(53416004)(89996001)(99396003)(77096002)(85852003)(50226001)(110136001)(229853001)(102836001)(122386002)(87976001)(95666004)(48376002)(19580395003)(19580405001)(20776003)(47776003)(76482002)(2351001)(86152002)(64706001)(101416001)(107046002)(50466002)(88136002)(93916002)(86362001)(87286001)(21056001)(92726001)(92566001)(85306004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
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
v2: reset_control_status should be returning an int, and add a comment about
    status in reset-controller.h
---
 drivers/reset/core.c             | 13 +++++++++++++
 include/linux/reset-controller.h |  2 ++
 include/linux/reset.h            |  7 +++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index baeaf82..1e7ff06 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -126,6 +126,19 @@ int reset_control_deassert(struct reset_control *rstc)
 EXPORT_SYMBOL_GPL(reset_control_deassert);
 
 /**
+ * reset_control_status - returns a status of a reset bit
+ * @rstc: reset controller
+ */
+int reset_control_status(struct reset_control *rstc)
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
index 41a4695..ce6b962 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -12,11 +12,13 @@ struct reset_controller_dev;
  *         things to reset the device
  * @assert: manually assert the reset line, if supported
  * @deassert: manually deassert the reset line, if supported
+ * @status: return the status of the reset line, if supported
  */
 struct reset_control_ops {
 	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
 	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
 	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
+	int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
 };
 
 struct module;
diff --git a/include/linux/reset.h b/include/linux/reset.h
index 349f150..f7c76f2 100644
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
 
+static inline int reset_control_status(struct reset_control *rstc)
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

