Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaIXJQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:16:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:48212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="596081747"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 06/12] tpm: TPM2 support for tpm_pcr_extend()
Date: Wed, 24 Sep 2014 12:05:56 +0300
Message-Id: <1411549562-24242-7-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemented TPM2 protocol support for tpm_pcr_extend().

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  6 ++++++
 drivers/char/tpm/tpm.h           | 17 +++++++++++++++++
 drivers/char/tpm/tpm2-commands.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  7 +++++++
 4 files changed, 67 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 069be1e..ed23ba3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -717,6 +717,12 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->tpm2) {
+		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
+		tpm_chip_put(chip);
+		return rc;
+	}
+
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3cdbf9c..4637342 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -321,6 +321,22 @@ struct tpm2_pcr_read_out {
 	u8	digest[TPM_DIGEST_SIZE];
 } __packed;
 
+struct tpm2_null_auth_area {
+	__be32			handle;
+	__be16			nonce_size;
+	u8			attributes;
+	__be16			auth_size;
+} __packed;
+
+struct tpm2_pcr_extend_in {
+	__be32				pcr_idx;
+	__be32				auth_area_size;
+	struct tpm2_null_auth_area	auth_area;
+	__be32				digest_cnt;
+	__be16				hash_alg;
+	u8				digest[TPM_DIGEST_SIZE];
+} __packed;
+
 struct tpm2_get_tpm_pt_in {
 	__be32	cap_id;
 	__be32	property_id;
@@ -348,6 +364,7 @@ typedef union {
 	struct tpm_startup_in startup_in;
 	struct	tpm2_pcr_read_in tpm2_pcrread_in;
 	struct	tpm2_pcr_read_out tpm2_pcrread_out;
+	struct	tpm2_pcr_extend_in tpm2_pcrextend_in;
 	struct	tpm2_self_test_in tpm2_selftest_in;
 	struct	tpm2_get_tpm_pt_in tpm2_get_tpm_pt_in;
 	struct	tpm2_get_tpm_pt_out tpm2_get_tpm_pt_out;
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index 11c031b..b69999e 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -231,6 +231,43 @@ int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	return rc;
 }
 
+/**
+ * tpm_pcr_extend - extend pcr value with hash
+ * @chip_num:	tpm idx # or AN&
+ * @pcr_idx:	pcr idx to extend
+ * @hash:	hash value used to extend pcr value
+ */
+static struct tpm_input_header tpm2_pcrextend_header = {
+	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_pcr_extend_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
+};
+
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
+{
+	struct tpm_cmd_t cmd;
+	int rc;
+
+	cmd.header.in = tpm2_pcrextend_header;
+	cmd.params.tpm2_pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
+	cmd.params.tpm2_pcrextend_in.auth_area_size =
+		cpu_to_be32(sizeof(struct tpm2_null_auth_area));
+	cmd.params.tpm2_pcrextend_in.auth_area.handle =
+		cpu_to_be32(TPM2_RS_PW);
+	cmd.params.tpm2_pcrextend_in.auth_area.nonce_size = 0;
+	cmd.params.tpm2_pcrextend_in.auth_area.attributes = 0;
+	cmd.params.tpm2_pcrextend_in.auth_area.auth_size = 0;
+	cmd.params.tpm2_pcrextend_in.digest_cnt = cpu_to_be32(1);
+	cmd.params.tpm2_pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+	memcpy(cmd.params.tpm2_pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+			      "attempting extend a PCR value");
+
+	return rc;
+}
+
 static struct tpm_input_header tpm2_selftest_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
 	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 61ab0df..e4ed2e5 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -23,6 +23,7 @@ enum tpm2_const {
 
 enum tpm2_structures {
 	TPM2_ST_NO_SESSIONS	= 0x8001,
+	TPM2_ST_SESSIONS	= 0x8002,
 };
 
 enum tpm2_return_codes {
@@ -38,6 +39,11 @@ enum tpm2_command_codes {
 	TPM2_CC_SELF_TEST	= 0x0143,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_PCR_READ	= 0x017E,
+	TPM2_CC_PCR_EXTEND	= 0x0182,
+};
+
+enum tpm2_permanent_handles {
+	TPM2_RS_PW		= 0x40000009,
 };
 
 enum tpm2_capabilities {
@@ -53,6 +59,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
 ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
 			const char *desc);
 int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_do_selftest(struct tpm_chip *chip);
 
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

