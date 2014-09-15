Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaIOVPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:15:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaIOT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3.16 021/158] tpm: missing tpm_chip_put in tpm_get_random()
Date: Mon, 15 Sep 2014 12:24:20 -0700
Message-Id: <20140915192543.519664757@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 3e14d83ef94a5806a865b85b513b4e891923c19b upstream.

Regression in 41ab999c. Call to tpm_chip_put is missing. This
will cause TPM device driver not to unload if tmp_get_random()
is called.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-interface.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -991,13 +991,13 @@ int tpm_get_random(u32 chip_num, u8 *out
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
@@ -1016,6 +1016,7 @@ int tpm_get_random(u32 chip_num, u8 *out
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
+	tpm_chip_put(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);


