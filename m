Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3AQSEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab3AQSEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:04:02 -0500
Subject: [PATCH 1/3] KEYS: Load *.x509 files into kernel keyring
To: dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Thu, 17 Jan 2013 18:03:53 +0000
Message-ID: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load all the files matching the pattern "*.x509" that are to be found in kernel
base source dir and base build dir into the module signing keyring.

The "extra_certificates" file is then redundant.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile              |   33 +++++++++++++++++++++++++++------
 kernel/modsign_certificate.S |    3 +--
 2 files changed, 28 insertions(+), 8 deletions(-)


diff --git a/kernel/Makefile b/kernel/Makefile
index 6c072b6..9fe74ff 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -134,17 +134,38 @@ $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
 
 ifeq ($(CONFIG_MODULE_SIG),y)
+###############################################################################
 #
-# Pull the signing certificate and any extra certificates into the kernel
+# Roll all the X.509 certificates that we can find together and pull
+# them into the kernel.
 #
+###############################################################################
+X509_CERTIFICATES := $(sort signing_key.x509 $(wildcard *.x509) $(wildcard $(srctree)/*.x509))
+
+ifeq ($(X509_CERTIFICATES),)
+$(warning *** No X.509 certificates found ***)
+endif
+
+ifneq ($(wildcard $(obj)/.x509.list),)
+ifneq ($(shell cat $(obj)/.x509.list),$(X509_CERTIFICATES))
+$(info X.509 certificate list changed)
+$(shell rm $(obj)/.x509.list)
+endif
+endif
+
+kernel/modsign_certificate.o: $(obj)/x509_certificate_list
 
-quiet_cmd_touch = TOUCH   $@
-      cmd_touch = touch   $@
+quiet_cmd_x509certs  = CERTS   $@
+      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@
+targets += $(obj)/x509_certificate_list
+$(obj)/x509_certificate_list: $(X509_CERTIFICATES) $(obj)/.x509.list
+	$(call if_changed,x509certs)
 
-extra_certificates:
-	$(call cmd,touch)
+targets += $(obj)/.x509.list
+$(obj)/.x509.list:
+	@echo $(X509_CERTIFICATES) >$@
 
-kernel/modsign_certificate.o: signing_key.x509 extra_certificates
+clean-files := x509_certificate_list .x509.list
 
 ###############################################################################
 #
diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
index 246b4c6..0a60203 100644
--- a/kernel/modsign_certificate.S
+++ b/kernel/modsign_certificate.S
@@ -14,6 +14,5 @@
 	.section ".init.data","aw"
 
 GLOBAL(modsign_certificate_list)
-	.incbin "signing_key.x509"
-	.incbin "extra_certificates"
+	.incbin "kernel/x509_certificate_list"
 GLOBAL(modsign_certificate_list_end)

