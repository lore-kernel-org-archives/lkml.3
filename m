Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaIXJGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:06:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:55243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaIXJGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="479658346"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 03/12] tpm: TPM2 support for tpm_pcr_read()
Date: Wed, 24 Sep 2014 12:05:53 +0300
Message-Id: <1411549562-24242-4-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemented TPM2 support for tpm_pcr_read() by adding a new function
tpm2_pcr_read_dev() that is called for TPM2 chipsets.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  5 ++++-
 drivers/char/tpm/tpm.h           | 21 ++++++++++++++++++++
 drivers/char/tpm/tpm2-commands.c | 43 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          | 18 +++++++++++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 07a2fc5..4494b16 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -680,7 +680,10 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
-	rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
+	if (chip->tpm2)
+		rc = tpm2_pcr_read_dev(chip, pcr_idx, res_buf);
+	else
+		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
 	tpm_chip_put(chip);
 	return rc;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index bda88aa..10d6731 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -298,6 +298,25 @@ struct tpm_startup_in {
 	__be16	startup_type;
 } __packed;
 
+struct tpm2_pcr_read_in {
+	__be32	pcr_selects_cnt;
+	__be16	hash_alg;
+	u8	pcr_select_size;
+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
+} __packed;
+
+
+struct tpm2_pcr_read_out {
+	__be32	update_cnt;
+	__be32	pcr_selects_cnt;
+	__be16	hash_alg;
+	u8	pcr_select_size;
+	u8	pcr_select[TPM2_PCR_SELECT_MIN];
+	__be32	digests_cnt;
+	__be16	digest_size;
+	u8	digest[TPM_DIGEST_SIZE];
+} __packed;
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -309,6 +328,8 @@ typedef union {
 	struct	tpm_getrandom_in getrandom_in;
 	struct	tpm_getrandom_out getrandom_out;
 	struct tpm_startup_in startup_in;
+	struct	tpm2_pcr_read_in tpm2_pcrread_in;
+	struct	tpm2_pcr_read_out tpm2_pcrread_out;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index 14b3ae7..2fb553c 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -157,3 +157,46 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 	else
 		return duration;
 }
+
+#define TPM2_PCR_READ_IN_SIZE \
+	(sizeof(struct tpm_input_header) + \
+	 sizeof(struct tpm2_pcr_read_in))
+
+static struct tpm_input_header tpm2_pcrread_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
+};
+
+int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+{
+	int rc;
+	struct tpm_cmd_t cmd;
+	u8 *buf;
+	int i, j;
+
+	if (pcr_idx >= TPM2_PLATFORM_PCR)
+		return -EINVAL;
+
+	cmd.header.in = tpm2_pcrread_header;
+	cmd.params.tpm2_pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
+	cmd.params.tpm2_pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+	cmd.params.tpm2_pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
+
+	for (i = 0; i < TPM2_PCR_SELECT_MIN; i++) {
+		j = pcr_idx - i * 8;
+
+		cmd.params.tpm2_pcrread_in.pcr_select[i] =
+			(j >= 0 && j < 8) ? 1 << j : 0;
+	}
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+			      "attempting to read a pcr value");
+
+	if (rc == 0) {
+		buf = cmd.params.tpm2_pcrread_out.digest;
+		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
+	}
+
+	return rc;
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index dc0a2a2..fbab49c 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -16,11 +16,29 @@
 #ifndef __DRIVERS_CHAR_TPM2_H__
 #define __DRIVERS_CHAR_TPM2_H__
 
+enum tpm2_const {
+	TPM2_PLATFORM_PCR = 24,
+	TPM2_PCR_SELECT_MIN = ((TPM2_PLATFORM_PCR + 7) / 8),
+};
+
+enum tpm2_structures {
+	TPM2_ST_NO_SESSIONS	= 0x8001,
+};
+
+enum tpm2_algorithms {
+	TPM2_ALG_SHA1		= 0x0004,
+};
+
+enum tpm2_command_codes {
+	TPM2_CC_PCR_READ	= 0x017E,
+};
+
 struct tpm_chip;
 
 #define TPM2_CC_FIRST	0x11F
 #define TPM2_CC_LAST	0x18F
 
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
+int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

