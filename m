Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaDNPu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:50:57 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37492 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaDNPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:50:33 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH resend 2/2] tpm,random: Call add_drbg_randomness after selftest
Date: Mon, 14 Apr 2014 08:50:00 -0700
Message-Id: <7fc0764e033cf91ebdd4b9f874047c4967093823.1397487345.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
References: <cover.1397487345.git.luto@amacapital.net>
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
References: <cover.1397487345.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPMs contain a DRBG.  Use it.

On some but not all TPMs, this will also call add_drbg_randomness on
resume.  As a future improvement, this could be tweaked to cover all
of them, but I'll leave that to someone more familiar with the
individual drivers.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/tpm/tpm-interface.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 62e10fd..20516e7 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/random.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -780,10 +781,22 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			return 0;
 		}
 		if (rc != TPM_WARN_DOING_SELFTEST)
-			return rc;
+			break;
 		msleep(delay_msec);
 	} while (--loops > 0);
 
+	if (rc == 0) {
+		/* We're functional and/or we just resumed. */
+		u8 randomness[32];
+		int bytes = tpm_get_random(chip->dev_num,
+					   randomness, sizeof(randomness));
+		if (bytes > 0) {
+			dev_info(chip->dev, "adding %d bits of DRBG data\n",
+				 bytes * 8);
+			add_drbg_randomness(randomness, bytes);
+		}
+	}
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
-- 
1.9.0

