Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaI3AfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:35:17 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10974 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755095AbaI3AfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:35:12 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 6/7] mfd: qcom-smd-rpm: Driver for the Qualcomm RPM over SMD
Date: Mon, 29 Sep 2014 17:34:50 -0700
Message-ID: <1412037291-16880-7-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for the Resource Power Manager (RPM) found in Qualcomm 8974 based
devices.
The driver exposes resources that child drivers can operate on; to
implementing regulator, clock and bus frequency drivers.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Note that the qcom_rpm_smd_write is equivalent of qcom_rpm_write and there is a
possibility of re-using at least the clock implementation on top of this. This
would however require some logic for calling the right implementation so I have
not done it at this time to keep things as clean as possible.

An idea for improvement is that in qcom_rpm_smd_write we put the ack_status and
completion on the stack and register this with idr using the message id, upon
receiving the interrupt we would find the right client and complete this.
Allowing for multiple requests to be in flight at any given time.

I did not implement this because I haven't done any measurements on what kind
of improvements this could give and it would be a clean iteration ontop of
this.

 drivers/mfd/Kconfig              |   14 ++
 drivers/mfd/Makefile             |    1 +
 drivers/mfd/qcom-smd-rpm.c       |  299 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/qcom-smd-rpm.h |    9 ++
 4 files changed, 323 insertions(+)
 create mode 100644 drivers/mfd/qcom-smd-rpm.c
 create mode 100644 include/linux/mfd/qcom-smd-rpm.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6743e88..c62c7f5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -553,6 +553,20 @@ config MFD_QCOM_RPM
 	  Say M here if you want to include support for the Qualcomm RPM as a
 	  module. This will build a module called "qcom_rpm".
 
+config MFD_QCOM_SMD_RPM
+	tristate "Qualcomm Resource Power Manager (RPM) over SMD"
+	depends on QCOM_SMD && OF
+	help
+	  If you say yes to this option, support will be included for the
+	  Resource Power Manager system found in the Qualcomm 8974 based
+	  devices.
+
+	  This is required to access many regulators, clocks and bus
+	  frequencies controlled by the RPM on these devices.
+
+	  Say M here if you want to include support for the Qualcomm RPM as a
+	  module. This will build a module called "qcom-smd-rpm".
+
 config MFD_RDC321X
 	tristate "RDC R-321x southbridge"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3f2fc89..e19ab12 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -154,6 +154,7 @@ obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
 obj-$(CONFIG_MFD_QCOM_RPM)	+= qcom_rpm.o
