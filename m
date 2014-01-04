Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaADCni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:38 -0500
Received: from mout.gmx.net ([212.227.17.21]:59919 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbaADCnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:18 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 11/15] tpm: Create a tpm_class_ops structure and use it in the drivers
Date: Sat,  4 Jan 2014 03:44:45 +0100
Message-Id: <1388803489-13258-11-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:aqNLA7H5yWVV8xHAUTqGQ0pUxKLWNsVxKx234hxQl8otEuP3r5o
 eBEQD7IyQRG9DqnEy3t2waJz4cPJVxJ/ZnIwMXtdYpBDMtgPLZTWkakUsGPQTAQMJHa8OB5
 fz6/5QN4p7t0Q2ual9gY5BJLdH0cGLDf/n8ycWNYzOYaILeDoUJ7/M6IJL8/Kec8oVLvNno
 N20H3B8ywyknc/PpMUcjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

This replaces the static initialization of a tpm_vendor_specific
structure in the drivers with the standard Linux idiom of providing
a const structure of function pointers.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>
[phuewe: did apply manually due to commit
191ffc6bde3 tpm/tpm_i2c_atmel: fix coccinelle warnings]
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm-interface.c    | 10 ++++++++--
 drivers/char/tpm/tpm.h              |  6 +++---
 drivers/char/tpm/tpm_atmel.c        |  2 +-
 drivers/char/tpm/tpm_i2c_atmel.c    |  2 +-
 drivers/char/tpm/tpm_i2c_infineon.c |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  2 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c |  2 +-
 drivers/char/tpm/tpm_ibmvtpm.c      |  2 +-
 drivers/char/tpm/tpm_infineon.c     |  2 +-
 drivers/char/tpm/tpm_nsc.c          |  2 +-
 drivers/char/tpm/tpm_tis.c          |  2 +-
 drivers/char/tpm/xen-tpmfront.c     |  2 +-
 include/linux/tpm.h                 | 12 ++++++++++++
 13 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 389d483..1b01246 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1060,7 +1060,7 @@ static void tpm_dev_release(struct device *dev)
  * pci_disable_device
  */
 struct tpm_chip *tpm_register_hardware(struct device *dev,
-					const struct tpm_vendor_specific *entry)
+				       const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
 
@@ -1073,7 +1073,13 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
+	chip->vendor.req_complete_mask = ops->req_complete_mask;
+	chip->vendor.req_complete_val = ops->req_complete_val;
+	chip->vendor.req_canceled = ops->req_canceled;
+	chip->vendor.recv = ops->recv;
+	chip->vendor.send = ops->send;
+	chip->vendor.cancel = ops->cancel;
+	chip->vendor.status = ops->status;
 
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 14ba162..a56af2c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -64,8 +64,8 @@ enum tpm_duration {
 struct tpm_chip;
 
 struct tpm_vendor_specific {
-	const u8 req_complete_mask;
-	const u8 req_complete_val;
+	u8 req_complete_mask;
+	u8 req_complete_val;
 	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
 	void __iomem *iobase;		/* ioremapped address */
 	unsigned long base;		/* TPM base address */
@@ -336,7 +336,7 @@ extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
-				 const struct tpm_vendor_specific *);
+					      const struct tpm_class_ops *ops);
 extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern void tpm_remove_hardware(struct device *);
 extern int tpm_pm_suspend(struct device *);
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 7e665d0..6069d13 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -121,7 +121,7 @@ static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == ATML_STATUS_READY);
 }
 
-static const struct tpm_vendor_specific tpm_atmel = {
+static const struct tpm_class_ops tpm_atmel = {
 	.recv = tpm_atml_recv,
 	.send = tpm_atml_send,
 	.cancel = tpm_atml_cancel,
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index fe8bdce..7727292 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -140,7 +140,7 @@ static bool i2c_atmel_req_canceled(struct tpm_chip *chip, u8 status)
 	return false;
 }
 
-static const struct tpm_vendor_specific i2c_atmel = {
+static const struct tpm_class_ops i2c_atmel = {
 	.status = i2c_atmel_read_status,
 	.recv = i2c_atmel_recv,
 	.send = i2c_atmel_send,
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index ac1218f..52b9b2b 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -566,7 +566,7 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static struct tpm_vendor_specific tpm_tis_i2c = {
+static const struct tpm_class_ops tpm_tis_i2c = {
 	.status = tpm_tis_i2c_status,
 	.recv = tpm_tis_i2c_recv,
 	.send = tpm_tis_i2c_send,
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 1e6905b..7b158ef 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -455,7 +455,7 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static const struct tpm_vendor_specific tpm_i2c = {
+static const struct tpm_class_ops tpm_i2c = {
 	.status = i2c_nuvoton_read_status,
 	.recv = i2c_nuvoton_recv,
 	.send = i2c_nuvoton_send,
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 6902f7b..874b3be 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -574,7 +574,7 @@ static bool tpm_st33_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static struct tpm_vendor_specific st_i2c_tpm = {
+static const struct tpm_class_ops st_i2c_tpm = {
 	.send = tpm_stm_i2c_send,
 	.recv = tpm_stm_i2c_recv,
 	.cancel = tpm_stm_i2c_cancel,
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index ff064f0..af74c57 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -403,7 +403,7 @@ static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == 0);
 }
 
-static const struct tpm_vendor_specific tpm_ibmvtpm = {
+static const struct tpm_class_ops tpm_ibmvtpm = {
 	.recv = tpm_ibmvtpm_recv,
 	.send = tpm_ibmvtpm_send,
 	.cancel = tpm_ibmvtpm_cancel,
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index 9525be5..dc0a255 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -371,7 +371,7 @@ static u8 tpm_inf_status(struct tpm_chip *chip)
 	return tpm_data_in(STAT);
 }
 
-static const struct tpm_vendor_specific tpm_inf = {
+static const struct tpm_class_ops tpm_inf = {
 	.recv = tpm_inf_recv,
 	.send = tpm_inf_send,
 	.cancel = tpm_inf_cancel,
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index ad980be..3179ec9 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -232,7 +232,7 @@ static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == NSC_STATUS_RDY);
 }
 
-static const struct tpm_vendor_specific tpm_nsc = {
+static const struct tpm_class_ops tpm_nsc = {
 	.recv = tpm_nsc_recv,
 	.send = tpm_nsc_send,
 	.cancel = tpm_nsc_cancel,
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a362ede..8094b08 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,7 +432,7 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 	}
 }
 
-static struct tpm_vendor_specific tpm_tis = {
+static const struct tpm_class_ops tpm_tis = {
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
 	.send = tpm_tis_send,
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index d4f6b521..92b0970 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -143,7 +143,7 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return length;
 }
 
-static const struct tpm_vendor_specific tpm_vtpm = {
+static const struct tpm_class_ops tpm_vtpm = {
 	.status = vtpm_status,
 	.recv = vtpm_recv,
 	.send = vtpm_send,
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 9a9051b..fff1d09 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -29,6 +29,18 @@
  */
 #define	TPM_ANY_NUM 0xFFFF
 
+struct tpm_chip;
+
+struct tpm_class_ops {
+	const u8 req_complete_mask;
+	const u8 req_complete_val;
+	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
+	int (*recv) (struct tpm_chip *chip, u8 *buf, size_t len);
+	int (*send) (struct tpm_chip *chip, u8 *buf, size_t len);
+	void (*cancel) (struct tpm_chip *chip);
+	u8 (*status) (struct tpm_chip *chip);
+};
+
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
-- 
1.8.1.5

