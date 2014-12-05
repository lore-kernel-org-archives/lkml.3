Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaLEVk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:40:29 -0500
Received: from mail.eperm.de ([89.247.134.16]:54915 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaLEVk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:40:26 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: [RESEND][PATCH] crypto: drbg - panic on continuous self test error
Date: Fri, 05 Dec 2014 22:40:21 +0100
Message-ID: <1565261.ENnvzOKNx0@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a panic if the FIPS 140-2 self test error failed.
Note, that entire code is only executed with fips_enabled (i.e. when the
kernel is booted with fips=1. It is therefore not executed for 99.9% of
all user base.

As mathematically such failure cannot occur, this panic should never be
triggered. But to comply with NISTs current requirements, an endless
loop must be replaced with the panic.

When the new version of FIPS 140 will be released, this entire
continuous self test function will be ripped out as it will not be
needed any more.

This patch is functionally equivalent as implemented in ansi_cprng.c and drivers/char/random.c.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9fb38a5..2c46d5e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -222,15 +222,6 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
  * function. Thus, the function implicitly knows the size of the
  * buffer.
  *
- * The FIPS test can be called in an endless loop until it returns
- * true. Although the code looks like a potential for a deadlock, it
- * is not the case, because returning a false cannot mathematically
- * occur (except once when a reseed took place and the updated state
- * would is now set up such that the generation of new value returns
- * an identical one -- this is most unlikely and would happen only once).
- * Thus, if this function repeatedly returns false and thus would cause
- * a deadlock, the integrity of the entire kernel is lost.
- *
  * @drbg DRBG handle
  * @buf output buffer of random data to be checked
  *
@@ -257,6 +248,8 @@ static bool drbg_fips_continuous_test(struct drbg_state *drbg,
 		return false;
 	}
 	ret = memcmp(drbg->prev, buf, drbg_blocklen(drbg));
+	if (!ret)
+		panic("DRBG continuous self test failed\n");
 	memcpy(drbg->prev, buf, drbg_blocklen(drbg));
 	/* the test shall pass when the two compared values are not equal */
 	return ret != 0;
-- 
2.1.0


