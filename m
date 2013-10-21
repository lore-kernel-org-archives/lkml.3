Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3JUWoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:44:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35489 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3JUWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@us.ibm.com>, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 22/23] ima: enable support for larger default filedata hash algorithms
Date: Mon, 21 Oct 2013 18:43:07 -0400
Message-Id: <1382395388-8108-23-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-0928-0000-0000-000002C09E25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA measurement list contains two hashes - a template data hash
and a filedata hash.  The template data hash is committed to the TPM,
which is limited, by the TPM v1.2 specification, to 20 bytes.  The
filedata hash is defined as 20 bytes as well.

Now that support for variable length measurement list templates was
added, the filedata hash is not limited to 20 bytes.  This patch adds
Kconfig support for defining larger default filedata hash algorithms
and replacing the builtin default with one specified on the kernel
command line.

<uapi/linux/hash_info.h> contains a list of hash algorithms.  The
Kconfig default hash algorithm is a subset of this list, but any hash
algorithm included in the list can be specified at boot, using the
'ima_hash=' kernel command line option.

Changelog v2:
- update Kconfig

Changelog:
- support hashes that are configured
- use generic HASH_ALGO_ definitions
- add Kconfig support
- hash_setup must be called only once (Dmitry)
- removed trailing whitespaces (Roberto Sassu)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/kernel-parameters.txt |  6 +++++-
 security/integrity/ima/Kconfig      | 35 +++++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_main.c   | 26 ++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b78cb5..1e8761c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1181,9 +1181,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			owned by uid=0.
 
 	ima_hash=	[IMA]
-			Format: { "sha1" | "md5" }
+			Format: { md5 | sha1 | rmd160 | sha256 | sha384
+				   | sha512 | ... }
 			default: "sha1"
 
+			The list of supported hash algorithms is defined
+			in crypto/hash_info.h.
+
 	ima_tcb		[IMA]
 			Load a policy which meets the needs of the Trusted
 			Computing Base.  This means IMA will measure all
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index de26cc8..351a58e 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -71,6 +71,41 @@ config IMA_DEFAULT_TEMPLATE
 	default "ima" if IMA_TEMPLATE
 	default "ima-ng" if IMA_NG_TEMPLATE
 
+choice
+	prompt "Default integrity hash algorithm"
+	default IMA_DEFAULT_HASH_SHA1
+	depends on IMA
+	help
+	   Select the default hash algorithm used for the measurement
+	   list, integrity appraisal and audit log.  The compiled default
+	   hash algorithm can be overwritten using the kernel command
+	   line 'ima_hash=' option.
+
+	config IMA_DEFAULT_HASH_SHA1
+		bool "SHA1 (default)"
+		depends on CRYPTO_SHA1
+
+	config IMA_DEFAULT_HASH_SHA256
+		bool "SHA256"
+		depends on CRYPTO_SHA256 && !IMA_TEMPLATE
+
+	config IMA_DEFAULT_HASH_SHA512
+		bool "SHA512"
+		depends on CRYPTO_SHA512 && !IMA_TEMPLATE
+
+	config IMA_DEFAULT_HASH_WP512
+		bool "WP512"
+		depends on CRYPTO_WP512 && !IMA_TEMPLATE
+endchoice
+
+config IMA_DEFAULT_HASH
+	string
+	depends on IMA
+	default "sha1" if IMA_DEFAULT_HASH_SHA1
+	default "sha256" if IMA_DEFAULT_HASH_SHA256
+	default "sha512" if IMA_DEFAULT_HASH_SHA512
+	default "wp512" if IMA_DEFAULT_HASH_WP512
+
 config IMA_APPRAISE
 	bool "Appraise integrity measurements"
 	depends on IMA
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 0b11bb4..14d4cb5 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -37,11 +37,32 @@ int ima_appraise;
 #endif
 
 int ima_hash_algo = HASH_ALGO_SHA1;
+static int hash_setup_done;
 
 static int __init hash_setup(char *str)
 {
-	if (strncmp(str, "md5", 3) == 0)
-		ima_hash_algo = HASH_ALGO_MD5;
+	struct ima_template_desc *template_desc = ima_template_desc_current();
+	int i;
+
+	if (hash_setup_done)
+		return 1;
+
+	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
+		if (strncmp(str, "sha1", 4) == 0)
+			ima_hash_algo = HASH_ALGO_SHA1;
+		else if (strncmp(str, "md5", 3) == 0)
+			ima_hash_algo = HASH_ALGO_MD5;
+		goto out;
+	}
+
+	for (i = 0; i < HASH_ALGO__LAST; i++) {
+		if (strcmp(str, hash_algo_name[i]) == 0) {
+			ima_hash_algo = i;
+			break;
+		}
+	}
+out:
+	hash_setup_done = 1;
 	return 1;
 }
 __setup("ima_hash=", hash_setup);
@@ -306,6 +327,7 @@ static int __init init_ima(void)
 {
 	int error;
 
+	hash_setup(CONFIG_IMA_DEFAULT_HASH);
 	error = ima_init();
 	if (!error)
 		ima_initialized = 1;
-- 
1.8.1.4

