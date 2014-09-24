Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaIXJG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:06:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:38096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaIXJG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604543903"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Will Arthur <will.c.arthur@intel.com>
Subject: [PATCH v1 08/12] tpm: TPM2 support for tpm_startup()
Date: Wed, 24 Sep 2014 12:05:58 +0300
Message-Id: <1411549562-24242-9-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Arthur <will.c.arthur@intel.com>

This patch implements TPM2 support for tpm_startup().

[jarkko.sakkinen: implemented tpm2_startup() based on the Wills
 original patch.]

Signed-off-by: Will Arthur <will.c.arthur@intel.com>
---
 drivers/char/tpm/tpm-interface.c |  6 +++++-
 drivers/char/tpm/tpm.h           |  4 ++++
 drivers/char/tpm/tpm2-commands.c | 17 +++++++++++++++++
 drivers/char/tpm/tpm2.h          |  2 ++
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3d4a664..f0c9009 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -474,6 +474,7 @@ EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 #define TPM_ST_CLEAR cpu_to_be16(1)
 #define TPM_ST_STATE cpu_to_be16(2)
 #define TPM_ST_DEACTIVATED cpu_to_be16(3)
+
 static const struct tpm_input_header tpm_startup_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(12),
@@ -483,7 +484,10 @@ static const struct tpm_input_header tpm_startup_header = {
 static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 {
 	struct tpm_cmd_t start_cmd;
-	start_cmd.header.in = tpm_startup_header;
+
+	if (chip->tpm2)
+		return tpm2_startup(chip, startup_type);
+
 	start_cmd.params.startup_in.startup_type = startup_type;
 	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
 				"attempting to start the TPM");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b4c0d5d..5a29fb7 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -298,6 +298,10 @@ struct tpm_startup_in {
 	__be16	startup_type;
 } __packed;
 
+struct tpm2_startup_in {
+	__be16	startup_type;
+} __packed;
+
 struct tpm2_self_test_in {
 	u8	full_test;
 } __packed;
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index 90cebb2..c36f7fb 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -158,6 +158,23 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 		return duration;
 }
 
+static const struct tpm_input_header tpm2_startup_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(12),
+	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
+};
+
+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
+{
+	struct tpm_cmd_t cmd;
+
+	cmd.header.in = tpm2_startup_header;
+
+	cmd.params.startup_in.startup_type = startup_type;
+	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+				"attempting to start the TPM");
+}
+
 #define TPM2_GET_TPM_PT_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_get_tpm_pt_in))
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 6ec84bc..73a1c35 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -37,6 +37,7 @@ enum tpm2_algorithms {
 
 enum tpm2_command_codes {
 	TPM2_CC_SELF_TEST	= 0x0143,
+	TPM2_CC_STARTUP		= 0x0144,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_GET_RANDOM	= 0x017B,
 	TPM2_CC_PCR_READ	= 0x017E,
@@ -57,6 +58,7 @@ struct tpm_chip;
 #define TPM2_CC_LAST	0x18F
 
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
+int tpm2_startup(struct tpm_chip *chip, __be16 startup_type);
 ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
 			const char *desc);
 int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
-- 
2.1.0

