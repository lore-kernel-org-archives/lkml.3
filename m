Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJJPZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:25:08 -0400
Received: from mail-by2on0093.outbound.protection.outlook.com ([207.46.100.93]:58457
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbaJJPZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:25:04 -0400
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <atull@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv3] reset: add reset_control_status helper function
Date: Fri, 10 Oct 2014 10:21:14 -0500
Message-ID: <1412954474-25775-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0023.namprd10.prod.outlook.com (25.160.213.33) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(48376002)(95666004)(229853001)(42186005)(87286001)(77156001)(99396003)(92726001)(87976001)(2351001)(50986999)(66066001)(64706001)(86362001)(93916002)(88136002)(92566001)(107046002)(85852003)(89996001)(120916001)(97736003)(46102003)(86152002)(81156004)(80022003)(105586002)(50226001)(122386002)(40100002)(4396001)(101416001)(19580405001)(33646002)(110136001)(102836001)(104166001)(21056001)(76482002)(53416004)(77096002)(47776003)(19580395003)(106356001)(31966008)(69596002)(62966002)(85306004)(20776003)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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
v3: Remove last unsigned int and update comment
v2: reset_control_status should be returning an int, and add a comment about
    status in reset-controller.h
---
 drivers/reset/core.c             | 15 +++++++++++++++
 include/linux/reset-controller.h |  2 ++
 include/linux/reset.h            |  7 +++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index baeaf82..7955e00 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -126,6 +126,21 @@ int reset_control_deassert(struct reset_control *rstc)
 EXPORT_SYMBOL_GPL(reset_control_deassert);
 
 /**
+ * reset_control_status - returns a negative errno if not supported, a
+ * positive value if the reset line is asserted, or zero if the reset
+ * line is not asserted.
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
index 349f150..da5602b 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -10,6 +10,7 @@ struct reset_control;
 int reset_control_reset(struct reset_control *rstc);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
+int reset_control_status(struct reset_control *rstc);
 
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

