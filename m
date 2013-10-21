Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3JUWq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:46:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41750 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3JUWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:46 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@us.ibm.com>, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 20/23] ima: add Kconfig default measurement list template
Date: Mon, 21 Oct 2013 18:43:05 -0400
Message-Id: <1382395388-8108-21-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-3532-0000-0000-000002596B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a Kconfig option to select the default IMA
measurement list template.  The 'ima' template limited the
filedata hash to 20 bytes and the pathname to 255 charaters.
The 'ima-ng' measurement list template permits larger hash
digests and longer pathnames.

Changelog:
- keep 'select CRYPTO_HASH_INFO' in 'config IMA' section (Kconfig)
  (Roberto Sassu);
- removed trailing whitespaces (Roberto Sassu).
- Lindent fixes

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/Kconfig        | 25 +++++++++++++++++++++++++
 security/integrity/ima/ima_template.c |  4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index e6628e7..de26cc8 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -46,6 +46,31 @@ config IMA_LSM_RULES
 	help
 	  Disabling this option will disregard LSM based policy rules.
 
+choice
+	prompt "Default template"
+	default IMA_NG_TEMPLATE
+	depends on IMA
+	help
+	  Select the default IMA measurement template.
+
+	  The original 'ima' measurement list template contains a
+	  hash, defined as 20 bytes, and a null terminated pathname,
+	  limited to 255 characters.  The 'ima-ng' measurement list
+	  template permits both larger hash digests and longer
+	  pathnames.
+
+	config IMA_TEMPLATE
+		bool "ima"
+	config IMA_NG_TEMPLATE
+		bool "ima-ng (default)"
+endchoice
+
+config IMA_DEFAULT_TEMPLATE
+	string
+	depends on IMA
+	default "ima" if IMA_TEMPLATE
+	default "ima-ng" if IMA_NG_TEMPLATE
+
 config IMA_APPRAISE
 	bool "Appraise integrity measurements"
 	depends on IMA
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 1c4cf19..c28ff9b 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -127,8 +127,8 @@ static int init_defined_templates(void)
 struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
-		ima_template = lookup_template_desc(IMA_TEMPLATE_IMA_NAME);
-
+		ima_template =
+		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
 	return ima_template;
 }
 
-- 
1.8.1.4

