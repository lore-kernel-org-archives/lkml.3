Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3AXTGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:06:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab3AXTGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:06:18 -0500
Date: Thu, 24 Jan 2013 14:06:10 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au,
        jstancek@redhat.com, Stephan Mueller <stephan.mueller@atsec.com>
Subject: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic if
 those are unsigned
Message-ID: <20130124190610.GI6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFFF48.6020608@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After thinking about it a while, this seems like the best way to solve
the problem, although it does still kind of offend my delicate
sensibilities...

Doing this check in the crypto layer seems kind of like a layering
violation to me (and, to be honest, I think it'd be a gross-hack getting
from the callee back to the caller module.)

Instead, doing it in kernel/module.c and looking at the undefined symbol
list again looks to me like an ordering problem since we're doing the
signature check before we've even done the elf header check. We'd have
to move the panic to a part of the module code that may not necessarily
make sense.

Whereas checking the undefined symbol list at modpost time is fairly
logical, and adding a new MODULE_INFO entry in the CONFIG_CRYPTO_FIPS
case is a well understood thing to do, and should catch all the crypto
registrations regardless of where they exist in-tree...

Seems to build and work with both values of CONFIG_CRYPTO_FIPS.

Thoughts?

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2459,8 +2459,10 @@ static int module_sig_check(struct load_info *info)
 		return 0;
 	}
 
-	/* Not having a signature is only an error if we're strict. */
-	if (err < 0 && fips_enabled)
+	/* Not having a signature is only an error if we're strict, and
+	 * the module registers a crypto algorithm (checked in modpost)
+	 */
+	if (err < 0 && fips_enabled && !get_modinfo(info, "crypto_fips"))
 		panic("Module verification failed with error %d in FIPS mode\n",
 		      err);
 	if (err == -ENOKEY && !sig_enforce)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ff36c50..79f46e2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1888,6 +1888,23 @@ static void add_staging_flag(struct buffer *b, const char *name)
 		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
 }
 
+static void add_crypto_flag(struct buffer *b, struct module *mod)
+{
+#if defined(CONFIG_CRYPTO_FIPS)
+	struct symbol *s;
+
+	/* iterate unresolved symbols looking for...
+	 *  - crypto_register_algs
+	 */
+	for (s = mod->unres; s; s = s->next) {
+		if (strcmp("crypto_register_algs", s->name) == 0)
+			buf_printf(b, "\nMODULE_INFO(crypto_fips, \"Y\");\n");
+	}
+#else
+	return;
+#endif /*CONFIG_CRYPTO_FIPS*/
+}
+
 /**
  * Record CRCs for unresolved symbols
  **/
@@ -2202,6 +2219,7 @@ int main(int argc, char **argv)
 		add_header(&buf, mod);
 		add_intree_flag(&buf, !external_module);
 		add_staging_flag(&buf, mod->name);
+		add_crypto_flag(&buf, mod);
 		err |= add_versions(&buf, mod);
 		add_depends(&buf, mod, modules);
 		add_moddevtable(&buf, mod);
