Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaLSJzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:55:54 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33514 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaLSJzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:55:51 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: Peter.Chen@freescale.com
Cc: stefan@agner.ch, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 1/3] usb: chipidea: Add identification registers access APIs
Date: Fri, 19 Dec 2014 15:25:27 +0530
Message-Id: <72124df17c0f40f8a7ae02faa9664b9d51743584.1418981438.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using hw_write_id_reg and hw_read_id_reg to write and read
identification registers contents. This can be used to get
controller information, change some system configurations
and so on.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 drivers/usb/chipidea/ci.h |   53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index ea40626..94db636 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -29,6 +29,15 @@
 /******************************************************************************
  * REGISTERS
  *****************************************************************************/
+/* Identification Registers */
+#define ID_ID				0x0
+#define ID_HWGENERAL			0x4
+#define ID_HWHOST			0x8
+#define ID_HWDEVICE			0xc
+#define ID_HWTXBUF			0x10
+#define ID_HWRXBUF			0x14
+#define ID_SBUSCFG			0x90
+
 /* register indices */
 enum ci_hw_regs {
 	CAP_CAPLENGTH,
@@ -97,6 +106,18 @@ enum ci_role {
 	CI_ROLE_END,
 };
 
+enum CI_REVISION {
+	CI_REVISION_1X = 10,	/* Revision 1.x */
+	CI_REVISION_20 = 20, /* Revision 2.0 */
+	CI_REVISION_21, /* Revision 2.1 */
+	CI_REVISION_22, /* Revision 2.2 */
+	CI_REVISION_23, /* Revision 2.3 */
+	CI_REVISION_24, /* Revision 2.4 */
+	CI_REVISION_25, /* Revision 2.5 */
+	CI_REVISION_25_PLUS, /* Revision above than 2.5 */
+	CI_REVISION_UNKNOWN = 99, /* Unknown Revision */
+};
+
 /**
  * struct ci_role_driver - host/gadget role driver
  * @start: start this role
@@ -168,6 +189,7 @@ struct hw_bank {
  * @b_sess_valid_event: indicates there is a vbus event, and handled
  * at ci_otg_work
  * @imx28_write_fix: Freescale imx28 needs swp instruction for writing
+ * @rev: The revision number for controller
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -207,6 +229,7 @@ struct ci_hdrc {
 	bool				id_event;
 	bool				b_sess_valid_event;
 	bool				imx28_write_fix;
+	enum CI_REVISION		rev;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
@@ -244,6 +267,36 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
 }
 
 /**
+ * hw_read_id_reg: reads from a identification register
+ * @ci: the controller
+ * @offset: offset from the beginning of identification registers region
+ * @mask: bitfield mask
+ *
+ * This function returns register contents
+ */
+static inline u32 hw_read_id_reg(struct ci_hdrc *ci, u32 offset, u32 mask)
+{
+	return ioread32(ci->hw_bank.abs + offset) & mask;
+}
+
+/**
+ * hw_write_id_reg: writes to a identification register
+ * @ci: the controller
+ * @offset: offset from the beginning of identification registers region
+ * @mask: bitfield mask
+ * @data: new value
+ */
+static inline void hw_write_id_reg(struct ci_hdrc *ci, u32 offset,
+			    u32 mask, u32 data)
+{
+	if (~mask)
+		data = (ioread32(ci->hw_bank.abs + offset) & ~mask)
+			| (data & mask);
+
+	iowrite32(data, ci->hw_bank.abs + offset);
+}
+
+/**
  * hw_read: reads from a hw register
  * @ci: the controller
  * @reg:  register index
-- 
1.7.9.5

