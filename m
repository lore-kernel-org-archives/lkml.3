Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3BEW6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab3BEW6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:58:44 -0500
Date: Tue, 5 Feb 2013 17:58:30 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, jstancek@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [RFC PATCH] fips: check whether a module registering an alg or
 template is signed
Message-ID: <20130205225830.GH3751@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <20130124190610.GI6538@redacted.bos.redhat.com>
 <5102781D.9000408@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5102781D.9000408@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fips mode needs to prevent unsigned modules from registering crypto
algorithms, and currently panics if an unsigned module is attempted to
be loaded. Instead, forbid (by returning -EINVAL) registering a crypto
alg or template if fips mode is enabled and the module signature is not
valid.

crypto_sig_check should return 1 (and allow the registration) if any
of the following are true:
 1/ fips is not enabled (but CONFIG_CRYPTO_FIPS is enabled.)
 2/ the algorithm is built into the kernel (THIS_MODULE == NULL)
 3/ the algorithm is in a module, and the module sig check passes
and fail in any of the other cases.

Checking in crypto_check_alg and crypto_register_template seems to hit
the callpoints as far as I can see.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---

rusty,

How about something like this? It keeps the FIPS mess in the
crypto/fips.c file (aside from something that goes away entirely in the
!CONFIG_CRYPTO_FIPS case.)

regards, Kyle

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -52,6 +52,9 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_priority < 0)
 		return -EINVAL;
 
+	if (!crypto_sig_check(alg->cra_module))
+		return -EINVAL;
+
 	return crypto_set_driver_name(alg);
 }
 
@@ -435,6 +438,11 @@ int crypto_register_template(struct crypto_template *tmpl)
 			goto out;
 	}
 
+	if (!crypto_sig_check(tmpl->module)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	list_add(&tmpl->list, &crypto_template_list);
 	crypto_notify(CRYPTO_MSG_TMPL_REGISTER, tmpl);
 	err = 0;
diff --git a/crypto/fips.c b/crypto/fips.c
index 5539700..2ebbe0f 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -15,6 +15,19 @@
 int fips_enabled;
 EXPORT_SYMBOL_GPL(fips_enabled);
 
+/* forbid loading modules in fips mode if the module is not signed */
+int crypto_sig_check(struct module *m)
+{
+#if defined(CONFIG_MODULE_SIG)
+	if (!fips_enabled || !m || (m && m->sig_ok))
+		return 1;
+	else
+		return 0;
+#else
+	return 1;
+#endif
+}
+
 /* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
 static int fips_enable(char *str)
 {
diff --git a/crypto/internal.h b/crypto/internal.h
index 9ebedae..937bfaf 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -139,5 +139,14 @@ static inline void crypto_notify(unsigned long val, void *v)
 	blocking_notifier_call_chain(&crypto_chain, val, v);
 }
 
+#if defined(CONFIG_CRYPTO_FIPS)
+int crypto_sig_check(struct module *m);
+#else
+static inline int crypto_sig_check(struct module *m)
+{
+	return 1;
+}
+#endif
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
