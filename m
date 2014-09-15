Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaIOWLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaIOWLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/187] tpm: missing tpm_chip_put in tpm_get_random()
Date: Mon, 15 Sep 2014 15:08:38 -0700
Message-Id: <1410818997-9432-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 3e14d83ef94a5806a865b85b513b4e891923c19b upstream.

Regression in 41ab999c. Call to tpm_chip_put is missing. This
will cause TPM device driver not to unload if tmp_get_random()
is called.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/tpm/tpm-interface.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6ae41d3..901b370 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1400,13 +1400,13 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
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
@@ -1425,6 +1425,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
+	tpm_chip_put(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
-- 
1.9.1

