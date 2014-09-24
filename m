Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaIXJHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:46892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaIXJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390844588"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 11/12] tpm: Driver for TPM 2.0 CRB Interface
Date: Wed, 24 Sep 2014 12:06:01 +0300
Message-Id: <1411549562-24242-12-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpm_crb is a driver for TPM 2.0 CRB Interface as defined in

- http://www.trustedcomputinggroup.org/resources/tpm_20_mobile_command_response_buffer_interface_specification
- http://www.trustedcomputinggroup.org/resources/server_acpi_specification

Tested with TPM2 PTT included in 4th generation Intel processors.

Notes:

- PTT reports using only ACPI start as start method but seems to
  require CRB with ACPI start.
- cmdReady does not seem to work with PTT.
- Does not have yet interrupt based send/receive because I don't
  have hardware for that.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Kconfig   |   9 ++
 drivers/char/tpm/Makefile  |   1 +
 drivers/char/tpm/tpm_crb.c | 332 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 342 insertions(+)
 create mode 100644 drivers/char/tpm/tpm_crb.c

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index c54cac3..10c9419 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -122,4 +122,13 @@ config TCG_XEN
 	  To compile this driver as a module, choose M here; the module
 	  will be called xen-tpmfront.
 
+config TCG_CRB
+	tristate "TPM 2.0 CRB Interface"
+	depends on X86 && ACPI
+	---help---
+	  If you have a TPM security chip that is compliant with the
+	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
+	  from within Linux.  To compile this driver as a module, choose
+	  M here; the module will be called tpm_crb.
+
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 5ff5f3d..253e823 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
 obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
 obj-$(CONFIG_TCG_ST33_I2C) += tpm_i2c_stm_st33.o
 obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
