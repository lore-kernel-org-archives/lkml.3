Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaIXJGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:06:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:55243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaIXJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390844386"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 05/12] tpm: added tpm2_get_tpm_pt()
Date: Wed, 24 Sep 2014 12:05:55 +0300
Message-Id: <1411549562-24242-6-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the function tpm2_get_tpm_pt() for acquiring TPM properties
(properties under under TPM_CAP_TPM_PROPERTIES capability).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h           | 16 ++++++++++++++++
 drivers/char/tpm/tpm2-commands.c | 30 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  7 +++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 7cb0206..3cdbf9c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -321,6 +321,20 @@ struct tpm2_pcr_read_out {
 	u8	digest[TPM_DIGEST_SIZE];
 } __packed;
 
+struct tpm2_get_tpm_pt_in {
+	__be32	cap_id;
+	__be32	property_id;
+	__be32	property_cnt;
+} __packed;
+
+struct tpm2_get_tpm_pt_out {
+	u8	more_data;
+	__be32	subcap_id;
+	__be32	property_cnt;
+	__be32	property_id;
+	__be32	value;
+} __packed;
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -335,6 +349,8 @@ typedef union {
 	struct	tpm2_pcr_read_in tpm2_pcrread_in;
 	struct	tpm2_pcr_read_out tpm2_pcrread_out;
 	struct	tpm2_self_test_in tpm2_selftest_in;
+	struct	tpm2_get_tpm_pt_in tpm2_get_tpm_pt_in;
+	struct	tpm2_get_tpm_pt_out tpm2_get_tpm_pt_out;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index d54a0d0..11c031b 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -158,6 +158,36 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 		return duration;
 }
 
+#define TPM2_GET_TPM_PT_IN_SIZE \
+	(sizeof(struct tpm_input_header) + \
+	 sizeof(struct tpm2_get_tpm_pt_in))
+
+static struct tpm_input_header tpm2_get_tpm_pt_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
+};
+
+ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
+			const char *desc)
+{
+	struct tpm_cmd_t cmd;
+	int rc;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	cmd.header.in = tpm2_get_tpm_pt_header;
+	cmd.params.tpm2_get_tpm_pt_in.cap_id =
+		cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
+	cmd.params.tpm2_get_tpm_pt_in.property_id = property_id;
+	cmd.params.tpm2_get_tpm_pt_in.property_cnt = cpu_to_be32(1);
+
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
+	if (!rc)
+		*value = cmd.params.tpm2_get_tpm_pt_out.value;
+
+	return rc;
+}
+
 #define TPM2_PCR_READ_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_pcr_read_in))
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index b1721f9..61ab0df 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -36,15 +36,22 @@ enum tpm2_algorithms {
 
 enum tpm2_command_codes {
 	TPM2_CC_SELF_TEST	= 0x0143,
+	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_PCR_READ	= 0x017E,
 };
 
+enum tpm2_capabilities {
+	TPM2_CAP_TPM_PROPERTIES = 6,
+};
+
 struct tpm_chip;
 
 #define TPM2_CC_FIRST	0x11F
 #define TPM2_CC_LAST	0x18F
 
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
+ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
+			const char *desc);
 int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 int tpm2_do_selftest(struct tpm_chip *chip);
 
-- 
2.1.0

