Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaIXJMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:12:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:38096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaIXJGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604543850"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 07/12] tpm: TPM2 support for tpm_get_random().
Date: Wed, 24 Sep 2014 12:05:57 +0300
Message-Id: <1411549562-24242-8-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemented TPM2 support for tpm_get_random().

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  6 ++++++
 drivers/char/tpm/tpm.h           | 11 ++++++++++
 drivers/char/tpm/tpm2-commands.c | 45 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  2 ++
 4 files changed, 64 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index ed23ba3..3d4a664 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1002,6 +1002,12 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->tpm2) {
+		err = tpm2_get_random(chip, out, max);
+		tpm_chip_put(chip);
+		return err;
+	}
+
 	do {
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4637342..b4c0d5d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -351,6 +351,15 @@ struct tpm2_get_tpm_pt_out {
 	__be32	value;
 } __packed;
 
+struct tpm2_get_random_in {
+	__be16	size;
+} __packed;
+
+struct tpm2_get_random_out {
+	__be16	size;
+	u8	buffer[TPM_MAX_RNG_DATA];
+} __packed;
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -368,6 +377,8 @@ typedef union {
 	struct	tpm2_self_test_in tpm2_selftest_in;
 	struct	tpm2_get_tpm_pt_in tpm2_get_tpm_pt_in;
 	struct	tpm2_get_tpm_pt_out tpm2_get_tpm_pt_out;
+	struct	tpm2_get_random_in tpm2_getrandom_in;
+	struct	tpm2_get_random_out tpm2_getrandom_out;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index b69999e..90cebb2 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -349,3 +349,48 @@ int tpm2_do_selftest(struct tpm_chip *chip)
 
 	return rc;
 }
+
+static struct tpm_input_header tpm2_getrandom_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_get_random_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_RANDOM)
+};
+
+/**
+ * tpm2_get_random() - get random bytes from the TPM RNG
+ * @chip: TPM chip to use
+ * @out: destination buffer for the random bytes
+ * @max: the max number of bytes to write to @out
+ *
+ * Returns < 0 on error and the number of bytes read on success
+ */
+int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
+{
+	struct tpm_cmd_t tpm_cmd;
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	int err, total = 0, retries = 5;
+	u8 *dest = out;
+
+	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
+		return -EINVAL;
+
+	do {
+		tpm_cmd.header.in = tpm2_getrandom_header;
+		tpm_cmd.params.tpm2_getrandom_in.size = cpu_to_be16(num_bytes);
+
+		err = tpm_transmit_cmd(chip, &tpm_cmd, sizeof(tpm_cmd),
+				       "attempting get random");
+		if (err)
+			break;
+
+		recd = be16_to_cpu(tpm_cmd.params.tpm2_getrandom_out.size);
+		memcpy(dest, tpm_cmd.params.tpm2_getrandom_out.buffer, recd);
+
+		dest += recd;
+		total += recd;
+		num_bytes -= recd;
+	} while (retries-- && total < max);
+
+	return total ? total : -EIO;
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index e4ed2e5..6ec84bc 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -38,6 +38,7 @@ enum tpm2_algorithms {
 enum tpm2_command_codes {
 	TPM2_CC_SELF_TEST	= 0x0143,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
+	TPM2_CC_GET_RANDOM	= 0x017B,
 	TPM2_CC_PCR_READ	= 0x017E,
 	TPM2_CC_PCR_EXTEND	= 0x0182,
 };
@@ -61,5 +62,6 @@ ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
 int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_do_selftest(struct tpm_chip *chip);
+int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
 
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

