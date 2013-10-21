Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3JUWq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:46:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34025 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3JUWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:46 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 19/23] ima: defer determining the appraisal hash algorithm for 'ima' template
Date: Mon, 21 Oct 2013 18:43:04 -0400
Message-Id: <1382395388-8108-20-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-1542-0000-0000-0000027C6AC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

The same hash algorithm should be used for calculating the file
data hash for the IMA measurement list, as for appraising the file
data integrity.  (The appraise hash algorithm is stored in the
'security.ima' extended attribute.)  The exception is when the
reference file data hash digest, stored in the extended attribute,
is larger than the one supported by the template.  In this case,
the file data hash needs to be calculated twice, once for the
measurement list and, again, for appraisal.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 5e8b1f7..0b11bb4 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -145,6 +145,7 @@ static int process_measurement(struct file *file, const char *filename,
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
+	struct ima_template_desc *template_desc = ima_template_desc_current();
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
@@ -188,7 +189,10 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
-	if (action & IMA_APPRAISE_SUBMASK)
+	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
+		if (action & IMA_APPRAISE_SUBMASK)
+			xattr_ptr = &xattr_value;
+	} else
 		xattr_ptr = &xattr_value;
 
 	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
-- 
1.8.1.4

