Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaEILXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:23:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:39092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaEILXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:23:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1017,1389772800"; 
   d="scan'208";a="508961525"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: peterhuewe@gmx.de, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: missing tpm_chip_put in tpm_get_random()
Date: Fri,  9 May 2014 14:23:10 +0300
Message-Id: <1399634590-8360-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression in 41ab999c. Call to tpm_chip_put is missing. This
will cause TPM device driver not to unload if tmp_get_random()
is called.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 62e10fd..4ea4d52 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -991,13 +991,13 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	int err, total = 0, retries = 5;
 	u8 *dest = out;
 
+	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
+		return -EINVAL;
+
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
 
-	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
-		return -EINVAL;
-
 	do {
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
@@ -1016,6 +1016,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
+	tpm_chip_put(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
-- 
1.9.1

