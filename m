Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3A1Q7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:59:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56037 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3A1Q7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:59:12 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 13/15] MODSIGN: Add module certificate blacklist keyring
Date: Mon, 28 Jan 2013 11:42:37 -0500
Message-Id: <1359391359-25783-14-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This adds an additional keyring that is used to store certificates that
are blacklisted.  This keyring is searched first when loading signed modules
and if the module's certificate is found, it will refuse to load.  This is
useful in cases where third party certificates are used for module signing.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 init/Kconfig             |  8 ++++++++
 kernel/modsign_pubkey.c  | 14 ++++++++++++++
 kernel/module-internal.h |  3 +++
 kernel/module_signing.c  | 12 ++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..d972b77 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1665,6 +1665,14 @@ config MODULE_SIG_FORCE
 	  Reject unsigned modules or signed modules for which we don't have a
 	  key.  Without this, such modules will simply taint the kernel.
 
+config MODULE_SIG_BLACKLIST
+	bool "Support for blacklisting module signature certificates"
+	depends on MODULE_SIG
+	help
+	  This adds support for keeping a blacklist of certificates that
+	  should not pass module signature verification.  If a module is
+	  signed with something in this keyring, the load will be rejected.
+
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG
diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 2b6e699..4cd408d 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -17,6 +17,9 @@
 #include "module-internal.h"
 
 struct key *modsign_keyring;
+#ifdef CONFIG_MODULE_SIG_BLACKLIST
+struct key *modsign_blacklist;
+#endif
 
 extern __initdata const u8 modsign_certificate_list[];
 extern __initdata const u8 modsign_certificate_list_end[];
@@ -43,6 +46,17 @@ static __init int module_verify_init(void)
 	if (IS_ERR(modsign_keyring))
 		panic("Can't allocate module signing keyring\n");
 
+#ifdef CONFIG_MODULE_SIG_BLACKLIST
+	modsign_blacklist = keyring_alloc(".modsign_blacklist",
+				    KUIDT_INIT(0), KGIDT_INIT(0),
+				    current_cred(),
+				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				    KEY_USR_VIEW | KEY_USR_READ,
+				    KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(modsign_blacklist))
+		panic("Can't allocate module signing blacklist keyring\n");
+#endif
+
 	return 0;
 }
 
diff --git a/kernel/module-internal.h b/kernel/module-internal.h
index 24f9247..51a8380 100644
--- a/kernel/module-internal.h
+++ b/kernel/module-internal.h
@@ -10,5 +10,8 @@
  */
 
 extern struct key *modsign_keyring;
+#ifdef CONFIG_MODULE_SIG_BLACKLIST
+extern struct key *modsign_blacklist;
+#endif
 
 extern int mod_verify_sig(const void *mod, unsigned long *_modlen);
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index f2970bd..5423195 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -157,6 +157,18 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 
 	pr_debug("Look up: \"%s\"\n", id);
 
+#ifdef CONFIG_MODULE_SIG_BLACKLIST
+	key = keyring_search(make_key_ref(modsign_blacklist, 1),
+				   &key_type_asymmetric, id);
+	if (!IS_ERR(key)) {
+		/* module is signed with a cert in the blacklist.  reject */
+		pr_err("Module key '%s' is in blacklist\n", id);
+		key_ref_put(key);
+		kfree(id);
+		return ERR_PTR(-EKEYREJECTED);
+	}
+#endif
+
 	key = keyring_search(make_key_ref(modsign_keyring, 1),
 			     &key_type_asymmetric, id);
 	if (IS_ERR(key))
-- 
1.8.0.2

