Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3JaQ13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:27:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35456 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3JaQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:27:25 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-36-527284ebd588
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: dhowells@redhat.com, rusty@rustcorp.com.au,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/1] KEYS: store keys in the dedicated directory
Date: Thu, 31 Oct 2013 18:26:30 +0200
Message-id: <1c88669c38d627ca2f5ccc9ffc2e24e2d04c05ea.1383236790.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xa7qvW4qCDJ49YrW49Xcvs8W7pt8s
	Fl+W1llc3jWHzaJh9ndWiw89j9gsbk67wOLA7rFz1l12j/f7rrJ5rNhwgtmjb8sqRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mi7u38xU0KhUMfXkZqYGxk8yXYycHBICJhIruh+yQNhiEhfurWfr
	YuTiEBJYyiixpGEBI4TTySTx7PQ5ZpAqNgE9iQ3NP9hBbBGBcImuiYvBipgF2hglXkxoASsS
	FnCQ+Lr2JGsXIwcHi4CqRN/yYpAwr0CcxLv/nYwQ2xQkfl4+wTaBkXsBI8MqRtHU0uSC4qT0
	XCO94sTc4tK8dL3k/NxNjJAg+bqDcekxq0OMAhyMSjy8DLqFQUKsiWXFlbmHGCU4mJVEeEVy
	ioKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MMY5MbucL8pkf8zyymq3YNi8OCv5AzZ7Nvbptx+M
	UL6ZffTLJoPcvf4cwo8ZJS1rOhP/LHkf4x+stNTxxTcpp2MMYr62hyp/bDSzPNEmZX/p50E9
	NaN7zXd3XGV7ovroQs71qSE/RDLrhbNavU0Elxck9TzVLApR7+55uGXeS9b4edHLFhjOU2Ip
	zkg01GIuKk4EACaALlHwAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent patch "KEYS: Load *.x509 files into kernel keyring" allows to bultin
multiple X509 certificates. It is easier to manage keys and certificates
when they are stored in the dedicated directory.

This patch proposes to store keys in the 'keys' directory.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Makefile        |  4 ++--
 kernel/Makefile | 55 +++++++++++++++++++++++++++++++------------------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/Makefile b/Makefile
index 8d0668f..329684a 100644
--- a/Makefile
+++ b/Makefile
@@ -722,8 +722,8 @@ export mod_strip_cmd
 
 
 ifdef CONFIG_MODULE_SIG_ALL
-MODSECKEY = ./signing_key.priv
-MODPUBKEY = ./signing_key.x509
+MODSECKEY = ./keys/signing_key.priv
+MODPUBKEY = ./keys/signing_key.x509
 export MODPUBKEY
 mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
diff --git a/kernel/Makefile b/kernel/Makefile
index 6313698..3e7799a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -154,9 +154,15 @@ $(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
 # duplicates.
 #
 ###############################################################################
+
+KEYDIR = keys
+MODGENKEY = $(KEYDIR)/x509.genkey
+MODSECKEY = $(KEYDIR)/signing_key.priv
+MODPUBKEY = $(KEYDIR)/signing_key.x509
+
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
-X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += signing_key.x509
+X509_CERTIFICATES-y := $(wildcard $(srctree)/keys/*.x509)
+X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(MODPUBKEY)
 X509_CERTIFICATES := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
 				$(or $(realpath $(CERT)),$(CERT))))
 
@@ -199,7 +205,7 @@ ifndef CONFIG_MODULE_SIG_HASH
 $(error Could not determine digest type to use from kernel config)
 endif
 
-signing_key.priv signing_key.x509: x509.genkey
+$(MODSECKEY) $(MODPUBKEY): $(MODGENKEY)
 	@echo "###"
 	@echo "### Now generating an X.509 key pair to be used for signing modules."
 	@echo "###"
@@ -209,30 +215,31 @@ signing_key.priv signing_key.x509: x509.genkey
 	@echo "### number generator if one is available."
 	@echo "###"
 	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
-		-batch -x509 -config x509.genkey \
-		-outform DER -out signing_key.x509 \
-		-keyout signing_key.priv 2>&1
+		-batch -x509 -config $(MODGENKEY) \
+		-outform DER -out $(MODPUBKEY) \
+		-keyout $(MODSECKEY) 2>&1
 	@echo "###"
 	@echo "### Key pair generated."
 	@echo "###"
 
-x509.genkey:
+$(MODGENKEY):
 	@echo Generating X.509 key generation config
-	@echo  >x509.genkey "[ req ]"
-	@echo >>x509.genkey "default_bits = 4096"
-	@echo >>x509.genkey "distinguished_name = req_distinguished_name"
-	@echo >>x509.genkey "prompt = no"
-	@echo >>x509.genkey "string_mask = utf8only"
-	@echo >>x509.genkey "x509_extensions = myexts"
-	@echo >>x509.genkey
-	@echo >>x509.genkey "[ req_distinguished_name ]"
-	@echo >>x509.genkey "O = Magrathea"
-	@echo >>x509.genkey "CN = Glacier signing key"
-	@echo >>x509.genkey "emailAddress = slartibartfast@magrathea.h2g2"
-	@echo >>x509.genkey
-	@echo >>x509.genkey "[ myexts ]"
-	@echo >>x509.genkey "basicConstraints=critical,CA:FALSE"
-	@echo >>x509.genkey "keyUsage=digitalSignature"
-	@echo >>x509.genkey "subjectKeyIdentifier=hash"
-	@echo >>x509.genkey "authorityKeyIdentifier=keyid"
+	@mkdir -p $(KEYDIR)
+	@echo  >$(MODGENKEY) "[ req ]"
+	@echo >>$(MODGENKEY) "default_bits = 4096"
+	@echo >>$(MODGENKEY) "distinguished_name = req_distinguished_name"
+	@echo >>$(MODGENKEY) "prompt = no"
+	@echo >>$(MODGENKEY) "string_mask = utf8only"
+	@echo >>$(MODGENKEY) "x509_extensions = myexts"
+	@echo >>$(MODGENKEY)
+	@echo >>$(MODGENKEY) "[ req_distinguished_name ]"
+	@echo >>$(MODGENKEY) "O = Magrathea"
+	@echo >>$(MODGENKEY) "CN = Glacier signing key"
+	@echo >>$(MODGENKEY) "emailAddress = slartibartfast@magrathea.h2g2"
+	@echo >>$(MODGENKEY)
+	@echo >>$(MODGENKEY) "[ myexts ]"
+	@echo >>$(MODGENKEY) "basicConstraints=critical,CA:FALSE"
+	@echo >>$(MODGENKEY) "keyUsage=digitalSignature"
+	@echo >>$(MODGENKEY) "subjectKeyIdentifier=hash"
+	@echo >>$(MODGENKEY) "authorityKeyIdentifier=keyid"
 endif
-- 
1.8.1.2

