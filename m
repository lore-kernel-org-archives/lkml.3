Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbaIZKbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaIZJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/142] tpm: missing tpm_chip_put in tpm_get_random()
Date: Fri, 26 Sep 2014 11:44:13 +0200
Message-Id: <a4ed6bc99bb00d7202cb1e0ef99095d39d76d200.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3e14d83ef94a5806a865b85b513b4e891923c19b upstream.

Regression in 41ab999c. Call to tpm_chip_put is missing. This
will cause TPM device driver not to unload if tmp_get_random()
is called.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/tpm/tpm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index e3c974a6c522..334b9ef1bb1d 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1423,13 +1423,13 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
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
@@ -1448,6 +1448,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
+	tpm_chip_put(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
-- 
2.1.0

