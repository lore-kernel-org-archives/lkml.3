Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaILNH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:07:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:59750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbaILNH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="477116915"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: use tpm_pcr_read_dev() in tpm_do_selftest()
Date: Fri, 12 Sep 2014 16:06:41 +0300
Message-Id: <1410527201-32428-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to construct the PCR read command in
tpm_do_selftest() when there is already a function that does
the job.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6af1700..ee0711b 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -759,7 +759,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
-	struct tpm_cmd_t cmd;
+	u8 digest[TPM_DIGEST_SIZE];
 
 	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
 
@@ -773,10 +773,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		return rc;
 
 	do {
-		/* Attempt to read a PCR value */
-		cmd.header.in = pcrread_header;
-		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
-		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		rc = tpm_pcr_read_dev(chip, 0, digest);
 		/* Some buggy TPMs will not respond to tpm_tis_ready() for
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
@@ -786,10 +783,9 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			continue;
 		}
 
-		if (rc < TPM_HEADER_SIZE)
+		if (rc < 0)
 			return -EFAULT;
 
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
-- 
2.1.0