+obj-$(CONFIG_TCG_CRB) += tpm_crb.o
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
new file mode 100644
index 0000000..db29bd2
--- /dev/null
+++ b/drivers/char/tpm/tpm_crb.c
@@ -0,0 +1,332 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG CRB 2.0 TPM specification.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/acpi.h>
+#include <linux/highmem.h>
+#include <linux/rculist.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include "tpm.h"
+
+#define ACPI_SIG_TPM2 "TPM2"
+
+static const u8 CRB_ACPI_START_UUID[] = {
+	/* 0000 */ 0xAB, 0x6C, 0xBF, 0x6B, 0x63, 0x54, 0x14, 0x47,
+	/* 0008 */ 0xB7, 0xCD, 0xF0, 0x20, 0x3C, 0x03, 0x68, 0xD4
+};
+
+enum crb_defaults {
+	CRB_SHORT_TIMEOUT = 1000,
+	CRB_LONG_TIMEOUT = 2000,
+	CRB_ACPI_START_REVISION_ID = 1,
+	CRB_ACPI_START_INDEX = 1,
+};
+
+enum crb_start_method {
+	CRB_SM_ACPI_START = 2,
+	CRB_SM_CRB = 7,
+	CRB_SM_CRB_WITH_ACPI_START = 8,
+};
+
+struct acpi_tpm2 {
+	struct acpi_table_header hdr;
+	u16 platform_class;
+	u16 reserved;
+	u64 control_area_pa;
+	u32 start_method;
+};
+
+enum crb_ca_request {
+	CRB_CA_REQ_GO_IDLE	= 0x01,
+	CRB_CA_REQ_CMD_READY	= 0x02,
+};
+
+enum crb_ca_status {
+	CRB_CA_STS_ERROR	= 0x01,
+	CRB_CA_STS_TPM_IDLE	= 0x02,
+};
+
+struct crb_control_area {
+	u32 req;
+	u32 sts;
+	u32 cancel;
+	u32 start;
+	u32 int_enable;
+	u32 int_sts;
+	u32 cmd_size;
+	u64 cmd_pa;
+	u32 rsp_size;
+	u64 rsp_pa;
+} __packed;
+
+enum crb_status {
+	CRB_STS_COMPLETE	= 0x01,
+};
+
+struct crb_priv {
+	struct {
+		unsigned int acpi_start : 1;
+		unsigned int crb_start	: 1;
+		unsigned int reserved	: 30;
+	} opt;
+
+	struct crb_control_area *cca;
+	unsigned long cca_pa;
+	acpi_handle dev_handle;
+};
+
+#ifdef CONFIG_PM_SLEEP
+int crb_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int crb_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	(void) tpm_do_selftest(chip);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(crb_pm, crb_suspend, crb_resume);
+
+static u8 crb_status(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	u8 sts = 0;
+
+	if ((priv->cca->start & 1) != 1)
+		sts |= CRB_STS_COMPLETE;
+
+	return sts;
+}
+
+static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	struct crb_control_area *cca;
+	unsigned int expected;
+	unsigned long offset;
+	u8 *resp;
+
+	cca = priv->cca;
+	if (cca->sts & CRB_CA_STS_ERROR)
+		return -EIO;
+
+	offset = cca->rsp_pa - priv->cca_pa;
+	resp = (u8 *) ((unsigned long) cca + offset);
+	memcpy(buf, resp, 6);
+	expected = be32_to_cpu(*(__be32 *) (buf + 2));
+
+	if (expected > count)
+		return -EIO;
+
+	memcpy(buf + 6, resp + 6, expected - 6);
+
+	return expected;
+}
+
+static int crb_do_acpi_start(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	union acpi_object *obj;
+	int rc;
+
+	obj = acpi_evaluate_dsm(priv->dev_handle,
+				CRB_ACPI_START_UUID,
+				CRB_ACPI_START_REVISION_ID,
+				CRB_ACPI_START_INDEX,
+				NULL);
+	if (!obj)
+		return -ENXIO;
+	rc = obj->integer.value == 0 ? 0 : -ENXIO;
+	ACPI_FREE(obj);
+	return rc;
+}
+
+static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	struct crb_control_area *cca;
+	u8 *cmd;
+	int rc = 0;
+
+	cca = priv->cca;
+
+	if (len > cca->cmd_size) {
+		dev_err(chip->dev,
+			"invalid command count value %x %zx\n",
+			(unsigned int) len,
+			(size_t) cca->cmd_size);
+		return -E2BIG;
+	}
+
+	cmd = (u8 *) ((unsigned long) cca + cca->cmd_pa - priv->cca_pa);
+	memcpy(cmd, buf, len);
+	wmb();
+
+	cca->start = 1;
+	rc = crb_do_acpi_start(chip);
+	return rc;
+}
+
+static void crb_cancel(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	struct crb_control_area *cca;
+
+	cca = priv->cca;
+	cca->cancel = 1;
+	wmb();
+
+	if (crb_do_acpi_start(chip))
+		dev_err(chip->dev, "ACPI Start failed\n");
+
+	cca->cancel = 0;
+}
+
+static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+
+	return priv->cca->cancel;
+}
+
+static const struct tpm_class_ops tpm_crb = {
+	.status = crb_status,
+	.recv = crb_recv,
+	.send = crb_send,
+	.cancel = crb_cancel,
+	.req_canceled = crb_req_canceled,
+	.req_complete_mask = CRB_STS_COMPLETE,
+	.req_complete_val = CRB_STS_COMPLETE,
+};
+
+static void crb_release(void *data)
+{
+	struct tpm_chip *chip = (struct tpm_chip *) data;
+	tpm_remove_hardware(chip->dev);
+}
+
+static int crb_acpi_add(struct acpi_device *device)
+{
+	struct tpm_chip *chip;
+	struct acpi_tpm2 *buf;
+	struct crb_priv *priv;
+	struct device *dev = &device->dev;
+	acpi_status status;
+	u32 sm;
+	int rc;
+
+	chip = tpm_chip_alloc(dev, &tpm_crb);
+	if (!chip)
+		return -ENODEV;
+
+	chip->tpm2 = true;
+
+	rc = tpm_chip_register(chip);
+	if (rc) {
+		put_device(chip->dev);
+		kfree(chip);
+		return -ENODEV;
+	}
+
+	status = acpi_get_table(ACPI_SIG_TPM2, 1,
+				(struct acpi_table_header **) &buf);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "could not get TPM2 ACPI table\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	priv = (struct crb_priv *) devm_kzalloc(dev, sizeof(struct crb_priv),
+						GFP_KERNEL);
+	if (!priv) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	sm = buf->start_method;
+
+	if (sm == CRB_SM_CRB || sm == CRB_SM_CRB_WITH_ACPI_START)
+		priv->opt.crb_start = 1;
+
+	if (sm == CRB_SM_ACPI_START || sm == CRB_SM_CRB_WITH_ACPI_START)
+		priv->opt.acpi_start = 1;
+
+	priv->dev_handle = device->handle;
+	priv->cca_pa = buf->control_area_pa;
+	priv->cca = (struct crb_control_area *)
+		devm_ioremap_nocache(dev, buf->control_area_pa, 0x1000);
+	if (!priv->cca) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	chip->vendor.priv = priv;
+
+	/* Default timeouts and durations */
+	chip->vendor.timeout_a = msecs_to_jiffies(CRB_SHORT_TIMEOUT);
+	chip->vendor.timeout_b = msecs_to_jiffies(CRB_LONG_TIMEOUT);
+	chip->vendor.timeout_c = msecs_to_jiffies(CRB_SHORT_TIMEOUT);
+	chip->vendor.timeout_d = msecs_to_jiffies(CRB_SHORT_TIMEOUT);
+
+	chip->vendor.duration[TPM_SHORT] = usecs_to_jiffies(TPM2_DURATION_SHORT);
+	chip->vendor.duration[TPM_MEDIUM] = usecs_to_jiffies(TPM2_DURATION_MEDIUM);
+	chip->vendor.duration[TPM_LONG] = usecs_to_jiffies(TPM2_DURATION_LONG);
+
+	rc = tpm_do_selftest(chip);
+	if (rc) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	rc = devm_add_action(dev, crb_release, chip);
+	if (rc)
+		goto out_err;
+
+	return 0;
+out_err:
+	tpm_remove_hardware(chip->dev);
+	return rc;
+}
+
+static struct acpi_device_id crb_device_ids[] = {
+	{"MSFT0101", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, crb_device_ids);
+
+static struct acpi_driver crb_acpi_driver = {
+	.name = "tpm_crb",
+	.ids = crb_device_ids,
+	.ops = {
+		.add = crb_acpi_add,
+	},
+	.drv = {
+		.pm = &crb_pm,
+	},
+};
+
+module_acpi_driver(crb_acpi_driver);
+MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
+MODULE_DESCRIPTION("TPM2 Driver");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
-- 
2.1.0

