Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaIXJMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:12:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:2525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaIXJGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="607709014"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 04/12] tpm: TPM2 support for tpm_do_selftest()
Date: Wed, 24 Sep 2014 12:05:54 +0300
Message-Id: <1411549562-24242-5-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemented tpm2_do_selftest() that runs the full (all commands)
self-test for the TPM chip. During the self-test TPM2 commands return
with the TPM error code RC_TESTING. Waiting is done by issuing PCR
read until it executes succesfully or some other error condition
than RC_TESTING happens.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  3 ++
 drivers/char/tpm/tpm.h           |  5 +++
 drivers/char/tpm/tpm2-commands.c | 82 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  7 ++++
 4 files changed, 97 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 4494b16..069be1e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -744,6 +744,9 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	unsigned long duration;
 	struct tpm_cmd_t cmd;
 
+	if (chip->tpm2)
+		return tpm2_do_selftest(chip);
+
 	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
 
 	loops = jiffies_to_msecs(duration) / delay_msec;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 10d6731..7cb0206 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -298,6 +298,10 @@ struct tpm_startup_in {
 	__be16	startup_type;
 } __packed;
 
+struct tpm2_self_test_in {
+	u8	full_test;
+} __packed;
+
 struct tpm2_pcr_read_in {
 	__be32	pcr_selects_cnt;
 	__be16	hash_alg;
@@ -330,6 +334,7 @@ typedef union {
 	struct tpm_startup_in startup_in;
 	struct	tpm2_pcr_read_in tpm2_pcrread_in;
 	struct	tpm2_pcr_read_out tpm2_pcrread_out;
+	struct	tpm2_self_test_in tpm2_selftest_in;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index 2fb553c..d54a0d0 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -200,3 +200,85 @@ int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	return rc;
 }
+
+static struct tpm_input_header tpm2_selftest_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
+			      sizeof(struct tpm2_self_test_in)),
+	.ordinal = cpu_to_be32(TPM2_CC_SELF_TEST)
+};
+
+#define TPM2_SELF_TEST_IN_SIZE \
+	(sizeof(struct tpm_input_header) + sizeof(struct tpm2_self_test_in))
+
+/**
+ * tpm2_continue_selftest -- start a self test
+ * @chip: TPM chip to use
+ * @full: test all commands instead of testing only those that were not
+ *        previously tested.
+ *
+ * Returns 0 on success, < 0 on a system error and > 0 on a TPM error.
+ */
+static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
+{
+	int rc;
+	struct tpm_cmd_t cmd;
+
+	cmd.header.in = tpm2_selftest_header;
+	cmd.params.tpm2_selftest_in.full_test = full;
+
+	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE,
+			      "continue selftest");
+
+	return rc;
+}
+
+/**
+ * tpm2_do_selftest -- start a full self test and wait until it is completed.
+ *                     During the self test TPM2 commands return with the error
+ *                     code RC_TESTING. Waiting is done by issuing PCR read until
+ *                     it executes succesfully.
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 on a system error and > 0 on a TPM error.
+ */
+int tpm2_do_selftest(struct tpm_chip *chip)
+{
+	int rc;
+	unsigned int loops;
+	unsigned int delay_msec = 100;
+	unsigned long duration;
+	struct tpm_cmd_t cmd;
+	int i;
+
+	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
+
+	loops = jiffies_to_msecs(duration) / delay_msec;
+
+	rc = tpm2_start_selftest(chip, true);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < loops; i++) {
+		/* Attempt to read a PCR value */
+		cmd.header.in = tpm2_pcrread_header;
+		cmd.params.tpm2_pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
+		cmd.params.tpm2_pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
+		cmd.params.tpm2_pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
+		cmd.params.tpm2_pcrread_in.pcr_select[0] = 0x01;
+		cmd.params.tpm2_pcrread_in.pcr_select[1] = 0x00;
+		cmd.params.tpm2_pcrread_in.pcr_select[2] = 0x00;
+
+		rc = tpm_transmit(chip, (u8 *) &cmd, sizeof(cmd));
+		if (rc < 0)
+			break;
+
+		rc = be32_to_cpu(cmd.header.out.return_code);
+		if (rc != TPM2_RC_TESTING)
+			break;
+
+		msleep(delay_msec);
+	}
+
+	return rc;
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index fbab49c..b1721f9 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -25,11 +25,17 @@ enum tpm2_structures {
 	TPM2_ST_NO_SESSIONS	= 0x8001,
 };
 
+enum tpm2_return_codes {
+	TPM2_RC_TESTING		= 0x090A,
+	TPM2_RC_DISABLED	= 0x0120,
+};
+
 enum tpm2_algorithms {
 	TPM2_ALG_SHA1		= 0x0004,
 };
 
 enum tpm2_command_codes {
+	TPM2_CC_SELF_TEST	= 0x0143,
 	TPM2_CC_PCR_READ	= 0x017E,
 };
 
@@ -40,5 +46,6 @@ struct tpm_chip;
 
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
 int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+int tpm2_do_selftest(struct tpm_chip *chip);
 
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

