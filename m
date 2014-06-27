Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaF0TOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:14:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaF0TOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:14:43 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto/fips: only panic on bad/missing crypto mod signatures
Date: Fri, 27 Jun 2014 15:12:54 -0400
Message-Id: <1403896374-62781-1-git-send-email-jarod@redhat.com>
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

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephan Mueller <stephan.mueller@atsec.com>
CC: linux-crypto@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/Kconfig  |  1 +
 crypto/algapi.c | 13 +++++++++++++
 kernel/module.c |  3 ---
 3 files changed, 14 insertions(+), 3 deletions(-)

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
index 7a1ae87..7d228ff 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -43,6 +43,12 @@ static inline int crypto_set_driver_name(struct crypto_alg *alg)
 
 static int crypto_check_alg(struct crypto_alg *alg)
 {
+#ifdef CONFIG_CRYPTO_FIPS
+	if (fips_enabled && alg->cra_module && !alg->cra_module->sig_ok)
+		panic("Module %s signature verification failed in FIPS mode\n",
+		      alg->cra_module->name);
+#endif
+
 	if (alg->cra_alignmask & (alg->cra_alignmask + 1))
 		return -EINVAL;
 
@@ -430,6 +436,12 @@ int crypto_register_template(struct crypto_template *tmpl)
 
 	down_write(&crypto_alg_sem);
 
+#ifdef CONFIG_CRYPTO_FIPS
+	if (fips_enabled && tmpl->module && !tmpl->module->sig_ok)
+		panic("Module %s signature verification failed in FIPS mode\n",
+		      tmpl->module->name);
+#endif
+
 	list_for_each_entry(q, &crypto_template_list, list) {
 		if (q == tmpl)
 			goto out;
@@ -437,6 +449,7 @@ int crypto_register_template(struct crypto_template *tmpl)
 
 	list_add(&tmpl->list, &crypto_template_list);
 	crypto_notify(CRYPTO_MSG_TMPL_REGISTER, tmpl);
+
 	err = 0;
 out:
 	up_write(&crypto_alg_sem);
diff --git a/kernel/module.c b/kernel/module.c
index 81e727c..ec801d5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2448,9 +2448,6 @@ static int module_sig_check(struct load_info *info)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err < 0 && fips_enabled)
-		panic("Module verification failed with error %d in FIPS mode\n",
-		      err);
 	if (err == -ENOKEY && !sig_enforce)
 		err = 0;
 
-- 
1.8.3.1

