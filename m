Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaGDOQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:16:07 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43565 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGDOQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:16:04 -0400
Date: Fri, 4 Jul 2014 22:15:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Message-ID: <20140704141541.GB27229@gondor.apana.org.au>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
 <3104100.drOBnqUFp8@myon.chronox.de>
 <53AFC322.2060109@infradead.org>
 <1616464.nTZ4WdyPoM@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616464.nTZ4WdyPoM@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 01:37:05PM +0200, Stephan Mueller wrote:
>
> When looking into the documentation and trying it I found:
> 
> - bool choices allow me to only select one option, and only one
> 
> - tristate choices allow me to only select one option, if the initial tristate 
> is set to yes. If the initial tristate is set to module, it allows zero to all 
> options to be set.
> 
> That said, neither covers my requirement here: require that at least one 
> option is set, but allow more options.

I have added the following patch to solve this problem.

Please respin your patch against this.

commit f2c89a10de4fd123a3d15223d26994f2fe1b95d8
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jul 4 22:15:08 2014 +0800

    crypto: drbg - Use Kconfig to ensure at least one RNG option is set
    
    This patch removes the build-time test that ensures at least one RNG
    is set.  Instead we will simply not build drbg if no options are set
    through Kconfig.
    
    This also fixes a typo in the name of the Kconfig option CRYTPO_DRBG
    (should be CRYPTO_DRBG).
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1dca374..6345c47 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,7 +23,7 @@ comment "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on (CRYPTO_ANSI_CPRNG || CRYTPO_DRBG) && !CRYPTO_MANAGER_DISABLE_TESTS
+	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && !CRYPTO_MANAGER_DISABLE_TESTS
 	depends on MODULE_SIG
 	help
 	  This options enables the fips boot option which is
@@ -1394,39 +1394,39 @@ config CRYPTO_ANSI_CPRNG
 	  ANSI X9.31 A.2.4. Note that this option must be enabled if
 	  CRYPTO_FIPS is selected
 
-menuconfig CRYTPO_DRBG
+menuconfig CRYPTO_DRBG_MENU
 	tristate "NIST SP800-90A DRBG"
-	depends on CRYPTO
-	select CRYPTO_RNG
 	help
 	  NIST SP800-90A compliant DRBG. In the following submenu, one or
 	  more of the DRBG types must be selected.
 
-if CRYTPO_DRBG
+if CRYPTO_DRBG_MENU
 
 config CRYPTO_DRBG_HMAC
 	bool "Enable HMAC DRBG"
 	default y
-	depends on CRYTPO_DRBG
 	select CRYPTO_HMAC
 	help
 	  Enable the HMAC DRBG variant as defined in NIST SP800-90A.
 
 config CRYPTO_DRBG_HASH
 	bool "Enable Hash DRBG"
-	depends on CRYTPO_DRBG
 	select CRYPTO_HASH
 	help
 	  Enable the Hash DRBG variant as defined in NIST SP800-90A.
 
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
-	depends on CRYTPO_DRBG
 	select CRYPTO_AES
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
 
-endif #CRYTPO_DRBG
+config CRYPTO_DRBG
+	tristate
+	default CRYPTO_DRBG_MENU if (CRYPTO_DRBG_HMAC || CRYPTO_DRBG_HASH || CRYPTO_DRBG_CTR)
+	select CRYPTO_RNG
+
+endif	# if CRYPTO_DRBG_MENU
 
 config CRYPTO_USER_API
 	tristate
diff --git a/crypto/Makefile b/crypto/Makefile
index bfa94fa..cfa57b3 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,7 +92,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
-obj-$(CONFIG_CRYTPO_DRBG) += drbg.o
+obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
diff --git a/crypto/drbg.c b/crypto/drbg.c
index d6621a6..acc7523 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -99,12 +99,6 @@
 
 #include <crypto/drbg.h>
 
-#if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
-	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
-	!defined(CONFIG_CRYPTO_DRBG_CTR)
-#warning "The DRBG code is useless without compiling at least one DRBG type"
-#endif
-
 /***************************************************************
  * Backend cipher definitions available to DRBG
  ***************************************************************/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
