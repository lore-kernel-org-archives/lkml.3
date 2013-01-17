Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3AQSEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:04:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066Ab3AQSE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:04:27 -0500
Subject: [PATCH 2/3] KEYS: Separate the kernel signature checking keyring
 from module signing
To: dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Thu, 17 Jan 2013 18:04:00 +0000
Message-ID: <20130117180400.27885.2973.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the kernel signature checking keyring from module signing so that it
can be used by code other than the module-signing code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/Kconfig                 |   13 +++++
 kernel/Makefile              |   17 ++++---
 kernel/modsign_certificate.S |   18 -------
 kernel/modsign_pubkey.c      |  104 ------------------------------------------
 kernel/module-internal.h     |    2 -
 kernel/module_signing.c      |    3 +
 kernel/system_certificates.S |   18 +++++++
 kernel/system_keyring.c      |  101 +++++++++++++++++++++++++++++++++++++++++
 8 files changed, 145 insertions(+), 131 deletions(-)
 delete mode 100644 kernel/modsign_certificate.S
 delete mode 100644 kernel/modsign_pubkey.c
 create mode 100644 kernel/system_certificates.S
 create mode 100644 kernel/system_keyring.c


diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..a5363d2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1568,6 +1568,18 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
+config SYSTEM_TRUSTED_KEYRING
+	bool "Provide system-wide ring of trusted keys"
+	select KEYS
+	help
+	  Provide a system keyring to which trusted keys can be added.  Keys in
+	  the keyring are considered to be trusted.  Keys may be added at will
+	  by the kernel from compiled-in data and from hardware key stores, but
+	  userspace may only add extra keys if those keys can be verified by
+	  keys already in the keyring.
+
+	  Keys in this keyring are used by module signature checking.
+
 menuconfig MODULES
 	bool "Enable loadable module support"
 	help
@@ -1640,6 +1652,7 @@ config MODULE_SRCVERSION_ALL
 config MODULE_SIG
 	bool "Module signature verification"
 	depends on MODULES
+	select SYSTEM_TRUSTED_KEYS
 	select KEYS
 	select CRYPTO
 	select ASYMMETRIC_KEY_TYPE
diff --git a/kernel/Makefile b/kernel/Makefile
index 9fe74ff..658e250 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,8 +53,9 @@ obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
+obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
 obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
+obj-$(CONFIG_MODULE_SIG) += module_signing.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -133,13 +134,14 @@ targets += timeconst.h
 $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
 
-ifeq ($(CONFIG_MODULE_SIG),y)
 ###############################################################################
 #
-# Roll all the X.509 certificates that we can find together and pull
-# them into the kernel.
+# Roll all the X.509 certificates that we can find together and pull them into
+# the kernel so that they get loaded into the system trusted keyring during
+# boot.
 #
 ###############################################################################
+ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 X509_CERTIFICATES := $(sort signing_key.x509 $(wildcard *.x509) $(wildcard $(srctree)/*.x509))
 
 ifeq ($(X509_CERTIFICATES),)
@@ -153,10 +155,11 @@ $(shell rm $(obj)/.x509.list)
 endif
 endif
 
-kernel/modsign_certificate.o: $(obj)/x509_certificate_list
+kernel/system_certificates.o: $(obj)/x509_certificate_list
 
 quiet_cmd_x509certs  = CERTS   $@
-      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@
+      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@ $(foreach X509,$(X509_CERTIFICATES),; echo "  - Including cert $(X509)")
+
 targets += $(obj)/x509_certificate_list
 $(obj)/x509_certificate_list: $(X509_CERTIFICATES) $(obj)/.x509.list
 	$(call if_changed,x509certs)
@@ -166,7 +169,9 @@ $(obj)/.x509.list:
 	@echo $(X509_CERTIFICATES) >$@
 
 clean-files := x509_certificate_list .x509.list
+endif
 
+ifeq ($(CONFIG_MODULE_SIG),y)
 ###############################################################################
 #
 # If module signing is requested, say by allyesconfig, but a key has not been
diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
deleted file mode 100644
index 0a60203..0000000
--- a/kernel/modsign_certificate.S
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SYMBOL_PREFIX defined on commandline from CONFIG_SYMBOL_PREFIX */
-#ifndef SYMBOL_PREFIX
-#define ASM_SYMBOL(sym) sym
-#else
-#define PASTE2(x,y) x##y
-#define PASTE(x,y) PASTE2(x,y)
-#define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
-#endif
-
-#define GLOBAL(name)	\
-	.globl ASM_SYMBOL(name);	\
-	ASM_SYMBOL(name):
-
-	.section ".init.data","aw"
-
-GLOBAL(modsign_certificate_list)
-	.incbin "kernel/x509_certificate_list"
-GLOBAL(modsign_certificate_list_end)
diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
deleted file mode 100644
index 2b6e699..0000000
--- a/kernel/modsign_pubkey.c
+++ /dev/null
@@ -1,104 +0,0 @@
-/* Public keys for module signature verification
- *
- * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/cred.h>
-#include <linux/err.h>
-#include <keys/asymmetric-type.h>
-#include "module-internal.h"
-
-struct key *modsign_keyring;
-
-extern __initdata const u8 modsign_certificate_list[];
-extern __initdata const u8 modsign_certificate_list_end[];
-
-/*
- * We need to make sure ccache doesn't cache the .o file as it doesn't notice
- * if modsign.pub changes.
- */
-static __initdata const char annoy_ccache[] = __TIME__ "foo";
-
-/*
- * Load the compiled-in keys
- */
-static __init int module_verify_init(void)
-{
-	pr_notice("Initialise module verification\n");
-
-	modsign_keyring = keyring_alloc(".module_sign",
-					KUIDT_INIT(0), KGIDT_INIT(0),
-					current_cred(),
-					((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-					 KEY_USR_VIEW | KEY_USR_READ),
-					KEY_ALLOC_NOT_IN_QUOTA, NULL);
-	if (IS_ERR(modsign_keyring))
-		panic("Can't allocate module signing keyring\n");
-
-	return 0;
-}
-
-/*
- * Must be initialised before we try and load the keys into the keyring.
- */
-device_initcall(module_verify_init);
-
-/*
- * Load the compiled-in keys
- */
-static __init int load_module_signing_keys(void)
-{
-	key_ref_t key;
-	const u8 *p, *end;
-	size_t plen;
-
-	pr_notice("Loading module verification certificates\n");
-
-	end = modsign_certificate_list_end;
-	p = modsign_certificate_list;
-	while (p < end) {
-		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
-		 * than 256 bytes in size.
-		 */
-		if (end - p < 4)
-			goto dodgy_cert;
-		if (p[0] != 0x30 &&
-		    p[1] != 0x82)
-			goto dodgy_cert;
-		plen = (p[2] << 8) | p[3];
-		plen += 4;
-		if (plen > end - p)
-			goto dodgy_cert;
-
-		key = key_create_or_update(make_key_ref(modsign_keyring, 1),
-					   "asymmetric",
-					   NULL,
-					   p,
-					   plen,
-					   (KEY_POS_ALL & ~KEY_POS_SETATTR) |
-					   KEY_USR_VIEW,
-					   KEY_ALLOC_NOT_IN_QUOTA);
-		if (IS_ERR(key))
-			pr_err("MODSIGN: Problem loading in-kernel X.509 certificate (%ld)\n",
-			       PTR_ERR(key));
-		else
-			pr_notice("MODSIGN: Loaded cert '%s'\n",
-				  key_ref_to_ptr(key)->description);
-		p += plen;
-	}
-
-	return 0;
-
-dodgy_cert:
-	pr_err("MODSIGN: Problem parsing in-kernel X.509 certificate list\n");
-	return 0;
-}
-late_initcall(load_module_signing_keys);
diff --git a/kernel/module-internal.h b/kernel/module-internal.h
index 24f9247..915e123 100644
--- a/kernel/module-internal.h
+++ b/kernel/module-internal.h
@@ -9,6 +9,4 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-extern struct key *modsign_keyring;
-
 extern int mod_verify_sig(const void *mod, unsigned long *_modlen);
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index f2970bd..0034e36 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -14,6 +14,7 @@
 #include <crypto/public_key.h>
 #include <crypto/hash.h>
 #include <keys/asymmetric-type.h>
+#include <keys/system_keyring.h>
 #include "module-internal.h"
 
 /*
@@ -157,7 +158,7 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 
 	pr_debug("Look up: \"%s\"\n", id);
 
-	key = keyring_search(make_key_ref(modsign_keyring, 1),
+	key = keyring_search(make_key_ref(system_trusted_keyring, 1),
 			     &key_type_asymmetric, id);
 	if (IS_ERR(key))
 		pr_warn("Request for unknown module key '%s' err %ld\n",
diff --git a/kernel/system_certificates.S b/kernel/system_certificates.S
new file mode 100644
index 0000000..86240df
--- /dev/null
+++ b/kernel/system_certificates.S
@@ -0,0 +1,18 @@
+/* SYMBOL_PREFIX defined on commandline from CONFIG_SYMBOL_PREFIX */
+#ifndef SYMBOL_PREFIX
+#define ASM_SYMBOL(sym) sym
+#else
+#define PASTE2(x,y) x##y
+#define PASTE(x,y) PASTE2(x,y)
+#define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
+#endif
+
+#define GLOBAL(name)	\
+	.globl ASM_SYMBOL(name);	\
+	ASM_SYMBOL(name):
+
+	.section ".init.data","aw"
+
+GLOBAL(system_certificate_list)
+	.incbin "kernel/x509_certificate_list"
+GLOBAL(system_certificate_list_end)
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
new file mode 100644
index 0000000..a3ca76f
--- /dev/null
+++ b/kernel/system_keyring.c
@@ -0,0 +1,101 @@
+/* System trusted keyring for trusted public keys
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <keys/asymmetric-type.h>
+#include <keys/system_keyring.h>
+#include "module-internal.h"
+
+struct key *system_trusted_keyring;
+EXPORT_SYMBOL_GPL(system_trusted_keyring);
+
+extern __initdata const u8 system_certificate_list[];
+extern __initdata const u8 system_certificate_list_end[];
+
+/*
+ * Load the compiled-in keys
+ */
+static __init int system_trusted_keyring_init(void)
+{
+	pr_notice("Initialise system trusted keyring\n");
+
+	system_trusted_keyring =
+		keyring_alloc(".system_keyring",
+			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
+			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			       KEY_USR_VIEW | KEY_USR_READ),
+			      KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(system_trusted_keyring))
+		panic("Can't allocate system trusted keyring\n");
+
+	return 0;
+}
+
+/*
+ * Must be initialised before we try and load the keys into the keyring.
+ */
+device_initcall(system_trusted_keyring_init);
+
+/*
+ * Load the compiled-in list of X.509 certificates.
+ */
+static __init int load_system_certificate_list(void)
+{
+	key_ref_t key;
+	const u8 *p, *end;
+	size_t plen;
+
+	pr_notice("Loading compiled-in X.509 certificates\n");
+
+	end = system_certificate_list_end;
+	p = system_certificate_list;
+	while (p < end) {
+		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
+		 * than 256 bytes in size.
+		 */
+		if (end - p < 4)
+			goto dodgy_cert;
+		if (p[0] != 0x30 &&
+		    p[1] != 0x82)
+			goto dodgy_cert;
+		plen = (p[2] << 8) | p[3];
+		plen += 4;
+		if (plen > end - p)
+			goto dodgy_cert;
+
+		key = key_create_or_update(make_key_ref(system_trusted_keyring, 1),
+					   "asymmetric",
+					   NULL,
+					   p,
+					   plen,
+					   (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					   KEY_USR_VIEW,
+					   KEY_ALLOC_NOT_IN_QUOTA);
+		if (IS_ERR(key))
+			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
+			       PTR_ERR(key));
+		else
+			pr_notice("Loaded X.509 cert '%s'\n",
+				  key_ref_to_ptr(key)->description);
+		p += plen;
+	}
+
+	return 0;
+
+dodgy_cert:
+	pr_err("Problem parsing in-kernel X.509 certificate list\n");
+	return 0;
+}
+late_initcall(load_system_certificate_list);

