Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbaGBTjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:39:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbaGBTjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:39:19 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto/fips: only panic on bad/missing crypto mod signatures
Date: Wed,  2 Jul 2014 15:37:30 -0400
Message-Id: <1404329850-35509-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1403896374-62781-1-git-send-email-jarod@redhat.com>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per further discussion with NIST, the requirements for FIPS state that
we only need to panic the system on failed kernel module signature checks
for crypto subsystem modules. This moves the fips-mode-only module
signature check out of the generic module loading code, into the crypto
subsystem, at points where we can catch both algorithm module loads and
mode module loads. At the same time, make CONFIG_CRYPTO_FIPS dependent on
CONFIG_MODULE_SIG, as this is entirely necessary for FIPS mode.

v2: remove extraneous blank line, perform checks in static inline
function, drop no longer necessary fips.h include.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephan Mueller <stephan.mueller@atsec.com>
CC: linux-crypto@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/Kconfig  |  1 +
 crypto/algapi.c | 14 ++++++++++++++
 kernel/module.c |  4 ----
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..36402e5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -24,6 +24,7 @@ comment "Crypto core or helper"
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
 	depends on CRYPTO_ANSI_CPRNG && !CRYPTO_MANAGER_DISABLE_TESTS
+	depends on MODULE_SIG
 	help
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 7a1ae87..e8d3a7d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -41,8 +41,20 @@ static inline int crypto_set_driver_name(struct crypto_alg *alg)
 	return 0;
 }
 
+static inline void crypto_check_module_sig(struct module *mod)
+{
+#ifdef CONFIG_CRYPTO_FIPS
+	if (fips_enabled && mod && !mod->sig_ok)
+		panic("Module %s signature verification failed in FIPS mode\n",
+		      mod->name);
+#endif
+	return;
+}
+
 static int crypto_check_alg(struct crypto_alg *alg)
 {
+	crypto_check_module_sig(alg->cra_module);
+
 	if (alg->cra_alignmask & (alg->cra_alignmask + 1))
 		return -EINVAL;
 
@@ -430,6 +442,8 @@ int crypto_register_template(struct crypto_template *tmpl)
 
 	down_write(&crypto_alg_sem);
 
+	crypto_check_module_sig(tmpl->module);
+
 	list_for_each_entry(q, &crypto_template_list, list) {
 		if (q == tmpl)
 			goto out;
diff --git a/kernel/module.c b/kernel/module.c
index 81e727c..ae79ce6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -60,7 +60,6 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
-#include <linux/fips.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -2448,9 +2447,6 @@ static int module_sig_check(struct load_info *info)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err < 0 && fips_enabled)
-		panic("Module verification failed with error %d in FIPS mode\n",
-		      err);
 	if (err == -ENOKEY && !sig_enforce)
 		err = 0;
 
-- 
1.8.3.1

