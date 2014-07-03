Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaGCVI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaGCVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 8/9] PEFILE: Validate PKCS#7 trust chain
Date: Thu,  3 Jul 2014 17:07:20 -0400
Message-Id: <1404421641-12691-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Validate the PKCS#7 trust chain against the contents of the system keyring.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/Kconfig                |  1 +
 arch/x86/kernel/pefile_parser.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 29b9967..741d90d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1579,6 +1579,7 @@ config SIGNED_PE_FILE_PARSER
 	depends on PKCS7_MESSAGE_PARSER=y
 	select ASN1
 	select OID_REGISTRY
+	select SYSTEM_TRUSTED_KEYRING
 	---help---
 	  This option provides support for parsing signed PE
 	  (Protable Executable) binaries.
diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
index f11c254..de61279 100644
--- a/arch/x86/kernel/pefile_parser.c
+++ b/arch/x86/kernel/pefile_parser.c
@@ -18,6 +18,7 @@
 #include <linux/asn1.h>
 #include <keys/asymmetric-subtype.h>
 #include <keys/asymmetric-parser.h>
+#include <keys/system_keyring.h>
 #include <crypto/hash.h>
 #include <crypto/pkcs7.h>
 #include "pefile_parser.h"
@@ -388,6 +389,7 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 	void *pkcs7;
 	struct pefile_context ctx;
 	int ret;
+	bool trusted;
 
 	kenter("");
 
@@ -421,9 +423,13 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 	ret = pkcs7_verify(pkcs7);
 	if (ret < 0)
 		goto error;
-
-	/* Not yet complete */
-	ret = -ENOANO;
+	/*
+	 * Trust is being verified against system_trusted_keyring. This is
+	 * a trusted keyring and all the keys in this keyring should be
+	 * trusted. So there should not be any need to check "trusted"
+	 * parameter.
+	 */
+	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
 
 error:
 	pkcs7_free_message(ctx.pkcs7);
-- 
1.9.0

