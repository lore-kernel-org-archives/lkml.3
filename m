Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaIXJHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:38096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaIXJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="596081857"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Will Arthur <will.c.arthur@intel.com>
Subject: [PATCH v1 09/12] tpm: TPM2 support for tpm_gen_interrupt().
Date: Wed, 24 Sep 2014 12:05:59 +0300
Message-Id: <1411549562-24242-10-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Arthur <will.c.arthur@intel.com>

This patch adds TPM2 support for tpm_gen_interrupt().

[jarkko.sakkinen: implemented tpm2_gen_interrupt() based on Wills
 original patch that is called from tpm_gen_interrupt() for TPM2
 chipsets.]

Signed-off-by: Will Arthur <will.c.arthur@intel.com>
---
 drivers/char/tpm/tpm-interface.c | 5 +++++
 drivers/char/tpm/tpm2-commands.c | 9 +++++++++
 drivers/char/tpm/tpm2.h          | 1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index f0c9009..b1d1cc8 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -460,6 +460,11 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 	struct	tpm_cmd_t tpm_cmd;
 	ssize_t rc;
 
+	if (chip->tpm2) {
+		tpm2_gen_interrupt(chip);
+		return;
+	}
+
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index c36f7fb..a21dfd5 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -411,3 +411,12 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 
 	return total ? total : -EIO;
 }
+
+void tpm2_gen_interrupt(struct tpm_chip *chip)
+{
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip->dev, TPM2_CAP_TPM_PROPERTIES, &value,
+			     "attempting to determine the timeouts");
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 73a1c35..98b8b80 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -65,5 +65,6 @@ int tpm2_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_do_selftest(struct tpm_chip *chip);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
+void tpm2_gen_interrupt(struct tpm_chip *chip);
 
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

