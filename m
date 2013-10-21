Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3JUWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:44:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47138 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3JUWnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:50 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 21/23] ima: define kernel parameter 'ima_template=' to change configured default
Date: Mon, 21 Oct 2013 18:43:06 -0400
Message-Id: <1382395388-8108-22-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-0000232916CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

This patch allows users to specify from the kernel command line the
template descriptor, among those defined, that will be used to generate
and display measurement entries. If an user specifies a wrong template,
IMA reverts to the template descriptor set in the kernel configuration.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt   |  5 +++++
 security/integrity/ima/ima_template.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1a036cd9..2b78cb5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1190,6 +1190,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			programs exec'd, files mmap'd for exec, and all files
 			opened for read by uid=0.
 
+	ima_template=   [IMA]
+			Select one of defined IMA measurements template formats.
+			Formats: { "ima" | "ima-ng" }
+			Default: "ima-ng"
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index c28ff9b..0002214 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -12,6 +12,8 @@
  * File: ima_template.c
  *      Helpers to manage template descriptors.
  */
+#include <crypto/hash_info.h>
+
 #include "ima.h"
 #include "ima_template_lib.h"
 
@@ -32,6 +34,35 @@ static struct ima_template_field supported_fields[] = {
 };
 
 static struct ima_template_desc *ima_template;
+static struct ima_template_desc *lookup_template_desc(const char *name);
+
+static int __init ima_template_setup(char *str)
+{
+	struct ima_template_desc *template_desc;
+	int template_len = strlen(str);
+
+	/*
+	 * Verify that a template with the supplied name exists.
+	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
+	 */
+	template_desc = lookup_template_desc(str);
+	if (!template_desc)
+		return 1;
+
+	/*
+	 * Verify whether the current hash algorithm is supported
+	 * by the 'ima' template.
+	 */
+	if (template_len == 3 && strcmp(str, IMA_TEMPLATE_IMA_NAME) == 0 &&
+	    ima_hash_algo != HASH_ALGO_SHA1 && ima_hash_algo != HASH_ALGO_MD5) {
+		pr_err("IMA: template does not support hash alg\n");
+		return 1;
+	}
+
+	ima_template = template_desc;
+	return 1;
+}
+__setup("ima_template=", ima_template_setup);
 
 static struct ima_template_desc *lookup_template_desc(const char *name)
 {
-- 
1.8.1.4