+obj-$(CONFIG_MFD_QCOM_SMD_RPM)	+= qcom-smd-rpm.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
diff --git a/drivers/mfd/qcom-smd-rpm.c b/drivers/mfd/qcom-smd-rpm.c
new file mode 100644
index 0000000..3f77f87
--- /dev/null
+++ b/drivers/mfd/qcom-smd-rpm.c
@@ -0,0 +1,299 @@
+/*
+ * Copyright (c) 2014, Sony Mobile Communications AB.
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+
+#include <linux/soc/qcom/qcom_smd.h>
+#include <linux/mfd/qcom-smd-rpm.h>
+
+#include <dt-bindings/mfd/qcom-rpm.h>
+
+#define RPM_REQUEST_TIMEOUT     (5 * HZ)
+
+struct qcom_rpm_resource {
+	u32 resource_type;
+	u32 resource_id;
+};
+
+struct qcom_rpm_data {
+	const struct qcom_rpm_resource *resource_table;
+	unsigned nresources;
+};
+
+struct qcom_smd_rpm {
+	struct device *dev;
+	struct qcom_smd_channel *rpm_channel;
+
+	struct completion ack;
+	struct mutex lock;
+	int ack_status;
+
+	const struct qcom_rpm_data *data;
+};
+
+struct qcom_rpm_header {
+	u32 service_type;
+	u32 length;
+};
+
+struct qcom_rpm_request {
+	u32 msg_id;
+	u32 flags;
+	u32 resource_type;
+	u32 resource_id;
+	u32 data_len;
+};
+
+struct qcom_rpm_message {
+	u32 msg_type;
+	u32 length;
+	union {
+		u32 msg_id;
+		u8 message[0];
+	};
+};
+
+#define RPM_SERVICE_TYPE_REQUEST	0x00716572 /* "req\0" */
+
+#define RPM_MSG_TYPE_ERR		0x00727265 /* "err\0" */
+#define RPM_MSG_TYPE_MSG_ID		0x2367736d /* "msg#" */
+
+#define RESOURCE_TYPE_SMPA		0x61706d73 /* "smpa" */
+#define RESOURCE_TYPE_SMPB		0x62706d73 /* "smpb" */
+#define RESOURCE_TYPE_LDOA		0x616f646c /* "ldoa" */
+#define RESOURCE_TYPE_VSA		0x00617376 /* "vsa\0" */
+
+#define RPM_MSG_FLAGS_SET_ACTIVE_MODE	BIT(0)
+#define RPM_MSG_FLAGS_SET_SLEEP_MODE	BIT(1)
+
+static const struct qcom_rpm_resource msm8x74_resource_table[] = {
+	[QCOM_RPM_PM8841_SMPS1] = { RESOURCE_TYPE_SMPB, 1 },
+	[QCOM_RPM_PM8841_SMPS2] = { RESOURCE_TYPE_SMPB, 2 },
+	[QCOM_RPM_PM8841_SMPS3] = { RESOURCE_TYPE_SMPB, 3 },
+	[QCOM_RPM_PM8841_SMPS4] = { RESOURCE_TYPE_SMPB, 4 },
+
+	[QCOM_RPM_PM8941_SMPS1] = { RESOURCE_TYPE_SMPA, 1 },
+	[QCOM_RPM_PM8941_SMPS2] = { RESOURCE_TYPE_SMPA, 2 },
+	[QCOM_RPM_PM8941_SMPS3] = { RESOURCE_TYPE_SMPA, 3 },
+
+	[QCOM_RPM_PM8941_LDO1] =  { RESOURCE_TYPE_LDOA, 1 },
+	[QCOM_RPM_PM8941_LDO2] =  { RESOURCE_TYPE_LDOA, 2 },
+	[QCOM_RPM_PM8941_LDO3] =  { RESOURCE_TYPE_LDOA, 3 },
+	[QCOM_RPM_PM8941_LDO4] =  { RESOURCE_TYPE_LDOA, 4 },
+	[QCOM_RPM_PM8941_LDO5] =  { RESOURCE_TYPE_LDOA, 5 },
+	[QCOM_RPM_PM8941_LDO6] =  { RESOURCE_TYPE_LDOA, 6 },
+	[QCOM_RPM_PM8941_LDO7] =  { RESOURCE_TYPE_LDOA, 7 },
+	[QCOM_RPM_PM8941_LDO8] =  { RESOURCE_TYPE_LDOA, 8 },
+	[QCOM_RPM_PM8941_LDO9] =  { RESOURCE_TYPE_LDOA, 9 },
+	[QCOM_RPM_PM8941_LDO10] = { RESOURCE_TYPE_LDOA, 10 },
+	[QCOM_RPM_PM8941_LDO11] = { RESOURCE_TYPE_LDOA, 11 },
+	[QCOM_RPM_PM8941_LDO12] = { RESOURCE_TYPE_LDOA, 12 },
+	[QCOM_RPM_PM8941_LDO13] = { RESOURCE_TYPE_LDOA, 13 },
+	[QCOM_RPM_PM8941_LDO14] = { RESOURCE_TYPE_LDOA, 14 },
+	[QCOM_RPM_PM8941_LDO15] = { RESOURCE_TYPE_LDOA, 15 },
+	[QCOM_RPM_PM8941_LDO16] = { RESOURCE_TYPE_LDOA, 16 },
+	[QCOM_RPM_PM8941_LDO17] = { RESOURCE_TYPE_LDOA, 17 },
+	[QCOM_RPM_PM8941_LDO18] = { RESOURCE_TYPE_LDOA, 18 },
+	[QCOM_RPM_PM8941_LDO19] = { RESOURCE_TYPE_LDOA, 19 },
+	[QCOM_RPM_PM8941_LDO20] = { RESOURCE_TYPE_LDOA, 20 },
+	[QCOM_RPM_PM8941_LDO21] = { RESOURCE_TYPE_LDOA, 21 },
+	[QCOM_RPM_PM8941_LDO22] = { RESOURCE_TYPE_LDOA, 22 },
+	[QCOM_RPM_PM8941_LDO23] = { RESOURCE_TYPE_LDOA, 23 },
+	[QCOM_RPM_PM8941_LDO24] = { RESOURCE_TYPE_LDOA, 24 },
+
+	[QCOM_RPM_PM8941_LVS1] =  { RESOURCE_TYPE_VSA, 1 },
+	[QCOM_RPM_PM8941_LVS2] =  { RESOURCE_TYPE_VSA, 2 },
+	[QCOM_RPM_PM8941_LVS3] =  { RESOURCE_TYPE_VSA, 3 },
+
+	[QCOM_RPM_PM8941_MVS1] =  { RESOURCE_TYPE_VSA, 4 },
+	[QCOM_RPM_PM8941_MVS2] =  { RESOURCE_TYPE_VSA, 5 },
+};
+
+static const struct qcom_rpm_data msm8x74_template = {
+	.resource_table = msm8x74_resource_table,
+	.nresources = ARRAY_SIZE(msm8x74_resource_table),
+};
+
+static const struct of_device_id qcom_smd_rpm_of_match[] = {
+	{ .compatible = "qcom,rpm-msm8974", .data = &msm8x74_template },
+	{}
+};
+MODULE_DEVICE_TABLE(of, qcom_smd_rpm_of_match);
+
+/**
+ * qcom_rpm_smd_write - write @buf to @resource
+ * @rpm:	rpm handle
+ * @resource:	resource identifier
+ * @buf:	the data to be written
+ * @count:	number of bytes in @buf
+ */
+int qcom_rpm_smd_write(struct qcom_smd_rpm *rpm,
+		       int resource,
+		       void *buf,
+		       size_t count)
+{
+	const struct qcom_rpm_resource *res;
+	const struct qcom_rpm_data *data = rpm->data;
+	static unsigned msg_id = 1;
+	int left;
+	int ret;
+
+	struct {
+		struct qcom_rpm_header hdr;
+		struct qcom_rpm_request req;
+		u8 payload[count];
+	} pkt;
+
+	/* SMD packets to the RPM may not exceed 256 bytes */
+	if (WARN_ON(sizeof(pkt) >= 256))
+		return -EINVAL;
+
+	if (WARN_ON(resource < 0 || resource >= data->nresources))
+		return -EINVAL;
+
+	res = &data->resource_table[resource];
+	if (WARN_ON(!res->resource_id || !res->resource_type))
+		return -EINVAL;
+
+	mutex_lock(&rpm->lock);
+
+	pkt.hdr.service_type = RPM_SERVICE_TYPE_REQUEST;
+	pkt.hdr.length = sizeof(struct qcom_rpm_request) + count;
+
+	pkt.req.msg_id = msg_id++;
+	pkt.req.flags = RPM_MSG_FLAGS_SET_ACTIVE_MODE;
+	pkt.req.resource_type = res->resource_type;
+	pkt.req.resource_id = res->resource_id;
+	pkt.req.data_len = count;
+	memcpy(pkt.payload, buf, count);
+
+	ret = qcom_smd_send(rpm->rpm_channel, &pkt, sizeof(pkt));
+	if (ret)
+		goto out;
+
+	left = wait_for_completion_timeout(&rpm->ack, RPM_REQUEST_TIMEOUT);
+	if (!left)
+		ret = -ETIMEDOUT;
+	else
+		ret = rpm->ack_status;
+
+out:
+	mutex_unlock(&rpm->lock);
+	return ret;
+}
+EXPORT_SYMBOL(qcom_rpm_smd_write);
+
+#define RPM_ERR_INVALID_RESOURCE "resource does not exist"
+
+static bool qcom_rpm_msg_is_invalid_resource(struct qcom_rpm_message *msg)
+{
+	size_t msg_len = sizeof(RPM_ERR_INVALID_RESOURCE) - 1;
+
+	if (msg->length != msg_len)
+		return false;
+
+	if (memcmp(msg->message, RPM_ERR_INVALID_RESOURCE, msg_len))
+		return false;
+
+	return true;
+}
+
+static int qcom_smd_rpm_callback(struct qcom_smd_device *qsdev,
+				 void *data,
+				 size_t count)
+{
+	struct qcom_rpm_header *hdr = data;
+	struct qcom_rpm_message *msg;
+	struct qcom_smd_rpm *rpm = dev_get_drvdata(&qsdev->dev);
+	u8 *buf = data + sizeof(struct qcom_rpm_header);
+	u8 *end = buf + hdr->length;
+	int status = 0;
+
+	if (hdr->service_type != RPM_SERVICE_TYPE_REQUEST ||
+	    hdr->length < sizeof(struct qcom_rpm_message)) {
+		dev_err(rpm->dev, "invalid request\n");
+		return 0;
+	}
+
+	while (buf < end) {
+		msg = (struct qcom_rpm_message *)buf;
+		switch (msg->msg_type) {
+		case RPM_MSG_TYPE_MSG_ID:
+			break;
+		case RPM_MSG_TYPE_ERR:
+			if (qcom_rpm_msg_is_invalid_resource(msg))
+				status = -ENXIO;
+			else
+				status = -EIO;
+			break;
+		}
+
+		buf = PTR_ALIGN(buf + 2 * sizeof(u32) + msg->length, 4);
+	}
+
+	rpm->ack_status = status;
+	complete(&rpm->ack);
+	return 0;
+}
+
+static int qcom_smd_rpm_probe(struct qcom_smd_device *sdev)
+{
+	const struct of_device_id *match;
+	struct qcom_smd_rpm *rpm;
+
+	rpm = devm_kzalloc(&sdev->dev, sizeof(*rpm), GFP_KERNEL);
+	if (!rpm)
+		return -ENOMEM;
+
+	rpm->dev = &sdev->dev;
+	mutex_init(&rpm->lock);
+	init_completion(&rpm->ack);
+
+	match = of_match_device(qcom_smd_rpm_of_match, &sdev->dev);
+	rpm->data = match->data;
+	rpm->rpm_channel = sdev->channel;
+
+	dev_set_drvdata(&sdev->dev, rpm);
+
+	dev_info(&sdev->dev, "Qualcomm SMD RPM driver probed\n");
+
+	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
+}
+
+static void qcom_smd_rpm_remove(struct qcom_smd_device *sdev)
+{
+	dev_set_drvdata(&sdev->dev, NULL);
+	of_platform_depopulate(&sdev->dev);
+}
+
+static struct qcom_smd_driver qcom_smd_rpm_driver = {
+	.probe = qcom_smd_rpm_probe,
+	.remove = qcom_smd_rpm_remove,
+	.callback = qcom_smd_rpm_callback,
+	.driver  = {
+		.name  = "qcom_smd_rpm",
+		.owner = THIS_MODULE,
+		.of_match_table = qcom_smd_rpm_of_match,
+	},
+};
+
+module_qcom_smd_driver(qcom_smd_rpm_driver);
+
+MODULE_AUTHOR("Bjorn Andersson <bjorn.andersson@sonymobile.com>");
+MODULE_DESCRIPTION("Qualcomm SMD backed RPM driver");
+MODULE_LICENSE("GPLv2");
diff --git a/include/linux/mfd/qcom-smd-rpm.h b/include/linux/mfd/qcom-smd-rpm.h
new file mode 100644
index 0000000..59b9425
--- /dev/null
+++ b/include/linux/mfd/qcom-smd-rpm.h
@@ -0,0 +1,9 @@
+#ifndef __QCOM_SMD_RPM_H__
+#define __QCOM_SMD_RPM_H__
+
+struct qcom_smd_rpm;
+
+int qcom_rpm_smd_write(struct qcom_smd_rpm *rpm, int resource,
+		       void *buf, size_t count);
+
+#endif
-- 
1.7.9.5

