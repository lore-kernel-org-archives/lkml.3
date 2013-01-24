Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945970Ab3AXVWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:22:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945981Ab3AXVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:20:39 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] MODSIGN: Simplify Makefile with a Kconfig helper
Date: Thu, 24 Jan 2013 22:20:26 +0100
Message-Id: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v2: Check in kernel/Makefile that CONFIG_MODULE_SIG_HASH is set

---
 init/Kconfig    |    9 +++++++++
 kernel/Makefile |   22 +++-------------------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..ba7d1c1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1634,6 +1634,15 @@ config MODULE_SIG_SHA512
 
 endchoice
 
+config MODULE_SIG_HASH
+	string
+	depends on MODULE_SIG
+	default "sha1" if MODULE_SIG_SHA1
+	default "sha224" if MODULE_SIG_SHA224
+	default "sha256" if MODULE_SIG_SHA256
+	default "sha384" if MODULE_SIG_SHA384
+	default "sha512" if MODULE_SIG_SHA512
+
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
diff --git a/kernel/Makefile b/kernel/Makefile
index 86e3285..fe5dfb0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -148,23 +148,7 @@ kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
 # fail and that the kernel may be used afterwards.
 #
 ###############################################################################
-sign_key_with_hash :=
-ifeq ($(CONFIG_MODULE_SIG_SHA1),y)
-sign_key_with_hash := -sha1
-endif
-ifeq ($(CONFIG_MODULE_SIG_SHA224),y)
-sign_key_with_hash := -sha224
-endif
-ifeq ($(CONFIG_MODULE_SIG_SHA256),y)
-sign_key_with_hash := -sha256
-endif
-ifeq ($(CONFIG_MODULE_SIG_SHA384),y)
-sign_key_with_hash := -sha384
-endif
-ifeq ($(CONFIG_MODULE_SIG_SHA512),y)
-sign_key_with_hash := -sha512
-endif
-ifeq ($(sign_key_with_hash),)
+ifndef CONFIG_MODULE_SIG_HASH
 $(error Could not determine digest type to use from kernel config)
 endif
 
@@ -177,8 +161,8 @@ signing_key.priv signing_key.x509: x509.genkey
 	@echo "### needs to be run as root, and uses a hardware random"
 	@echo "### number generator if one is available."
 	@echo "###"
-	openssl req -new -nodes -utf8 $(sign_key_with_hash) -days 36500 -batch \
-		-x509 -config x509.genkey \
+	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
+		-batch -x509 -config x509.genkey \
 		-outform DER -out signing_key.x509 \
 		-keyout signing_key.priv
 	@echo "###"
-- 
1.7.8.3

