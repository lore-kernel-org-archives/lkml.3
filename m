Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaIMRho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 13:37:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:45683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaIMRhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 13:37:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385706726"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: merge duplicate transmit_cmd() functions
Date: Sat, 13 Sep 2014 20:35:33 +0300
Message-Id: <1410629733-10105-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c
with a single tpm_transmit_cmd() that can be used in both files.

This patch is preliminary clean up work for the TPM2 support. This
function is needed for implementing TPM2 versions of the in-kernel
TPM utility functions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 44 ++++++++++++++++++++--------------------
 drivers/char/tpm/tpm-sysfs.c     | 23 ++-------------------
 drivers/char/tpm/tpm.h           |  2 ++
 3 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6af1700..f638f9d 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -398,8 +398,8 @@ out:
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
 
-static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
-			    int len, const char *desc)
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
+			 int len, const char *desc)
 {
 	int err;
 
@@ -448,7 +448,7 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = subcap_id;
 	}
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -464,8 +464,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the timeouts");
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			      "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
@@ -484,8 +484,8 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	struct tpm_cmd_t start_cmd;
 	start_cmd.header.in = tpm_startup_header;
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
-			    "attempting to start the TPM");
+	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
+				"attempting to start the TPM");
 }
 
 int tpm_get_timeouts(struct tpm_chip *chip)
@@ -500,7 +500,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
 
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
@@ -513,7 +513,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 				  NULL);
 	}
 	if (rc) {
@@ -575,8 +575,8 @@ duration:
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the durations");
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			      "attempting to determine the durations");
 	if (rc)
 		return rc;
 
@@ -631,8 +631,8 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
-			  "continue selftest");
+	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+			      "continue selftest");
 	return rc;
 }
 
@@ -672,8 +672,8 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
-			  "attempting to read a pcr value");
+	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
+			      "attempting to read a pcr value");
 
 	if (rc == 0)
 		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
@@ -737,8 +737,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-			  "attempting extend a PCR value");
+	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+			      "attempting extend a PCR value");
 
 	tpm_chip_put(chip);
 	return rc;
@@ -817,7 +817,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
+	rc = tpm_transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
 
 	tpm_chip_put(chip);
 	return rc;
@@ -938,14 +938,14 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-				  "extending dummy pcr before suspend");
+		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+				      "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
+		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -1022,7 +1022,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
-		err = transmit_cmd(chip, &tpm_cmd,
+		err = tpm_transmit_cmd(chip, &tpm_cmd,
 				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
 				   "attempting get random");
 		if (err)
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 01730a2..8ecb052 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -20,25 +20,6 @@
 #include <linux/device.h>
 #include "tpm.h"
 
-/* XXX for now this helper is duplicated in tpm-interface.c */
-static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
-			    int len, const char *desc)
-{
-	int err;
-
-	len = tpm_transmit(chip, (u8 *) cmd, len);
-	if (len <  0)
-		return len;
-	else if (len < TPM_HEADER_SIZE)
-		return -EFAULT;
-
-	err = be32_to_cpu(cmd->header.out.return_code);
-	if (err != 0 && desc)
-		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
-
-	return err;
-}
-
 #define READ_PUBEK_RESULT_SIZE 314
 #define TPM_ORD_READPUBEK cpu_to_be32(124)
 static struct tpm_input_header tpm_readpubek_header = {
@@ -58,8 +39,8 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			   "attempting to read the PUBEK");
+	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+			       "attempting to read the PUBEK");
 	if (err)
 		goto out;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e4d0888..d893335 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -317,6 +317,8 @@ ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
+			 int len, const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
-- 
2.1.0

